// ---
// title: "Introduksjon til STATA"
// ---
//

//// WELCOME TO STATA PREP ////

	// I assume you’ve all “installed” STATA on your computer
	// First we’re going to go through the STATA-interface
		// The STATA console-pane
		// The command-box
		// Previous Commands (we can navigate these using PgUp/PgDn)
		// Variables-pane
		// Properties-pane
		// DataSet-pane
		// Do-files
		// GUI-interfaces
	// For this course i recommend that you use either the do-file, or the command box
	// I have included .do-files for every session we have, so you do not need to stress about remembering every command
	
	// If you at any point fall behind, or have questions please raise your hand on teams

//// WORKING DIRECTORY AND LOADING DATASETS ////

// Before we do anything in STATA, we first need a dataset to work with.
//
// In general I recommend that you always set a working directory usng the cd command:


cd "~/Dropbox/PSY8003_v24/Lab-sessions/Introduction_to_STATA"


// If we use the dir command, we can see the files in our directory


dir


// We can then see that we have a file called "workout1.dta" to open it we can use the "use" command


use workout1.dta

// If we want to browse our dataset we can use the command browse. Each STATA session can only have one dataset at once, so we can just write the commands


browse 


//// Section 1: The STATA Language ////
//
// ## Commands and Syntax
//
// ### Commands
//
// 1.  Almost evertything in STATA is done through commands
// 2.  Commands are essentially functions which takes some arguments, and returns an output
// 3.  One example is the summarize command
// 4.  Each command has its own syntax for what arguments can be given
// 5.  However, most commands have similar arguments, chosen from a standard set of arguments
// 6.  One example which we will be using is *summarize*
// 7.  When looking at help files [] denotes optional arguments


help language


// ### [varlist] and [variable]
//
// 1.  The most important input in most commands is the variables it works upon
// 2.  Commands either take a *varlist* or *variable*
// 3.  *Variable* means that a command only takes a single variable (e.g., histogram)
// 4.  *Varlist* means that a command takes multiple variables
//     1.  usually all variables in your dataset, unless it is extremely large (i.e., \> 100 000 variables))
// 5.  We can use *summarize* to fetch basic descrivptive statistics
// 6.  *Summarize* takes varlist


summarize v01 
*summarize v01 v02
*summarize 


**NB**: We can also write *sum, summ, summa, summar*.. etc. Any unique prefix for a given command can be used to call that command, this is also true for arguments (although not all arguments have unique prefixes, e.g., "*in")*


sum v01
sum 


// ### [prefix]
//
// 1.  Prefix arguments modify the input, modify the output, or repeat execution of the command.
// 2.  Perfixes can be thought of as "pre-commands" which are performed before the main command
// 3.  There are many examples, but a very usefull example is the "by" prefix
// 4.  For example lets say we want fetch descrivptive statistics seperately for men and women
//
// Before we can use the *by* prefix, we must first sort our dataset by the relevant variable v01(Gender)


sort v01
by v01: summ


// 1.  Since by takes a varlist, we can do this for as many variables as we want
// 2.  We can skip using the sort command by either adding it as an option to by (we will dicuss options later).
// 3.  However using the bysort function is even easier



*by v01 v06 v05, sort: sum 
bysort v01 v06 v05: sum 


// ### [=exp]
//
// The [=exp] is primarily used in realtion to datamanagement commands, so we will return to this later
//

// ### [if]
//
// 1.  The if expression evaluates a logical expression, and only performs the command on cases satisfying the logical expression (i.e., returning TRUE)
// 2.  Logical operators
//     -   Is equal: ==
//     -   Does not equal: !=
//     -   Less than: \<
//     -   Less than or equal: \<=
//     -   Greater than: \>
//     -   Greater than or equal: \>=
//     -   AND: &
//     -   OR: \|
// 3.  For example lets say we want to fetch descrivptive statistics for men only


summarize if v01 == "Men"


// 1.  This example does not work, and is because were attempting to specify the value using the labels, not the actual coded value.
// 2.  In stata all variables (in general) are coded numerically.
// 3.  To find how the variable is coded, we can use the command "codebook"


codebook v01


// we can now see that women = 1 and men = 2


summarize if v01 == 2


// 1.  We can make our logical expression more complicated using a combination of multiple logical operators
// 2.  Lets say we only want descrivptives for men with Primary/Secondary school education and come from Vikhammer
// 3.  firstly we should run codebook for our relevant variables


codebook v01 v03 v05


// Now that we know how the values are coded, we can create our expression


summarize if v01 == 2 & v03 == 1 & v05 == 1


// We can also use & to exclude particants with too high/low values on a given variable. Here we exclude those whith the highest and lowest education


sum v03 if v03 >= 2 & v03 <=3


// #### Combining if and prefix
//
// 1.  We can also combine this with the by prefix.
// 2.  Lets for example say that we wish to get seperate descrivptives for men and women ith Primary/Secondary school education and come from Vikhammer


bysort v01: summ if v03 == 1 & v05 == 1


// ### [in]
//
// 1.  The in expression specifies the range of participants to perform the command on
// 2.  This is based on the order of participants in your dataset
// 3.  If we for example want the first 10 participants


sum v03 in 1/10


// 1.  The in command is seldom usefull in of it self, but can be more usefull if the dataset is sorted
// 2.  Lets for example we want the participants top 20 oldest particpants in our dataset
// 3.  The *sort* command always sorts by ascending order
// 4.  We must therefore use the *gsort* command which can do both


