model proyectoFinal

/* Insert your model definition here */

grid gworld width: 25 height: 25 neighbors:4 {
	rgb color <- rgb (208,157,87);
}
global{
	
	predicate patrol_desire <- new_predicate("patrol");

	init {
		create pueblo number:1;
		create agua number:1;
		create zonadeCultivo number:1;
		create human number:6;
	}
}

species pueblo{
	init{
		gworld place <- one_of(gworld);
		location <- place.location;

		
		int locationInicialx <- 10;
		int locationInicialy <- 10;
		int locationActualx <- locationInicialx;
		int locationActualy <- locationInicialy;
		int auxiliar <- 0;
		
		loop i from: 0 to: 5 {
			
			if(i=3){
				auxiliar <- auxiliar + 8;
				locationActualx <- locationInicialx;
			}
			
			create casa{
				location <- {locationActualx + 8,locationActualy + auxiliar};
			}
			
			locationActualx <- locationActualx+8;
		}
	}
}

species zonadeCultivo{
	init{
		gworld place <- one_of(gworld);
		location <- place.location;

		
		int locationInicialx <- 10;
		int locationInicialy <- 62;
		int locationActualx <- locationInicialx;
		int locationActualy <- locationInicialy;
		int auxiliar <- 0;
		
		loop i from: 0 to: 20 {
			
			if(i=10){
				auxiliar <- auxiliar + 4;
				locationActualx <- locationInicialx;
			}
			
			create tierra{
				location <- {locationActualx + 4,locationActualy + auxiliar};
			}
			
			locationActualx <- locationActualx+4;
		}
	}
}

species human skills: [moving] control: simple_bdi{
	
	init{
		gworld place <- one_of(gworld);
		location <- place.location;
		do add_desire(patrol_desire);
	}
	
	plan patrolling intention:patrol_desire{
		do wander amplitude: 30.0 speed: 1.0;
	}
	
	aspect base {			
		draw triangle(2) color:color rotate: 90 + heading;	
	}
}

species casa{
	
	aspect base {
	  draw square(4) color: #red border: #black;		
	}
}

species agua{
	aspect base{
		draw square(4) color: #blue border: #black;
	}
}

species tierra{
	aspect base{
		rgb colorTierra <- rgb (148,100,37);
		draw square(4) color: colorTierra border:#black;
	}
}

experiment resources_main_1 type: gui {
	/** Insert here the definition of the input and output of the model */
	output {					
		display view1 { 
			grid gworld border: #darkgreen;
			species casa aspect:base;
			species pueblo;
			species agua aspect:base;
			species tierra aspect:base;
			species human aspect:base;

		}
		
		
	}
}