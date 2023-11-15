model proyectoFinal


// Grid del mundo
grid gworld width: 25 height: 25 neighbors:4 {
	rgb color <- rgb (208,157,87);
}

// Definción de global
global{
	
	// --- Predicates ---
	predicate patrol <- new_predicate("patrol");
	predicate drink <- new_predicate("drink");
	predicate thirst <- new_predicate("thirst");
	predicate no_thirst <- new_predicate("no_thirst");
	predicate water <- new_predicate("water");
	predicate no_water <- new_predicate("no_water");
	predicate negotiate <- new_predicate("negotiate");
	
	predicate food <- new_predicate("food");
	predicate no_food <- new_predicate("no_food");
	predicate eat <- new_predicate("eat");
	predicate negotiate_food <- new_predicate("negotiate_food");
	
	predicate farm <- new_predicate("farm");
	predicate dry <- new_predicate("dry");
	predicate cultivate <- new_predicate("cultivate");
	predicate irrigate <- new_predicate("irrigate");
	predicate harvest <- new_predicate("harvest");
	
	point agua_loc;   // Locaclización del agua conocida para todos
	int n_max;
	int rainFrecuency <- 200;
	int rainFrecuencyCounter;
	int cantidadLluvia;
	
	
	
	// -- Init --
	init {
		n_max <- 5;
		
		// --- Creación de especies ---
		// Creación de las casas
		loop i from: 0 to: n_max - 1{
			create casa with: [id:: i, max_row:: 3];
		}

		// Creación del Pozo de agua
		create agua{
			location<-{74, 50};
		}
		
		
		loop human_1 over: farmer{
			loop human_2 over: farmer{
				if(human_1 != human_2){
					ask human_1{

						int id1 <- human_1.id;
						int id2 <- human_2.id;
						
						// Cálculo del "liking"
						float liking <- float(n_max - abs(id1 - id2))/n_max;
						
						// Crea el vínculo social
						do add_social_link(new_social_link(human_2));
						social_link sl <- set_liking(get_social_link(new_social_link(human_2)), liking);
					}
				}
			}
		}
		
		point original_earth <- {18, 62};
		point init_earth <- original_earth;
		point aux <- init_earth;
		
		
		loop farmer_1 over:farmer{
			create tierra with: [location::init_earth];
//			add init_earth to:farmer_1.earth_loc;
//			
			aux <- {init_earth.x + 8, init_earth.y};
			init_earth <- aux;
			
			if(init_earth.x > 50){
				
				init_earth <- {18, init_earth.y + 8};
			}
		}
		
		int idx <- 0;
		
		loop earth_1 over: tierra{
			add earth_1 to: farmer[idx].earth_loc;
			idx <- idx + 1;
		}
		
		
		// -- ASKS --
		// Pregunta la posición del agua
		ask agua{
			agua_loc <- self.location;
		}
		
	}
	
	reflex update_capacity{
			rainFrecuencyCounter <- rainFrecuencyCounter + 1;
			write rainFrecuencyCounter;
			if(rainFrecuencyCounter > rainFrecuency){
				rainFrecuencyCounter <- 0;
				cantidadLluvia <- generateRain();
				do rainEfect;
			}
	}
	
	int generateRain{
		int auxRnd <- rnd(1,5);
		int cantidadLLuviaAux <- 0;
		if(auxRnd=1){
			cantidadLLuviaAux <- 200;
		}else if(auxRnd=2){
			cantidadLLuviaAux <- 150;
		}else if(auxRnd=3){
			cantidadLLuviaAux <- 100;
		}else if(auxRnd=4){
			cantidadLLuviaAux <- 50;
		}else{
			cantidadLLuviaAux <- 0;
		}
		write "lo que llueve es" + cantidadLLuviaAux;
		return cantidadLLuviaAux;
	}
	
	action rainEfect{
		ask agua{
			capacity <- capacity + cantidadLluvia;
		}
		
		loop tierra_1 over:tierra{
			ask tierra_1{
				hidr <- hidr + cantidadLluvia*0.05;
				if(hidr > 10.0){
					hidr <- 10.0;
				}
			} 
		}
	}
	
}




