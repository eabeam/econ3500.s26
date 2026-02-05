version 17.0
args repo_root slides_dir

if "`repo_root'" == "" | "`slides_dir'" == "" {
  di as error "Usage: do run_all.do <repo_root> <slides_dir>"
  exit 198
}

cd "`slides_dir'"

capture log close _all
set more off
set linesize 90

local data_dir "`repo_root'/datasets"

use "`data_dir'/BWGHT.DTA", clear

log using "stata/inference.log", text replace
regress bwght motheduc, robust
log close

log using "stata/binary.log", text replace
regress bwght male, robust
log close

log using "stata/homo1.log", text replace
regress bwght cigs
log close

log using "stata/homo2.log", text replace
regress bwght cigs, robust
log close

exit
