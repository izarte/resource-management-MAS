model proyectoFinal

<<<<<<< HEAD
=======

>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
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
	
<<<<<<< HEAD
	point agua_loc;   // Locaclización del agua conocida para todos
	int n_max;
	int rainFrecuencyCounter;
	
	// Optimizaciones
	float cantidadLluvia <- 114.0;
	int rainFrecuency <- 200;
	float eat_drink_q <- 0.005;
	float earth_ratio <- 0.02;//0.005; 
=======
	
	// Optimizaciones
	float cantidadLluvia <- 114.0;
	int rainFrecuency <- 201;
	float eat_drink_q <- 0.005;
	float earth_ratio <- 0.005; 
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	float negotiate_q <- 14.0;
	float bonus_negotiate <- 0.05;
	
	// Reward
	float reward <- 0.0;
	int n_agents <- 0;
	int max_n_agents <- 0;
	float water_q <- 0.0;
	float max_water_q <- 10000.0;
	
<<<<<<< HEAD
	float cantidadLluvia_;
	
	// Visualization parameters
	float water_capacity <- 0.0;
	int yes_negotiation_w <- 0;
	int no_negotiation_w <- 0;
	int yes_negotiation_f <- 0;
	int no_negotiation_f <- 0;
	float thirst_update <- rnd(1.0, 2.0) * eat_drink_q;
	float hunger_update <- rnd(1.0, 2.0) * eat_drink_q;
