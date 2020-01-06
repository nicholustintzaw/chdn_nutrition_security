/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROJECT:		CPI - CHDN Nutrition Security Report

PURPOSE: 		Mother health dataset - data cleaning

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:
   

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

**  PREPARE DATASETS FOR DATA CLEA ING  **

use "$dta/mom_health_combined.dta", clear
					
**-----------------------------------------------------**
** PREVIOUS U2 PREGNANCY
**-----------------------------------------------------**

**-----------------------------------------------------**
** ANC 
**-----------------------------------------------------**

// ancpast_adopt 
destring ancpast_adopt, replace
tab ancpast_adopt, m

drop if mi(ancpast_adopt) // non U2 hh members

// ancpast_yn 
destring ancpast_yn, replace
replace ancpast_yn = .m if ancpast_adopt == 1
tab ancpast_yn, m

// ancpast_who 
tab ancpast_who, m

local who ancpast_who1 ancpast_who2 ancpast_who3 ancpast_who4 ancpast_who5 ancpast_who6 ancpast_who7 ancpast_who8 ancpast_who9 ancpast_who10 ancpast_who11 ancpast_who888 
foreach var in `who' {
	destring `var', replace
	replace `var' = .m if ancpast_adopt == 1
	tab `var', m
}

rename ancpast_who1		ancpast_spelist
rename ancpast_who2 	ancpast_doc
rename ancpast_who3 	ancpast_nurs
rename ancpast_who4 	ancpast_ha
rename ancpast_who5 	ancpast_pdoc
rename ancpast_who6 	ancpast_lhv
rename ancpast_who7 	ancpast_mw
rename ancpast_who8 	ancpast_amw
rename ancpast_who9 	ancpast_tba
rename ancpast_who10 	ancpast_chw
rename ancpast_who11 	ancpast_ehw
rename ancpast_who888 	ancpast_oth

// ancpast_who_oth 

// ancpast_spelist_where 
destring ancpast_spelist_where, replace
replace ancpast_spelist_where = .m if ancpast_adopt == 1

local num	1 2 3 4 5 6 888
foreach x in `num' {
	gen ancpast_spelist_where_`x' 		= (ancpast_spelist_where == `x')
	replace ancpast_spelist_where_`x' 	= .m if mi(ancpast_spelist_where)
	tab ancpast_spelist_where_`x', m
}

rename ancpast_spelist_where_1		ancpast_spelist_home
rename ancpast_spelist_where_2		ancpast_spelist_hosp
rename ancpast_spelist_where_3		ancpast_spelist_clinic
rename ancpast_spelist_where_4		ancpast_spelist_rhc
rename ancpast_spelist_where_5		ancpast_spelist_vill
rename ancpast_spelist_where_6		ancpast_spelist_eho
rename ancpast_spelist_where_888	ancpast_spelist_othplc

// ancpast_spelist_where_oth 

// ancpast_spelist_dist_dry ancpast_spelist_dist_wet 

destring ancpast_spelist_dist_dry ancpast_spelist_dist_wet, replace
replace ancpast_spelist_dist_dry = .m if ancpast_adopt == 1
replace ancpast_spelist_dist_wet = .m if ancpast_adopt == 1
replace ancpast_spelist_dist_dry = .m if ancpast_spelist != 1
replace ancpast_spelist_dist_wet = .m if ancpast_spelist != 1
tab1 ancpast_spelist_dist_dry ancpast_spelist_dist_wet, m

// ancpast_spelist_visit ancpast_spelist_1tri_times ancpast_spelist_2tri_times ancpast_spelist_3tri_times 
destring ancpast_spelist_visit ancpast_spelist_1tri_times ancpast_spelist_2tri_times ancpast_spelist_3tri_times, replace

replace ancpast_spelist_visit = .m if ancpast_adopt == 1
replace ancpast_spelist_visit = .m if ancpast_spelist != 1
replace ancpast_spelist_visit = .n if ancpast_spelist_visit == 444

replace ancpast_spelist_1tri_times = .m if mi(ancpast_spelist_visit)
replace ancpast_spelist_2tri_times = .m if mi(ancpast_spelist_visit)
replace ancpast_spelist_3tri_times = .m if mi(ancpast_spelist_visit)

replace ancpast_spelist_1tri_times = .n if ancpast_spelist_1tri_times == 444
replace ancpast_spelist_2tri_times = .n if ancpast_spelist_2tri_times == 444
replace ancpast_spelist_3tri_times = .n if ancpast_spelist_3tri_times == 444

tab1 ancpast_spelist_visit ancpast_spelist_1tri_times ancpast_spelist_2tri_times ancpast_spelist_3tri_times , m


// ancpast_doc_where 
destring ancpast_doc_where, replace
replace ancpast_doc_where = .m if ancpast_adopt == 1

local num	1 2 3 4 5 6 888
foreach x in `num' {
	gen ancpast_doc_where_`x' 		= (ancpast_doc_where == `x')
	replace ancpast_doc_where_`x' 	= .m if mi(ancpast_doc_where)
	tab ancpast_doc_where_`x', m
}

rename ancpast_doc_where_1		ancpast_doc_home
rename ancpast_doc_where_2		ancpast_doc_hosp
rename ancpast_doc_where_3		ancpast_doc_clinic
rename ancpast_doc_where_4		ancpast_doc_rhc
rename ancpast_doc_where_5		ancpast_doc_vill
rename ancpast_doc_where_6		ancpast_doc_eho
rename ancpast_doc_where_888	ancpast_doc_othplc

// ancpast_doc_where_oth 

// ancpast_doc_dist_dry ancpast_doc_dist_wet 

destring ancpast_doc_dist_dry ancpast_doc_dist_wet , replace
replace ancpast_doc_dist_dry = .m if ancpast_adopt == 1
replace ancpast_doc_dist_wet = .m if ancpast_adopt == 1
replace ancpast_doc_dist_dry = .m if ancpast_doc != 1
replace ancpast_doc_dist_wet = .m if ancpast_doc != 1
tab1 ancpast_doc_dist_dry ancpast_doc_dist_wet , m

// ancpast_doc_visit ancpast_doc_1tri_times ancpast_doc_2tri_times ancpast_doc_3tri_times  
destring ancpast_doc_visit ancpast_doc_1tri_times ancpast_doc_2tri_times ancpast_doc_3tri_times, replace
replace ancpast_doc_visit = .m if ancpast_adopt == 1
replace ancpast_doc_visit = .m if ancpast_doc != 1
replace ancpast_doc_visit = .n if ancpast_doc_visit == 444

replace ancpast_doc_1tri_times = .m if mi(ancpast_doc_visit)
replace ancpast_doc_2tri_times = .m if mi(ancpast_doc_visit)
replace ancpast_doc_3tri_times = .m if mi(ancpast_doc_visit)

replace ancpast_doc_1tri_times = .n if ancpast_doc_1tri_times == 444
replace ancpast_doc_2tri_times = .n if ancpast_doc_2tri_times == 444
replace ancpast_doc_3tri_times = .n if ancpast_doc_3tri_times == 444

tab1  ancpast_doc_visit ancpast_doc_1tri_times ancpast_doc_2tri_times ancpast_doc_3tri_times, m


// ancpast_nurs_where ancpast_nurs_where_oth ancpast_nurs_dist_dry ancpast_nurs_dist_wet ancpast_nurs_visit ancpast_nurs_1tri_times ancpast_nurs_2tri_times ancpast_nurs_3tri_times 
destring ancpast_nurs_where, replace
replace ancpast_nurs_where = .m if ancpast_adopt == 1

local num	1 2 3 4 5 6 888
foreach x in `num' {
	gen ancpast_nurs_where_`x' 		= (ancpast_nurs_where == `x')
	replace ancpast_nurs_where_`x' 	= .m if mi(ancpast_nurs_where)
	tab ancpast_nurs_where_`x', m
}

rename ancpast_nurs_where_1		ancpast_nurs_home
rename ancpast_nurs_where_2		ancpast_nurs_hosp
rename ancpast_nurs_where_3		ancpast_nurs_clinic
rename ancpast_nurs_where_4		ancpast_nurs_rhc
rename ancpast_nurs_where_5		ancpast_nurs_vill
rename ancpast_nurs_where_6		ancpast_nurs_eho
rename ancpast_nurs_where_888	ancpast_nurs_othplc

// ancpast_nurs_where_oth 

// ancpast_nurs_dist_dry ancpast_nurs_dist_wet 

destring ancpast_nurs_dist_dry ancpast_nurs_dist_wet , replace
replace ancpast_nurs_dist_dry = .m if ancpast_adopt == 1
replace ancpast_nurs_dist_wet = .m if ancpast_adopt == 1
replace ancpast_nurs_dist_dry = .m if ancpast_nurs != 1
replace ancpast_nurs_dist_wet = .m if ancpast_nurs != 1
tab1 ancpast_nurs_dist_dry ancpast_nurs_dist_wet , m


// ancpast_nurs_visit ancpast_nurs_1tri_times ancpast_nurs_2tri_times ancpast_nurs_3tri_times  
destring ancpast_nurs_visit ancpast_nurs_1tri_times ancpast_nurs_2tri_times ancpast_nurs_3tri_times, replace
replace ancpast_nurs_visit = .m if ancpast_adopt == 1
replace ancpast_nurs_visit = .m if ancpast_nurs != 1
replace ancpast_nurs_visit = .n if ancpast_nurs_visit == 444

replace ancpast_nurs_1tri_times = .m if mi(ancpast_nurs_visit)
replace ancpast_nurs_2tri_times = .m if mi(ancpast_nurs_visit)
replace ancpast_nurs_3tri_times = .m if mi(ancpast_nurs_visit)

replace ancpast_nurs_1tri_times = .n if ancpast_nurs_1tri_times == 444
replace ancpast_nurs_2tri_times = .n if ancpast_nurs_2tri_times == 444
replace ancpast_nurs_3tri_times = .n if ancpast_nurs_3tri_times == 444

tab1  ancpast_nurs_visit ancpast_nurs_1tri_times ancpast_nurs_2tri_times ancpast_nurs_3tri_times, m


// ancpast_ha_where ancpast_ha_where_oth ancpast_ha_dist_dry ancpast_ha_dist_wet ancpast_ha_visit ancpast_ha_1tri_times ancpast_ha_2tri_times ancpast_ha_3tri_times 
destring ancpast_ha_where, replace
replace ancpast_ha_where = .m if ancpast_adopt == 1

local num	1 2 3 4 5 6 888
foreach x in `num' {
	gen ancpast_ha_where_`x' 		= (ancpast_ha_where == `x')
	replace ancpast_ha_where_`x' 	= .m if mi(ancpast_ha_where)
	tab ancpast_ha_where_`x', m
}

rename ancpast_ha_where_1		ancpast_ha_home
rename ancpast_ha_where_2		ancpast_ha_hosp
rename ancpast_ha_where_3		ancpast_ha_clinic
rename ancpast_ha_where_4		ancpast_ha_rhc
rename ancpast_ha_where_5		ancpast_ha_vill
rename ancpast_ha_where_6		ancpast_ha_eho
rename ancpast_ha_where_888	ancpast_ha_othplc

// ancpast_ha_where_oth 

// ancpast_ha_dist_dry ancpast_ha_dist_wet 

destring ancpast_ha_dist_dry ancpast_ha_dist_wet , replace
replace ancpast_ha_dist_dry = .m if ancpast_adopt == 1
replace ancpast_ha_dist_wet = .m if ancpast_adopt == 1
replace ancpast_ha_dist_dry = .m if ancpast_ha != 1
replace ancpast_ha_dist_wet = .m if ancpast_ha != 1
tab1 ancpast_ha_dist_dry ancpast_ha_dist_wet , m


