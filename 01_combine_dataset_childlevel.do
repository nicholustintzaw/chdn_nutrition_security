/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROJECT:		CPI - CHDN Nutrition Security Report

PURPOSE: 		Prepare Child - IYCF and Health Dataset

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:
   

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

**  PREPARE DATASETS FOR COMBINATION  **
local org vi chdn

foreach x in `org' {
	// Main respondent dataset //
	use "$dta/hh_baseline_mcct_`x'.dta", clear

	gen key = _index
	order key, before(_index)
	drop _index

	save "$dta/respondent_`x'.dta",replace
	clear


	// hh members dataset //
	use "$dta/hh_consent_hh_grp_grp_hh_`x'.dta", clear

	gen key = _parent_index
	order key, before(_parent_index)

	gen hh_mem_key = _parent_index + "_" + test
	order hh_mem_key, after(key)

	drop _index _parent_index
	save "$dta/hh_roster_`x'", replace
	clear

	// child related data from main baseline survey //
	// child health dataset //
	use "$dta/hh_consent_child_vc_rep_`x'.dta", clear

	gen key = _parent_index
	order key, before(_parent_index)
	
	drop if mi(child_id_health)

	gen hh_mem_key = _parent_index + "_" + child_id_health
	order hh_mem_key, after(key)

	drop _index _parent_index
	save "$dta/child_health_`x'", replace
	clear


	// child iycf //
	use "$dta/hh_consent_grp_q2_5_to_q2_7_`x'.dta", clear

	gen key = _parent_index
	order key, before(_parent_index)
	
	drop if mi(child_id_iycf)

	gen hh_mem_key = _parent_index + "_" + child_id_iycf
	order hh_mem_key, after(key)

	drop _index _parent_index
	save "$dta/child_iycf_`x'", replace
	clear

	// child related data from anthro dataset //
	// child anthro respondent //
	use "$dta/anthro_mcct_anthro_`x'.dta", clear

	gen key = _index
	order key, before(_index)
	drop _index

	save "$dta/anthro_respondent_`x'.dta",replace
	clear

	// anthro mother info //
	use "$dta/anthro_consent_hh_grp_grp_family_`x'.dta", clear

	gen key = _parent_index
	order key, before(_parent_index)

	gen mom_key = _parent_index + "_" + testfamily
	order mom_key, after(key)

	drop _index _parent_index
	save "$dta/anthro_hh_mom_roster_`x'", replace
	clear


	// anthro child info //
	use "$dta/anthro_consent_hh_grp_grp_hh_`x'.dta", clear

	gen key = _parent_index
	order key, before(_parent_index)

	gen hh_mem_key = _parent_index + "_" + test
	order hh_mem_key, after(key)
	
	gen mom_key = _parent_index + "_" + hh_mem_relation
	order mom_key, after(key)

	drop _index _parent_index
	save "$dta/anthro_hh_child_roster_`x'", replace
	clear


	// child anthro data //
	use "$dta/anthro_consent_childanthro_rep_`x'.dta", clear

	gen key = _parent_index
	order key, before(_parent_index)

	gen hh_mem_key = _parent_index + "_" + cal_anthro
	order hh_mem_key, after(key)

	drop _index _parent_index
	save "$dta/anthro_child_measure_`x'", replace
	clear

}

********************************************************************************
********************************************************************************
** PERFORM DATA CLEANING ON RESPONDENT DATASET **

do "$do/01_respondent_hh_datacleaning.do"

**  COMBINED DATASET AT ORGANIZATION LEVEL  **
local org vi chdn

foreach x in `org' {

	// non - anthro child level data - iycf and health information // 
	use "$cdta/respondent_cleanded_`x'.dta",clear
	tostring key, replace
	tostring _id _parent_table_name _tags _notes _version _duration _xform_id, replace
	
	merge 1:m key using "$dta/hh_roster_`x'.dta"

	drop if _merge != 3
	drop _merge

	order hh_mem_key test, after(key)

	merge 1:m hh_mem_key using "$dta/child_health_`x'.dta"

	drop if _merge != 3
	drop _merge

	order hh_mem_key test child_id_health, after(key)

	merge 1:1 hh_mem_key using "$dta/child_iycf_`x'.dta"

	drop if _merge != 3
	drop _merge

	order hh_mem_key test child_id_health child_id_iycf, after(key)

	save "$dta/child_nonanthro_combined_`x'.dta", replace
	clear
}


// anthro child level data // 
local org vi chdn

foreach x in `org' {

	use "$cdta/anthro_respondent_cleanded_`x'.dta", clear

	merge 1:m key using "$dta/anthro_hh_child_roster_`x'.dta"

	keep if _merge == 3
	drop _merge

	order test, after(key)

	merge 1:m hh_mem_key using "$dta/anthro_child_measure_`x'.dta"

	keep if _merge == 3
	drop _merge

	order test hh_mem_key, after(key)

	merge m:1 mom_key using "$dta/anthro_hh_mom_roster_`x'.dta"

	keep if _merge == 3
	drop _merge

	order test hh_mem_key mom_key, after(key)

	save "$dta/child_anthro_combined_`x'.dta", replace
	clear
}
 
********************************************************************************
********************************************************************************
**  PREPARE TO COMBINE AS ONE CHILD DATASET  **
// non - anthro dataset //
use "$dta/child_nonanthro_combined_vi.dta", clear
append using "$dta/child_nonanthro_combined_chdn.dta", gen(source)

save "$dta/child_nonanthro_combined.dta", replace
clear


// anthro dataset //
use "$dta/child_anthro_combined_vi.dta", clear

merge m:m cal_respid 	using "$cdta/respondent_cleanded_vi.dta", ///
						keepusing(wealth_quintile wealth_poorest wealth_poor wealth_medium wealth_wealthy wealth_wealthiest)

					
drop if _merge == 2
local wealth wealth_quintile wealth_poorest wealth_poor wealth_medium wealth_wealthy wealth_wealthiest
foreach var in `wealth' {
	replace `var' = .n if _merge == 1
}
drop _merge

 

tempfile vi
save `vi', replace
clear

use  "$dta/child_anthro_combined_chdn.dta", clear
merge m:m cal_respid 	using "$cdta/respondent_cleanded_chdn.dta", ///
						keepusing(wealth_quintile wealth_poorest wealth_poor wealth_medium wealth_wealthy wealth_wealthiest)

drop if _merge == 2
local wealth wealth_quintile wealth_poorest wealth_poor wealth_medium wealth_wealthy wealth_wealthiest
foreach var in `wealth' {
	replace `var' = .n if _merge == 1
}
drop _merge

tempfile chdn
save `chdn', replace
clear


use `vi', clear
append using "`chdn'", gen(source)

save "$dta/child_anthro_combined.dta", replace
clear


