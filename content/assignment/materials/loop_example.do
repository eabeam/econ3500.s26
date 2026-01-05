/* Examples of loops 

These don't require any data 

*/ 

clear 
set seed 100920

set obs 10000
 forvalues i = 1(1)100 {
    generate x`i' = runiform()
 }

forval num = 10(2)20 {
	count if x`num' > 0.9
}


foreach name in "Annette Fett" "Ashley Poole" "Marsha Martinez" {
  display length("`name'") " characters long -- `name'"
        }

	
foreach var of varlist x* {
   summarize `var'
   sum `var' if `var' > r(mean) + r(sd)
    }

