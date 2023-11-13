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
	point agua_loc;   // Locaclización del agua conocida para todos
	
	
	// -- Init --
	init {
		int n_max <- 3;
		// --- Creación de especies ---
		// Creación de las casas
		loop i from: 0 to: n_max - 1{
			create casa with: [id:: i, max_row:: 3];
		}

		// Creación del Pozo de agua
		create agua{
			location<-{74, 50};
		}
		
		
		loop human_1 over: human{
			loop human_2 over: human{
				if(human_1 != human_2){
					ask human_1{

						int id1 <- human_1.id;
						int id2 <- human_2.id;
						
						float liking <- float(n_max - abs(id1 - id2));
//						float dominance <- 0.0;
//						float solidarity <- 0.0;
//						float familiarity <- float(n_max - abs(id1 - id2));
//						write familiarity;
						
						do add_social_link(new_social_link(human_2));
						social_link sl <- set_liking(get_social_link(new_social_link(human_2)),0.3);
//						write get_familiarity(get_social_link(new_social_link(human_2)));
//						write get_liking(get_social_link(new_social_link(human_2)));
//						write get_dominance(get_social_link(new_social_link(human_2)));
//						write get_solidarity(get_social_link(new_social_link(human_2)));
//						write "--";
					}
				}
			}
		}
		
		
		// -- ASKS --
		// Pregunta la posición del agua
		ask agua{
			agua_loc <- self.location;
		}
	}
}




// Especie Humano
// TODO: 1a iteración --> modelo BDI del humano
species human skills: [moving] control: simple_bdi{
	int id;				// Id de la casa a la que pertenece
	point home_pos;		// Posición de la casa
	float water_cap;
	float max_water_cap;
	float hidr_level;
	float thirst_thres;
	float thirst_update;
	
	
	
	
	// -- Init --
	init{
		use_social_architecture  <- true;
		water_cap <- 10.0;
		max_water_cap <- 10.0;
		hidr_level <- 2.0;
		thirst_thres <- 5.0;
		thirst_update <- 0.1;
		
		do add_desire(patrol);			// Deseo inicial: patrullar
		home_pos <- location;			// Asigna localización de la casa
	}
	
	// -- Perceptions --
	// Sed
	perceive target:self {
		if(hidr_level > 5){
			do add_belief(no_thirst);
			do remove_belief(thirst);
		}
		else{
			do add_belief(thirst);
			do remove_belief(no_thirst);
			do remove_intention(get_predicate(get_current_intention()));
		}
	}
	
	// Agua
	perceive target:self{
		if(water_cap <= 1){
			do add_belief(no_water);
			do remove_belief(water);
			do remove_intention(patrol);
		}
		else{
			do add_belief(water);
			do remove_belief(no_water);
		}
	}
	
	
	// -- Rules --
	rule belief: thirst new_desire: drink strength: 15.0;
	rule belief: no_thirst new_desire: patrol;
	
	rule belief: no_water new_desire: water strength: 20;
	rule belief: water new_desire: patrol;
	
	
	// -- Planes --
	plan patrolling intention:patrol{
		do wander amplitude: 30.0 speed:1.0;
	}
	
	plan drink intention:drink priority:10.0{

		if(water_cap > 0)
		{
			write "I am " + name + " and I drink";
			hidr_level <- hidr_level + 1;
			water_cap <- water_cap - 1;
			
			if(hidr_level > thirst_thres)
			{
				do remove_intention(drink, true);
				do remove_belief(drink);
			}
		}		
	}
	
	plan go_to_well intention:water priority:15.0{
		agua wa <- first(agua);
		do goto target: wa.location speed:2.0;
		write "I am going for water";
		
		if (self distance_to wa <= 1) {
			ask agua
			{
				float water_taken <- min(myself.max_water_cap - myself.water_cap, self.capacity);
				myself.water_cap <- myself.water_cap + water_taken;
				self.capacity <- self.capacity - water_taken;
			}
    		
    		write "I am taking water";
		}
		if(water_cap >= max_water_cap)
		{
			do remove_intention(water, true);
			write "Finish water";
		}
	}
	
	
	// -- Reflex --
	reflex thirst_update_ref{
		hidr_level <- hidr_level - thirst_update;
	}
	
	reflex human_die when: hidr_level <= 0 {
		write "I am " + name + " and I die";
		do die;
	}
	
	// -- Apecto --	
	aspect base {			
		draw triangle(2) color:color rotate: 90 + heading;	
	}
}

// Especie Casa
species casa{
	
	int n_humanos;			// Número de humanos por casa
	int id;					// Id de la casa
	int max_row;			// Máximo de filas del poblado
	
	// -- Init --
	init{
		n_humanos <- 1; //rnd (1, 3);		// Número de humanos aleatorio

		location <- {18 + 8*(id - max_row*int(id/max_row)), 18 + 8*int(id/max_row)};	// Localización de la casa
		
		// --- Creación de humanos: conocen el ID de la casa y su localización ---
		create human number: n_humanos with: [id::self.id, location::self.location];
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
		ratio <- 0.02;
		capacity <- 100.0;
		max_capacity <- 100.0;
	}
	
	
	// -- Reflex --
	// Actualización de la capacidad de agua
	reflex update_capacity{
		if(capacity < max_capacity){
			capacity <- capacity + ratio;
		}
	}
	
	// -- Aspecto --
	aspect base{
		draw square(4) color: #blue border: #black;
	}
}


// Especies Tierra: 
// TODO: 2a iteración --> tipos de tierra, rotaciones de cultivos, tipos, ...
species tierra{
	aspect base{
		rgb colorTierra <- rgb (148,100,37);
		draw square(4) color: colorTierra border:#black;
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
		}
	}
}