// ancpast_ha_visit ancpast_ha_1tri_times ancpast_ha_2tri_times ancpast_ha_3tri_times  
destring ancpast_ha_visit ancpast_ha_1tri_times ancpast_ha_2tri_times ancpast_ha_3tri_times, replace
replace ancpast_ha_visit = .m if ancpast_adopt == 1
replace ancpast_ha_visit = .m if ancpast_ha != 1
replace ancpast_ha_visit = .n if ancpast_ha_visit == 444

replace ancpast_ha_1tri_times = .m if mi(ancpast_ha_visit)
replace ancpast_ha_2tri_times = .m if mi(ancpast_ha_visit)
replace ancpast_ha_3tri_times = .m if mi(ancpast_ha_visit)

replace ancpast_ha_1tri_times = .n if ancpast_ha_1tri_times == 444
replace ancpast_ha_2tri_times = .n if ancpast_ha_2tri_times == 444
replace ancpast_ha_3tri_times = .n if ancpast_ha_3tri_times == 444

tab1  ancpast_ha_visit ancpast_ha_1tri_times ancpast_ha_2tri_times ancpast_ha_3tri_times, m

// ancpast_pdoc_where ancpast_pdoc_where_oth ancpast_pdoc_dist_dry ancpast_pdoc_dist_wet ancpast_pdoc_visit ancpast_pdoc_1tri_times ancpast_pdoc_2tri_times ancpast_pdoc_3tri_times 
destring ancpast_pdoc_where, replace
replace ancpast_pdoc_where = .m if ancpast_adopt == 1

local num	1 2 3 4 5 6 888
foreach x in `num' {
	gen ancpast_pdoc_where_`x' 		= (ancpast_pdoc_where == `x')
	replace ancpast_pdoc_where_`x' 	= .m if mi(ancpast_pdoc_where)
	tab ancpast_pdoc_where_`x', m
}

rename ancpast_pdoc_where_1		ancpast_pdoc_home
rename ancpast_pdoc_where_2		ancpast_pdoc_hosp
rename ancpast_pdoc_where_3		ancpast_pdoc_clinic
rename ancpast_pdoc_where_4		ancpast_pdoc_rhc
rename ancpast_pdoc_where_5		ancpast_pdoc_vill
rename ancpast_pdoc_where_6		ancpast_pdoc_eho
rename ancpast_pdoc_where_888	ancpast_pdoc_othplc

// ancpast_pdoc_where_oth 

// ancpast_pdoc_dist_dry ancpast_pdoc_dist_wet 

destring ancpast_pdoc_dist_dry ancpast_pdoc_dist_wet , replace
replace ancpast_pdoc_dist_dry = .m if ancpast_adopt == 1
replace ancpast_pdoc_dist_wet = .m if ancpast_adopt == 1
replace ancpast_pdoc_dist_dry = .m if ancpast_pdoc != 1
replace ancpast_pdoc_dist_wet = .m if ancpast_pdoc != 1
tab1 ancpast_pdoc_dist_dry ancpast_pdoc_dist_wet , m


// ancpast_pdoc_visit ancpast_pdoc_1tri_times ancpast_pdoc_2tri_times ancpast_pdoc_3tri_times  
destring ancpast_pdoc_visit ancpast_pdoc_1tri_times ancpast_pdoc_2tri_times ancpast_pdoc_3tri_times, replace
replace ancpast_pdoc_visit = .m if ancpast_adopt == 1
replace ancpast_pdoc_visit = .m if ancpast_pdoc != 1
replace ancpast_pdoc_visit = .n if ancpast_pdoc_visit == 444

replace ancpast_pdoc_1tri_times = .m if mi(ancpast_pdoc_visit)
replace ancpast_pdoc_2tri_times = .m if mi(ancpast_pdoc_visit)
replace ancpast_pdoc_3tri_times = .m if mi(ancpast_pdoc_visit)

replace ancpast_pdoc_1tri_times = .n if ancpast_pdoc_1tri_times == 444
replace ancpast_pdoc_2tri_times = .n if ancpast_pdoc_2tri_times == 444
replace ancpast_pdoc_3tri_times = .n if ancpast_pdoc_3tri_times == 444

tab1  ancpast_pdoc_visit ancpast_pdoc_1tri_times ancpast_pdoc_2tri_times ancpast_pdoc_3tri_times, m

// ancpast_lhv_where ancpast_lhv_where_oth ancpast_lhv_dist_dry ancpast_lhv_dist_wet ancpast_lhv_visit ancpast_lhv_1tri_times ancpast_lhv_2tri_times ancpast_lhv_3tri_times 
destring ancpast_lhv_where, replace
replace ancpast_lhv_where = .m if ancpast_adopt == 1

local num	1 2 3 4 5 6 888
foreach x in `num' {
	gen ancpast_lhv_where_`x' 		= (ancpast_lhv_where == `x')
	replace ancpast_lhv_where_`x' 	= .m if mi(ancpast_lhv_where)
	tab ancpast_lhv_where_`x', m
}

rename ancpast_lhv_where_1		ancpast_lhv_home
rename ancpast_lhv_where_2		ancpast_lhv_hosp
rename ancpast_lhv_where_3		ancpast_lhv_clinic
rename ancpast_lhv_where_4		ancpast_lhv_rhc
rename ancpast_lhv_where_5		ancpast_lhv_vill
rename ancpast_lhv_where_6		ancpast_lhv_eho
rename ancpast_lhv_where_888	ancpast_lhv_othplc

// ancpast_lhv_where_oth 

// ancpast_lhv_dist_dry ancpast_lhv_dist_wet 

destring ancpast_lhv_dist_dry ancpast_lhv_dist_wet , replace
replace ancpast_lhv_dist_dry = .m if ancpast_adopt == 1
replace ancpast_lhv_dist_wet = .m if ancpast_adopt == 1
replace ancpast_lhv_dist_dry = .m if ancpast_lhv != 1
replace ancpast_lhv_dist_wet = .m if ancpast_lhv != 1
tab1 ancpast_lhv_dist_dry ancpast_lhv_dist_wet , m


// ancpast_lhv_visit ancpast_lhv_1tri_times ancpast_lhv_2tri_times ancpast_lhv_3tri_times  
destring ancpast_lhv_visit ancpast_lhv_1tri_times ancpast_lhv_2tri_times ancpast_lhv_3tri_times, replace
replace ancpast_lhv_visit = .m if ancpast_adopt == 1
replace ancpast_lhv_visit = .m if ancpast_lhv != 1
replace ancpast_lhv_visit = .n if ancpast_lhv_visit == 444

replace ancpast_lhv_1tri_times = .m if mi(ancpast_lhv_visit)
replace ancpast_lhv_2tri_times = .m if mi(ancpast_lhv_visit)
replace ancpast_lhv_3tri_times = .m if mi(ancpast_lhv_visit)

replace ancpast_lhv_1tri_times = .n if ancpast_lhv_1tri_times == 444
replace ancpast_lhv_2tri_times = .n if ancpast_lhv_2tri_times == 444
replace ancpast_lhv_3tri_times = .n if ancpast_lhv_3tri_times == 444

tab1  ancpast_lhv_visit ancpast_lhv_1tri_times ancpast_lhv_2tri_times ancpast_lhv_3tri_times, m

// ancpast_mw_where ancpast_mw_where_oth ancpast_mw_dist_dry ancpast_mw_dist_wet ancpast_mw_visit ancpast_mw_1tri_times ancpast_mw_2tri_times ancpast_mw_3tri_times 
destring ancpast_mw_where, replace
replace ancpast_mw_where = .m if ancpast_adopt == 1

local num	1 2 3 4 5 6 888
foreach x in `num' {
	gen ancpast_mw_where_`x' 		= (ancpast_mw_where == `x')
	replace ancpast_mw_where_`x' 	= .m if mi(ancpast_mw_where)
	tab ancpast_mw_where_`x', m
}

rename ancpast_mw_where_1		ancpast_mw_home
rename ancpast_mw_where_2		ancpast_mw_hosp
rename ancpast_mw_where_3		ancpast_mw_clinic
rename ancpast_mw_where_4		ancpast_mw_rhc
rename ancpast_mw_where_5		ancpast_mw_vill
rename ancpast_mw_where_6		ancpast_mw_eho
rename ancpast_mw_where_888	ancpast_mw_othplc

// ancpast_mw_where_oth 

// ancpast_mw_dist_dry ancpast_mw_dist_wet 

destring ancpast_mw_dist_dry ancpast_mw_dist_wet , replace
replace ancpast_mw_dist_dry = .m if ancpast_adopt == 1
replace ancpast_mw_dist_wet = .m if ancpast_adopt == 1
replace ancpast_mw_dist_dry = .m if ancpast_mw != 1
replace ancpast_mw_dist_wet = .m if ancpast_mw != 1
tab1 ancpast_mw_dist_dry ancpast_mw_dist_wet , m


// ancpast_mw_visit ancpast_mw_1tri_times ancpast_mw_2tri_times ancpast_mw_3tri_times  
destring ancpast_mw_visit ancpast_mw_1tri_times ancpast_mw_2tri_times ancpast_mw_3tri_times, replace
replace ancpast_mw_visit = .m if ancpast_adopt == 1
replace ancpast_mw_visit = .m if ancpast_mw != 1
replace ancpast_mw_visit = .n if ancpast_mw_visit == 444

replace ancpast_mw_1tri_times = .m if mi(ancpast_mw_visit)
replace ancpast_mw_2tri_times = .m if mi(ancpast_mw_visit)
replace ancpast_mw_3tri_times = .m if mi(ancpast_mw_visit)

replace ancpast_mw_1tri_times = .n if ancpast_mw_1tri_times == 444
replace ancpast_mw_2tri_times = .n if ancpast_mw_2tri_times == 444
replace ancpast_mw_3tri_times = .n if ancpast_mw_3tri_times == 444

tab1  ancpast_mw_visit ancpast_mw_1tri_times ancpast_mw_2tri_times ancpast_mw_3tri_times, m

// ancpast_amw_where ancpast_amw_where_oth ancpast_amw_dist_dry ancpast_amw_dist_wet ancpast_amw_visit ancpast_amw_1tri_times ancpast_amw_2tri_times ancpast_amw_3tri_times 
destring ancpast_amw_where, replace
replace ancpast_amw_where = .m if ancpast_adopt == 1

local num	1 2 3 4 5 6 888
foreach x in `num' {
	gen ancpast_amw_where_`x' 		= (ancpast_amw_where == `x')
	replace ancpast_amw_where_`x' 	= .m if mi(ancpast_amw_where)
	tab ancpast_amw_where_`x', m
}

rename ancpast_amw_where_1		ancpast_amw_home
rename ancpast_amw_where_2		ancpast_amw_hosp
rename ancpast_amw_where_3		ancpast_amw_clinic
rename ancpast_amw_where_4		ancpast_amw_rhc
rename ancpast_amw_where_5		ancpast_amw_vill
rename ancpast_amw_where_6		ancpast_amw_eho
rename ancpast_amw_where_888	ancpast_amw_othplc

// ancpast_amw_where_oth 

// ancpast_amw_dist_dry ancpast_amw_dist_wet 

destring ancpast_amw_dist_dry ancpast_amw_dist_wet , replace
replace ancpast_amw_dist_dry = .m if ancpast_adopt == 1
replace ancpast_amw_dist_wet = .m if ancpast_adopt == 1
replace ancpast_amw_dist_dry = .m if ancpast_amw != 1
replace ancpast_amw_dist_wet = .m if ancpast_amw != 1
tab1 ancpast_amw_dist_dry ancpast_amw_dist_wet , m


