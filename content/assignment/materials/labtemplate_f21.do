/*		labtemplate_f21.do

Last updated 12 September 2021 by Emily Beam


Use this template for any EC200 Stata Labs or any related assignments

To make this work, you'll need the following: 
	1. A folder where you want to store all your materials -- you'll need to know the file path for that folder
	2. Your data file, saved into that folder. 

*/ 


****************************************
*	1. 	Set working directory 
*		Only ONE line of code should be "active" (not commented) at a time 
****************************************


* cd means "change directory." it changes your working directory to wherever your files are. 
*	Once you declare this, all files saved/opened in this do-file will look here.

*cd "C:\My Documents\EC200\Lab"						// Sample lab directory for a Windows machine. Put your data file there. 

cd "/Users/ebeam/Dropbox/EC200 - Stata/Lab"			// Sample lab directory for a Mac. This is my "home" directory. 


	* When it comes to file paths ... 
		* Backwards slashes \\\\\ --> windows only 
		* Forward slashes --> works for all computers!

****************************************
*	2. Open data files
****************************************

* use: open this data file.  the "clear" option erases any previous file from the memory 
use "acs2014_all.dta",	clear		// Stata will look in your working directory only


****************************************
*	3. Begin log files
****************************************

*3. Now, let's open a log file. The log file will save to whatever our "working directory" is 

* capture:  ignore this command if it doesn't work 
* log close: close any opening logs 

capture log close 		// Close any open logs

* log: start a new log and save as log_lab2.log
*	  the "replace" option replaces any previous file with the same name 

log using "log_lab2.log",	replace


****************************************
*	4. Analysis
****************************************


							// <-- add commands here


****************************************
*	5. Close log
****************************************


log close 


