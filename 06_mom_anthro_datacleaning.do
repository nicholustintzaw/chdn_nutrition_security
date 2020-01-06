/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROJECT:		CPI - CHDN Nutrition Security Report

PURPOSE: 		Mother anthro data cleaning

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:
   

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

**  PREPARE DATASETS FOR DATA CLEANING  **

use "$dta/mom_anthro_muac_combined.dta", clear

destring calc_momage mom_muac, replace
replace mom_muac = mom_muac * 10 if mom_muac != 0
replace mom_muac = .r if mom_muac == 0

***** all Mothers' MUAC** 
//under nutrition by less than 21 cm//
gen mom_gam 			= ( mom_muac < 210 )
replace mom_gam	 		= .m if mi(mom_muac)
lab var mom_gam "mother malnutrition by MUAC" 
tab mom_gam, m

save "$cdta/mom_anthro_cleanded.dta", replace