// ancpast_amw_visit ancpast_amw_1tri_times ancpast_amw_2tri_times ancpast_amw_3tri_times  
destring ancpast_amw_visit ancpast_amw_1tri_times ancpast_amw_2tri_times ancpast_amw_3tri_times, replace
replace ancpast_amw_visit = .m if ancpast_adopt == 1
replace ancpast_amw_visit = .m if ancpast_amw != 1
replace ancpast_amw_visit = .n if ancpast_amw_visit == 444

replace ancpast_amw_1tri_times = .m if mi(ancpast_amw_visit)
replace ancpast_amw_2tri_times = .m if mi(ancpast_amw_visit)
replace ancpast_amw_3tri_times = .m if mi(ancpast_amw_visit)

replace ancpast_amw_1tri_times = .n if ancpast_amw_1tri_times == 444
replace ancpast_amw_2tri_times = .n if ancpast_amw_2tri_times == 444
replace ancpast_amw_3tri_times = .n if ancpast_amw_3tri_times == 444

tab1  ancpast_amw_visit ancpast_amw_1tri_times ancpast_amw_2tri_times ancpast_amw_3tri_times, m

// ancpast_tba_where ancpast_tba_where_oth ancpast_tba_dist_dry ancpast_tba_dist_wet ancpast_tba_visit ancpast_tba_1tri_times ancpast_tba_2tri_times ancpast_tba_3tri_times 
destring ancpast_tba_where, replace
replace ancpast_tba_where = .m if ancpast_adopt == 1

local num	1 2 3 4 5 6 888
foreach x in `num' {
	gen ancpast_tba_where_`x' 		= (ancpast_tba_where == `x')
	replace ancpast_tba_where_`x' 	= .m if mi(ancpast_tba_where)
	tab ancpast_tba_where_`x', m
}

rename ancpast_tba_where_1		ancpast_tba_home
rename ancpast_tba_where_2		ancpast_tba_hosp
rename ancpast_tba_where_3		ancpast_tba_clinic
rename ancpast_tba_where_4		ancpast_tba_rhc
rename ancpast_tba_where_5		ancpast_tba_vill
rename ancpast_tba_where_6		ancpast_tba_eho
rename ancpast_tba_where_888	ancpast_tba_othplc

// ancpast_tba_where_oth 

// ancpast_tba_dist_dry ancpast_tba_dist_wet 

destring ancpast_tba_dist_dry ancpast_tba_dist_wet , replace
replace ancpast_tba_dist_dry = .m if ancpast_adopt == 1
replace ancpast_tba_dist_wet = .m if ancpast_adopt == 1
replace ancpast_tba_dist_dry = .m if ancpast_tba != 1
replace ancpast_tba_dist_wet = .m if ancpast_tba != 1
tab1 ancpast_tba_dist_dry ancpast_tba_dist_wet , m


// ancpast_tba_visit ancpast_tba_1tri_times ancpast_tba_2tri_times ancpast_tba_3tri_times  
destring ancpast_tba_visit ancpast_tba_1tri_times ancpast_tba_2tri_times ancpast_tba_3tri_times, replace
replace ancpast_tba_visit = .m if ancpast_adopt == 1
replace ancpast_tba_visit = .m if ancpast_tba != 1
replace ancpast_tba_visit = .n if ancpast_tba_visit == 444

replace ancpast_tba_1tri_times = .m if mi(ancpast_tba_visit)
replace ancpast_tba_2tri_times = .m if mi(ancpast_tba_visit)
replace ancpast_tba_3tri_times = .m if mi(ancpast_tba_visit)

replace ancpast_tba_1tri_times = .n if ancpast_tba_1tri_times == 444
replace ancpast_tba_2tri_times = .n if ancpast_tba_2tri_times == 444
replace ancpast_tba_3tri_times = .n if ancpast_tba_3tri_times == 444

tab1  ancpast_tba_visit ancpast_tba_1tri_times ancpast_tba_2tri_times ancpast_tba_3tri_times, m

// ancpast_chw_where ancpast_chw_where_oth ancpast_chw_dist_dry ancpast_chw_dist_wet ancpast_chw_visit ancpast_chw_1tri_times ancpast_chw_2tri_times ancpast_chw_3tri_times 
destring ancpast_chw_where, replace
replace ancpast_chw_where = .m if ancpast_adopt == 1

local num	1 2 3 4 5 6 888
foreach x in `num' {
	gen ancpast_chw_where_`x' 		= (ancpast_chw_where == `x')
	replace ancpast_chw_where_`x' 	= .m if mi(ancpast_chw_where)
	tab ancpast_chw_where_`x', m
}

rename ancpast_chw_where_1		ancpast_chw_home
rename ancpast_chw_where_2		ancpast_chw_hosp
rename ancpast_chw_where_3		ancpast_chw_clinic
rename ancpast_chw_where_4		ancpast_chw_rhc
rename ancpast_chw_where_5		ancpast_chw_vill
rename ancpast_chw_where_6		ancpast_chw_eho
rename ancpast_chw_where_888	ancpast_chw_othplc

// ancpast_chw_where_oth 

// ancpast_chw_dist_dry ancpast_chw_dist_wet 

destring ancpast_chw_dist_dry ancpast_chw_dist_wet , replace
replace ancpast_chw_dist_dry = .m if ancpast_adopt == 1
replace ancpast_chw_dist_wet = .m if ancpast_adopt == 1
replace ancpast_chw_dist_dry = .m if ancpast_chw != 1
replace ancpast_chw_dist_wet = .m if ancpast_chw != 1
tab1 ancpast_chw_dist_dry ancpast_chw_dist_wet , m


// ancpast_chw_visit ancpast_chw_1tri_times ancpast_chw_2tri_times ancpast_chw_3tri_times  
destring ancpast_chw_visit ancpast_chw_1tri_times ancpast_chw_2tri_times ancpast_chw_3tri_times, replace
replace ancpast_chw_visit = .m if ancpast_adopt == 1
replace ancpast_chw_visit = .m if ancpast_chw != 1
replace ancpast_chw_visit = .n if ancpast_chw_visit == 444

replace ancpast_chw_1tri_times = .m if mi(ancpast_chw_visit)
replace ancpast_chw_2tri_times = .m if mi(ancpast_chw_visit)
replace ancpast_chw_3tri_times = .m if mi(ancpast_chw_visit)

replace ancpast_chw_1tri_times = .n if ancpast_chw_1tri_times == 444
replace ancpast_chw_2tri_times = .n if ancpast_chw_2tri_times == 444
replace ancpast_chw_3tri_times = .n if ancpast_chw_3tri_times == 444

tab1  ancpast_chw_visit ancpast_chw_1tri_times ancpast_chw_2tri_times ancpast_chw_3tri_times, m

// ancpast_ehw_where ancpast_ehw_where_oth ancpast_ehw_dist_dry ancpast_ehw_dist_wet ancpast_ehw_visit ancpast_ehw_1tri_times ancpast_ehw_2tri_times ancpast_ehw_3tri_times 
destring ancpast_ehw_where, replace
replace ancpast_ehw_where = .m if ancpast_adopt == 1

local num	1 2 3 4 5 6 888
foreach x in `num' {
	gen ancpast_ehw_where_`x' 		= (ancpast_ehw_where == `x')
	replace ancpast_ehw_where_`x' 	= .m if mi(ancpast_ehw_where)
	tab ancpast_ehw_where_`x', m
}

rename ancpast_ehw_where_1		ancpast_ehw_home
rename ancpast_ehw_where_2		ancpast_ehw_hosp
rename ancpast_ehw_where_3		ancpast_ehw_clinic
rename ancpast_ehw_where_4		ancpast_ehw_rhc
rename ancpast_ehw_where_5		ancpast_ehw_vill
rename ancpast_ehw_where_6		ancpast_ehw_eho
rename ancpast_ehw_where_888	ancpast_ehw_othplc

// ancpast_ehw_where_oth 

// ancpast_ehw_dist_dry ancpast_ehw_dist_wet 

destring ancpast_ehw_dist_dry ancpast_ehw_dist_wet , replace
replace ancpast_ehw_dist_dry = .m if ancpast_adopt == 1
replace ancpast_ehw_dist_wet = .m if ancpast_adopt == 1
replace ancpast_ehw_dist_dry = .m if ancpast_ehw != 1
replace ancpast_ehw_dist_wet = .m if ancpast_ehw != 1
tab1 ancpast_ehw_dist_dry ancpast_ehw_dist_wet , m


// ancpast_ehw_visit ancpast_ehw_1tri_times ancpast_ehw_2tri_times ancpast_ehw_3tri_times  
destring ancpast_ehw_visit ancpast_ehw_1tri_times ancpast_ehw_2tri_times ancpast_ehw_3tri_times, replace
replace ancpast_ehw_visit = .m if ancpast_adopt == 1
replace ancpast_ehw_visit = .m if ancpast_ehw != 1
replace ancpast_ehw_visit = .n if ancpast_ehw_visit == 444

replace ancpast_ehw_1tri_times = .m if mi(ancpast_ehw_visit)
replace ancpast_ehw_2tri_times = .m if mi(ancpast_ehw_visit)
replace ancpast_ehw_3tri_times = .m if mi(ancpast_ehw_visit)

replace ancpast_ehw_1tri_times = .n if ancpast_ehw_1tri_times == 444
replace ancpast_ehw_2tri_times = .n if ancpast_ehw_2tri_times == 444
replace ancpast_ehw_3tri_times = .n if ancpast_ehw_3tri_times == 444

tab1  ancpast_ehw_visit ancpast_ehw_1tri_times ancpast_ehw_2tri_times ancpast_ehw_3tri_times, m


// ancpast_oth_where ancpast_oth_where_oth ancpast_oth_dist_dry ancpast_oth_dist_wet ancpast_oth_visit ancpast_oth_1tri_times ancpast_oth_2tri_times ancpast_oth_3tri_times 
destring ancpast_oth_where, replace
replace ancpast_oth_where = .m if ancpast_adopt == 1

local num	1 2 3 4 5 6 888
foreach x in `num' {
	gen ancpast_oth_where_`x' 		= (ancpast_oth_where == `x')
	replace ancpast_oth_where_`x' 	= .m if mi(ancpast_oth_where)
	tab ancpast_oth_where_`x', m
}

rename ancpast_oth_where_1		ancpast_oth_home
rename ancpast_oth_where_2		ancpast_oth_hosp
rename ancpast_oth_where_3		ancpast_oth_clinic
rename ancpast_oth_where_4		ancpast_oth_rhc
rename ancpast_oth_where_5		ancpast_oth_vill
rename ancpast_oth_where_6		ancpast_oth_eho
rename ancpast_oth_where_888	ancpast_oth_othplc

// ancpast_oth_where_oth 

// ancpast_oth_dist_dry ancpast_oth_dist_wet 

destring ancpast_oth_dist_dry ancpast_oth_dist_wet , replace
replace ancpast_oth_dist_dry = .m if ancpast_adopt == 1
replace ancpast_oth_dist_wet = .m if ancpast_adopt == 1
replace ancpast_oth_dist_dry = .m if ancpast_oth != 1
replace ancpast_oth_dist_wet = .m if ancpast_oth != 1
tab1 ancpast_oth_dist_dry ancpast_oth_dist_wet , m


// ancpast_oth_visit ancpast_oth_1tri_times ancpast_oth_2tri_times ancpast_oth_3tri_times  
destring ancpast_oth_visit ancpast_oth_1tri_times ancpast_oth_2tri_times ancpast_oth_3tri_times, replace
replace ancpast_oth_visit = .m if ancpast_adopt == 1
replace ancpast_oth_visit = .m if ancpast_oth != 1
replace ancpast_oth_visit = .n if ancpast_oth_visit == 444

