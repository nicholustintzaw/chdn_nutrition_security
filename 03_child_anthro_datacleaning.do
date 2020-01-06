/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROJECT:		CPI - CHDN Nutrition Security Report

PURPOSE: 		Child Anthro Data Cleaning

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:
   

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

*------------------------------------------------------------------------------*
***  DATA CLEANING  ***
*------------------------------------------------------------------------------*

**  use child non anthro dataset  **
use "$dta/child_anthro_combined.dta", clear




** CHILD AGE CALCULATION **
* Child age calculation in months 
*tab starttime, m

split starttime, p("T")

gen start_date = date(starttime1, "YMD")
format start_date %td
lab var start_date "Survey Date"
order start_date, after(starttime)
drop starttime1 starttime2

gen child_dob = date(hh_mem_dob, "DMY")
format child_dob %td
lab var child_dob "Child Date of Birth"
order child_dob, after(hh_mem_dob)

destring hh_mem_certification hh_mem_age_month, replace

gen child_age = hh_mem_age_month

gen child_age_dob = round((start_date - child_dob)/30.44,0.1)
tab child_age_dob

gen cage_check = round(child_age - child_age_dob,0.1)
list child_age child_age_dob if cage_check != 0 & !mi(cage_check)

*br starttime start_date child_dob cage_check child_age_dob child_age child_dobsrc if cage_check<=-1 | cage_check>=1

* Construct Valid Child Age (months)
* (replace with mom reponse on child age months in case of poor validity reference doc)
gen child_valid_age     = child_age
replace child_valid_age = child_age_dob if hh_mem_certification == 1 | hh_mem_certification == 2 //birth certificate or health card
lab var child_valid_age "Child age in months - valid"
tab child_valid_age

drop child_age_dob cage_check

* Child Age Group Construction 
foreach var of varlist child_valid_age {

		* 1) 0 to 5 months
		gen child_agegroup_1 = (`var'<6) if !missing(`var')
		lab var child_agegroup_1	"Child aged 0 to 5 months"
		rename child_agegroup_1 	child_age_05
		
		* 2) 6 to 8 months
		gen child_agegroup_2 = (`var'>=6 & `var'<9) if !missing(`var')
		lab var child_agegroup_2	"Child aged 6 to 8 months"
		rename child_agegroup_2 	child_age_68
			
		* 3) 6 to 9 months
		gen child_agegroup_3 = (`var'>=6 & `var'<10) if !missing(`var')
		lab var child_agegroup_3	"Child aged 6 to 9 months"
		rename child_agegroup_3 	child_age_69
	
		* 4) 6 to 11 months
		gen child_agegroup_4 = (`var'>=6 & `var'<12) if !missing(`var')
		lab var child_agegroup_4	"Child aged 6 to 11 months"
		rename child_agegroup_4 	child_age_611

		* 5) 6 to 23 months
		gen child_agegroup_5 = (`var'>=6 & `var'<24) if !missing(`var')
		lab var child_agegroup_5	"Child aged 6 to 23 months"
		rename child_agegroup_5 	child_age_623

		* 6) 9 to 23 months
		gen child_agegroup_6 = (`var'>=9 & `var'<24) if !missing(`var')
		lab var child_agegroup_6	"Child aged 9 to 23 months"
		rename child_agegroup_6 	child_age_923

		* 7) 12 to 15 months
		gen child_agegroup_7 = (`var'>=12 & `var'<16) if !missing(`var')
		lab var child_agegroup_7	"Child aged 12 to 15 months"
		rename child_agegroup_7 	child_age_1215

		* 8) 12 to 17 months
		gen child_agegroup_8 = (`var'>=12 & `var'<18) if !missing(`var')
		lab var child_agegroup_8	"Child aged 12 to 17 months"
		rename child_agegroup_8 	child_age_1217

		* 9) 18 to 23 months
		gen child_agegroup_9 = (`var'>=18 & `var'<24) if !missing(`var')
		lab var child_agegroup_9	"Child aged 18 to 23 months"
		rename child_agegroup_9 	child_age_1823

		* 10) 20 to 23 months
		gen child_agegroup_10 = (`var'>=20 & `var'<24) if !missing(`var')
		lab var child_agegroup_10	"Child aged 20 to 23 months"
		rename child_agegroup_10 	child_age_2023
		
		* 11) 12 to 23 months (SCI)
		gen child_agegroup_11 = (`var'>=12 & `var'<24) if !missing(`var')
		lab var child_agegroup_11	"Child aged 12 to 23 months"
		rename child_agegroup_11	child_age_1223
		
		* 12) 24 to 29 months (current age of children addressed by intervention)
		gen child_agegroup_12 = (`var'>=24 & `var'<29) if !missing(`var')
		lab var child_agegroup_12	"Child aged 24 to 29 months"
		rename child_agegroup_12	child_age_2429
		
		* 13) 24 to 36 months (larger group of children addressed by intervention)
		gen child_agegroup_13 = (`var'>=24 & `var'<36) if !missing(`var')
		lab var child_agegroup_13	"Child aged 24 to 36 months"
		rename child_agegroup_13	child_age_2436
		
		* 14) 24 to 59 months
		gen child_agegroup_15 = (`var'>=24 & `var'<60) if !missing(`var')
		lab var child_agegroup_15	"Child aged 24 to 59 months"
		rename child_agegroup_15	child_age_2459

}

