
//// LOADING DATASET ////

	// setting working directory
	cd C:\Users\slupp\OneDrive\Skrivebord\NTNU\Mehmet\PSY8003\Simple_and_multiple_regression

	// Loading the dataset 
	use flats.dta

	// Viewing the dataset
	browse



//// SIMPLE REGRESSION ////

	// Simple Regression flat_price ~ floor size
	reg flat_price floor_size

	// Scatterplot
	twoway lfit flat_price floor_size

	// Scatterplot with line of best fit (i.e., regression line)
	twoway (lfit flat_price floor_size) (scatter flat_price floor_size) 

	// Adding a mean line (i.e., baseline model)
		// Creating variable (using the egen command) which is mean of flatprice
	egen mean_var = mean(flat_price) 

		// Creating the plot
	twoway (lfit flat_price floor_size) (scatter flat_price floor_size) (lfit mean_var floor_size)



//// MULTIPLE REGRESSION ////

	// Regression flat_price ~ floor_size + year_built
	reg flat_price floor_size year_built

	// Visualizing Regression using margins and marginsplot
		// X-axis = year_built
	margins, at(year_built = (1930(50)2010) floor_size = (60(50)220))
	marginsplot

		// X-axis = floor_size 
	margins, at(floor_size = (60(50)220) year_built = (1930(30)2010))
	marginsplot

//// ANSWERS TO EXERCISES (NB NOT ALL) ////

	

	// Exercise 6
	
	// Regression flat_price ~ floor_size + energy_efficiency + year_built
	reg flat_price floor_size c.energy_efficiency year_built

	// Visualizing Regression using margins and marginsplot
	margins, at(floor_size = (60(50)220) year_built = (1930(30)2010) energy_efficiency = (1(1)3))
	marginsplot


