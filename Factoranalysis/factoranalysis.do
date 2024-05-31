//// INSTALLING PACKAGES ////
findit fapara
ssc install sumscale


//// FACTORANALYSIS ////

	// Loading Dataset
	cd "C:\Users\slupp\OneDrive\Skrivebord\NTNU\Mehmet\PSY8003\Factoranalysis"
	use workout3.dta, clear
	
	// Parallel Analysis
	factor _all
	fapara, reps(25)
	
	// SMC
	quietly factor _all
	estat smc
	// average SMC
	display (0.7020 + 0.79 + 0.7098 + 0.6125 + 0.7872 + 0.7465 )/6
	
	// Varimax rotation
	quietly factor _all
	rotate , varimax blank(0.4)
	
	// Promax rotation 
	quietly factor _all
	rotate, oblique promax blank(0.4)
	
	// Generating Factors
	sumscale, f1(Var1 Var2 Var3) f2(Var4 Var5 Var6)
	
	//estimating our factors
	quietly factor _all
	quietly rotate, oblique promax
	predict relaxation appearance , regression
	
	// Check descriptives
	sum
//// PRINCIPAL COMPONENTS ////

	// Parallel Analysis
	quietly factor _all, pcf 
	fapara, pca reps(25)
	
	//Initial solution (no rotation)
	factor _all, pcf
	
	// Varimax rotation
	quietly factor _all, pcf
	rotate , varimax blank(0.4)
	
	// Promax rotation 
	quietly factor _all, pcf
	rotate, oblique promax blank(0.4)
	
	// Generating components
	sumscale, f1(Var1 Var2 Var3) f2(Var4 Var5 Var6)
	
	//estimating our components
	quietly factor _all, pcf
	quietly rotate, oblique promax
	predict relaxation appearance , regression