order child_age_* , after(child_age)

********************************************************************************
********************************************************************************

*** ANTHRO DATA PREPARATION ***
local anthro cmuacinit cmuacinit2 cmuacinit3 cweightinit cweightinit2 cweightinit3 cheightinit cheightinit2 cheightinit3 //lenheightinit lenheightinit2 lenheightinit3

foreach var in `anthro' {
	destring `var', replace
	replace `var' = .r if `var' == 0
	replace `var' = .m if mi(`var')
	tab `var', m
}

destring csex lenheightinit, replace

drop if child_valid_age < 6 
drop if child_valid_age >=60

/*
0	Length
1	Height

csex
cmuacinit 
cweightinit 
cheightinit 
lenheightinit 
*/

// drop unnecessary variable
drop oedemaconfirm-samrefconfirm

gen child_sex = csex

*------------------------------------------------------------------------------*
* CHILD ANTHROPOMETRICS                           *
*------------------------------------------------------------------------------*

*-------------------------------------------------------------------------------
* MUAC AVAILABILITY
*-------------------------------------------------------------------------------
tab cmuacinit, m
gen cmuac_case 		= (!mi(cmuacinit)) 
lab val cmuac_case yesno
tab cmuac_case, m

*-------------------------------------------------------------------------------
* 6.5. WEIGHT AVAILABILITY
*-------------------------------------------------------------------------------
tab cweightinit, m
gen cwt_case		=	(!mi(cweightinit))
lab val cwt_case yesno
tab cwt_case, m

*-------------------------------------------------------------------------------
* 6.6. HEIGHT AVAILABILITY
*-------------------------------------------------------------------------------
tab cheightinit, m
gen cht_case		=	(!mi(cheightinit))
lab val cht_case yesno
tab cht_case, m

*-------------------------------------------------------------------------------
* 6.7. Z-SCORE CALCULATION
*-------------------------------------------------------------------------------
zscore06,	a(child_valid_age) ///
			s(csex) ///
			h(cheightinit) ///
			w(cweightinit) ///
			female(0) male(1) ///
			measure(lenheightinit) recum(0) stand(1)

/*
WHO anthro Z score Standard Guideline for Flag data
WHZ <-5 | > +5
HAZ <-6 | > +6
WAZ <-6 | > +5
BAZ <-5 | > +5 (BMI-for-age z-score)
*/ 
 

** removed flag z score 
replace haz06 = .n if haz06 <-6 | haz06 > 6
replace waz06 = .n if waz06	<-6 | waz06 > 5
replace whz06 = .n if whz06	<-5 | whz06 > 5

*BMI
drop bmiz06

*-------------------------------------------------------------------------------
* 6.8. STUNTING VAR CONSTRUCTION: HAZ
*-------------------------------------------------------------------------------
replace haz06 = .m if cht_case != 1 
replace haz06 = .n if haz06 == 99
tab haz06, m

gen haz_case		= (!mi(haz06))
lab val haz_case yesno
tab haz_case

*-------------------------------------------------------------------------------
* 6.9. WASTING VAR CONSTRUCTION: WHZ
*-------------------------------------------------------------------------------
replace whz06 = .m if cwt_case != 1 | cht_case != 1 
replace whz06 = .n if whz06 == 99
tab whz06, m

gen whz_case		= (!mi(whz06))
lab val whz_case yesno
tab whz_case

*-------------------------------------------------------------------------------
* 6.10. UNDER WEIGHT VAR CONSTRUCTION: WAZ
*-------------------------------------------------------------------------------
replace waz06 = .m if cwt_case != 1 
replace waz06 = .n if waz06 == 99 
tab waz06, m

gen waz_case		=	(!mi(waz06))
lab val waz_case yesno
tab waz_case

*-------------------------------------------------------------------------------
* 6.11. WASTING - GAM: GLOBAL ACUTE MALNUTRITION 
*-------------------------------------------------------------------------------
* ~~~
* Indicator definition:
* Global Acute Malnutrition WAZ: <-2 z score
* moderate acute malnutrition WHZ: <-2 and >=-3 z score
* severe acute malnutrition WHZ: <-3 z score
* ~~~

sum whz06

gen gam		=	(whz06 < -2) 				// global acute malnutrition
replace gam	=	.m if mi(whz06)
lab val gam yesno
tab gam, m

gen sam		=	(whz06 < -3) 				//sever acute malnutrition 
replace sam	=	.m if mi(whz06)
lab val sam yesno
tab sam, m
 
gen mam		=	(whz06 < -2 & whz06 >= -3) // moderate acute malnturition
replace mam	=	.m if mi(whz06)
lab val mam yesno 
tab mam, m

* Wasting disaggregated by age group and gender
local age 05 611 1223 623 2459

foreach var of varlist whz06 haz06 waz06 {
forvalue x = 0/1 {
	gen `var'_`x' = `var' if child_sex == `x' 
	replace `var'_`x' = .m if child_sex != `x' | mi(`var')

	}
}

rename *06_0 *06_female
rename *06_1 *06_male

foreach var of varlist whz06 haz06 waz06 {
foreach y in `age' {
	
		gen `var'_`y' = `var' if child_age_`y' == 1
		replace `var'_`y' = .m if child_age_`y' == 0 | mi(`var')
	
		gen `var'_`y'_male = `var' if child_sex == 1 & child_age_`y' == 1 
		replace `var'_`y'_male = .m if child_sex != 1 | child_age_`y' == 0 | mi(`var')
		gen `var'_`y'_female = `var' if child_sex == 0 & child_age_`y' == 1 
		replace `var'_`y'_female = .m if child_sex != 0 | child_age_`y' == 0 | mi(`var')
}
}