replace ancpast_oth_1tri_times = .m if mi(ancpast_oth_visit)
replace ancpast_oth_2tri_times = .m if mi(ancpast_oth_visit)
replace ancpast_oth_3tri_times = .m if mi(ancpast_oth_visit)

replace ancpast_oth_1tri_times = .n if ancpast_oth_1tri_times == 444
replace ancpast_oth_2tri_times = .n if ancpast_oth_2tri_times == 444
replace ancpast_oth_3tri_times = .n if ancpast_oth_3tri_times == 444

tab1  ancpast_oth_visit ancpast_oth_1tri_times ancpast_oth_2tri_times ancpast_oth_3tri_times, m

// ancpast_cost 
destring ancpast_cost, replace
replace ancpast_cost = .d if ancpast_cost == 999
replace ancpast_cost = .m if ancpast_yn != 1
tab ancpast_cost, m

// ancpast_amount 
destring ancpast_amount, replace
replace ancpast_amount = .d if ancpast_amount == 999
replace ancpast_amount = .r if ancpast_amount == 666
replace ancpast_amount = .n if ancpast_amount == 444
replace ancpast_amount = .m if ancpast_cost != 1
tab ancpast_amount, m

// ancpast_costitem 
local items ancpast_costitem1 ancpast_costitem2 ancpast_costitem3 ancpast_costitem4 ancpast_costitem5 ancpast_costitem6 ancpast_costitem888 

foreach var in `items' {
	destring `var', replace
	replace `var' = .m if mi(ancpast_amount)

	tab `var', m
}

rename ancpast_costitem1 	ancpast_cost_ta
rename ancpast_costitem2 	ancpast_cost_reg
rename ancpast_costitem3 	ancpast_cost_drug
rename ancpast_costitem4 	ancpast_cost_lab
rename ancpast_costitem5 	ancpast_cost_consult
rename ancpast_costitem6 	ancpast_cost_gift
rename ancpast_costitem888	ancpast_cost_oth

// ancpast_costitem_oth 

// ancpast_borrow 
destring ancpast_borrow, replace
replace ancpast_borrow = .m if ancpast_cost != 1
tab ancpast_borrow, m

// ancpast_mchbook 
destring ancpast_mchbook, replace
replace ancpast_mchbook = .m if ancpast_yn != 1
tab ancpast_mchbook, m

// ancpast_conselling 
destring ancpast_conselling, replace
replace ancpast_conselling = .m if ancpast_yn != 1
tab ancpast_conselling, m

// ancpast_noreason 
destring ancpast_noreason, replace
replace ancpast_noreason = .d if ancpast_noreason == 999
replace ancpast_noreason = .m if ancpast_yn != 0
tab ancpast_noreason, m

local val 1 2 3 4 5 6 7 888
foreach x in `val' {
	gen ancpast_noreason_`x' = (ancpast_noreason == `x')
	replace ancpast_noreason_`x' = .m if mi(ancpast_noreason)
	order ancpast_noreason_`x', before(ancpast_restrict)
	tab ancpast_noreason_`x', m
}

rename ancpast_noreason_1 	ancpast_no_important
rename ancpast_noreason_2 	ancpast_no_distance
rename ancpast_noreason_3 	ancpast_no_restrict
rename ancpast_noreason_4 	ancpast_no_accompany
rename ancpast_noreason_5 	ancpast_no_hf
rename ancpast_noreason_6 	ancpast_no_staff
rename ancpast_noreason_7 	ancpast_no_finance
rename ancpast_noreason_888	ancpast_no_oth

// ancpast_noreason_oth 

// ancpast_restrict 
destring ancpast_restrict, replace
replace ancpast_restrict = .m if ancpast_adopt == 1
tab ancpast_restrict, m

// ancpast_restrict_item 
local items ancpast_restrict_item1 ancpast_restrict_item2 ancpast_restrict_item3 ancpast_restrict_item4 ancpast_restrict_item5 ancpast_restrict_item6 ancpast_restrict_item888 

foreach var in `items' {
	destring `var', replace
	replace `var' = .m if ancpast_restrict != 1
	tab `var', m
}

rename ancpast_restrict_item1	ancpast_restrict_veg 	
rename ancpast_restrict_item2 	ancpast_restrict_fruit
rename ancpast_restrict_item3 	ancpast_restrict_grain
rename ancpast_restrict_item4 	ancpast_restrict_meat
rename ancpast_restrict_item5 	ancpast_restrict_fish
rename ancpast_restrict_item6 	ancpast_restrict_diary
rename ancpast_restrict_item888	ancpast_restrict_oth

// ancpast_restrict_item_oth 

// ancpast_restrict_why 
destring ancpast_restrict_why, replace
replace ancpast_restrict_why = .m if ancpast_restrict != 1
tab ancpast_restrict_why, m

local val 1 2 888
foreach x in `val' {
	gen ancpast_restrict_why_`x' = (ancpast_restrict_why == `x')
	replace ancpast_restrict_why_`x' = .m if ancpast_restrict != 1
	order ancpast_restrict_why_`x', before(ancpast_bone)
	tab ancpast_restrict_why_`x', m
}

rename ancpast_restrict_why_1 		ancpast_restrict_adult
rename ancpast_restrict_why_2 		ancpast_restrict_tradit
rename ancpast_restrict_why_888		ancpast_restrict_whyoth		

// ancpast_restrict_why_oth 

// ancpast_bone 
destring ancpast_bone, replace
replace ancpast_bone = .d if ancpast_bone == 999
replace ancpast_bone = .m if ancpast_adopt == 1
tab ancpast_bone, m

// ancpast_rion 
destring ancpast_rion, replace
replace ancpast_rion = .d if ancpast_rion == 999
replace ancpast_rion = .m if ancpast_adopt == 1
tab ancpast_rion, m

// ancpast_iron_freq 
destring ancpast_iron_freq, replace
replace ancpast_rion = .d if ancpast_rion == 999
replace ancpast_iron_freq = .m if ancpast_rion != 1
tab ancpast_iron_freq, m

local val 0 1 2 3
foreach x in `val' {
	gen ancpast_iron_freq_`x' = (ancpast_iron_freq == `x')
	replace ancpast_iron_freq_`x' = .m if ancpast_rion != 1
	order ancpast_iron_freq_`x', before(ancpast_iron_freq_lab)
	tab ancpast_iron_freq_`x', m
}

rename ancpast_iron_freq_0 ancpast_iron_freq_no 
rename ancpast_iron_freq_1 ancpast_iron_freq_day
rename ancpast_iron_freq_2 ancpast_iron_freq_wk
rename ancpast_iron_freq_3 ancpast_iron_freq_month

// ancpast_iron_freq_lab 

// ancpast_iron_count 
destring ancpast_iron_count, replace
replace ancpast_iron_count = .n if ancpast_iron_count == 444 | ancpast_iron_count == 0
replace ancpast_iron_count = .m if mi(ancpast_iron_freq) | ancpast_iron_freq == 0 
tab ancpast_iron_count, m

// ancpast_rion_length 
destring ancpast_rion_length, replace
replace ancpast_rion_length = .m if mi(ancpast_iron_count)
tab ancpast_rion_length, m

gen ancpast_rion_less_month = (ancpast_rion_length == 1)
replace ancpast_rion_less_month = .m if mi(ancpast_rion_length)
order ancpast_rion_less_month, after(ancpast_rion_length)
tab ancpast_rion_less_month, m

// ancpast_rion_length_oth 
destring ancpast_rion_length_oth, replace
replace ancpast_rion_length_oth = 0.5 if ancpast_rion_length == 1 // assumed only half of a month
replace ancpast_rion_length_oth = .d if ancpast_rion_length_oth == 999
replace ancpast_rion_length_oth = .n if ancpast_rion_length_oth == 444
replace ancpast_rion_length_oth = .m if mi(ancpast_iron_count)
tab ancpast_rion_length_oth, m

rename ancpast_rion_length_oth ancpast_rion_lengthnum

// ancpast_iron_cost  
destring ancpast_iron_cost, replace
replace ancpast_iron_cost = .m if ancpast_rion != 1
tab ancpast_iron_cost, m

// ancpast_iron_amount
destring ancpast_iron_amount, replace
replace ancpast_iron_amount = .d if ancpast_iron_amount == 999
replace ancpast_iron_amount = .n if ancpast_iron_amount == 444 | ancpast_iron_amount == 5
replace ancpast_iron_amount = .m if ancpast_iron_cost != 1
tab ancpast_iron_amount, m

// ancpast_iron_source 
local iron	ancpast_iron_source1 ancpast_iron_source2 ancpast_iron_source3 ancpast_iron_source4 ancpast_iron_source5 ancpast_iron_source888 

foreach var in `iron' {
	destring `var', replace
	replace `var' = .m if ancpast_rion != 1
	tab `var', m
}

rename ancpast_iron_source1 	ancpast_iron_hosp 
rename ancpast_iron_source2 	ancpast_iron_eho
rename ancpast_iron_source3 	ancpast_iron_pdoc
rename ancpast_iron_source4 	ancpast_iron_rhc
rename ancpast_iron_source5 	ancpast_iron_vill
rename ancpast_iron_source888 	ancpast_iron_oth

// ancpast_iron_source_oth 

// ancpast_test_yesno 
local test ancpast_test_yesno0 ancpast_test_yesno1 ancpast_test_yesno2 ancpast_test_yesno3 ancpast_test_yesno4 ancpast_test_yesno888 ancpast_test_yesno999 

foreach var in `test' {
	destring `var', replace
	replace `var' = .m if ancpast_adopt == 1
	tab `var', m
}

gen ancpast_test_yes		= (ancpast_test_yesno != "0" & ancpast_test_yesno != "999")
replace ancpast_test_yes	= .d if ancpast_test_yesno == "999"
replace ancpast_test_yes	= .m if mi(ancpast_test_yesno)
tab ancpast_test_yes, m

order ancpast_test_yes, after(ancpast_test_yesno)

rename ancpast_test_yesno0 		ancpast_test_no
rename ancpast_test_yesno1 		ancpast_test_hepb
rename ancpast_test_yesno2 		ancpast_test_hepc
rename ancpast_test_yesno3 		ancpast_test_hiv
rename ancpast_test_yesno4 		ancpast_test_std
rename ancpast_test_yesno888 	ancpast_test_oth
rename ancpast_test_yesno999	ancpast_test_dk

// ancpast_test_yesno_oth 

// ancpast_test_where 
local where ancpast_test_where1 ancpast_test_where2 ancpast_test_where3 ancpast_test_where4 ancpast_test_where5 ancpast_test_where888 

foreach var in `where' {
	destring `var', replace
	replace `var' = .m if mi(ancpast_test_where)
	tab `var', m
}

rename ancpast_test_where1		ancpast_test_hosp		
rename ancpast_test_where2 		ancpast_test_eho
rename ancpast_test_where3 		ancpast_test_pdoc
rename ancpast_test_where4 		ancpast_test_rhc
rename ancpast_test_where5 		ancpast_test_vill
rename ancpast_test_where888	ancpast_test_plcoth

// ancpast_test_cost 
destring ancpast_test_cost, replace
replace ancpast_test_cost = .d if ancpast_test_cost == 999
replace ancpast_test_cost = .n if ancpast_test_cost == 444 | ancpast_test_cost < 500
replace ancpast_test_cost = .m if ancpast_test_cost == .
tab ancpast_test_cost, m

// ancpast_test_where_oth


*** reporting variable generation ***

* anc with trained health personnel
gen ancpast_trained 		= 0 
replace ancpast_trained 	= .m if ancpast_yn != 1
local trained 	ancpast_spelist ancpast_doc ancpast_nurs ancpast_ha ancpast_pdoc ///
				ancpast_lhv ancpast_mw ancpast_ehw
				
foreach var in `trained' {
	replace ancpast_trained = 1 if `var' == 1
}
tab ancpast_trained, m

* anc visits freq with trained health personnel
egen ancpast_trained_freq		= rowtotal(ancpast_spelist_visit ancpast_doc_visit ancpast_nurs_visit ///
									ancpast_ha_visit ancpast_pdoc_visit ancpast_lhv_visit ancpast_mw_visit ///
									ancpast_ehw_visit)
replace ancpast_trained_freq 	= .m if mi(ancpast_yn)
tab ancpast_trained_freq, m


* Winsorized
winsor2 ancpast_trained_freq, replace cuts(1 75)

* anc visits freq detail with trained health personnel
forvalue x = 1/4 {
	gen ancpast_trained_freq`x' 	= (ancpast_trained_freq >= `x')
	replace ancpast_trained_freq`x' = .m if mi(ancpast_trained_freq)
	tab ancpast_trained_freq`x', m
}

