/*==============================================================================
    generate_logs.do
    
    Generates clean Stata log files for Chapter 5 slides.
    Output files are plain text, trimmed of headers/footers, ready for 
    inclusion in Quarto slides.
    
    Usage:
        From Stata, first cd to the stata/ directory, then run:
        do "generate_logs.do" "/path/to/datasets"
        
    Example:
        cd "/Users/ebeam/Dropbox/GitHub/econ3500.s26/slides/ch5/stata"
        do "generate_logs.do"
    
    Output files (in current directory):
        - inference.log   : Mother's education and birthweight (robust)
        - binary.log      : Sex and birthweight (robust)
        - homo1.log       : Cigarettes and birthweight (non-robust)
        - homo2.log       : Cigarettes and birthweight (robust)
    
    Data required:
        - BWGHT.DTA (Wooldridge birthweight data)
    
    After running:
        The .log files contain clean Stata output. Copy the content into
        ch5_hypothesis_tests.qmd or use Quarto's include shortcode.
==============================================================================*/

version 17.0
clear all
set more off

* Parse arguments
args data_dir

* Default to repo datasets directory if no argument provided
if "`data_dir'" == "" {
    local data_dir "/Users/ebeam/Dropbox/GitHub/econ3500.s26/datasets"
    di "Using default data directory: `data_dir'"
}

* Check if data file exists
capture confirm file "`data_dir'/BWGHT.DTA"
if _rc {
    di as error "Data file not found: `data_dir'/BWGHT.DTA"
    exit 601
}

* Load data
use "`data_dir'/BWGHT.DTA", clear
di "Loaded BWGHT.DTA with `c(N)' observations"

* Set line size for clean output
set linesize 90

* Close any open logs
capture log close _all

/*------------------------------------------------------------------------------
    inference.log - Hypothesis test: mother's education and birthweight
------------------------------------------------------------------------------*/
quietly {
    tempname logfile
    log using "inference_temp.log", text replace name(`logfile')
}
regress bwght motheduc, robust
quietly log close `logfile'

* Extract just the command and output (remove log header/footer)
tempname fh_in fh_out
file open `fh_in' using "inference_temp.log", read text
file open `fh_out' using "inference.log", write text replace

local capture = 0
file read `fh_in' line
while r(eof) == 0 {
    if strpos(`"`line'"', ". regress") > 0 {
        local capture = 1
    }
    if strpos(`"`line'"', ". quietly log close") > 0 | strpos(`"`line'"', "log close") > 0 {
        local capture = 0
    }
    if `capture' == 1 {
        file write `fh_out' `"`line'"' _n
    }
    file read `fh_in' line
}
file close `fh_in'
file close `fh_out'
erase "inference_temp.log"
di "Created: inference.log"

/*------------------------------------------------------------------------------
    binary.log - Binary regressor: sex and birthweight
------------------------------------------------------------------------------*/
quietly {
    tempname logfile
    log using "binary_temp.log", text replace name(`logfile')
}
regress bwght male, robust
quietly log close `logfile'

tempname fh_in fh_out
file open `fh_in' using "binary_temp.log", read text
file open `fh_out' using "binary.log", write text replace

local capture = 0
file read `fh_in' line
while r(eof) == 0 {
    if strpos(`"`line'"', ". regress") > 0 {
        local capture = 1
    }
    if strpos(`"`line'"', ". quietly log close") > 0 | strpos(`"`line'"', "log close") > 0 {
        local capture = 0
    }
    if `capture' == 1 {
        file write `fh_out' `"`line'"' _n
    }
    file read `fh_in' line
}
file close `fh_in'
file close `fh_out'
erase "binary_temp.log"
di "Created: binary.log"

/*------------------------------------------------------------------------------
    homo1.log - Homoskedastic standard errors (without robust)
------------------------------------------------------------------------------*/
quietly {
    tempname logfile
    log using "homo1_temp.log", text replace name(`logfile')
}
regress bwght cigs
quietly log close `logfile'

tempname fh_in fh_out
file open `fh_in' using "homo1_temp.log", read text
file open `fh_out' using "homo1.log", write text replace

local capture = 0
file read `fh_in' line
while r(eof) == 0 {
    if strpos(`"`line'"', ". regress") > 0 {
        local capture = 1
    }
    if strpos(`"`line'"', ". quietly log close") > 0 | strpos(`"`line'"', "log close") > 0 {
        local capture = 0
    }
    if `capture' == 1 {
        file write `fh_out' `"`line'"' _n
    }
    file read `fh_in' line
}
file close `fh_in'
file close `fh_out'
erase "homo1_temp.log"
di "Created: homo1.log"

/*------------------------------------------------------------------------------
    homo2.log - Heteroskedasticity-robust standard errors
------------------------------------------------------------------------------*/
quietly {
    tempname logfile
    log using "homo2_temp.log", text replace name(`logfile')
}
regress bwght cigs, robust
quietly log close `logfile'

tempname fh_in fh_out
file open `fh_in' using "homo2_temp.log", read text
file open `fh_out' using "homo2.log", write text replace

local capture = 0
file read `fh_in' line
while r(eof) == 0 {
    if strpos(`"`line'"', ". regress") > 0 {
        local capture = 1
    }
    if strpos(`"`line'"', ". quietly log close") > 0 | strpos(`"`line'"', "log close") > 0 {
        local capture = 0
    }
    if `capture' == 1 {
        file write `fh_out' `"`line'"' _n
    }
    file read `fh_in' line
}
file close `fh_in'
file close `fh_out'
erase "homo2_temp.log"
di "Created: homo2.log"

/*------------------------------------------------------------------------------
    Done
------------------------------------------------------------------------------*/
di _n "All log files generated successfully."
di "Files created in: `c(pwd)'"
di _n "To update slides, copy the Stata output from these .log files"
di "into the corresponding sections of ch5_hypothesis_tests.qmd"
