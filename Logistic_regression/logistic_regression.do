// Setting WorkingDirectory and loading dataset
	cd "C:\Users\slupp\OneDrive\Skrivebord\NTNU\Mehmet\PSY8003\Logistic_regression"
	use titanic.dta, clear

//// SECTION 1: SIMPLE LOGISTIC REGRESSION ////

// Regression Survived Age
	logit Survived Age2
	
	// Predicting probabilities
	quietly logit Survived Age2
	margins , at(Age2 = (0(5)40))
	
	// Visualizing the model
	quietly logit Survived Age2
	margins , at(Age2 = (0(0.2)40))
	marginsplot, noci plotopts(msize(0) lwidth(0.6))
		//NB for better resolution you could just add more datapoints for age in the margins command
	
	// Using Odds Ratio instead of logodds
	logistic Survived Age2
	
	// Prediction accuracy 
	logit Survived Age2
	estat class

//// SECTION 2: MULTIPLE lOGISTIC REGRESSION ////

// Adding a dummy variable 
	logit Survived Sex Age
	estat class
	
	// Difference in probability between men and women at mean age
	logit Survived Sex Age
	margins, at(Sex = (0(1)1)) atmeans

	// Visualizing the model
	quietly logit Survived Sex Age
	margins, at (Age = (0(0.2)50) Sex = (0(1)1))
	marginsplot, noci plotopts(msize(0) lwidth(.6))
	
// Adding a dummy interaction term
	//model
	logit Survived i.Sex##c.Age 
	estat class
	
	//Visualizing
	quietly logit Survived i.Sex##c.Age
	margins, at(Age = (0(0.5)50) Sex = (0(1)1))
	marginsplot, noci plotopts(lwidth(0.6) msize(0))
	
// Adding a second covariate with ineraction
	//model
	logit Survived i.Sex##c.Age##c.Pclass
	
	//Visualizing the model in a single plot
	quietly logit Survived i.Sex##c.Age##c.Pclass
	margins, at (Age = (0(0.5)50) Sex = (0(1)1) Pclass = (1(1)3))
	marginsplot, noci plotopts(msize(0) lwidth(0.6))
	
	//Visualizing the model in seperate plots for each Pclass
		// Pclass = 1
		quietly logit Survived i.Sex##c.Age##c.Pclass
		margins, at (Age = (0(0.5)50) Sex = (0(1)1) Pclass = 1)
		marginsplot, noci plotopts(msize(0) lwidth(0.7))

		// Pclass = 2
		quietly logit Survived i.Sex##c.Age##c.Pclass
		margins, at (Age = (0(0.5)50) Sex = (0(1)1) Pclass = 2)
		marginsplot, noci plotopts(msize(0) lwidth(0.7))

		// Pclass = 3
		quietly logit Survived i.Sex##c.Age##c.Pclass
		margins, at (Age = (0(0.5)50) Sex = (0(1)1) Pclass = 3)
		marginsplot, noci plotopts(msize(0) lwidth(0.7))