order 	ancpast_trained ancpast_trained_freq ancpast_trained_freq1 ancpast_trained_freq2 ///
		ancpast_trained_freq3 ancpast_trained_freq4, before(ancpast_cost)
		

* iron calculation 

// ancpast_bone ancpast_rion ancpast_iron_freq ancpast_iron_freq_no 
// ancpast_iron_freq_day ancpast_iron_freq_wk ancpast_iron_freq_month
// ancpast_iron_count ancpast_rion_less_month ancpast_rion_lengthnum ancpast_iron_cost ancpast_iron_amount 

gen ancpast_iron_consum 	= .m
replace ancpast_iron_consum = 0 if ancpast_rion == 0 
replace ancpast_iron_consum = round(ancpast_iron_count * 30 * ancpast_rion_lengthnum,0.1) 	if ancpast_iron_freq_day == 1
replace ancpast_iron_consum = round(ancpast_iron_count * 4 * ancpast_rion_lengthnum,0.1) 	if ancpast_iron_freq_wk == 1
replace ancpast_iron_consum = round(ancpast_iron_count * ancpast_rion_lengthnum,0.1) 		if ancpast_iron_freq_month == 1
replace ancpast_iron_consum = .m if mi(ancpast_iron_count) & ancpast_rion != 0 
replace ancpast_iron_consum = .m if mi(ancpast_rion_lengthnum) & ancpast_rion != 0
tab ancpast_iron_consum, m

* Winsorized
winsor2 ancpast_iron_consum, replace cuts(1 95)

order ancpast_iron_consum , after(ancpast_rion_lengthnum)

** reporting variables **

lab var ancpast_yn			"Received ANC"

lab var ancpast_spelist 	"ANC - Specialist"
lab var ancpast_doc 		"ANC - Doctor"
lab var ancpast_nurs		"ANC - Nurse"
lab var ancpast_ha 			"ANC - Health assistant"
lab var ancpast_pdoc 		"ANC - Private doctor"
lab var ancpast_lhv 		"ANC - LHV"
lab var ancpast_mw 			"ANC - Midwife"
lab var ancpast_amw 		"ANC - AMW"
lab var ancpast_tba 		"ANC - TBA"
lab var ancpast_chw 		"ANC - Community Health Worker"
lab var ancpast_ehw 		"ANC - Ethnic health worker"
lab var ancpast_oth			"ANC - other"

lab var ancpast_spelist_home 	"Specialist at home"
lab var ancpast_spelist_hosp 	"Specialist at Government hospital"
lab var ancpast_spelist_clinic 	"Specialist at Private doctor/clinic"
lab var ancpast_spelist_rhc 	"Specialist at SRHC-RHC"
lab var ancpast_spelist_vill 	"Specialist at Routine ANC place within village/ward"
lab var ancpast_spelist_eho 	"Specialist at EHO clinic"
lab var ancpast_spelist_othplc	"Specialist at other places"
lab var ancpast_spelist_visit 	"Specialist - ANC visits"

lab var ancpast_doc_home 	"Doctor at home"
lab var ancpast_doc_hosp 	"Doctor at Government hospital"
lab var ancpast_doc_clinic 	"Doctor at Private doctor/clinic"
lab var ancpast_doc_rhc 	"Doctor at SRHC-RHC"
lab var ancpast_doc_vill 	"Doctor at Routine ANC place within village/ward"
lab var ancpast_doc_eho 	"Doctor at EHO clinic"
lab var ancpast_doc_othplc	"Doctor at other places"
lab var ancpast_doc_visit 	"Doctor - ANC visits"

lab var ancpast_nurs_home 	"Nurse at home"
lab var ancpast_nurs_hosp 	"Nurse at Government hospital"
lab var ancpast_nurs_clinic "Nurse at Private doctor/clinic"
lab var ancpast_nurs_rhc 	"Nurse at SRHC-RHC"
lab var ancpast_nurs_vill 	"Nurse at Routine ANC place within village/ward"
lab var ancpast_nurs_eho 	"Nurse at EHO clinic"
lab var ancpast_nurs_othplc	"Nurse at other places"
lab var ancpast_nurs_visit 	"Nurse - ANC visits"

lab var ancpast_ha_home 	"HA at home"
lab var ancpast_ha_hosp 	"HA at Government hospital"
lab var ancpast_ha_clinic 	"HA at Private doctor/clinic"
lab var ancpast_ha_rhc	 	"HA at SRHC-RHC"
lab var ancpast_ha_vill 	"HA at Routine ANC place within village/ward"
lab var ancpast_ha_eho 		"HA at EHO clinic"
lab var ancpast_ha_othplc	"HA at other places"
lab var ancpast_ha_visit 	"HA - ANC visits"

lab var ancpast_pdoc_home 	"Private doctor at home"
lab var ancpast_pdoc_hosp 	"Private doctor at Government hospital"
lab var ancpast_pdoc_clinic "Private doctor at Private doctor/clinic"
lab var ancpast_pdoc_rhc 	"Private doctor at SRHC-RHC"
lab var ancpast_pdoc_vill 	"Private doctor at Routine ANC place within village/ward"
lab var ancpast_pdoc_eho 	"Private doctor at EHO clinic"
lab var ancpast_pdoc_othplc	"Private doctor at other places"
lab var ancpast_pdoc_visit 	"Private doctor - ANC visits"

lab var ancpast_lhv_home 	"LHV at home"
lab var ancpast_lhv_hosp 	"LHV at Government hospital"
lab var ancpast_lhv_clinic 	"LHV at Private doctor/clinic"
lab var ancpast_lhv_rhc 	"LHV at SRHC-RHC"
lab var ancpast_lhv_vill 	"LHV at Routine ANC place within village/ward"
lab var ancpast_lhv_eho 	"LHV at EHO clinic"
lab var ancpast_lhv_othplc	"LHV at other places"
lab var ancpast_lhv_visit 	"LHV - ANC visits"

lab var ancpast_mw_home 	"MW at home"
lab var ancpast_mw_hosp 	"MW at Government hospital"
lab var ancpast_mw_clinic 	"MW at Private doctor/clinic"
lab var ancpast_mw_rhc 		"MW at SRHC-RHC"
lab var ancpast_mw_vill 	"MW at Routine ANC place within village/ward"
lab var ancpast_mw_eho 		"MW at EHO clinic"
lab var ancpast_mw_othplc	"MW at other places"
lab var ancpast_mw_visit 	"MW - ANC visits"

lab var ancpast_amw_home 	"AMW at home"
lab var ancpast_amw_hosp 	"AMW at Government hospital"
lab var ancpast_amw_clinic 	"AMW at Private doctor/clinic"
lab var ancpast_amw_rhc 	"AMW at SRHC-RHC"
lab var ancpast_amw_vill 	"AMW at Routine ANC place within village/ward"
lab var ancpast_amw_eho 	"AMW at EHO clinic"
lab var ancpast_amw_othplc	"AMW at other places"
lab var ancpast_amw_visit 	"AMW - ANC visits"

lab var ancpast_tba_home 	"TBA at home"
lab var ancpast_tba_hosp 	"TBA at Government hospital"
lab var ancpast_tba_clinic 	"TBA at Private doctor/clinic"
lab var ancpast_tba_rhc 	"TBA at SRHC-RHC"
lab var ancpast_tba_vill 	"TBA at Routine ANC place within village/ward"
lab var ancpast_tba_eho 	"TBA at EHO clinic"
lab var ancpast_tba_othplc	"TBA at other places"
lab var ancpast_tba_visit 	"TBA - ANC visits"

lab var ancpast_chw_home 	"Community Health Worker at home"
lab var ancpast_chw_hosp 	"Community Health Worker at Government hospital"
lab var ancpast_chw_clinic 	"Community Health Worker at Private doctor/clinic"
lab var ancpast_chw_rhc 	"Community Health Worker at SRHC-RHC"
lab var ancpast_chw_vill 	"Community Health Worker at Routine ANC place within village/ward"
lab var ancpast_chw_eho 	"Community Health Worker at EHO clinic"
lab var ancpast_chw_othplc	"Community Health Worker at other places"
lab var ancpast_chw_visit 	"Community Health Worker - ANC visits"

lab var ancpast_ehw_home 	"Ethnic health worker at home"
lab var ancpast_ehw_hosp 	"Ethnic health worker at Government hospital"
lab var ancpast_ehw_clinic 	"Ethnic health worker at Private doctor/clinic"
lab var ancpast_ehw_rhc 	"Ethnic health worker at SRHC-RHC"
lab var ancpast_ehw_vill 	"Ethnic health worker at Routine ANC place within village/ward"
lab var ancpast_ehw_eho 	"Ethnic health worker at EHO clinic"
lab var ancpast_ehw_othplc	"Ethnic health worker at other places"
lab var ancpast_ehw_visit 	"Ethnic health worker - ANC visits"

lab var ancpast_oth_home 	"Other personnel at home"
lab var ancpast_oth_hosp 	"Other personnel at Government hospital"
lab var ancpast_oth_clinic 	"Other personnel at Private doctor/clinic"
lab var ancpast_oth_rhc 	"Other personnel at SRHC-RHC"
lab var ancpast_oth_vill 	"Other personnel at Routine ANC place within village/ward"
lab var ancpast_oth_eho 	"Other personnel at EHO clinic"
lab var ancpast_oth_othplc	"Other personnel at other places"
lab var ancpast_oth_visit 	"Other personnel - ANC visits"

lab var ancpast_trained 		"ANC with trained health personnel"
lab var ancpast_trained_freq 	"ANC visits with trained health personnel"
lab var ancpast_trained_freq1 	"at least one ANC visits with trained health personnel"
lab var ancpast_trained_freq2 	"at least two ANC visits with trained health personnel"
lab var ancpast_trained_freq3 	"at least three ANC visits with trained health personnel"
lab var ancpast_trained_freq4	"at least four ANC visits with trained health personnel"

lab var ancpast_cost 			"incur cost for ANC"
lab var ancpast_amount 			"ANC cost amount"
lab var ancpast_cost_ta 		"cost for Transportation"
lab var ancpast_cost_reg 		"cost for Registration fees"
lab var ancpast_cost_drug 		"cost for Medicines"
lab var ancpast_cost_lab 		"cost for Laboratory tests"
lab var ancpast_cost_consult 	"cost for Provider fees"
lab var ancpast_cost_gift 		"cost for Gifts"
lab var ancpast_cost_oth 		"cost for other expenditure"
lab var ancpast_borrow			"took loan for ANC"

lab var ancpast_conselling		"ANC counselling"