// Especie Humano
// TODO: 2a iteración --> modelo BPI del agricultor
species human skills: [moving] control: simple_bdi{
	int id;					// Id de la casa a la que pertenece
	point home_pos;			// Posición de la casa
	float water_cap;		// Cantidad de agua actual
	float max_water_cap;	// Capacidad de agua máxima
	float hidr_level;		// Nivel de hidratación
	float thirst_thres;		// Umbral de sed para beber
	float thirst_update;	// Ratio de actualización de la sed
	float drink_quantity;
	human negotiator;		// Humano con el que se espera hacer negociaciones
	list prev_neg;			// Lista de humanos con los que se ha negociado
	
	float food_cap;
	float max_food_cap;
	float hunger_level;
	float hunger_thres;
	float hunger_update;
	float eat_quantity;
	human negotiator_food;
	list prev_neg_food;
	
	
	
	// -- Init --
	init{
		
		use_social_architecture  <- true;
		water_cap <- 100.0;
		max_water_cap <- 100.0;
		hidr_level <- 100.0;
		thirst_thres <- 50.0;
		thirst_update <- rnd(0.01, 0.09);
		drink_quantity <- 1.0;
		agreeableness <- 1.0;
		negotiator <- nil;
		
		food_cap <- 100.0;
		max_food_cap <- 100.0;
		hunger_level <- 100.0;
		hunger_thres <- 50.0;
		eat_quantity <- 1.0;
		hunger_update <- rnd(0.01, 0.09);
		
		
		do add_desire(patrol);			// Deseo inicial: patrullar
		home_pos <- location;			// Asigna localización de la casa
	}
	
	// -- Perceptions --
	// Sed
	perceive target:self {
		if(hidr_level > thirst_thres){
			do add_belief(no_thirst);
			do remove_belief(thirst);
		}
		else{
			do add_belief(thirst);
			do remove_belief(no_thirst);
			do remove_intention(get_predicate(get_current_intention()));
		}
	}
	
	// Hambre
	perceive target:self {
		if(hunger_level > hunger_thres){
			do add_belief(no_food);
			do remove_belief(food);
		}
		else{
			do add_belief(food);
			do remove_belief(no_food);
			do remove_intention(get_predicate(get_current_intention()));
		}
	}
	
	list<agent> get_all_instances(species<agent> spec) {
        return spec.population +  spec.subspecies accumulate (get_all_instances(each));
    }
	
	action ask_for_water{
//		write "I am " + name + " and i want to negotiate";
		
		ask get_all_instances(human) at_distance(100) {
			if(not(myself.prev_neg contains self) and human(self).water_cap > 50)
			{
				write "I am " + name + " and i want to negotiate with " + self.name;
				human(myself).negotiator <- human(self);
			}
		}
		
		if(negotiator != nil){
			add negotiator to: prev_neg;

			do add_belief(negotiate);
		    do remove_belief(no_water);
		    do remove_intention(get_predicate(get_current_intention()));
		}
	}
	
	// Agua
	perceive target:self{
		
		// Negociar
		if(water_cap <= 30.0)
		{
			do ask_for_water;
		}
		
		// Ir al pozo
		if(water_cap <= 10){
			do add_belief(no_water);
			do remove_belief(water);
			do remove_intention(patrol);
		}
		else{
			do add_belief(water);
			do remove_belief(no_water);
		}
	}
	
	action ask_for_food{
//		write "I am " + name + " and i want to negotiate";
		ask get_all_instances(human) at_distance(100) {
			if(not(myself.prev_neg_food contains self) and human(self).food_cap > 50)
			{
				write "I am " + name + " and i want to negotiate with " + self.name + " with food";
				human(myself).negotiator_food <- human(self);
			}
		}
		
		if(negotiator_food != nil){
			add negotiator_food to: prev_neg_food;

			do add_belief(negotiate_food);
		    do remove_belief(no_food);
		    do remove_intention(get_predicate(get_current_intention()));
		}
	}
	
	// Pedir comida
	perceive target:self{
		
		// Negociar
		if(food_cap <= 30.0)
		{
			do ask_for_food;
		}
	}
	
	
	
	// -- Rules --
	rule belief: thirst new_desire: drink strength: 15.0;
	rule belief: no_thirst new_desire: patrol;
	
	rule belief: food new_desire: eat strength: 15.0;
	rule belief: no_food new_desire: patrol;
	
	rule belief: no_water new_desire: water strength: 20;
	rule belief: water new_desire: patrol;
	
	rule belief: negotiate new_desire: negotiate strength: 25;
	rule belief: negotiate_food new_desire: negotiate_food strength: 25;
	
	
	action default{
		do wander amplitude: 30.0 speed:1.0;
	}
	
	// -- Planes --
	// Patrullar
	plan patrolling intention:patrol{
		do default;
	}
	
	// Beber agua
	plan drink intention:drink priority:10.0{

		if(water_cap > 0)
		{
			//write "I am " + name + " and I drink";
			hidr_level <- hidr_level + drink_quantity;
			water_cap <- water_cap - drink_quantity;
			
			if(hidr_level > thirst_thres)
			{
				do remove_intention(drink, true);
				do remove_belief(drink);
			}
		}		
	}
	
	// Comer
	plan eat_plan intention:eat priority:10.0{

		if(food_cap > 0)
		{
			//write "I am " + name + " and I drink";
			hunger_level <- hunger_level + drink_quantity;
			food_cap <- food_cap - drink_quantity;
			
			if(hunger_level > hunger_thres)
			{
				do remove_intention(eat, true);
				do remove_belief(eat);
			}
		}		
	}
	
	// Ir al pozo
	plan go_to_well intention:water priority:15.0{
		agua wa <- first(agua);
		do goto target: wa.location speed:2.0;
		//write "I am going for water";
		
		if (self distance_to wa <= 1) {
			ask agua
			{
				float water_taken <- min(myself.max_water_cap - myself.water_cap, self.capacity);
				myself.water_cap <- myself.water_cap + water_taken;
				self.capacity <- self.capacity - water_taken;
			}
    		
    		//write "I am taking water";
		}
		if(water_cap >= max_water_cap)
		{
			prev_neg <- [];
			do remove_intention(water, true);
			//write "Finish water";
		}
	}
	
	
	// Hacer negocios: agua
	plan make_negotiation_water intention:negotiate priority:20{
		float likeness <- get_liking(get_social_link(new_social_link(negotiator))) - (1.0 - agreeableness);
		
		write "I am " + name + " and i am negotiating with " + negotiator.name + " for water";
		
		ask negotiator{
			bool res <- flip(likeness);
			write likeness;
			
			if(res){
				write "OK w";
				self.water_cap <- self.water_cap - 10.0;
				myself.water_cap <- myself.water_cap + 10.0;
			}
			else{
				write "BAD w";
				if(likeness > 0.5){
					self.agreeableness  <- self.agreeableness - abs((likeness)/n_max - 0.5);
				}
			}
		}
		
		negotiator <- nil;
		do remove_intention(negotiate, true);
		do remove_belief(negotiate);
	}
	
	
	// Hacer negocios: comida
	plan make_negotiation_food intention:negotiate_food priority:20{
		float likeness <- get_liking(get_social_link(new_social_link(negotiator_food))) - (1.0 - agreeableness);
		
		write "I am " + name + " and i am negotiating with " + negotiator_food.name + " for food";
		
		ask negotiator_food{
			bool res <- flip(likeness);
			write likeness;
			
			if(res){
				write "OK F";
				self.food_cap <- self.food_cap - 10.0;
				myself.food_cap <- myself.food_cap + 10.0;
			}
			else{
				write "BAD F";
				if(likeness > 0.5){
					self.agreeableness  <- self.agreeableness - abs((likeness)/n_max - 0.5);
				}
			}
		}
		
		negotiator_food <- nil;
		do remove_intention(negotiate_food, true);
		do remove_belief(negotiate_food);
	}
	
	
	// -- Reflex --
	// Thirst update
	reflex thirst_update_ref{
		hidr_level <- hidr_level - thirst_update;
	}
	
	// Hunger update
	reflex hunger_update_ref{
		hunger_level <- hunger_level - hunger_update;
	}
	
	// Die
	reflex human_die when: hidr_level <= 0 or hunger_level <= 0 {
		write "I am " + name + " and I die";
		do die;
	}
	
	// -- Apecto --	
	aspect base {			
		draw triangle(2) color:color rotate: 90 + heading;	
	}
}



