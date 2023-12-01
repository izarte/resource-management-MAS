model proyectoFinal

// World grid
grid gworld width: 25 height: 25 neighbors:4 {
	rgb color <- rgb (208,157,87);
}

// Definition of the global species
global{
	
	// --- Predicates ---
	predicate patrol <- new_predicate("patrol");					// For the patrol desire
	predicate drink <- new_predicate("drink");						// For the drink desire
	predicate thirst <- new_predicate("thirst");					// For the thirsty belief
	predicate no_thirst <- new_predicate("no_thirst");				// For the not thirsty belief
	predicate water <- new_predicate("water");						// For the having water belief
	predicate no_water <- new_predicate("no_water"); 				// For the not having water belief
	predicate negotiate <- new_predicate("negotiate");  			// For the negotiation for water desire
	
	predicate food <- new_predicate("food");						// For the having food belief		
	predicate no_food <- new_predicate("no_food");					// For the not having food belief
	predicate eat <- new_predicate("eat");							// For the eating desire
	predicate negotiate_food <- new_predicate("negotiate_food");	// For the negotiation for food desire
	
	predicate farm <- new_predicate("farm");						// Formalism
	predicate dry <- new_predicate("dry");							// For the dry earth belief
	predicate cultivate <- new_predicate("cultivate");				// For the cultivate earth desire
	predicate irrigate <- new_predicate("irrigate");				// For the irrigate earth desire
	predicate harvest <- new_predicate("harvest");					// For the harvest earth desire
	
	
	// --- Parameters optimized with Hill Climbing ---
	float rainQuantity <- 114.0;		// Number of water units added to the pond
	int rainFrecuency <- 200;			// How many cycles may pass until it rains
	float eat_drink_q <- 0.005;			// Rate for decreasing the thirst and hunger satisfaction levels
	float earth_ratio <- 0.005;         // Rate for decreasing the earth hydration levels
	float negotiate_q <- 14.0;			// Water or food quantity that is being traded in the negotiations
	float bonus_negotiate <- 0.05;		// Update the agreeableness depending on the negotiation result
	
	float reward <- 0.0; 				// Reward to be maximized in the algorithm
	int n_agents <- 0;					// Number of agents living in the world
	int max_n_agents <- 0;				// Maximum number of agents living in the world simultaneously
	float water_q <- 0.0;				// Water quantity to calculate the reward
	float max_water_q <- 10000.0;		// Max water quantity to calculate the reward
	
	
	// --- Visualization parameters ---
	float water_capacity <- 0.0;		// Pond's water capacity
	int yes_negotiation_w <- 0;			// Number of successful water negotiations
	int no_negotiation_w <- 0;			// Number of unsuccessful water negotiations
	int yes_negotiation_f <- 0;         // Number of successful food negotiations
	int no_negotiation_f <- 0;          // Number of unsuccessful food negotiations
	
	
	// --- Other parameters ---
	point water_loc;   									// Water localization known by everyone 
	int n_max;											// Maximum number of houses		
	int rainFrecuencyCounter;							// Auxiliary variable to count the number of cycles until it rains
	float rainQuantity_;								// Random rain quantity generated
	float thirst_update <- rnd(1.0, 2.0) * eat_drink_q; // For updating the thirst satisfaction level every cycle
	float hunger_update <- rnd(1.0, 2.0) * eat_drink_q; // For updating the hunger satisfaction level every cycle
	
	// --- Initialization ---
	init {
		n_max <- 5; // Maximum number of houses
		
		// --- Species creation ---
		// Houses creation
		loop i from: 0 to: n_max - 1{
			create house with: [id:: i, max_row:: 3];
		}

		// Water pond creation
		create pond{
			location<-{74, 50};
		}
		
		// Loop through all pairs of farmers to create social links based on "liking"
		loop human_1 over: farmer{
			loop human_2 over: farmer{
				if(human_1 != human_2){
					ask human_1{
					
						int id1 <- human_1.id;
						int id2 <- human_2.id;
						
						// Calculation of "liking" between the two farmers
						float liking <- float(n_max - abs(id1 - id2))/n_max;
						
						// Create the social link between the farmers
						do add_social_link(new_social_link(human_2));
						social_link sl <- set_liking(get_social_link(new_social_link(human_2)), liking);
					}
				}
			}
		}
		
		// Set up initial location for creating earth agents
		point original_earth <- {18, 62};
		point init_earth <- original_earth;
		point aux <- init_earth;
		
		// Loop through farmers to create earth agents and assign them locations
		loop farmer_1 over:farmer{
			create earth with: [location::init_earth];
			
			// Update the next earth location
			aux <- {init_earth.x + 8, init_earth.y};
			init_earth <- aux;
			
			// Check if the earth location exceeds a certain threshold and adjust
			if(init_earth.x > 50){	
				init_earth <- {18, init_earth.y + 8};
			}
		}
		
		int idx <- 0; // For assigning earth agents to farmers
		
		// Loop through earth agents and assign them to farmers
		loop earth_1 over: earth{
			add earth_1 to: farmer[idx].earth_loc;
			idx <- idx + 1;
		}
		
		
		// -- ASKS --
		// Ask for the position of the water
		ask pond{
			water_loc <- self.location;
		}		
		
	}
	
	// For calculating the reward based on the number of agents and water quantity
	reflex reward_func{
		reward <- n_agents + water_q * max_n_agents / max_water_q;
	}
	
	// For updating rain capacity and triggering rain effects
	reflex update_capacity{
		
			rainFrecuencyCounter <- rainFrecuencyCounter + 1;
			
			if(rainFrecuencyCounter > rainFrecuency){
				rainFrecuencyCounter <- 0;
				rainQuantity_ <- generateRain();
				do rainEfect;
			}
	}
	
	// Function to generate random rain quantity
	float generateRain{
		float quant <- rnd (0.0, 1.0, 0.2);
		
		return rainQuantity * quant;
	}
	
	// For applying rain effects to the pond and earth agents
	action rainEfect{
		// Increase the pond's capacity based on the generated rain quantity
		ask pond{
			capacity <- capacity + rainQuantity_;
		}
		
		// Loop through earth agents and adjust their hydration levels
		loop earth_1 over:earth{
			ask earth_1{
				hidr <- hidr + rainQuantity_*0.05;
				// Cap hydration at 10.0
				if(hidr > 10.0){
					hidr <- 10.0;
				}
			} 
		}
	}
	
	// For updating the water chart based on the pond's capacity
	reflex update_water_chart{
		ask pond{
			water_capacity <- self.capacity;
		}
	}
	
}


