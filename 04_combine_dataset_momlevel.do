/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROJECT:		CPI - CHDN Nutrition Security Report

PURPOSE: 		Combined all mothers Dataset

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

	// mom related data from main baseline survey //
	// mom health dataset //
	use "$dta/hh_consent_ancpast_rep_`x'.dta", clear

	gen key = _parent_index
	order key, before(_parent_index)
	
	drop if mi(women_id_pregpast)

	gen hh_mem_key = _parent_index + "_" + women_id_pregpast
	order hh_mem_key, after(key)

	drop _index _parent_index
	save "$dta/mom_health_`x'", replace
	clear



	// mom related data from anthro dataset //
	// anthro respondent //
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

	// mom anthro data //
	use "$dta/anthro_consent_mom_anthro_rep_`x'.dta", clear

	gen key = _parent_index
	order key, before(_parent_index)

	gen mom_key = _parent_index + "_" + calc_mom_post
	order mom_key, after(key)

	drop _index _parent_index
	save "$dta/mom_anthro_muac_`x'", replace
	clear

}

********************************************************************************
********************************************************************************
**  COMBINED DATASET AT ORGANIZATION LEVEL  **
local org vi chdn

foreach x in `org' {

	// non - anthro child level data - iycf and health information // 
	use "$cdta/respondent_cleanded_`x'.dta",clear
	tostring key, replace
	tostring _id _parent_table_name _tags _notes _version _duration _xform_id, replace

	merge 1:m key using "$dta/hh_roster_`x'.dta"

	keep if _merge == 3
	drop _merge

	order hh_mem_key test, after(key)

	merge 1:m hh_mem_key using "$dta/mom_health_`x'.dta"

	keep if _merge == 3
	drop _merge

	order hh_mem_key test women_id_pregpast, after(key)

	save "$dta/mom_health_combined_`x'.dta", replace
	clear
}


// anthro mom level data // 
local org vi chdn

foreach x in `org' {

	use "$cdta/anthro_respondent_cleanded_`x'.dta", clear

	merge 1:m key using "$dta/anthro_hh_mom_roster_`x'.dta"

	keep if _merge == 3
	drop _merge

	order test, after(key)

	merge m:1 mom_key using "$dta/mom_anthro_muac_`x'.dta"

	keep if _merge == 3
	drop _merge

	order test mom_key, after(key)

	save "$dta/mom_anthro_muac_combined_`x'.dta", replace
	clear
}

********************************************************************************
********************************************************************************
**  PREPARE TO COMBINE AS ONE CHILD DATASET  **
// non - anthro dataset //
use "$dta/mom_health_combined_vi.dta", clear
append using "$dta/mom_health_combined_chdn.dta"

save "$dta/mom_health_combined.dta", replace
clear

/*
// anthro dataset //
use "$dta/mom_anthro_muac_combined_vi.dta", clear
append using "$dta/mom_anthro_muac_combined_chdn.dta"

save "$dta/mom_anthro_muac_combined.dta", replace
clear
*/

// anthro dataset //
use "$dta/mom_anthro_muac_combined_vi.dta", clear

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

use  "$dta/mom_anthro_muac_combined_chdn.dta", clear
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

save "$dta/mom_anthro_muac_combined.dta", replace
clear
