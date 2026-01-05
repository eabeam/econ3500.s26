


global path "/Users/ebeam/Dropbox/Labs/"

use "$path/graduation.dta",clear

keep if !missing(fsec1)

gen female = dem1 == 1
rename dem2 age
rename dem12 hhmember


regress fsec1 treat_1 treat_2 treat_3 female age hhmember,cluster(barangay)


test treat_2 = treat_3
testparm treat_1 treat_2 treat_3


// Output regressions 

*ssc install outreg2

outreg2 using "$path/outreg.doc", word replace


exit
















// Fix 

lab var treat_1 "Group Livelihood / Group Coacing"
lab var treat_2 "Individual Livelihood / Group Coaching"
lab var treat_3 "Individual Livelihood / Individual Coaching"



// No Covariates 

regress fsec1 treat_1 treat_2 treat_3 ,cluster(barangay)

sum fsec1 if treat_1 == 0 & treat_2 == 0 & treat_3 == 0 
local dvmean = `r(mean)'
test treat_2 = treat_3
loc p1 = `r(p)'
testparm treat_1 treat_2 treat_3
loc pjoint = `r(p)'



outreg2 using "$path/outreg.doc", replace keep(treat_1 treat_2 treat_3) addstat("DV Mean", `dvmean', "Group vs Individual coaching", `p1', "Joint significance p-value", `pjoint') addtext("Covariates", "No") label bracket word 


// With covariates 

regress fsec1 treat_1 treat_2 treat_3 female age hhmember,cluster(barangay)

sum fsec1 if treat_1 == 0 & treat_2 == 0 & treat_3 == 0 
local dvmean = `r(mean)'
test treat_2 = treat_3
loc p1 = `r(p)'
testparm treat_1 treat_2 treat_3
loc pjoint = `r(p)'



outreg2 using "$path/outreg.doc", append keep(treat_1 treat_2 treat_3) addstat("DV Mean", `dvmean', "Group vs Individual coaching", `p1', "Joint significance p-value", `pjoint') addtext("Covariates", "Yes") label bracket word 