lab var ancpast_no_important 	"Did not think it was important"
lab var ancpast_no_distance		"Long distance"
lab var ancpast_no_restrict 	"Not allowed by family"
lab var ancpast_no_accompany 	"No family members to come with me"
lab var ancpast_no_hf 			"No health facility"
lab var ancpast_no_staff 		"No health staff present"
lab var ancpast_no_finance 		"Financial difficulties"
lab var ancpast_no_oth			"Other reason"

lab var ancpast_restrict 		"ANC - diet restriction"
lab var ancpast_restrict_veg	"Vegetables"
lab var ancpast_restrict_fruit	"Fruits"
lab var ancpast_restrict_grain	"Grains"
lab var ancpast_restrict_meat	"Meat"
lab var ancpast_restrict_fish	"Fish"
lab var ancpast_restrict_diary	"Diary foods"
lab var ancpast_restrict_oth 	"other food groups"

lab var ancpast_bone 			"ANC B1 consumption"
lab var ancpast_rion 			"ANC IFA consumption"
lab var ancpast_iron_consum 	"ANC IFA consumption number"
lab var ancpast_iron_cost 		"ANC IFA consumption cost"
lab var ancpast_iron_amount 	"ANC IFA consumption cost amount"

lab var ancpast_iron_hosp 		"IFA source - Government hospital"
lab var ancpast_iron_eho 		"IFA source - EHO Clinic"
lab var ancpast_iron_pdoc 		"IFA source - Private doctor/clinic"
lab var ancpast_iron_rhc		"IFA source - SRHC-RHC"
lab var ancpast_iron_vill 		"IFA source - Routine ANC place within village/ward"
lab var ancpast_iron_oth		"IFA source - other"

lab var ancpast_test_yes		"Testing of infection"
lab var ancpast_test_no 		"No testing"
lab var ancpast_test_hepb 		"Viral hepatitis B"
lab var ancpast_test_hepc 		"Viral hepatitis C"
lab var ancpast_test_hiv 		"HIV/AIDS"
lab var ancpast_test_std 		"Syphilis"
lab var ancpast_test_oth 		"Other diseases"
lab var ancpast_test_dk			"Don't know"

lab var ancpast_test_hosp 		"Government hospital"
lab var ancpast_test_eho 		"EHO Clinic"
lab var ancpast_test_pdoc 		"Private doctor/clinic"
lab var ancpast_test_rhc 		"SRHC-RHC"
lab var ancpast_test_vill 		"Routine ANC place within village/ward"
lab var ancpast_test_plcoth		"other"

lab var ancpast_test_cost		"incur cost for ANC test"


global anc			ancpast_yn ///
					ancpast_spelist ancpast_doc ancpast_nurs ancpast_ha ancpast_pdoc ancpast_lhv ancpast_mw ancpast_amw ancpast_tba ancpast_chw ancpast_ehw ancpast_oth ///
					ancpast_trained ancpast_trained_freq ancpast_trained_freq1 ancpast_trained_freq2 ancpast_trained_freq3 ancpast_trained_freq4 ///
					ancpast_spelist_home ancpast_spelist_hosp ancpast_spelist_clinic ancpast_spelist_rhc ancpast_spelist_vill ancpast_spelist_eho ancpast_spelist_othplc ///
					ancpast_spelist_visit ///
					ancpast_doc_home ancpast_doc_hosp ancpast_doc_clinic ancpast_doc_rhc ancpast_doc_vill ancpast_doc_eho ancpast_doc_othplc ///
					ancpast_doc_visit ///
					ancpast_nurs_home ancpast_nurs_hosp ancpast_nurs_clinic ancpast_nurs_rhc ancpast_nurs_vill ancpast_nurs_eho ancpast_nurs_othplc ///
					ancpast_nurs_visit ///
					ancpast_ha_home ancpast_ha_hosp ancpast_ha_clinic ancpast_ha_rhc ancpast_ha_vill ancpast_ha_eho ancpast_ha_othplc ///
					ancpast_ha_visit ///
					ancpast_pdoc_home ancpast_pdoc_hosp ancpast_pdoc_clinic ancpast_pdoc_rhc ancpast_pdoc_vill ancpast_pdoc_eho ancpast_pdoc_othplc ///
					ancpast_pdoc_visit ///
					ancpast_lhv_home ancpast_lhv_hosp ancpast_lhv_clinic ancpast_lhv_rhc ancpast_lhv_vill ancpast_lhv_eho ancpast_lhv_othplc ///
					ancpast_lhv_visit ///
					ancpast_mw_home ancpast_mw_hosp ancpast_mw_clinic ancpast_mw_rhc ancpast_mw_vill ancpast_mw_eho ancpast_mw_othplc ///
					ancpast_mw_visit ///
					ancpast_amw_home ancpast_amw_hosp ancpast_amw_clinic ancpast_amw_rhc ancpast_amw_vill ancpast_amw_eho ancpast_amw_othplc ///
					ancpast_amw_visit ///
					ancpast_tba_home ancpast_tba_hosp ancpast_tba_clinic ancpast_tba_rhc ancpast_tba_vill ancpast_tba_eho ancpast_tba_othplc ///
					ancpast_tba_visit ///
					ancpast_chw_home ancpast_chw_hosp ancpast_chw_clinic ancpast_chw_rhc ancpast_chw_vill ancpast_chw_eho ancpast_chw_othplc ///
					ancpast_chw_visit ///
					ancpast_ehw_home ancpast_ehw_hosp ancpast_ehw_clinic ancpast_ehw_rhc ancpast_ehw_vill ancpast_ehw_eho ancpast_ehw_othplc ///
					ancpast_ehw_visit ///
					ancpast_oth_home ancpast_oth_hosp ancpast_oth_clinic ancpast_oth_rhc ancpast_oth_vill ancpast_oth_eho ancpast_oth_othplc ///
					ancpast_oth_visit ///
					ancpast_cost ancpast_amount ancpast_cost_ta ancpast_cost_reg ancpast_cost_drug ancpast_cost_lab ancpast_cost_consult ancpast_cost_gift ancpast_cost_oth ancpast_borrow ///
					ancpast_conselling ///
					ancpast_no_important ancpast_no_distance ancpast_no_restrict ancpast_no_accompany ancpast_no_hf ancpast_no_staff ancpast_no_finance ancpast_no_oth ///
					ancpast_restrict ancpast_restrict_veg ancpast_restrict_fruit ancpast_restrict_grain ancpast_restrict_meat ancpast_restrict_fish ancpast_restrict_diary ancpast_restrict_oth ///
					ancpast_bone ///
					ancpast_rion ancpast_iron_consum ancpast_iron_cost ancpast_iron_amount ///
					ancpast_iron_hosp ancpast_iron_eho ancpast_iron_pdoc ancpast_iron_rhc ancpast_iron_vill ancpast_iron_oth ///
					ancpast_test_yes ancpast_test_no ancpast_test_hepb ancpast_test_hepc ancpast_test_hiv ancpast_test_std ancpast_test_oth ancpast_test_dk ///
					ancpast_test_hosp ancpast_test_eho ancpast_test_pdoc ancpast_test_rhc ancpast_test_vill ancpast_test_plcoth ///
					ancpast_test_cost


**-----------------------------------------------------**
** DELIVERY 
**-----------------------------------------------------**

// deliv_place 
destring deliv_place, replace
replace deliv_place = .m if ancpast_adopt == 1
tab deliv_place, m


local val 1 2 3 4 5 888
foreach x in `val' {
	gen deliv_place_`x' = (deliv_place == `x')
	replace deliv_place_`x' = .m if ancpast_adopt == 1
	order deliv_place_`x', before(deliv_gestmonth)
	tab deliv_place_`x', m
}

rename deliv_place_1 	deliv_place_home
rename deliv_place_2 	deliv_place_hosp
rename deliv_place_3 	deliv_place_pdoc
rename deliv_place_4 	deliv_place_rhc
rename deliv_place_5 	deliv_place_eho
rename deliv_place_888	deliv_place_placoth

// deliv_place_oth 

// deliv_gestmonth deliv_gestweek 
foreach var of varlist deliv_gestmonth deliv_gestweek {
	destring `var', replace
	replace `var' = .n if `var' == 444
	replace `var' = .d if `var' == 999
	replace `var' = .m if ancpast_adopt == 1
	tab `var', m
}

// deliv_place_why 
local place deliv_place_why1 deliv_place_why2 deliv_place_why3 deliv_place_why4 deliv_place_why5 deliv_place_why888 
foreach var in `place' {
	destring `var', replace
	replace `var' = .m if ancpast_adopt == 1
	tab `var', m
}

rename deliv_place_why1 	deliv_place_conve
rename deliv_place_why2 	deliv_place_trad
rename deliv_place_why3 	deliv_place_dist
rename deliv_place_why4 	deliv_place_safe
rename deliv_place_why5 	deliv_place_cost
rename deliv_place_why888	deliv_place_whyoth

// deliv_place_why_oth 

// deliv_assist 
destring deliv_assist, replace
replace deliv_assist = .d if deliv_assist == 999
replace deliv_assist = .m if ancpast_adopt == 1
tab deliv_assist, m