=======
	
	point agua_loc;   // Locaclización del agua conocida para todos
	int n_max;
	
	int rainFrecuencyCounter;
	
	float cantidadLluvia_;
	
	
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	
	// -- Init --
	init {
		n_max <- 5;
<<<<<<< HEAD
		//bool sound_ok <- play_sound('../includes/sv_music.wav');
		
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
	
	reflex reward_func{
		reward <- n_agents + water_q * max_n_agents / max_water_q;
	}
	
	reflex update_capacity{
		
			rainFrecuencyCounter <- rainFrecuencyCounter + 1;
			//write rainFrecuencyCounter;
			if(rainFrecuencyCounter > rainFrecuency){
				rainFrecuencyCounter <- 0;
				cantidadLluvia_ <- generateRain();
				do rainEfect;
			}
	}
	
	float generateRain{
		float quant <- rnd (0.0, 1.0, 0.2);
		
		return cantidadLluvia * quant;
	}
	
	action rainEfect{
		ask agua{
			capacity <- capacity + cantidadLluvia_;
		}
		
		loop tierra_1 over:tierra{
			ask tierra_1{
				hidr <- hidr + cantidadLluvia_*0.05;
				if(hidr > 10.0){
					hidr <- 10.0;
				}
			} 
		}
	}
	
	reflex update_water_chart{
		ask agua{
			water_capacity <- self.capacity;
=======
		
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
	
	reflex reward_func{
		reward <- n_agents + water_q * max_n_agents / max_water_q;
	}
	
	reflex update_capacity{
		
			rainFrecuencyCounter <- rainFrecuencyCounter + 1;
			//write rainFrecuencyCounter;
			if(rainFrecuencyCounter > rainFrecuency){
				rainFrecuencyCounter <- 0;
				cantidadLluvia_ <- generateRain();
				do rainEfect;
			}
	}
	
	float generateRain{
		float quant <- rnd (0.0, 1.0, 0.2);
		
		return cantidadLluvia * quant;
	}
	
	action rainEfect{
		ask agua{
			capacity <- capacity + cantidadLluvia_;
		}
		
		loop tierra_1 over:tierra{
			ask tierra_1{
				hidr <- hidr + cantidadLluvia_*0.05;
				if(hidr > 10.0){
					hidr <- 10.0;
				}
			} 
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
		}
	}
	
}


<<<<<<< HEAD
=======


>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
// Especie Humano
// TODO: 2a iteración --> modelo BPI del agricultor
species human skills: [moving] control: simple_bdi{
	int id;					// Id de la casa a la que pertenece
	point home_pos;			// Posición de la casa
	float water_cap;		// Cantidad de agua actual
	float max_water_cap;	// Capacidad de agua máxima
	float hidr_level;		// Nivel de hidratación
	float thirst_thres;		// Umbral de sed para beber
<<<<<<< HEAD
	//float thirst_update;	// Ratio de actualización de la sed
=======
	float thirst_update;	// Ratio de actualización de la sed
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	float drink_quantity;
	human negotiator;		// Humano con el que se espera hacer negociaciones
	list prev_neg;			// Lista de humanos con los que se ha negociado
	
	float food_cap;
	float max_food_cap;
	float hunger_level;
	float hunger_thres;
<<<<<<< HEAD
	//float hunger_update;
=======
	float hunger_update;
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	float eat_quantity;
	human negotiator_food;
	list prev_neg_food;
	
<<<<<<< HEAD
	int aspect_likeness; // Para visualizar si se agradan o no en la negociacion
	bool neg_activation;
	int neg_cycles;
	bool neg_animation;
	string neg_name;
=======
	float velocity;
	
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	
	
	// -- Init --
	init{
		
		use_social_architecture  <- true;
		water_cap <- 100.0;
		max_water_cap <- 100.0;
		hidr_level <- 100.0;
		thirst_thres <- 50.0;
<<<<<<< HEAD
		//thirst_update <- rnd(1.0, 2.0) * eat_drink_q;
=======
		thirst_update <- rnd(1.0, 2.0) * eat_drink_q; // rnd(0.01, 0.05);
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
		drink_quantity <- 1.0;
		agreeableness <- 1.0;
		negotiator <- nil;
		
		food_cap <- 100.0;
		max_food_cap <- 100.0;
		hunger_level <- 100.0;
		hunger_thres <- 50.0;
		eat_quantity <- 1.0;
<<<<<<< HEAD
		//hunger_update <- rnd(1.0, 2.0) * eat_drink_q;
		
=======
		hunger_update <- rnd(1.0, 2.0) * eat_drink_q; // rnd(0.01, 0.05);
		
		velocity <- 2.0;
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
		
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
<<<<<<< HEAD
				write "I am " + myself.name + " and i want to negotiate with " + self.name;
=======
				write "I am " + name + " and i want to negotiate with " + self.name;
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
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
<<<<<<< HEAD
				write "I am " + name + " and i want to negotiate with " + self.name + " with food";
=======
//				write "I am " + name + " and i want to negotiate with " + self.name + " with food";
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
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
		if(food_cap < 10.0){
			prev_neg_food <- [];
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
<<<<<<< HEAD
		do wander amplitude: 30.0 speed:1.0;
=======
		if(hunger_level > 30)
		{
			do wander amplitude: 30.0 speed:velocity;
		}
		else{
			do wander amplitude: 30.0 speed:velocity * 1.8;
		}
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
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
		bool equal <- false;
<<<<<<< HEAD
		write "I am " + name + " and i am negotiating with " + negotiator.name + " for water";
	
		
		ask negotiator{
=======
		
//		write "I am " + name + " and i am negotiating with " + negotiator.name + " for water";
		
		ask negotiator{
			
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
			if(myself.food_cap > 50){
				equal <- true;
				likeness <- likeness + 0.1;
			}
			
<<<<<<< HEAD
			if  likeness >= 0.5{
				self.aspect_likeness <- 1;
			}
			else{
				self.aspect_likeness <- 2;
			}
			bool res <- flip(likeness);
			write likeness;
			
			if(res){
				write "OK w";
				self.water_cap <- self.water_cap - negotiate_q;
				myself.water_cap <- myself.water_cap + negotiate_q;
=======
			bool res <- flip(likeness);
//			write likeness;
			
			if(res){
//				write "OK w";
				
				self.water_cap <- self.water_cap - negotiate_q;
				myself.water_cap <- myself.water_cap + negotiate_q;
				
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
				if(equal){
					self.food_cap <- self.food_cap + negotiate_q;
					myself.food_cap <- myself.food_cap - negotiate_q;
//					write "Negocio tmb por comida";
				}
<<<<<<< HEAD
				self.agreeableness  <- self.agreeableness + bonus_negotiate;	
				yes_negotiation_w <- yes_negotiation_w+1;
				self.neg_activation <- true;
				self.neg_cycles <- cycle;
				myself.neg_activation <- true;
				myself.neg_cycles <- cycle;
				myself.neg_name <- self.name;
				self.neg_name <- myself.name;
				//write "cycle: " + neg_cycles;
			}
			else{
				write "BAD w";
				if(likeness > 0.5){
					self.agreeableness  <- self.agreeableness - bonus_negotiate;
				}
				no_negotiation_w <- no_negotiation_w+1;
=======
				
				self.agreeableness  <- self.agreeableness + bonus_negotiate;				
			}
			else{
//				write "BAD w";
				if(likeness > 0.5){
					self.agreeableness  <- self.agreeableness - bonus_negotiate;
				}
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
			}
		}
		if(equal){
			likeness <- likeness - 0.1;
		}
		
		negotiator <- nil;
		do remove_intention(negotiate, true);
		do remove_belief(negotiate);
	}
	
	
	// Hacer negocios: comida
	plan make_negotiation_food intention:negotiate_food priority:20{
		float likeness <- get_liking(get_social_link(new_social_link(negotiator_food))) - (1.0 - agreeableness);
		bool equal <- false;
<<<<<<< HEAD
		write "I am " + name + " and i am negotiating with " + negotiator_food.name + " for food";
		
		ask negotiator_food{
=======
		
//		write "I am " + name + " and i am negotiating with " + negotiator_food.name + " for food";
		
		ask negotiator_food{
			
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
			if(myself.water_cap > 50){
				equal <- true;
				likeness <- likeness + 0.1;
			}
<<<<<<< HEAD
			if  likeness >= 0.5{
				self.aspect_likeness <- 1;
			}
			else{
				self.aspect_likeness <- 2;
			}
			bool res <- flip(likeness);
			write likeness;
			
			if(res){
				write "OK F";
				self.food_cap <- self.food_cap - negotiate_q;
				myself.food_cap <- myself.food_cap + negotiate_q;
=======
			
			bool res <- flip(likeness);
//			write likeness;
			
			if(res){
//				write "OK F";
				self.food_cap <- self.food_cap - negotiate_q;
				myself.food_cap <- myself.food_cap + negotiate_q;
				
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
				if(equal){
					self.water_cap <- self.water_cap + negotiate_q;
					myself.water_cap <- myself.water_cap - negotiate_q;
//					write "Negocio tmb por agua";
				}
<<<<<<< HEAD
				self.agreeableness  <- self.agreeableness + bonus_negotiate;
				yes_negotiation_f <- yes_negotiation_f+1;
				self.neg_activation <- true;
				self.neg_cycles <- cycle;
				myself.neg_activation <- true;
				myself.neg_cycles <- cycle;
				myself.neg_name <- self.name;
				self.neg_name <- myself.name;
			}
			else{
				write "BAD F";
				if(likeness > 0.5){
					self.agreeableness  <- self.agreeableness - bonus_negotiate;
				}
				no_negotiation_f <- no_negotiation_f+1;
			}
		}
=======
				
				self.agreeableness  <- self.agreeableness + bonus_negotiate;
			}
			else{
//				write "BAD F";
				if(likeness > 0.5){
					self.agreeableness  <- self.agreeableness - bonus_negotiate;
				}
			}
		}
		
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
		if(equal)
		{
			likeness <- likeness - 0.1;
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
<<<<<<< HEAD
		write "I am " + name + " and I die";
=======
//		write "I am " + name + " and I die";
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
		n_agents <- n_agents - 1;
		do die;
	}
	
<<<<<<< HEAD
	reflex poner_animacion when: neg_activation{
		neg_animation <- true;
		//write "Negotiator: " + neg_name;
	}
	
	reflex quitar_animacion when: not neg_activation{
		neg_animation <- false;
		neg_name <- "";
	}
	
	reflex actualizar_animacion when: cycle = neg_cycles + 50{
		neg_activation <- false;
	}
	
=======
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	// -- Apecto --	
	aspect base {			
		draw triangle(2) color:color rotate: 90 + heading;	
	}
	aspect info {
		draw triangle(2) color:color rotate: 90 + heading;
		draw string("w: " + water_cap with_precision 2) size: 3 at: location + {0.5, 0, 0} color: #black;
		draw string("f: " + food_cap with_precision 2) size: 3 at: location + {0.5, 1.5, 0} color: #black;
	}
}



// 
species farmer parent: human{
	list<tierra> earth_loc;
	int seeds;
<<<<<<< HEAD
	image_file my_icon;
	
=======
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	
	init{
		
		do remove_intention(get_predicate(get_current_intention()));
		do add_desire(farm);
<<<<<<< HEAD
		int rnd <- rnd(1,2);
		if rnd = 1{
			my_icon <- image_file("../includes/farmer_boy.png");
		}
		else{
			my_icon <- image_file("../includes/farmer_girl.png");
		}
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
		do goto target:earth_loc[0].location - {0,3,0} speed:1.0;
	}
	
	// Percepciones
	perceive target:earth_loc[0] in: 3{
=======
	}
	
	
	action default{
		do goto target:earth_loc[0].location  speed:1.0;
	}
	
	// Percepciones
	perceive target:earth_loc[0] in: 1{
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
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
	rule belief: dry new_desire: cultivate strength:50;
	rule belief: irrigate new_desire: irrigate;
	rule belief: harvest new_desire: harvest strength:50;
	
	// Planes
	plan cultivate_plan intention:cultivate priority:50{
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
	
	plan harvest_plan intention: harvest priority:50{
		//write "I am "+name+" and i am harvesting";
		
		earth_loc[0].state <- "dry";
		food_cap <-  100.0;
		
		prev_neg_food <- [];
		
		do remove_intention(get_predicate(get_current_intention()), true);
		do remove_belief(harvest);
		do remove_intention(harvest);
	}
<<<<<<< HEAD
	
	aspect icon {		
		//draw string("Negotiator:" + neg_name) color: #black size: 5 at: location + {-3, -5, 0};
		bool first_selected <- true;	
		int rnd <- rnd(1,2);
		//image_file my_icon <- image_file("../includes/farmer_boy.png");
//		if rnd = 1{
//			my_icon <- image_file("../includes/farmer_boy.png");
//		}
//		else{
//			my_icon <- image_file("../includes/farmer_girl.png");
//		}
		draw my_icon size: 5;
		
		if neg_animation{
			draw string("Negotiator: " + neg_name) size: 3 at: location + {-2, -5, 0} color: #black;
			if aspect_likeness != nil{
				if aspect_likeness = 1{ // Se gustan
					image_file heart <- image_file("../includes/heart.png");
					draw heart size: 3 at: location + {0, -4, 0};
				}
				else if aspect_likeness = 2{ // No se gustan
					image_file angry <- image_file("../includes/angry.png");
					draw angry size: 3 at: location + {0, -4, 0};
				}
			}
		}
		draw string(name) size: 3 at: location + {2,0,0} color: #black;
	}
	aspect info {
		//image_file my_icon <- image_file("../includes/farmer_boy.png");	
		draw my_icon size: 5;
		draw string("w: " + water_cap with_precision 2) size: 3 at: location + {0.5, 0, 0} color: #black;
		draw string("f: " + food_cap with_precision 2) size: 3 at: location + {0.5, 1.5, 0} color: #black;
	}
=======
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
}

// Especie Casa
species casa{
	
	int n_humanos;			// Número de humanos por casa
<<<<<<< HEAD
	int n_farmers;			// Número de granjeros por casa
=======
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	int id;					// Id de la casa
	int max_row;			// Máximo de filas del poblado
	
	// -- Init --
	init{
<<<<<<< HEAD
		n_farmers <- rnd(1, 2);
		n_humanos <- rnd (1, 2);		// Número de humanos aleatorio

=======
		n_humanos <- rnd (1, 2);		// Número de humanos aleatorio
		int n_farmer <- rnd (1, 2);
		
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
		n_agents <- n_agents + n_humanos;
		max_n_agents <- n_agents;
		
		location <- {18 + 8*(id - max_row*int(id/max_row)), 18 + 8*int(id/max_row)};	// Localización de la casa
		
		// --- Creación de humanos: conocen el ID de la casa y su localización ---
<<<<<<< HEAD
		create farmer number: n_farmers with: [id::self.id, location::self.location, home_pos::self.location];
		//create human number: n_humanos with: [id::self.id, location::self.location, home_pos::self.location];
=======
		create farmer number: n_farmer with: [id::self.id, location::self.location, home_pos::self.location];
		create human number: n_humanos with: [id::self.id, location::self.location, home_pos::self.location];
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	}
	
	// -- Aspecto --
	aspect base {
	  draw square(4) color: #red border: #black;		
	}
	aspect icon {
	  image_file my_icon <- image_file("../includes/house.png");	
	  draw my_icon size: 5;	
	}
}

// Especie del Pozo de Agua
species agua{
	float ratio;							// Ratio de aparición
	float capacity;							// Capacidad actual
	float max_capacity;		
	rgb colorAgua;				// Máxima capacidad
<<<<<<< HEAD
	image_file icon <- image_file("../includes/pond.png");
=======
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	
	// -- Init --
	init{
		ratio <- 2.0;
		capacity <- 1000.0;
<<<<<<< HEAD
		max_capacity <- 10000.0;
=======
		max_capacity <- max_water_q;
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	}
	
	
	// -- Reflex --
	// Actualización de la capacidad de agua
//	reflex update_capacity{
//		if(capacity < max_capacity){
//			capacity <- capacity + ratio;
//		}
//	}
<<<<<<< HEAD
=======

	reflex get_cap{
		water_q <- capacity;
	}
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	
	// -- Aspecto --
	aspect base{
		
<<<<<<< HEAD
		//colorAgua <- #blue;
=======
		colorAgua <- #blue;
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
		
		if(capacity < 500){
			colorAgua  <- #darkblue;
		}else if(capacity < 100){
			colorAgua <- #black;
		}
		
<<<<<<< HEAD
		if colorAgua = #darkblue or colorAgua = #black{
			draw square(4) color: colorAgua border: #black;
		}
		else{
			draw icon size: 8.5;
		}
=======
		draw square(4) color: colorAgua border: #black;
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	}
}

// Especies Tierra: 
// TODO: 2a iteración --> tipos de tierra, rotaciones de cultivos, tipos, ...
species tierra{
	
	int type;
	string state;
	float hidr;
	rgb colorTierra;
	int counter;
<<<<<<< HEAD
	image_file crop;
=======
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
	
	
	init{
		colorTierra  <- rgb (148,100,37);
		state <- "dry";
		hidr <- 10.0;
		counter <- 0;
	}
	
	aspect base{
		// Dry color
		colorTierra  <- rgb (148,100,37);

		// Cultivated color
		if(state = "cultivated"){
<<<<<<< HEAD
			//colorTierra <- rgb (48,182,43);
			crop <- image_file("../includes/cultivated.png");	
=======
			colorTierra <- rgb (48,182,43);
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
		}

		// Harvestable color
		else if(state = "harvestable"){
<<<<<<< HEAD
			//colorTierra <- rgb (24,235,17);
			crop <- image_file("../includes/harvestable.png");
=======
			colorTierra <- rgb (24,235,17);
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
		}

		// Draw the aspect with selected color
		draw square(4) color: colorTierra border:#black;
		if crop != nil{
			draw crop size: 3;
		}
	}
	
	reflex update_hidr when: state = "cultivated"{
		if(hidr > 0.0){
			hidr <- hidr - earth_ratio;
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
<<<<<<< HEAD
}


// --- Experimentos ---
experiment resources_main_1 type: gui {
	parameter "Rain frequency: " var: rainFrecuency min: 0 max: 1000 category: "Rain";
	parameter "Earth ratio: " var: earth_ratio min: 0.0 max: 0.5 category: "Earth";
	//parameter "Water capacity: " var: water_capacity category: "Water";
	parameter "Thirst update: " var: thirst_update category: "Human";
	parameter "Hunger update: " var: hunger_update category: "Human";
	
	output {					
		display main_display type:2d antialias:false {
			grid gworld border: #darkgreen;
			species casa aspect:icon;
			species agua aspect:base;
			species tierra aspect:base;
			species human aspect:base;
			species farmer aspect: icon;		
		}
		display info_display type:2d antialias:false {
			grid gworld border: #darkgreen;
			species casa aspect:icon;
			species agua aspect:base;
			species tierra aspect:base;
			species human aspect:info;
			species farmer aspect: info;	
		}
		display Information refresh: every(1#cycles)  type: 2d {	
			chart "Water level" type: series {
				data "Water" value: water_capacity color: #blue;
			}	
			chart "Succesful water negotiation" type: histogram background: #white size: {0.5,0.5} position: {0, 0.5} {
				data "Yes" value: yes_negotiation_w color:#blue;
				data "No" value: no_negotiation_w color:#blue;

			}
			chart "Succesful food negotiation" type: histogram background: #white size: {0.5,0.5} position: {0.5, 0.5} {
				data "Yes" value: yes_negotiation_f color:#red;
				data "No" value: no_negotiation_f color:#red;

			}
=======
	
	reflex update_hidr when: state = "cultivated"{
		if(hidr > 0.0){
			hidr <- hidr - earth_ratio;
			counter <- counter + 1;
		}
		else{
			counter <- 0;
			state <- "dry";
		}
		
		if(counter >= 2000){
			
			counter <- 0;
			state <- "harvestable";
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
		}
	}
}

<<<<<<< HEAD
=======

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

//float cantidadLluvia <- 200.0;
//	int rainFrecuency <- 200;
//	float eat_drink_q <- 0.01;
//	float earth_ratio <- 0.01; 
//	float negotiate_q <- 10.0;
//	float bonus_negotiate <- 0.1;

>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
experiment Batch type: batch repeat: 1 keep_seed: true until: n_agents <= 0 or cycle > 30000{
    parameter 'cantidadLluvia:' var: cantidadLluvia min: 100.0 max: 300.0;
    parameter 'rainFrecuency' var: rainFrecuency min: 100 max: 300;
    parameter 'eat_drink_q' var: eat_drink_q min: 0.005 max: 0.3;
    parameter 'earth_ratio' var: earth_ratio min: 0.005 max: 0.3;
    parameter 'negotiate_q:' var: negotiate_q min: 1.0 max: 40.0;
    parameter 'bonus_negotiate' var: bonus_negotiate min: 0.05 max: 0.3;

    method hill_climbing iter_max: 100 maximize: reward;
<<<<<<< HEAD
}
=======
}
>>>>>>> ffd2af473e31d04f8e1d27e61a0f45d1480e7827