// 
species farmer parent: human{
	list<tierra> earth_loc;
	int seeds;
	
	init{
		
		do remove_intention(get_predicate(get_current_intention()));
		do add_desire(farm);
	}
	
//	action ask_for_water{
////		write "I am " + name + " and i want to negotiate";
//		ask farmer  at_distance(100) {
//			if(not(myself.prev_neg contains self) and self.water_cap > 50)
//			{
//				write "I am " + name + " and i want to negotiate with " + self.name + " with water ";
//				myself.negotiator <- self;
//			}
//		}
//		
//		if(negotiator != nil){
//			add negotiator to: prev_neg;
//
//			do add_belief(negotiate);
//		    do remove_belief(no_water);
//		    do remove_intention(get_predicate(get_current_intention()));
//		}
//	}
//	
//	action ask_for_food{
////		write "I am " + name + " and i want to negotiate";
//		ask farmer at_distance(100) {
//			if(not(myself.prev_neg_food contains self) and self.food_cap > 50)
//			{
//				write "I am " + name + " and i want to negotiate with " + self.name + " with food";
//				myself.negotiator_food <- self;
//			}
//		}
//		
//		if(negotiator_food != nil){
//			add negotiator_food to: prev_neg_food;
//
//			do add_belief(negotiate_food);
//		    do remove_belief(no_food);
//		    do remove_intention(get_predicate(get_current_intention()));
//		}
//	}
//	
	action default{
		do goto target:earth_loc[0].location  speed:1.0;
	}
	
	// Percepciones
	perceive target:earth_loc[0] in: 1{
		if (self.state = "dry"){
			ask myself{
				do add_belief(dry);
			    do remove_intention(get_predicate(get_current_intention()), true);
			}
		}
		else if(self.state = "cultivated" and self.hidr < 5.0 and myself.water_cap > 10.0){
			ask myself{
				do add_belief(irrigate);
			    do remove_intention(get_predicate(get_current_intention()), true);
			}
		}
		
		else if(self.state = "harvestable"){
			ask myself{
				do add_belief(harvest);
			    do remove_intention(get_predicate(get_current_intention()), true);
			}
		}
	}
	
	
	// Reglas
	rule belief: dry new_desire: cultivate;
	rule belief: irrigate new_desire: irrigate;
	rule belief: harvest new_desire: harvest;
	
	// Planes
	plan cultivate_plan intention:cultivate priority:5{
		//write "I am "+ name+ " and i cultivated";
		
		earth_loc[0].state <- "cultivated";
		do remove_intention(get_predicate(get_current_intention()), true);
		do remove_belief(dry);
		do remove_intention(cultivate);
	}
	
	plan irrigate_plan intention: irrigate priority:5{
		//write "I am "+name+" and i am irrigating";
		water_cap <- water_cap - drink_quantity * 5;
		earth_loc[0].hidr <- 10.0;
		do remove_intention(get_predicate(get_current_intention()), true);
		do remove_belief(irrigate);
		do remove_intention(irrigate);
	}
	
	plan harvest_plan intention: harvest priority:5{
		//write "I am "+name+" and i am harvesting";
		
		earth_loc[0].state <- "dry";
		food_cap <-  100.0;
		
		prev_neg_food <- [];
		
		do remove_intention(get_predicate(get_current_intention()), true);
		do remove_belief(harvest);
		do remove_intention(harvest);
	}
}

