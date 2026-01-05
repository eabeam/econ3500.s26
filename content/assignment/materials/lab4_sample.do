/* Let's talk about loops */ 

clear all 
set obs 100 


*** Loop through observations with forval 


// New local variable 

local x = 3
display `x' 		// `````````'''''''''


display `x' + 7

// 1, 2, 3, 4, 5, 6, 7, 
 forvalues i = 1/10   {	
 	generate x`i' = runiform()
	
	
 }

*** loop through more detailed types with foreach 

foreach george of varlist x*{
	di "`george'"
	sum `george' if `george' > 0.5
}


* create dummy variables 

forval i =1/5{ 
	gen health`i' = health == `i'
}

// Works sometimes
reg incwage i.statefip // only if variable is numeric 


// Works always 
xi: reg incwage i.statefip 