foreach var of varlist gam sam mam {
forvalue x = 0/1 {

	gen `var'_`x' = (child_sex == `x' & `var' == 1)
	replace `var'_`x' = .m if child_sex != `x' | mi(`var')
}
}

rename *m_0 *m_female
rename *m_1 *m_male

foreach var of varlist gam sam mam {
foreach y in `age' {
	
		gen `var'_`y' = (child_age_`y' == 1 & `var' == 1)
		replace `var'_`y' = .m if child_age_`y' == 0 | mi(`var')
	
		gen `var'_`y'_male = (child_sex == 1 & child_age_`y' == 1 & `var' == 1)
		replace `var'_`y'_male = .m if child_sex != 1 | child_age_`y' == 0 | mi(`var')
		gen `var'_`y'_female = (child_sex == 0 & child_age_`y' == 1 & `var' == 1)
		replace `var'_`y'_female = .m if child_sex != 0 | child_age_`y' == 0 | mi(`var')
}
}


*-------------------------------------------------------------------------------
* 6.12. STUNTING
*-------------------------------------------------------------------------------
* ~~~
* Indicator definition: 
* Height for Age HAZ: <-2 z score
* moderate stunting HAZ: <-2 and >=-3 z score
* severe stunting HAZ: <-3 z score
* ~~~
sum haz06 

gen stunt		=	(haz06 < -2)
replace stunt	=	. if mi(haz06)
lab val stunt yesno
tab stunt, m

gen sev_stunt		=	(haz06 < -3)
replace sev_stunt	=	. if mi(haz06)
lab val sev_stunt yesno
tab sev_stunt, m

gen mod_stunt		=	(haz06 < -2 & haz06 >= -3) 
replace mod_stunt	=	. if mi(haz06)
lab val mod_stunt yesno
tab mod_stunt, m


* Stunting disaggregated by age group and gender
foreach var of varlist stunt sev_stunt mod_stunt {
forvalue x = 0/1 {

	gen `var'_`x' = (child_sex == `x' & `var' == 1)
	replace `var'_`x' = .m if child_sex != `x' | mi(`var')
}
}

rename *tunt_0 *tunt_female
rename *tunt_1 *tunt_male

local age 05 611 1223 623 2459
foreach var of varlist stunt sev_stunt mod_stunt {
foreach y in `age' {
	
		gen `var'_`y' = (child_age_`y' == 1 & `var' == 1)
		replace `var'_`y' = .m if child_age_`y' == 0 | mi(`var')
	
		gen `var'_`y'_male = (child_sex == 1 & child_age_`y' == 1 & `var' == 1)
		replace `var'_`y'_male = .m if child_sex != 1 | child_age_`y' == 0 | mi(`var')
		gen `var'_`y'_female = (child_sex == 0 & child_age_`y' == 1 & `var' == 1)
		replace `var'_`y'_female = .m if child_sex != 0 | child_age_`y' == 0 | mi(`var')	
}
}

*-------------------------------------------------------------------------------
* 6.13. UNDERWEIGHT 
*-------------------------------------------------------------------------------
* ~~~
* Indicator definition:
* Weight for age WAZ: <-2 zscore
* modeate underweight WAZ: <-2 and >=-3 z score
* severe underweight WAZ: <-3 z score
* ~~~
sum waz06 

gen under_wt		=	(waz06 < -2)
replace under_wt	=	. if mi(waz06)
lab val under_wt yesno
tab under_wt, m

gen sev_under_wt		=	(waz06 < -3) 
replace sev_under_wt	=	. if mi(waz06)
lab val sev_under_wt yesno
tab sev_under_wt, m

gen mod_under_wt		=	(waz06 < -2 & waz06 >= -3) 
replace mod_under_wt	=	. if mi(waz06)
lab val mod_under_wt yesno
tab mod_under_wt, m

* Underweight disaggregated by age group and gender
foreach var of varlist under_wt sev_under_wt mod_under_wt {
forvalue x = 0/1 {

	gen `var'_`x' = (child_sex == `x' & `var' == 1)
	replace `var'_`x' = .m if child_sex != `x' | mi(`var')
}
}

rename *nder_wt_0 *nder_wt_female
rename *nder_wt_1 *nder_wt_male

local age 05 611 1223 623 2459
foreach var of varlist under_wt sev_under_wt mod_under_wt {
foreach y in `age' {
	
		gen `var'_`y' = (child_age_`y' == 1 & `var' == 1)
		replace `var'_`y' = .m if child_age_`y' == 0 | mi(`var')
	
		gen `var'_`y'_male = (child_sex == 1 & child_age_`y' == 1 & `var' == 1)
		replace `var'_`y'_male = .m if child_sex != 1 | child_age_`y' == 0 | mi(`var')
		gen `var'_`y'_female = (child_sex == 0 & child_age_`y' == 1 & `var' == 1)
		replace `var'_`y'_female = .m if child_sex != 0 | child_age_`y' == 0 | mi(`var')	
}
}

*-------------------------------------------------------------------------------
* 6.14. ACUTE MALNUTRITION BY MUAC
*-------------------------------------------------------------------------------
* ~~~
* Indicator definition:
* wasting by muac: <125 mm
* moderate wasting by muac: <125 mm and >=115 mm
* severe wasting by muac: <115 mm
* ~~~
gen cmuacinit_mm = cmuacinit * 10
replace cmuacinit_mm = .m if mi(cmuacinit)
tab cmuacinit_mm, m

gen gam_muac		=	(cmuacinit_mm < 125)
replace gam_muac	=	. if mi(cmuacinit)
lab val gam_muac yesno
tab gam_muac, m

gen sam_muac		=	(cmuacinit_mm < 115)
replace sam_muac	=	. if mi(cmuacinit)
lab val sam_muac yesno
tab sam_muac, m

gen mam_muac		=	(cmuacinit_mm >= 115 & cmuacinit_mm < 125)
replace mam_muac	=	. if mi(cmuacinit)
lab val mam_muac yesno
tab mam_muac, m

* SELECTED VARS FOR REPORT
lab var cwt_case 			"Weight data available cases"
lab var cht_case 			"Height data available cases"
lab var haz_case 			"HAZ score available case"

lab var haz06 				"HAZ score (WHO)"
lab var stunt 				"Stunted"
lab var sev_stunt 			"Severly Stunted"
lab var mod_stunt 			"Moderate Sunted"

lab var haz06_male 			"HAZ score (WHO) - male"
lab var haz06_female 		"HAZ score (WHO) - female"
lab var haz06_05 			"HAZ score (WHO) - 0 to 5 months"
lab var haz06_611 			"HAZ score (WHO) - 6 to 11 months"
lab var haz06_1223 			"HAZ score (WHO) - 12 to 23 months"
lab var haz06_2459 			"HAZ score (WHO) - 24 to 59 months"
lab var haz06_05_male 		"HAZ score (WHO) - 0 to 5 months male"
lab var haz06_611_male 		"HAZ score (WHO) - 6 to 11 months male"
lab var haz06_1223_male 	"HAZ score (WHO) - 12 to 23 months male"
lab var haz06_2459_male 	"HAZ score (WHO) - 24 to 59 months male"
lab var haz06_05_female 	"HAZ score (WHO) - 0 to 5 months female"
lab var haz06_611_female 	"HAZ score (WHO) - 6 to 11 months female"
lab var haz06_1223_female 	"HAZ score (WHO) - 12 to 23 months female"
lab var haz06_2459_female 	"HAZ score (WHO) - 24 to 59 months female"

lab var stunt_05 			"Stunted - 0 to 5 months"
lab var sev_stunt_05 		"Severly Stunted - 0 to 5 months"
lab var mod_stunt_05 		"Moderate Sunted - 0 to 5 months"
lab var stunt_611 			"Stunted - 6 to 11 months"
lab var sev_stunt_611 		"Severly Stunted - 6 to 11 months"
lab var mod_stunt_611 		"Moderate Sunted - 6 to 11 months"
lab var stunt_1223 			"Stunted - 12 to 23 months"
lab var sev_stunt_1223 		"Severly Stunted - 12 to 23 months"
lab var mod_stunt_1223 		"Moderate Sunted - 12 to 23 months"
lab var stunt_2459 			"Stunted - 24 to 59 months"
lab var sev_stunt_2459		"Severly Stunted - 24 to 59 months"
lab var mod_stunt_2459 		"Moderate Sunted - 24 to 59 months"

lab var stunt_male 			"Stunted - male"
lab var sev_stunt_male 		"Severly Stunted - male"
lab var mod_stunt_male 		"Moderate Sunted - male"
lab var stunt_female 		"Stunted - female"
lab var sev_stunt_female 	"Severly Stunted - female"
lab var mod_stunt_female 	"Moderate Sunted - female"

lab var stunt_05_male 			"Stunted - 0 to 5 months male"
lab var sev_stunt_05_male 		"Severly Children - 0 to 5 months male"
lab var mod_stunt_05_male 		"Moderate Sunted - 0 to 5 months male"
lab var stunt_05_female 		"Stunted - 0 to 5 months female"
lab var sev_stunt_05_female 	"Severly Stunted - 0 to 5 months female"
lab var mod_stunt_05_female 	"Moderate Sunted - 0 to 5 months female"

lab var stunt_611_male 			"Stunted - 6 to 11 months male"
lab var sev_stunt_611_male 		"Severly Stunted - 6 to 11 months male"
lab var mod_stunt_611_male 		"Moderate Sunted - 6 to 11 months male"
lab var stunt_611_female 		"Stunted - 6 to 11 months female"
lab var sev_stunt_611_female 	"Severly Stunted - 6 to 11 months female"
lab var mod_stunt_611_female 	"Moderate Sunted - 6 to 11 months female"

lab var stunt_1223_male 		"Stunted - 12 to 23 months male"
lab var sev_stunt_1223_male 	"Severly Stunted - 12 to 23 months male"
lab var mod_stunt_1223_male 	"Moderate Sunted - 12 to 23 months male"
lab var stunt_1223_female 		"Stunted - 12 to 23 months female"
lab var sev_stunt_1223_female 	"Severly Stunted - 12 to 23 months female"
lab var mod_stunt_1223_female 	"Moderate Sunted - 12 to 23 months female"

lab var stunt_2459_male 		"Stunted - 24 to 59 months male"
lab var sev_stunt_2459_male 	"Severly Stunted - 24 to 59 months male"
lab var mod_stunt_2459_male 	"Moderate Sunted - 24 to 59 months male"
lab var stunt_2459_female 		"Stunted - 24 to 59 months female"
lab var sev_stunt_2459_female 	"Severly Stunted - 24 to 59 months female"
lab var mod_stunt_2459_female 	"Moderate Sunted - 24 to 59 months female"

lab var whz_case 				"WHZ score available case (WHO)"
lab var whz06 					"WHZ score (WHO)"
lab var gam 					"Global Acute Malnutrition"
lab var sam 					"Severe Acute Malnutrition"
lab var mam 					"Moderate Acute Malnutrition"

lab var whz06_male 				"WHZ score (WHO) - male"
lab var whz06_female 			"WHZ score (WHO) - female"
lab var whz06_05 				"WHZ score (WHO) - 0 to 5 months"
lab var whz06_611 				"WHZ score (WHO) - 6 to 11 months"
lab var whz06_1223 				"WHZ score (WHO) - 12 to 23 months"
lab var whz06_2459 				"WHZ score (WHO) - 24 to 59 months"
lab var whz06_05_male 			"WHZ score (WHO) - 0 to 5 months male"
lab var whz06_611_male 			"WHZ score (WHO) - 6 to 11 months male"
lab var whz06_1223_male 		"WHZ score (WHO) - 12 to 23 months male"
lab var whz06_2459_male 		"WHZ score (WHO) - 24 to 59 months male"
lab var whz06_05_female 		"WHZ score (WHO) - 0 to 5 months female"
lab var whz06_611_female 		"WHZ score (WHO) - 6 to 11 months female"
lab var whz06_1223_female 		"WHZ score (WHO) - 12 to 23 months female"
lab var whz06_2459_female 		"WHZ score (WHO) - 24 to 59 months female"

lab var gam_male 				"GAM - male"
lab var sam_male 				"SAM - male"
lab var mam_male 				"MAM - male"
lab var gam_female 				"GAM - female"
lab var sam_female 				"SAM - female"
lab var mam_female 				"MAM - female"

lab var gam_05 					"GAM - 0 to 5 months"
lab var sam_05 					"SAM - 0 to 5 months"
lab var mam_05 					"MAM - 0 to 5 months"
lab var gam_611 				"GAM - 6 to 11 months"
lab var sam_611 				"SAM - 6 to 11 months"
lab var mam_611 				"MAM - 6 to 11 months"
lab var gam_1223 				"GAM - 12 to 23 months"
lab var sam_1223 				"SAM - 12 to 23 months"
lab var mam_1223 				"MAM - 12 to 23 months"
lab var gam_2459 				"GAM - 24 to 59 months"
lab var sam_2459 				"SAM - 24 to 59 months"
lab var mam_2459 				"MAM - 24 to 59 months"

lab var gam_05_male 			"GAM - 0 to 5 months male"
lab var sam_05_male 			"SAM - 0 to 5 months male"
lab var mam_05_male 			"MAM - 0 to 5 months male"
lab var gam_611_male 			"GAM - 6 to 11 months male"
lab var sam_611_male 			"SAM - 6 to 11 months male"
lab var mam_611_male 			"MAM - 6 to 11 months male"
lab var gam_1223_male 			"GAM - 12 to 23 months male"
lab var sam_1223_male 			"SAM - 12 to 23 months male"
lab var mam_1223_male 			"MAM - 12 to 23 months male"
lab var gam_2459_male 			"GAM - 24 to 59 months male"
lab var sam_2459_male 			"SAM - 24 to 59 months male"
lab var mam_2459_male 			"MAM - 24 to 59 months male"

lab var gam_05_female 			"GAM - 0 to 5 months female"
lab var sam_05_female 			"SAM - 0 to 5 months female"
lab var mam_05_female 			"MAM - 0 to 5 months female"
lab var gam_611_female 			"GAM - 6 to 11 months female"
lab var sam_611_female 			"SAM - 6 to 11 months female"
lab var mam_611_female 			"MAM - 6 to 11 months female"
lab var gam_1223_female 		"GAM - 12 to 23 months female"
lab var sam_1223_female 		"SAM - 12 to 23 months female"
lab var mam_1223_female 		"MAM - 12 to 23 months female"
lab var gam_2459_female 		"GAM - 24 to 59 months female"
lab var sam_2459_female 		"SAM - 24 to 59 months female"
lab var mam_2459_female 		"MAM - 24 to 59 months female"

lab var waz_case 				"WAZ score available case (WHO)"
lab var waz06 					"WAZ score (WHO)"
lab var under_wt 				"Under weight children"
lab var sev_under_wt 			"Severly Under Weight "
lab var mod_under_wt 			"Moderately Under Weight"

lab var waz06_male 				"WAZ score (WHO) - male"
lab var waz06_female 			"WAZ score (WHO) - female"
lab var waz06_05 				"WAZ score (WHO) - 0 to 5 months"
lab var waz06_611 				"WAZ score (WHO) - 6 to 11 months"
lab var waz06_1223 				"WAZ score (WHO) - 12 to 23 months"
lab var waz06_2459 				"WAZ score (WHO) - 24 to 59 months"
lab var waz06_05_male 			"WAZ score (WHO) - 0 to 5 months male"
lab var waz06_611_male 			"WAZ score (WHO) - 6 to 11 months male"
lab var waz06_1223_male 		"WAZ score (WHO) - 12 to 23 months male"
lab var waz06_2459_male 		"WAZ score (WHO) - 24 to 59 months male"
lab var waz06_05_female 		"WAZ score (WHO) - 0 to 5 months female"
lab var waz06_611_female 		"WAZ score (WHO) - 6 to 11 months female"
lab var waz06_1223_female 		"WAZ score (WHO) - 12 to 23 months female"
lab var waz06_2459_female 		"WAZ score (WHO) - 24 to 59 months female"

lab var under_wt_male 			"Underweight - male"
lab var sev_under_wt_male 		"Severly Underweight - male"
lab var mod_under_wt_male 		"Moderately Underweight - male"
lab var under_wt_female 		"Underweight - female"
lab var sev_under_wt_female 	"Severly Underweight - female"
lab var mod_under_wt_female 	"Moderately Underweight - female"

lab var under_wt_05 			"Underweight - 0 to 5 months"
lab var sev_under_wt_05 		"Severly Underweight - 0 to 5 months"
lab var mod_under_wt_05 		"Moderately Underweight - 0 to 5 months"
lab var under_wt_611 			"Underweight - 6 to 11 months"
lab var sev_under_wt_611 		"Severly Underweight - 6 to 11 months"
lab var mod_under_wt_611 		"Moderately Underweight - 6 to 11 months"
lab var under_wt_1223 			"Underweight - 12 to 23 months"
lab var sev_under_wt_1223 		"Severly Underweight - 12 to 23 months"
lab var mod_under_wt_1223 		"Moderately Underweight - 12 to 23 months"
lab var under_wt_2459 			"Underweight - 24 to 59 months"
lab var sev_under_wt_2459 		"Severly Underweight - 24 to 59 months"
lab var mod_under_wt_2459 		"Moderately Underweight - 24 to 59 months"

lab var under_wt_05_male 		"Underweight - 0 to 5 months male"
lab var sev_under_wt_05_male 	"Severly Underweight - 0 to 5 months male"
lab var mod_under_wt_05_male 	"Moderately Underweight - 0 to 5 months male"
lab var under_wt_611_male 		"Underweight - 6 to 11 months male"
lab var sev_under_wt_611_male 	"Severly Underweight - 6 to 11 months male"
lab var mod_under_wt_611_male 	"Moderately Underweight - 6 to 11 months male"
lab var under_wt_1223_male 		"Underweight - 12 to 23 months male"
lab var sev_under_wt_1223_male 	"Severly Underweight - 12 to 23 months male"
lab var mod_under_wt_1223_male 	"Moderately Underweight - 12 to 23 months male"
lab var under_wt_2459_male 		"Underweight - 24 to 59 months male"
lab var sev_under_wt_2459_male 	"Severly Underweight - 24 to 59 months male"
lab var mod_under_wt_2459_male 	"Moderately Underweight - 24 to 59 months male"

lab var under_wt_05_female 			"Underweight - 0 to 5 months female"
lab var sev_under_wt_05_female 		"Severly Underweight - 0 to 5 months female"
lab var mod_under_wt_05_female 		"Moderately Underweight - 0 to 5 months female"
lab var under_wt_611_female 		"Underweight - 6 to 11 months female"
lab var sev_under_wt_611_female 	"Severly Underweight - 6 to 11 months female"
lab var mod_under_wt_611_female 	"Moderately Underweight - 6 to 11 months female"
lab var under_wt_1223_female 		"Underweight - 12 to 23 months female"
lab var sev_under_wt_1223_female 	"Severly Underweight - 12 to 23 months female"
lab var mod_under_wt_1223_female 	"Moderately Underweight - 12 to 23 months female"
lab var under_wt_2459_female 		"Underweight - 24 to 59 months female"
lab var sev_under_wt_2459_female 	"Severly Underweight - 24 to 59 months female"
lab var mod_under_wt_2459_female 	"Moderately Underweight - 24 to 59 months female"

lab var cmuac_case				"MUAC data available cases"
lab var cmuacinit_mm			"MUAC - mm"
lab var gam_muac 				"Acute Malnutrition by MUAC"
lab var sam_muac 				"Severe Acute Malnutrition by MUAC"
lab var mam_muac 				"Moderate Acute Malnutrition by MUAC"

global anthro_child cwt_case cht_case haz_case ///
					haz06 haz06_female haz06_male haz06_05 haz06_05_male haz06_05_female haz06_611 haz06_611_male haz06_611_female haz06_1223 haz06_1223_male haz06_1223_female haz06_2459 haz06_2459_male haz06_2459_female ///
					stunt stunt_female stunt_male stunt_05 stunt_05_male stunt_05_female stunt_611 stunt_611_male stunt_611_female stunt_1223 stunt_1223_male stunt_1223_female stunt_2459 stunt_2459_male stunt_2459_female ///
					sev_stunt sev_stunt_female sev_stunt_male sev_stunt_05 sev_stunt_05_male sev_stunt_05_female sev_stunt_611 sev_stunt_611_male sev_stunt_611_female sev_stunt_1223 sev_stunt_1223_male sev_stunt_1223_female sev_stunt_2459 sev_stunt_2459_male sev_stunt_2459_female ///
					mod_stunt mod_stunt_female mod_stunt_male mod_stunt_05 mod_stunt_05_male mod_stunt_05_female mod_stunt_611 mod_stunt_611_male mod_stunt_611_female mod_stunt_1223 mod_stunt_1223_male mod_stunt_1223_female mod_stunt_2459 mod_stunt_2459_male mod_stunt_2459_female ///
					whz_case ///
					whz06 whz06_female whz06_male whz06_05 whz06_05_male whz06_05_female whz06_611 whz06_611_male whz06_611_female whz06_1223 whz06_1223_male whz06_1223_female whz06_2459 whz06_2459_male whz06_2459_female ///
					gam gam_female gam_male gam_05 gam_05_male gam_05_female gam_611 gam_611_male gam_611_female gam_1223 gam_1223_male gam_1223_female gam_2459 gam_2459_male gam_2459_female ///
					sam sam_female sam_male sam_05 sam_05_male sam_05_female sam_611 sam_611_male sam_611_female sam_1223 sam_1223_male sam_1223_female sam_2459 sam_2459_male sam_2459_female ///
					mam mam_female mam_male mam_05 mam_05_male mam_05_female mam_611 mam_611_male mam_611_female mam_1223 mam_1223_male mam_1223_female mam_2459 mam_2459_male mam_2459_female ///
					waz_case ///
					waz06 waz06_female waz06_male waz06_05 waz06_05_male waz06_05_female waz06_611 waz06_611_male waz06_611_female waz06_1223 waz06_1223_male waz06_1223_female waz06_2459 waz06_2459_male waz06_2459_female ///
					under_wt under_wt_female under_wt_male under_wt_05 under_wt_05_male under_wt_05_female under_wt_611 under_wt_611_male under_wt_611_female under_wt_1223 under_wt_1223_male under_wt_1223_female under_wt_2459 under_wt_2459_male under_wt_2459_female ///
					sev_under_wt sev_under_wt_female sev_under_wt_male sev_under_wt_05 sev_under_wt_05_male sev_under_wt_05_female sev_under_wt_611 sev_under_wt_611_male sev_under_wt_611_female sev_under_wt_1223 sev_under_wt_1223_male sev_under_wt_1223_female sev_under_wt_2459 sev_under_wt_2459_male sev_under_wt_2459_female ///
					mod_under_wt mod_under_wt_female mod_under_wt_male mod_under_wt_05 mod_under_wt_05_male mod_under_wt_05_female mod_under_wt_611 mod_under_wt_611_male mod_under_wt_611_female mod_under_wt_1223 mod_under_wt_1223_male mod_under_wt_1223_female mod_under_wt_2459 mod_under_wt_2459_male mod_under_wt_2459_female ///
					cmuac_case cmuacinit_mm gam_muac sam_muac mam_muac

					
save "$cdta/child_anthro_cleanded.dta", replace