// Especie Casa
species casa{
	
	int n_humanos;			// Número de humanos por casa
	int id;					// Id de la casa
	int max_row;			// Máximo de filas del poblado
	
	// -- Init --
	init{
		n_humanos <- rnd (1, 3);		// Número de humanos aleatorio

		location <- {18 + 8*(id - max_row*int(id/max_row)), 18 + 8*int(id/max_row)};	// Localización de la casa
		
		// --- Creación de humanos: conocen el ID de la casa y su localización ---
		create farmer number: n_humanos with: [id::self.id, location::self.location, home_pos::self.location];
	}
	
	// -- Aspecto --
	aspect base {
	  draw square(4) color: #red border: #black;		
	}
}

// Especie del Pozo de Agua
species agua{
	float ratio;							// Ratio de aparición
	float capacity;							// Capacidad actual
	float max_capacity;						// Máxima capacidad
	
	// -- Init --
	init{
		ratio <- 2.0;
		capacity <- 1000.0;
		max_capacity <- 10000.0;
	}
	
	
	// -- Reflex --
	// Actualización de la capacidad de agua
//	reflex update_capacity{
//		if(capacity < max_capacity){
//			capacity <- capacity + ratio;
//		}
//	}
	
	// -- Aspecto --
	aspect base{
		draw square(4) color: #blue border: #black;
	}
}

// Especies Tierra: 
// TODO: 2a iteración --> tipos de tierra, rotaciones de cultivos, tipos, ...
species tierra{
	
	int type;
	string state;
	float hidr;
	
	int counter;
	
	
	init{
		state <- "dry";
		hidr <- 10.0;
		counter <- 0;
	}
	
	aspect base{
		if(state = "dry"){
			rgb colorTierra <- rgb (148,100,37);
			draw square(4) color: colorTierra border:#black;
		}
		else if(state = "cultivated"){
			rgb colorTierra <- rgb (48,182,43);
			draw square(4) color: colorTierra border:#black;
		}
		else if(state = "harvestable"){
			rgb colorTierra <- rgb (24,235,17);
			draw square(4) color: colorTierra border:#black;
		}
	}
	
	reflex update_hidr when: state = "cultivated"{
		if(hidr > 0.0){
			hidr <- hidr - 0.05;
			counter <- counter + 1;
		}
		else{
			counter <- 0;
			state <- "dry";
		}
		
		if(counter >= 2000){
			
			counter <- 0;
			state <- "harvestable";
		}
	}
}


// --- Experimentos ---
experiment resources_main_1 type: gui {
	output {					
		display view1 { 
			grid gworld border: #darkgreen;
			species casa aspect:base;
			species agua aspect:base;
			species tierra aspect:base;
			species human aspect:base;
			species farmer aspect: base;
		}
	}
}