local val 1 2 3 4 5 6 7 8 9 888
foreach x in `val' {
	gen deliv_assist_`x' = (deliv_assist == `x')
	replace deliv_assist_`x' = .m if mi(deliv_assist)
	order deliv_assist_`x', before(deliv_method)
	tab deliv_assist_`x', m
}

rename deliv_assist_1 		deliv_assist_doc
rename deliv_assist_2 		deliv_assist_nurs
rename deliv_assist_3 		deliv_assist_lhv
rename deliv_assist_4 		deliv_assist_mw
rename deliv_assist_5 		deliv_assist_amw
rename deliv_assist_6 		deliv_assist_tba
rename deliv_assist_7 		deliv_assist_own
rename deliv_assist_8 		deliv_assist_hhmem
rename deliv_assist_9 		deliv_assist_eho
rename deliv_assist_888		deliv_assist_whooth

// deliv_assist_oth 

// deliv_method 
destring deliv_method, replace
replace deliv_method = .d if deliv_assist == 999
replace deliv_method = .m if ancpast_adopt == 1
tab deliv_method, m

local val 1 2 3 4
foreach x in `val' {
	gen deliv_method_`x' = (deliv_method == `x')
	replace deliv_method_`x' = .m if mi(deliv_method)
	order deliv_method_`x', before(deliv_cost)
	tab deliv_method_`x', m
}

rename deliv_method_1 deliv_how_normal
rename deliv_method_2 deliv_how_lscs
rename deliv_method_3 deliv_how_vacuun
rename deliv_method_4 deliv_how_forcep


// deliv_cost 
destring deliv_cost, replace
replace deliv_cost = .d if deliv_cost == 999
replace deliv_cost = .r if deliv_cost == 777
replace deliv_cost = .m if ancpast_adopt == 1
tab deliv_cost, m

// deliv_cost_amount 
destring deliv_cost_amount, replace
replace deliv_cost_amount = .d if deliv_cost_amount == 999
replace deliv_cost_amount = .r if deliv_cost_amount == 666
replace deliv_cost_amount = .n if deliv_cost_amount == 444
replace deliv_cost_amount = .m if deliv_cost != 1
tab deliv_cost_amount, m

// deliv_cost_loan  
destring deliv_cost_loan, replace
replace deliv_cost_loan = .d if deliv_cost_loan == 999
replace deliv_cost_loan = .m if deliv_cost != 1
tab deliv_cost_loan, m

*** reporting variable generation ***
local trained deliv_assist_doc deliv_assist_nurs deliv_assist_lhv deliv_assist_mw deliv_assist_eho
gen deliv_trained 		= 0
replace deliv_trained 	= .m if mi(deliv_assist)
foreach var in `trained' {
	replace deliv_trained = 1 if `var'  == 1
}
tab deliv_trained, m

local place deliv_place_hosp deliv_place_pdoc deliv_place_rhc deliv_place_eho
gen deliv_institute 		= 0
replace deliv_institute 	= .m if mi(deliv_place)
foreach var in `place' {
	replace deliv_institute = 1 if `var'  == 1
}
tab deliv_institute, m

order deliv_trained deliv_institute, before(pnc_yn)

** reporting variables **
lab var deliv_place_home 		"deliveried at home"
lab var deliv_place_hosp 		"deliveried at hospital"
lab var deliv_place_pdoc 		"deliveried at private doctor"
lab var deliv_place_rhc 		"deliveried at RHC or SRHC"
lab var deliv_place_eho 		"deliveried at EHO clinic"
lab var deliv_place_placoth 	"deliveried at other places"

lab var deliv_place_conve 		"deliveried because convenience"
lab var deliv_place_trad 		"deliveried because traditonal"
lab var deliv_place_dist 		"deliveried because close distance"
lab var deliv_place_safe 		"deliveried because safety for mother and baby"
lab var deliv_place_cost 		"deliveried because affordable cost"
lab var deliv_place_whyoth		"deliveried because other reasons"

lab var deliv_assist_doc 		"deliveried with doctor"
lab var deliv_assist_nurs 		"deliveried with nurse"
lab var deliv_assist_lhv 		"deliveried with LHV"
lab var deliv_assist_mw 		"deliveried with MW"
lab var deliv_assist_amw 		"deliveried with AMW"
lab var deliv_assist_tba 		"deliveried with TBA"
lab var deliv_assist_own 		"deliveried by herself" 
lab var deliv_assist_hhmem 		"deliveried with other family member"
lab var deliv_assist_eho 		"deliveried with EHO cadres"
lab var deliv_assist_whooth		"deliveried with other personnel"

lab var deliv_trained 			"deliveried with trained health personnel"
lab var deliv_institute			"institutional delivery - included EHO clinic"

lab var deliv_how_normal 		"normal delivery"
lab var deliv_how_lscs 			"cesarian section"
lab var deliv_how_vacuun 		"assisted delivery using vacuum"
lab var deliv_how_forcep		"assisted delivery using forceps"

lab var deliv_cost 				"delivery cost"
lab var deliv_cost_amount 		"delivery cost amount"
lab var deliv_cost_loan 		"delivery cost take loan"


global delivery		deliv_place_home deliv_place_hosp deliv_place_pdoc deliv_place_rhc deliv_place_eho deliv_place_placoth ///
					deliv_place_conve deliv_place_trad deliv_place_dist deliv_place_safe deliv_place_cost deliv_place_whyoth ///
					deliv_assist_doc deliv_assist_nurs deliv_assist_lhv deliv_assist_mw deliv_assist_amw deliv_assist_tba deliv_assist_own deliv_assist_hhmem deliv_assist_eho deliv_assist_whooth ///
					deliv_trained deliv_institute ///
					deliv_how_normal deliv_how_lscs deliv_how_vacuun deliv_how_forcep ///
					deliv_cost deliv_cost_amount deliv_cost_loan 

					
**-----------------------------------------------------**
** PNC 
**-----------------------------------------------------**
// pnc_yn
destring pnc_yn, replace
replace pnc_yn = .m if ancpast_adopt == 1
tab pnc_yn, m

// pnc_checktime 
destring pnc_checktime, replace
replace pnc_checktime = .d if pnc_checktime == 999
replace pnc_checktime = .n if pnc_checktime == 444
replace pnc_checktime = .m if pnc_yn != 1
replace pnc_checktime = .n if pnc_checktime == .
tab pnc_checktime, m

// pnc_checkunit 
destring pnc_checkunit, replace
replace pnc_checkunit = .m if mi(pnc_checktime)
tab pnc_checkunit, m

// pnc_who 
local who pnc_who1 pnc_who2 pnc_who3 pnc_who4 pnc_who5 pnc_who6 pnc_who7 pnc_who8 pnc_who777 pnc_who888 pnc_who999 
foreach var in `who' {
	destring `var', replace
	replace `var' = .m if pnc_yn != 1
	tab `var', m
}

rename pnc_who1 	pnc_doc
rename pnc_who2 	pnc_nurs
rename pnc_who3 	pnc_lhv
rename pnc_who4 	pnc_mw
rename pnc_who5 	pnc_amw
rename pnc_who6 	pnc_tba
rename pnc_who7 	pnc_relative
rename pnc_who8 	pnc_eho
rename pnc_who888	pnc_whooth
// pnc_who_oth 

local freq pnc_doc_freq pnc_nurs_freq pnc_lhv_freq pnc_mw_freq pnc_amw_freq pnc_tba_freq pnc_relative_freq pnc_eho_freq 
foreach var in `freq' {
	destring `var', replace
	replace `var' = .d if `var' == 999
	replace `var' = .n if `var' == 444
	replace `var' = .m if `var' != 1
	tab `var', m
}

// pnc_oth_freq 

// pnc_bone 
destring pnc_bone, replace
replace pnc_bone = .d if pnc_bone == 999
replace pnc_bone = .m if ancpast_adopt == 1
replace pnc_bone = .n if pnc_bone == .
tab pnc_bone, m

// pnc_bone_months pnc_bone_weeks 
local bone pnc_bone_months pnc_bone_weeks 
foreach var in `bone' {
	destring `var', replace
	replace `var' = .d if `var' == 999
	replace `var' = .n if `var' == 444
	replace `var' = .m if pnc_bone != 1
	tab `var', m
}

// pnc_cost 
destring pnc_cost, replace
replace pnc_cost = .d if pnc_cost == 999
replace pnc_cost = .n if pnc_cost == 777
replace pnc_cost = .m if pnc_yn != 1
tab pnc_cost, m

// pnc_cost_amount 
destring pnc_cost_amount, replace
replace pnc_cost_amount = .d if pnc_cost_amount == 999
replace pnc_cost_amount = .r if pnc_cost_amount == 777
replace pnc_cost_amount = .n if pnc_cost_amount == 444
replace pnc_cost_amount = .m if pnc_cost != 1
tab pnc_cost_amount, m

// pnc_cost_items 
local items pnc_cost_items1 pnc_cost_items2 pnc_cost_items3 pnc_cost_items4 pnc_cost_items5 pnc_cost_items6 pnc_cost_items888 
foreach var in `items' {
	destring `var', replace
	replace `var' = .m if ancpast_adopt == 1
	tab `var', m
}

rename pnc_cost_items1 		pnc_cost_ta
rename pnc_cost_items2 		pnc_cost_reg
rename pnc_cost_items3 		pnc_cost_drug
rename pnc_cost_items4 		pnc_cost_lab
rename pnc_cost_items5 		pnc_cost_consult
rename pnc_cost_items6 		pnc_cost_gift
rename pnc_cost_items888	pnc_cost_oth

// pnc_cost_loan 
destring pnc_cost_loan, replace
replace pnc_cost_loan = .d if pnc_cost_loan == 999
replace pnc_cost_loan = .r if pnc_cost_loan == 777
replace pnc_cost_loan = .m if ancpast_adopt == 1
replace pnc_cost_loan = .m if pnc_cost != 1
tab pnc_cost_loan, m

// pnc_cost_items_oth 

*** reporting variable generation ***
**Technical note**
**PNC: Provide every mother and baby a total of four postnatal visits on: 
**First day (24 hours), Day 3 (48 72 hours), 
**Between days 7 14 and 
**six weeks. */

**Postnatal Health Care Duration after Delivery**
**the definition provide six week maximum, going to drop all case
**over six week in this calculation. 6 weeks x 7 days= 42 days (6 weeks)


** 3MGDs indicator definition 
** who received atlest one PNC visit after delivery (first post natal check-up with skilled health personnel)
** regardless of delivery with whome (health care personnel)

gen pnc_starttime 		= 0
replace pnc_starttime 	= round(pnc_checktime/24, 0.1) if pnc_checkunit == 1
replace pnc_starttime 	= pnc_checktime if pnc_checkunit == 2
replace pnc_starttime 	= .m if mi(pnc_checktime) | mi(pnc_checkunit)
tab pnc_starttime, m

gen pnc_yes_6wks 		= (pnc_starttime <= 42)
replace pnc_yes_6wks 	= .m if mi(pnc_starttime)
tab pnc_yes_6wks, m