help gsort
sum v02
gsort - v02
sum v02 in 1/20


// ### [weight]
//
// 1.  The weight argument is used to weight observetions in your dataset.
// 2.  The four main forms are: *fweight, iweight, pweight* and *aweight*.
// 3.  For example *fweight* takes a variable indicating how many observations each case actually represents, or how many it should count as.
// 4.  Importantly the weight argument actually needs to be enclosed by []
// 5.  For example lets say v03 no longer represents educational level, but rather number of people in the household, and each case represents the score/average for the total household.



sum v01 [fweight=v03]


// ### [, options]
//
// 1. [, options] refers to specific/unique arguments for commands
// 2. These usually come last (after the default arguments) and are placed after ,
// 3. For example the sum function has the option: *"detail"*


sum , detail


// # Data management
//
// ### Renaming variables 
//
// 1. Variables can be renamed using the *rename* command. 
// 2. The syntax is: *rename [old_varname] [new_varname]*


rename v01 Gender
rename v02 Age
rename v03 Education
rename v04 Income
rename v05 Location
ren v06 marital_status
ren v07 divorced

sum 


// ### Recoding Variables
//
// 1.  Recoding can easily be done using the recode (prefix ) command
// 2.  Basic syntax: *recode varlist (rule) [(rule) ...] [, generate(newvar)]*
// 3.  The syntax of (rule) is (*old_value* = *new_value*)
// 4.  Lets for example say we want to recode *Other* into *Midtsand*


codebook Location //run this command seperately befor the next

recode Location (6=5)
codebook Location


// 1.  Notice that the syntax for recode allows for multiple rules:
// 2.  *recode varlist (rule) [(rule) ...] [, generate(newvar)]*
// 3.  Each rule is enclosed by its own parenthesis
// 4.  recode also takes varlist, but it does not take all variables if empty
// 5.  You can specify all varliables by using \* or \_all
// 6.  We can also specify ranges of old vales using / (as with the *in* argument)
// 7.  using the option , generate(newvar) allows us to create a new variable, instead of overwriting the exisitng one


recode Location (1 = 2) (3 = 4), generate(recode_1)
recode Location (1/3 = 1) (4/5 = 2), generate(recode_2)

codebook recode_1 recode_2


// ### Generating new variables
//
// 1.  Generating new ariables can be done useing the generate command
// 2.  Syntax: *generate [type] newvar[:lblname] =exp [if] [in] [, before(varname) \| after(varname)]*
// 3.  Notice that the =exp is required (since it is not encapsulated by [])
// 4.  Simplified the syntax is: *generate new_varname = expression*
// 5.  abbreviation = g, ge, gen etc..


generate sum_age_education = Age + Education
g product_age_education = Age * Education 

sum sum_age_education product_age_education



// 1.  The replace command can be thought of a more dynamic version of the generate command
// 2.  It is in essence the same command as generate, only that it replaces an existing variable
//


// ### labeling variables
//
// 1.  In STATA we usually want our variables to be coded numerically
// 2.  This can be problematic for categorical (especially nominal) variables
// 3.  To fix this we can label the values within our dataset
// 4.  We have already seen this for the variables in our dataset, but we do not have labels for our generated variables
// 5.  Lets say we want to create dummy variables for men and women
// 6.  There are easier ways, but we can use the generate and replace commands in combination


//Dummy variable women
generate women = 1 if Gender == 1
replace women = 0 if Gender == 2

//Dummy variable men
generate men = 1 if Gender == 2
replace men = 0 if Gender == 1

//Dummy variable women 
recode Gender (1 = 1) (2 = 0), generate(women)

codebook women men



// 1.  To label variables we can use the label command
// 2.  The label command has quite a complicated syntax:

help label

 
// 3.  This is because it changes a lot based on circumstance, allowing us to label a dataset, variable, variable-values, copy labels, drop labels etc...
// 4.  The two simplest versions are variable define and values
// 5.  Variable allows us to label what a variable is:
//     -   *label variable varname ["label"]*
// 6.  Define allows us to make the values of for a variable
//     -   *label define lblname \# "label" [\# "label" ...] [, add modify replace nofix]*
//     -   Here lblname is the variable which stores our labels
//     -   # is the numerical value
// 7.  Values allows us to assign the labels defined in define
//     -   *label values varlist lblname [, nofix]*



// Labeling the variable-names
label variable women "dummy variable representing women"
label variable men "dummy variable representing men"

//Defining labels
label define women_label 0 "men" 1 "women"
label define men_label 0 "women" 1 "men"

//Assigning Labels
label values women women_label
label values men men_label

codebook women men 


//// FILTERING DATASETS ////

// 	drop varlist
//
// 	drop if exp 
//
// 	drop in #/#


// ### Exercises (using commands not GUI)
//
// 1. Change working directory to the location of the workout1.dta 
// 2. Open workout.dta 
// 3. View the dataset 
// 4. Rename the variables 
// 5. Fetch summary statistics for: one, two, and all the variables (seperately)
// 6. Figure out what the tabulate command does (tips use the help command)
// 7. Use the tabulate command
// 8. Recode the Age variable into a categorical (ordinal) variable
// 9. Add labels to the variable 
// 10. Create a dummy variable for Vikhammer
// 11. Add labels to the dummy for Vikhammer

//// Review Exercises ////

//// Show STATA markdown ////

//// Questions About STATA vs. R ////

