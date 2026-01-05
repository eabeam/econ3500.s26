/* Lab 1 Solutions 

Last updated 11 September 2020 

Note: This do-file includes one version of the code and solutions to Lab 1. 
However, there are many ways to achieve these results! 



*/ 


* Close any log files that are open 
cap log close

* Start a log 
log using lab1_answers.log, replace

* Insert your file path 

cd "~/Dropbox/EC200 - Stata"


* Open data file 
use "driving_2004",clear




** Pre-exercises ** 

* Describe the data 

describe 

* Browse selected variables 

browse year sl70plus bac10 bac08 gdl

* look for a variable 

lookfor alcohol 


*****************************
*		Lab Exercises

*****************************



***
* 1. How many states have graduated drivers license laws (GDLs)? How many states have speed limits of 70 mph or higher (including no speed limit)?
***

tab gdl 		// 40 states 


tab sl70plus 	// 29 states 

***
* 2    What percentage of states with GDLs and with low speed limits (below 70 mph) have blood-alcohol limits of 0.10 (the more lenient level)? Note that some states have blood-alcohol limit for a fraction of a year. If so, consider having a limit of 0.10 in place for part of the year as having a limit
***


tab bac10 if gdl == 1 & sl70plus == 0 //	1 state, or 5.88% of states with GDLs and speed limits below 70 pmh.

***
* 3.    What is the mean fatality rate per 100 million miles across all states? What is the standard deviation?
***

sum totfatpvm	//  Mean = 1.514, sd = 0.41 --> The mean fatality rate is 1.51 deaths per 100 million miles, 
				// with a standard deviation of 0.41 fatalities. 

***
* 4    What was the fatality rate (deaths per 100 million miles) in Vermont? (Vermont is state 46)
***

sum totfatpvm if state == 46 // 1.25 fatalities per 100 million miles 

***
*5.     Generate a variable Y equal to one if a state has a fatality rate per 100 million miles that is above the mean, and zero otherwise. What is E[X]?
***

// Two potential approaches (let Y = highfatality)

gen highfatality = 0 
	replace highfatality = 1 if totfatpvm > 1.514
	
sum totfatpvm
gen highfatality2 = totfatpvm > `r(mean)'	

** Compare to show they are the same 

compare highfatality highfatality2 
// OR 

assert highfatality == highfatality2 	// returns error message if they are not the same 

sum highfatality 	// mean = 0.4375. E[X] = 0.4375, meaning that 44% of states have a fatality rate that is above the mean. (This isn't 50% because we're not looking at the median.) 





***
* 6. Write a joint probability distribution table for the following two random variables: X, a random variable equal to one if a state has a speed limit of 70 or greater and zero otherwise (see sl70plus), and Y, the random variable developed in the previous part.

// Tabulate variables 
tab highfatality sl70plus		
// this is sufficient and you can figure out the probabiliities. But instead, you can be fancier by asking it to report the cell percentages 


tab highfatality sl70plus	,cell	
 
 /* This is a join probability table, where Y is high fatality and X is sl70plus
 highfatali | sl70 + sl75 + slnone
        ty |         0          1 |     Total
-----------+----------------------+----------
         0 |        18          9 |        27 
           |     37.50      18.75 |     56.25 
-----------+----------------------+----------
         1 |         1         20 |        21 
           |      2.08      41.67 |     43.75 
-----------+----------------------+----------
     Total |        19         29 |        48 
           |     39.58      60.42 |    100.00 
*/ 


***
*7. Look up the command correlate in the help files: What is the correlation coefficient between nighttime fatalities per 100,000 population and weekend accidents per 100,000 population? Why might this correlation be so strong?
***



corr wkndfatrte nghtfatrte			

/*              | wkndfa~e nghtfa~e
-------------+------------------
  wkndfatrte |   1.0000
  nghtfatrte |   0.9707   1.0000

*/ 
// r = 0.97. This is a very high correlation. Two possibitilies, though you may think of others. (1) An underlying variable is the amount people drive. States where people drive a lot (because they are more spread out) may have more fatalities and more accidents overall, so we'll see high rates in both variables. (2) If a lot of weekend accidents occur at night time, then we would see high rates of night fatalities when there are high rates of weekend accidents. 


log close 