// Human species
species human skills: [moving] control: simple_bdi{
	int id;					// Identifier of the house it belongs to
	point house_pos;		// House position
	float water_cap;		// Current water capacity
	float max_water_cap;	// Maximum water capacity
	float hidr_level;		// Hydration level
	float thirst_thres;		// Thirst threshold for drinking
	float drink_quantity;	// Amount to drink
	human negotiator;		// Human for water negotiation
	list prev_neg;			// List of humans negotiated with previosly
	
	float food_cap;			// Current food capacity
	float max_food_cap;		// Maximum food capacity
	float hunger_level;		// Hunger level
	float hunger_thres;		// Hunger threshold for eating
	float eat_quantity;		// Amount to eat
	human negotiator_food;	// Human for food negotiation
	list prev_neg_food;		// List of humans negotiated with previosly for food
	
	int aspect_likeness; 	// Visualize likeness in negotiation
	bool neg_activation;	// Negotiation activation flag
	int neg_cycles;			// Number of negotiation cycles
	bool neg_animation;		// Negotiation animation flag
	string neg_name;		// Negotiator's name
	
	
	// -- Init --
	init{
		
		//Parameter initialization
		use_social_architecture  <- true;
		water_cap <- 100.0;
		max_water_cap <- 100.0;
		hidr_level <- 100.0;
		thirst_thres <- 50.0;
		thirst_update <- rnd(1.0, 2.0) * eat_drink_q;
		drink_quantity <- 1.0;
		agreeableness <- 1.0;
		negotiator <- nil;
		
		food_cap <- 100.0;
		max_food_cap <- 100.0;
		hunger_level <- 100.0;
		hunger_thres <- 50.0;
		eat_quantity <- 1.0;
		hunger_update <- rnd(1.0, 2.0) * eat_drink_q;
		
		
		do add_desire(patrol);			// Initial desire: patrol
		house_pos <- location;			// Assign house location
	}
	
	// -- Perceptions --
	// Thirst 
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
	
	// Hunger 
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
	
	// Utility function to get all instances of a species
	list<agent> get_all_instances(species<agent> spec) {
        return spec.population +  spec.subspecies accumulate (get_all_instances(each));
    }
	
	// Action to ask for water negotiation
	action ask_for_water{
		ask get_all_instances(human) at_distance(100) {
			//They haven't negotiate previously and the negotiator can offer water
			if(not(myself.prev_neg contains self) and human(self).water_cap > 50)
			{
				write "I am " + myself.name + " and i want to negotiate with " + self.name;
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
	
	// Water 
	perceive target:self{
		// Water negotiation
		if(water_cap <= 30.0)
		{
			do ask_for_water;
		}
		
		// Go to the pond
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
	
	// Action to ask for food negotiation
	action ask_for_food{
		ask get_all_instances(human) at_distance(100) {
			//They haven't negotiate previously and the negotiator can offer food
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
	
	// Food 
	perceive target:self{
		// Food negotiation
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
		do wander amplitude: 30.0 speed:1.0;
	}
	
	// -- Plans --
	// Patrol
	plan patrolling intention:patrol{
		do default;
	}
	
	// Drink water
	plan drink intention:drink priority:10.0{

		if(water_cap > 0)
		{
			// Increases hydration satisfaction level but reduces water capacity
			hidr_level <- hidr_level + drink_quantity;
			water_cap <- water_cap - drink_quantity;
			
			if(hidr_level > thirst_thres)
			{
				// It's not thirsty anymore
				do remove_intention(drink, true);
				do remove_belief(drink);
			}
		}		
	}
	
	// Eat
	plan eat_plan intention:eat priority:10.0{

		if(food_cap > 0)
		{
			// Increases hunger satisfaction level but reduces food capacity
			hunger_level <- hunger_level + drink_quantity;
			food_cap <- food_cap - drink_quantity;
			
			if(hunger_level > hunger_thres)
			{
				// It's not hungry anymore
				do remove_intention(eat, true);
				do remove_belief(eat);
			}
		}		
	}
	
	// Go to the pond
	plan go_to_pond intention:water priority:15.0{
		pond wa <- first(pond); // Get the first (and single) pond in the environment
		do goto target: wa.location speed:2.0; // Move towards the pond with a specified speed
		
		if (self distance_to wa <= 1) {
			ask pond
			{
				// Take water from the pond, considering capacity constraints
				float water_taken <- min(myself.max_water_cap - myself.water_cap, self.capacity);
				myself.water_cap <- myself.water_cap + water_taken;
				self.capacity <- self.capacity - water_taken;
			}
    		
		}
		if(water_cap >= max_water_cap)
		{
			// Reset the list of previous negotiators and remove the intention to get water
			prev_neg <- [];
			do remove_intention(water, true);
		}
	}
	
	
	// Negotation for water
	plan make_negotiation_water intention:negotiate priority:20{
		// Calculate likeness based on social link and agent's agreeableness
		float likeness <- get_liking(get_social_link(new_social_link(negotiator))) - (1.0 - agreeableness);
		bool equal <- false;
		write "I am " + name + " and i am negotiating with " + negotiator.name + " for water";
	
		
		ask negotiator{
			// Check if agent has enough food for a potential equal exchange
			if(myself.food_cap > 50){
				equal <- true;
				likeness <- likeness + 0.1;
			}
			
			// For visualization
			if  likeness >= 0.5{
				self.aspect_likeness <- 1;
			}
			else{
				self.aspect_likeness <- 2;
			}
			
			// Make a decision using a coin flip with adjusted likeness
			bool res <- flip(likeness);
			write likeness;
			
			if(res){
				write "OK w";
				// Update water and food quantities based on negotiation outcome
				self.water_cap <- self.water_cap - negotiate_q;
				myself.water_cap <- myself.water_cap + negotiate_q;
				if(equal){
					self.food_cap <- self.food_cap + negotiate_q;
					myself.food_cap <- myself.food_cap - negotiate_q;
				}
				
				self.agreeableness  <- self.agreeableness + bonus_negotiate;	
				yes_negotiation_w <- yes_negotiation_w+1;
				// Update negotiation parameters to show for a certain amount of cycles 
				self.neg_activation <- true;
				self.neg_cycles <- cycle;
				myself.neg_activation <- true;
				myself.neg_cycles <- cycle;
				myself.neg_name <- self.name;
				self.neg_name <- myself.name;
			}
			else{
				write "BAD w";
				// Adjust agreeableness based on likeness and update negotiation statistics
				if(likeness > 0.5){
					self.agreeableness  <- self.agreeableness - bonus_negotiate;
				}
				no_negotiation_w <- no_negotiation_w+1;
			}
		}
		if(equal){
			likeness <- likeness - 0.1;
		}
		
		negotiator <- nil;
		do remove_intention(negotiate, true);
		do remove_belief(negotiate);
	}
	
	
	// Negotiation for food
	plan make_negotiation_food intention:negotiate_food priority:20{
		// Calculate likeness based on social link and agent's agreeableness
		float likeness <- get_liking(get_social_link(new_social_link(negotiator_food))) - (1.0 - agreeableness);
		bool equal <- false;
		write "I am " + name + " and i am negotiating with " + negotiator_food.name + " for food";
		
		ask negotiator_food{
			// Check if agent has enough water for a potential equal exchange
			if(myself.water_cap > 50){
				equal <- true;
				likeness <- likeness + 0.1;
			}
			
			// For visualization
			if  likeness >= 0.5{
				self.aspect_likeness <- 1;
			}
			else{
				self.aspect_likeness <- 2;
			}
			
			// Make a decision using a coin flip with adjusted likeness
			bool res <- flip(likeness);
			write likeness;
			
			if(res){
				write "OK F";
				// Update water and food quantities based on negotiation outcome
				self.food_cap <- self.food_cap - negotiate_q;
				myself.food_cap <- myself.food_cap + negotiate_q;
				if(equal){
					self.water_cap <- self.water_cap + negotiate_q;
					myself.water_cap <- myself.water_cap - negotiate_q;
				}
				self.agreeableness  <- self.agreeableness + bonus_negotiate;
				yes_negotiation_f <- yes_negotiation_f+1;
				// Update negotiation parameters to show for a certain amount of cycles 
				self.neg_activation <- true;
				self.neg_cycles <- cycle;
				myself.neg_activation <- true;
				myself.neg_cycles <- cycle;
				myself.neg_name <- self.name;
				self.neg_name <- myself.name;
			}
			else{
				write "BAD F";
				// Adjust agreeableness based on likeness and update negotiation statistics
				if(likeness > 0.5){
					self.agreeableness  <- self.agreeableness - bonus_negotiate;
				}
				no_negotiation_f <- no_negotiation_f+1;
			}
		}
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
	
	// Agent's death based on low hydration or hunger
	reflex human_die when: hidr_level <= 0 or hunger_level <= 0 {
		write "I am " + name + " and I die";
		n_agents <- n_agents - 1;
		do die;
	}
	
	// To activate negotiation animation
	reflex show_animation when: neg_activation{
		neg_animation <- true;
	}
	
	// To deactivate negotiation animation
	reflex erase_animation when: not neg_activation{
		neg_animation <- false;
		neg_name <- "";
	}
	
	// To update negotiation animation status after a certain cycle
	reflex update_animation when: cycle = neg_cycles + 50{
		neg_activation <- false;
	}
	
	// -- Apects --	
	aspect base {			
		draw triangle(2) color:color rotate: 90 + heading;	
	}
	aspect icon{
		image_file my_icon <- image_file("../includes/human.png");
		draw my_icon size: 5;
	}
	aspect info {
		image_file my_icon <- image_file("../includes/human.png");
		draw my_icon size: 5;
		// Visualize the water and food capacity
		draw string("w: " + water_cap with_precision 2) size: 3 at: location + {0.5, 0, 0} color: #black;
		draw string("f: " + food_cap with_precision 2) size: 3 at: location + {0.5, 1.5, 0} color: #black;
	}
}


// Farmer species
species farmer parent: human{
	list<earth> earth_loc; 	// List to store the locations of farmer lands
	int seeds;				// Number of seeds the farmer has
	image_file my_icon;		// Image file for visualization
		
	// -- Init --
	init{
		
		do remove_intention(get_predicate(get_current_intention()));
		do add_desire(farm); //Formalism
		
		// Randomly choose an icon for the farmer (boy or girl)
		int rnd <- rnd(1,2);
		if rnd = 1{
			my_icon <- image_file("../includes/farmer_boy.png");
		}
		else{
			my_icon <- image_file("../includes/farmer_girl.png");
		}
	}
	
	// They remain on their farming area
	action default{
		do goto target:earth_loc[0].location - {0,3,0} speed:1.0;
	}
	
	// --- Perceptions ---
	perceive target:earth_loc[0] in: 3{
		// Check earth state and trigger beliefs and intentions accordingly
		if (self.state = "dry"){
			ask myself{
				do add_belief(dry);
			    do remove_intention(get_predicate(get_current_intention()), true);
			}
		}
		// It has seeds so it must be watered
		else if(self.state = "cultivated" and self.hidr < 5.0 and myself.water_cap > 10.0){
			ask myself{
				do add_belief(irrigate);
			    do remove_intention(get_predicate(get_current_intention()), true);
			}
		}
		// It's fully grown so it must be harvested
		else if(self.state = "harvestable"){
			ask myself{
				do add_belief(harvest);
			    do remove_intention(get_predicate(get_current_intention()), true);
			}
		}
	}
	
	
	// --- Rules --- 
	rule belief: dry new_desire: cultivate strength:50;
	rule belief: irrigate new_desire: irrigate;
	rule belief: harvest new_desire: harvest strength:50;
	
	// --- Plans ---
	plan cultivate_plan intention:cultivate priority:50{
		earth_loc[0].state <- "cultivated";
		do remove_intention(get_predicate(get_current_intention()), true);
		do remove_belief(dry);
		do remove_intention(cultivate);
	}
	
	plan irrigate_plan intention: irrigate priority:5{
		// Watering the earth
		water_cap <- water_cap - drink_quantity * 5;
		earth_loc[0].hidr <- 10.0;
		do remove_intention(get_predicate(get_current_intention()), true);
		do remove_belief(irrigate);
		do remove_intention(irrigate);
	}
	
	plan harvest_plan intention: harvest priority:50{
		// When harvested, the earth state resets and now the farmer has food so it doesn't need to negotiate 
		earth_loc[0].state <- "dry";
		food_cap <-  100.0;
		prev_neg_food <- [];
		
		do remove_intention(get_predicate(get_current_intention()), true);
		do remove_belief(harvest);
		do remove_intention(harvest);
	}
	
	// --- Aspects ---
	aspect icon {		
		draw my_icon size: 5;
		
		// Show negotiation likeness
		if neg_animation{
			draw string("Negotiator: " + neg_name) size: 3 at: location + {-2, -5, 0} color: #black;
			if aspect_likeness != nil{
				if aspect_likeness = 1{ // They like eachother
					image_file heart <- image_file("../includes/heart.png");
					draw heart size: 3 at: location + {0, -4, 0};
				}
				else if aspect_likeness = 2{ // They don't like eachother
					image_file angry <- image_file("../includes/angry.png");
					draw angry size: 3 at: location + {0, -4, 0};
				}
			}
		}
		draw string(name) size: 3 at: location + {2,0,0} color: #black; // Farmer's name
	}
	aspect info {
		draw my_icon size: 5;
		// Visualize the water and food capacity
		draw string("w: " + water_cap with_precision 2) size: 3 at: location + {0.5, 0, 0} color: #black;
		draw string("f: " + food_cap with_precision 2) size: 3 at: location + {0.5, 1.5, 0} color: #black;
	}
}

// House species
species house{
	
	int n_humans;			// Number of humans per house
	int n_farmers;			// Number of farmers per house
	int id;					// House's id
	int max_row;			// Maximum rows of the town
	
	// -- Init --
	init{
		n_farmers <- rnd(1, 2);		// Random number of farmers
		n_humans <- rnd (1, 2);		// Random number of humans

		n_agents <- n_agents + n_humans;
		max_n_agents <- n_agents;
		
		location <- {18 + 8*(id - max_row*int(id/max_row)), 18 + 8*int(id/max_row)};	// House location
		
		// --- Humans/Farmers creation: they know their houses ID and its location ---
		create farmer number: n_farmers with: [id::self.id, location::self.location, house_pos::self.location];
		create human number: n_humans with: [id::self.id, location::self.location, house_pos::self.location];
	}
	
	// --- Aspects ---
	aspect base {
	  draw square(4) color: #red border: #black;		
	}
	aspect icon {
	  image_file my_icon <- image_file("../includes/house.png");	
	  draw my_icon size: 5;	
	}
}

// Water pond species
species pond{
	float ratio;							// Appearance ratio
	float capacity;							// Current water capacity
	float max_capacity;						// Maximum water capacity
	rgb WaterColor;				 			// Water color
	image_file icon <- image_file("../includes/pond.png"); // Image file for visualization
	
	// -- Init --
	init{
		ratio <- 2.0;
		capacity <- 1000.0;
		max_capacity <- 10000.0;
	}

	
	// --- Aspects ---
	aspect base{
		// Set WaterColor based on capacity
		if(capacity < 500){
			WaterColor  <- #darkblue;
		}else if(capacity < 100){
			WaterColor <- #black;
		}
		
		// Draw different aspects based on WaterColor
		if WaterColor = #darkblue or WaterColor = #black{
			draw square(4) color: WaterColor border: #black;
		}
		else{
			draw icon size: 8.5;
		}
	}
}

// Earth species
species earth{
	int type;			// Type of earth
	string state;		// Current state of the earth (dry, cultivated, harvestable)
	float hidr;			// Hydration level of the earth
	rgb EarthColor;		// Color of the earth
	int counter;		// Counter for tracking time in a certain state
	image_file crop;	// Crop icon for visualization
	
	// -- Init --
	init{
		EarthColor  <- rgb (148,100,37);	// Set default earth color
		state <- "dry";						// Set default earth color
		hidr <- 10.0;						// Set initial hydration level
		counter <- 0;						// Initialize counter
	}
	
	// --- Aspects ---
	aspect base{
		// Dry color
		EarthColor  <- rgb (148,100,37);

		// Cultivated icon
		if(state = "cultivated"){
			crop <- image_file("../includes/cultivated.png");	
		}

		// Harvestable icon
		else if(state = "harvestable"){
			crop <- image_file("../includes/harvestable.png");
		}

		// Draw the aspect with selected color or icon
		draw square(4) color: EarthColor border:#black;
		if crop != nil{
			draw crop size: 3;
		}
	}
	
	reflex update_hidr when: state = "cultivated"{
		// When its cultivated, the hydration level decreases so it must be watered
		if(hidr > 0.0){
			hidr <- hidr - earth_ratio;
			counter <- counter + 1;
		}
		// If hydration level reaches zero, the crop wont grow and resets state to dry
		else{
			counter <- 0;
			state <- "dry";
		}
		// If the crop it's been growing for a certain amount of cycles, it is completely grown and harvestable
		if(counter >= 2000){
			
			counter <- 0;
			state <- "harvestable";
		}
	}
}


// --- Experiments ---
experiment resources_main_1 type: gui {
	parameter "Rain frequency: " var: rainFrecuency min: 0 max: 1000 category: "Rain";
	parameter "Earth ratio: " var: earth_ratio min: 0.0 max: 0.5 category: "Earth";
	parameter "Thirst update: " var: thirst_update category: "Human";
	parameter "Hunger update: " var: hunger_update category: "Human";
	
	output {					
		display main_display type:2d antialias:false {
			grid gworld border: #darkgreen;
			species house aspect:icon;
			species pond aspect:base;
			species earth aspect:base;
			species human aspect:icon;
			species farmer aspect: icon;		
		}
		display info_display type:2d antialias:false {
			grid gworld border: #darkgreen;
			species house aspect:icon;
			species pond aspect:base;
			species earth aspect:base;
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
		}
	}
}

// --- Parameter optimization ---
experiment Batch type: batch repeat: 1 keep_seed: true until: n_agents <= 0 or cycle > 30000{
    parameter 'rainQuantity:' var: rainQuantity min: 100.0 max: 300.0;
    parameter 'rainFrecuency' var: rainFrecuency min: 100 max: 300;
    parameter 'eat_drink_q' var: eat_drink_q min: 0.005 max: 0.3;
    parameter 'earth_ratio' var: earth_ratio min: 0.005 max: 0.3;
    parameter 'negotiate_q:' var: negotiate_q min: 1.0 max: 40.0;
    parameter 'bonus_negotiate' var: bonus_negotiate min: 0.05 max: 0.3;

    method hill_climbing iter_max: 100 maximize: reward;
}