local who pnc_doc pnc_nurs pnc_lhv pnc_mw pnc_amw pnc_tba pnc_relative pnc_eho 
foreach var in `who' {
	gen `var'_rpt 		= `var'
	replace `var'_rpt 	= .m if pnc_starttime > 42
	order `var'_rpt, after(`var')
	tab `var'_rpt, m
	
	gen `var'_freq_rpt 		= `var'_freq
	replace `var'_freq_rpt 	= .m if pnc_starttime > 42	
	order `var'_freq_rpt, after(`var'_freq)
	tab `var'_freq_rpt, m
}


gen pnc_trained 		= 0
replace pnc_trained 	= .m if mi(pnc_yn)
local who pnc_doc pnc_nurs pnc_lhv pnc_mw pnc_eho
foreach var in `who' {
	replace pnc_trained = 1 if `var'_rpt == 1
}
tab pnc_trained, m

order pnc_starttime pnc_yes_6wks pnc_trained, before(nbc_yn)


local pnc pnc_cost pnc_cost_amount pnc_cost_ta pnc_cost_reg pnc_cost_drug pnc_cost_lab pnc_cost_consult pnc_cost_gift pnc_cost_oth pnc_cost_loan 
foreach var in `pnc' {
	gen `var'_rpt 		= `var'
	replace `var'_rpt 	= .m if pnc_starttime > 42
	order `var'_rpt, after(`var')
	tab `var'_rpt, m
}


** reporting variable **

lab var pnc_yn					"PNC reported yes"
lab var pnc_yes_6wks			"PNC within 6 weeks"
lab var pnc_doc_rpt				"PNC - Doctor"
lab var pnc_doc_freq_rpt 		"PNC visit - Doctor"
lab var pnc_nurs_rpt 			"PNC - Nurse"
lab var pnc_nurs_freq_rpt 		"PNC visit - Nurse"
lab var pnc_lhv_rpt 			"PNC - LHV"
lab var pnc_lhv_freq_rpt 		"PNC visit - LHV" 
lab var pnc_mw_rpt 				"PNC - Midwife"
lab var pnc_mw_freq_rpt 		"PNC visit - Midwife"
lab var pnc_amw_rpt 			"PNC - AMW"
lab var pnc_amw_freq_rpt 		"PNC visit - AMW"
lab var pnc_tba_rpt				"PNC - TBA"
lab var pnc_tba_freq_rpt 		"PNC visit - TBA" 
lab var pnc_relative_rpt 		"PNC - Relatives"
lab var pnc_relative_freq_rpt	"PNC visit - Relatives"
lab var pnc_eho_rpt 			"PNC - EHO cadres"
lab var pnc_eho_freq_rpt		"PNC visit - EHO cadres"

lab var pnc_trained				"PNC with trainned health personnel" 
lab var pnc_bone				"PNC - B1"
lab var pnc_cost_rpt 			"PNC cost"
lab var pnc_cost_amount_rpt 	"PNC cost amount"
lab var pnc_cost_ta_rpt 		"PNC cost - Transportation"
lab var pnc_cost_reg_rpt 		"PNC cost - Registration fees"
lab var pnc_cost_drug_rpt 		"PNC cost - Medicines"
lab var pnc_cost_lab_rpt		"PNC cost - Laboratory tests"
lab var pnc_cost_consult_rpt 	"PNC cost - Provider fees"
lab var pnc_cost_gift_rpt 		"PNC cost - Gifts"
lab var pnc_cost_oth_rpt 		"PNC cost - other"
lab var pnc_cost_loan_rpt		"PNC took loan"

global pnc 	pnc_yn pnc_yes_6wks ///
			pnc_doc_rpt pnc_nurs_rpt pnc_lhv_rpt pnc_mw_rpt pnc_amw_rpt pnc_tba_rpt pnc_relative_rpt pnc_eho_rpt ///
			pnc_doc_freq_rpt pnc_nurs_freq_rpt pnc_lhv_freq_rpt pnc_mw_freq_rpt pnc_amw_freq_rpt pnc_tba_freq_rpt pnc_relative_freq_rpt  pnc_eho_freq_rpt ///
			pnc_trained pnc_bone ///
			pnc_cost_rpt pnc_cost_amount_rpt ///
			pnc_cost_ta_rpt pnc_cost_reg_rpt pnc_cost_drug_rpt pnc_cost_lab_rpt pnc_cost_consult_rpt pnc_cost_gift_rpt pnc_cost_oth_rpt pnc_cost_loan_rpt


**-----------------------------------------------------**
** NBC 
**-----------------------------------------------------**

// nbc_yn 
destring nbc_yn, replace
replace nbc_yn = .d if nbc_yn == 999
replace nbc_yn = .m if ancpast_adopt == 1
tab nbc_yn, m

// nbc_2days_yn 
destring nbc_2days_yn, replace
replace nbc_2days_yn = .d if nbc_2days_yn == 999
replace nbc_2days_yn = .m if ancpast_adopt == 1
tab nbc_2days_yn, m

// nbc_who 
local who nbc_who1 nbc_who2 nbc_who3 nbc_who4 nbc_who5 nbc_who6 nbc_who7 nbc_who8 nbc_who777 nbc_who888 nbc_who999 
foreach var in `who' {
	destring `var', replace
	replace `var' = .m if ancpast_adopt == 1
	tab `var', m
}

rename nbc_who1 	nbc_doc
rename nbc_who2 	nbc_nurs
rename nbc_who3 	nbc_lhv
rename nbc_who4 	nbc_mw
rename nbc_who5 	nbc_amw
rename nbc_who6 	nbc_tba
rename nbc_who7 	nbc_relative
rename nbc_who8 	nbc_eho
rename nbc_who888 	nbc_whooth

// nbc_who_oth 
local freq nbc_doc_freq nbc_nurs_freq nbc_lhv_freq nbc_mw_freq nbc_amw_freq nbc_tba_freq nbc_relative_freq nbc_eho_freq 
foreach var in `freq' {
	destring `var', replace
	replace `var' = .d if `var' == 999
	replace `var' = .n if `var' == 444
	replace `var' = .m if `var' != 1
	tab `var', m
}

// nbc_oth_freq 

// nbc_cost 
destring nbc_cost, replace
replace nbc_cost = .d if nbc_cost == 999
replace nbc_cost = .n if nbc_cost == 777
replace nbc_cost = .m if nbc_yn != 1
tab nbc_cost, m

// nbc_cost_amount 
destring nbc_cost_amount, replace
replace nbc_cost_amount = .d if nbc_cost_amount == 999
replace nbc_cost_amount = .r if nbc_cost_amount == 777
replace nbc_cost_amount = .n if nbc_cost_amount == 444
replace nbc_cost_amount = .m if nbc_cost != 1
tab nbc_cost_amount, m 

// nbc_cost_items 
local items nbc_cost_items1 nbc_cost_items2 nbc_cost_items3 nbc_cost_items4 nbc_cost_items5 nbc_cost_items6 nbc_cost_items888 
foreach var in `items' {
	destring `var', replace
	replace `var' = .m if mi(nbc_cost_amount)
	tab `var', m
}

rename nbc_cost_items1 		nbc_cost_ta
rename nbc_cost_items2 		nbc_cost_reg
rename nbc_cost_items3 		nbc_cost_drug
rename nbc_cost_items4 		nbc_cost_lab
rename nbc_cost_items5 		nbc_cost_consult
rename nbc_cost_items6 		nbc_cost_gift
rename nbc_cost_items888	nbc_cost_oth

// nbc_cost_items_oth

// nbc_cost_loan 
destring nbc_cost_loan, replace
replace nbc_cost_loan = .d if nbc_cost_loan == 999
replace nbc_cost_loan = .r if nbc_cost_loan == 777
replace nbc_cost_loan = .m if ancpast_adopt == 1
replace nbc_cost_loan = .m if nbc_cost != 1
tab nbc_cost_loan, m

// nbc_colostrum 
destring nbc_colostrum, replace
replace nbc_colostrum = .d if nbc_colostrum == 999
replace nbc_colostrum = .m if ancpast_adopt == 1
tab nbc_colostrum, m

// nbc_dangersigns 
local signs nbc_dangersigns1 nbc_dangersigns2 nbc_dangersigns3 nbc_dangersigns4 nbc_dangersigns5 nbc_dangersigns6 nbc_dangersigns7 nbc_dangersigns888 nbc_dangersigns999 nbc_dangersigns666 

foreach var in `signs' {
	destring `var', replace
	replace `var' = .m if ancpast_adopt == 1
	tab `var', m
}

rename nbc_dangersigns1		nbc_danger_feed
rename nbc_dangersigns2 	nbc_danger_fit
rename nbc_dangersigns3 	nbc_danger_fever
rename nbc_dangersigns4 	nbc_danger_infect
rename nbc_dangersigns5 	nbc_danger_move
rename nbc_dangersigns6 	nbc_danger_breath
rename nbc_dangersigns7 	nbc_danger_skin
rename nbc_dangersigns888 	nbc_danger_oth

// nbc_dangersigns_oth

// nbc_cordcare 
local care nbc_cordcare1 nbc_cordcare2 nbc_cordcare3 nbc_cordcare4 nbc_cordcare5 nbc_cordcare888 nbc_cordcare999 nbc_cordcare666 
foreach var in `care' {
	destring `var', replace
	replace `var' = .m if ancpast_adopt == 1
	tab `var', m
}

rename nbc_cordcare1		nbc_cord_no 
rename nbc_cordcare2 		nbc_cord_betadin
rename nbc_cordcare3 		nbc_cord_spirits
rename nbc_cordcare4 		nbc_cord_turmeric
rename nbc_cordcare5 		nbc_cord_brick
rename nbc_cordcare888 		nbc_cord_oth

// nbc_cordcare_oth

// nbc_deliwound 
local wound nbc_deliwound1 nbc_deliwound2 nbc_deliwound3 nbc_deliwound4 nbc_deliwound5 nbc_deliwound888 nbc_deliwound999 nbc_deliwound666 
foreach var in `wound' {
	destring `var', replace
	replace `var' = .m if ancpast_adopt == 1
	tab `var', m
}

rename nbc_deliwound1		nbc_deliwound_no 
rename nbc_deliwound2 		nbc_deliwound_betadin
rename nbc_deliwound3 		nbc_deliwound_spirits
rename nbc_deliwound4 		nbc_deliwound_turmeric
rename nbc_deliwound5 		nbc_deliwound_brick
rename nbc_deliwound888 	nbc_deliwound_careoth

// nbc_deliwound_oth

*** reporting variable generating ***

gen nbc_2days_trained 		= 0
replace nbc_2days_trained 	= .m if mi(nbc_2days_yn)
local who nbc_doc nbc_nurs nbc_lhv nbc_mw nbc_eho
foreach var in `who' {
	replace nbc_2days_trained = 1 if `var' == 1
}
tab nbc_2days_trained, m

order nbc_2days_trained, after(nbc_2days_yn) 

** reporting variable **

lab var nbc_yn				"NBC - within 24 hours"
lab var nbc_2days_yn		"NBC - within 48 hours"

lab var nbc_doc				"NBC - Doctor"
lab var nbc_doc_freq 		"NBC visit - Doctor"
lab var nbc_nurs 			"NBC - Nurse"
lab var nbc_nurs_freq 		"NBC visit - Nurse"
lab var nbc_lhv 			"NBC - LHV"
lab var nbc_lhv_freq 		"NBC visit - LHV" 
lab var nbc_mw 				"NBC - Midwife"
lab var nbc_mw_freq 		"NBC visit - Midwife"
lab var nbc_amw 			"NBC - AMW"
lab var nbc_amw_freq 		"NBC visit - AMW"
lab var nbc_tba				"NBC - TBA"
lab var nbc_tba_freq 		"NBC visit - TBA" 
lab var nbc_relative 		"NBC - Relatives"
lab var nbc_relative_freq	"NBC visit - Relatives"
lab var nbc_eho 			"NBC - EHO cadres"
lab var nbc_eho_freq		"NBC visit - EHO cadres"

lab var nbc_2days_trained	"NBC with trainned health personnel" 
lab var nbc_cost 			"NBC cost"
lab var nbc_cost_amount 	"NBC cost amount"
lab var nbc_cost_ta 		"NBC cost - Transportation"
lab var nbc_cost_reg 		"NBC cost - Registration fees"
lab var nbc_cost_drug 		"NBC cost - Medicines"
lab var nbc_cost_lab		"NBC cost - Laboratory tests"
lab var nbc_cost_consult 	"NBC cost - Provider fees"
lab var nbc_cost_gift 		"NBC cost - Gifts"
lab var nbc_cost_oth 		"NBC cost - other"
lab var nbc_cost_loan		"NBC took loan"
        
lab var nbc_danger_feed		"Feeding less or not feeding at all"
lab var nbc_danger_fit		"Convulsion"
lab var nbc_danger_fever	"High or very low temperature"
lab var nbc_danger_infect	"Local infection"
lab var nbc_danger_move 	"No movement or less movement"
lab var nbc_danger_breath 	"Fast or difficulty in breathing"
lab var nbc_danger_skin 	"Yellow skin"
lab var nbc_danger_oth		"other"

lab var nbc_cord_no			"Nothing"
lab var nbc_cord_betadin	"Betadine"
lab var nbc_cord_spirits	"Spirits"
lab var nbc_cord_turmeric	"Turmeric's powder"
lab var nbc_cord_brick		"Bricks' powder"
lab var nbc_cord_oth		"other"

lab var nbc_deliwound_no		"Nothing"
lab var nbc_deliwound_betadin 	"Betadine"
lab var nbc_deliwound_spirits	"Spirits"
lab var nbc_deliwound_turmeric	"Turmeric's powder"
lab var nbc_deliwound_brick 	"Bricks' powder"
lab var nbc_deliwound_careoth	"other"

global nbc		nbc_yn nbc_2days_yn ///
				nbc_doc nbc_nurs nbc_lhv nbc_mw nbc_amw nbc_tba nbc_relative nbc_eho ///
				nbc_doc_freq nbc_nurs_freq nbc_lhv_freq nbc_mw_freq nbc_amw_freq nbc_tba_freq nbc_relative_freq nbc_eho_freq ///
				nbc_2days_trained ///
				nbc_cost nbc_cost_amount nbc_cost_ta nbc_cost_reg nbc_cost_drug nbc_cost_lab nbc_cost_consult nbc_cost_gift nbc_cost_oth ///
				nbc_cost_loan ///
				nbc_danger_feed nbc_danger_fit nbc_danger_fever nbc_danger_infect nbc_danger_move nbc_danger_breath nbc_danger_skin nbc_danger_oth ///
				nbc_cord_no nbc_cord_betadin nbc_cord_spirits nbc_cord_turmeric nbc_cord_brick nbc_cord_oth ///
				nbc_deliwound_no nbc_deliwound_betadin nbc_deliwound_spirits nbc_deliwound_turmeric nbc_deliwound_brick nbc_deliwound_careoth


save "$cdta/mom_health_cleanded.dta", replace

