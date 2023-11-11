model proyectoFinal


// Grid del mundo
grid gworld width: 25 height: 25 neighbors:4 {
	rgb color <- rgb (208,157,87);
}

// Definción de global
global{
	
	// --- Predicates ---
	predicate patrol_desire <- new_predicate("patrol");
	
	// -- Init --
	init {
		point agua_loc;   // Locaclización del agua conocida para todos
		
		// --- Creación de especies ---
		// Creación de las casas
		loop i from: 0 to: 5{
			create casa with: [id:: i, max_row:: 3];
		}

		// Creación del Pozo de agua
		create agua{
			location<-{74, 50};
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
	
	// -- Init --
	init{
		do add_desire(patrol_desire);	// Deseo inicial: patrullar
		home_pos <- location;			// Asigna localización de la casa
	}
	
	// -- Planes --
	plan patrolling intention:patrol_desire{
		do wander amplitude: 30.0 speed: 0.0;
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
		n_humanos <- rnd (1, 3);		// Número de humanos aleatorio

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