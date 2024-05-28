
	// Setting Working directory
	cd "C:\Users\slupp\OneDrive\Skrivebord\NTNU\Mehmet\PSY8003\Dummy_moderation_and_mediation"


//// SECTION 1: DUMMY VARIABLE REGRESSION ////

	// Loading Dataset
	use flats.dta


	// Labeling variables (this is allready done)
		// Creating variable with labels
		label define labels_location 1 "centre" 2 "south" 3 "west" 4 "east"

		// Applying Labels to location 
		label values location labels_location 

			// Checking that it is done correctly
			codebook location

	// Regression flat_price location
		// wrong way
		reg flat_price location
		// Right way
		reg flat_price i.location
			
		// This works even if our variable lacks labels
			// removing labels from location
			label values location 
			reg flat_price i.location
		
		// Changing Reference Group
		reg flat_price ib2.location
	
		// Creating a boxplot
		graph box flat_price, over(location)
		
	// Regression flat_price location floor_size
		// Running the regression
		reg flat_price i.location floor_size
		
		// Visualizing the regression
		reg flat_price i.location floor_size // You do not need to run this again, unless it is not the last command you've run
		margins , at(floor_size = (20(50)220) location = (1(1)4))
		marginsplot

		
//// SECTION 2: INTERACTION ////
	
	// Interaction between two continuous variables
		// Running a regression between floor_size interaction with year_built
		reg flat_price c.floor_size##c.year_built
		
		// Visualizing the interaction
		reg flat_price c.floor_size##c.year_built 
		margins , at (floor_size = (20(200)220) year_built = (1930(20)2010))
		marginsplot
		
	// Interaction between a continuous and a categorical variable
		// Running a regression with location and floor size (with interaction)
		reg flat_price i.location##c.floor_size 
		
		//Visualizing the regression
		reg flat_price i.location##c.floor_size
		margins , at(floor_size = (20(200)220) location = (1(1)4))
		marginsplot
				
//// SECTION 3: MEDIATION ////

	// Installing medsem package (i have commented it out, since i already have installed both packages)

		// Install github package (allows you to download packages from github)
		*net install github, from("https://haghish.github.io/github/")

		//medsem (using github package)
		*github install mmoglu/medsem

	// Loading dataset
	use workout.dta, clear // the clear option clears the dataset which is already loaded

	// Regression approach dependent
		
		// Dependent = calories
		// Independent = attract
		// Mediating = appear
		
		// Step 1 assessing direct effect between independent and dependent
		reg calories attract
		
		// Step 2 assessing direct effect between independent and mediating 
		reg appear attract
		
		// Step 3 assessing direct effect between mediating and dependent
		reg calories appear
		
		// Step 4 assessing direct effect independent and dependent while controlling for mediating
		reg calories attract appear
	
	// SEM approach 
	
		// First creating our model as a SEM
		sem (calories <- attract appear) (appear <- attract) 

	
		// assessing the same model using the medsem package (this has to be run after the previous command)
		medsem, indep(attract) med(appear) dep(calories)
		
		
	//// APPENDIX: USING PLS-SEM ////
	
		//Installing plsem package (commented out because i have installed it already)
		
		*net install github, from("https://haghish.github.io/github/")
		*github install sergioventurini/plssem
		
		
			// 		The syntax of plssem reflects the measurement and structural part of a PLS-SEM model, and
			// accordingly requires the user to specify both of these parts simultaneously. Since a full PLSSEM model would include a structural model, i.e., the relationship between latent variables
			// (LV), we need to have at least two latent variables specified in the measurement part. Each
			// latent variable will be defined by a block of indicators (say, indblock). For example, if we
			// have two latent variables in our PLS-SEM model, the plssem syntax requires to specify the
			// measurement part by typing
			// plssem (LV1 > indblock1) (LV2 > indblock2).
			// Clearly, one can specify as many LVs as it is needed in the model. The specification of
			// reflective measures in the measurement model require to use the greater-than sign between
			// a latent variable and its associated indicators (e.g., LV1 > indblock1), while the less-than
			// sign needs to be provided when one needs to include latent variables measured in a formative
			// way (e.g., LV1 < indblock1).
			// To specify the structural part11, one needs to provide the endogenous/dependent latent variable (say, LV2) first followed by the exogenous latent variables (say, LV1) by typing
			// plssem (LV1 > indblock1) (LV2 > indblock2), structural(LV2 LV1).
			// One can specify further structural relationships following the same approach. For example,
			// suppose one has two further latent variables in the model, LV3 and LV4, still measured in a
			// reflective way, with LV4 endogenous and LV3 exogenous. Then, the syntax for the structural
			// part should be
			// plssem (LV1 > indblock1) (LV2 > indblock2) (LV3 > indblock3) ///
			// (LV4 > indblock4), structural(LV2 LV1, LV4 LV3).
			//
			//		
		// First two lines = measuremnt model (in this case it is formative), last line = structural model 
		plssem (Appear < appear) (Attract < attract) (Calories < calories), ///
		structural(Calories Appear Attract, Appear Attract)
		
		estat mediate, indep(Attract) dep(Calories) med(Appear)
