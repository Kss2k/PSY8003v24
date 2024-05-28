
//// LOADING DATASET ////
cd "C:\Users\slupp\OneDrive\Skrivebord\NTNU\Mehmet\PSY8003\multilevel"
use depression.dta


//// CONVERTING FROM WIDE TO LONG FORMAT ////
	reshape long BDI week, i(ID) j(session)

	
	
//// CONVERTING FROM LONG TO WIDE ////

	use depression_long.dta, clear
	reshape wide BDI week, i(ID) j(session)
	
	
	//// ANSWER TO EXERCISE ////
	use diet.dta, clear

	rename pre_weight weight0
	rename post_weight weight1

	reshape long weight, i(person) j(time)


	reshape wide weight, i(person) j(time)
		
//// MULTILEVEL MODELS ////
	// Switching back to long format
	use depression_long.dta, clear
	// Empty Model
	mixed BDI || ID:, ml variance
	
	
	// Random Intercept Model
	mixed BDI week || ID: , mle stddev
	


		
	// Random Coefficient Model 
	// Dependent 
	mixed BDI week || ID: week, cov(unstructured) mle stddev
	// independent
	mixed BDI week || ID: week, mle stddev
	
	// Interaction random intercept 
	mixed BDI c.week##i.married|| ID:, mle cov(unstructured) stddev
	
		// Plot 
		margins, at(week = (1 33) married =(0 1))
		marginsplot
	
	// Interaction random interaction coefficient
	gen week_job = week*job
	set maxiter 100
	mixed BDI c.week i.job week_job || ID: 	week job week_job, mle stddev cov(unstructured)   
	
	
	//Three level
	mixed BDI week || ID: , || job:, cov(unstructured) mle stddev
	
	
	
	//// SIGNIFICANCE TESTING ////
	
	// Kenward Rogers
	mixed BDI week || ID: week, stddev reml dfmethod(kroger)
	
	// Satterthwaite
	mixed BDI week || ID: week, stddev reml dfmethod(satterthwaite)
	
	// Bootstrapping 
	bootstrap, rep(100) cluster(ID): mixed BDI week || ID:, stddev reml