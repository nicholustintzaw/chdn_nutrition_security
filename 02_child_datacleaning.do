/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROJECT:		CPI - CHDN Nutrition Security Report

PURPOSE: 		IYCF and Health Data Cleaning

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
use "$dta/child_nonanthro_combined.dta", clear


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

*------------------------------------------------------------------------------*
***  INFANT AND YOUND CHILD FEEDING  ***
*------------------------------------------------------------------------------*

destring hh_mem_present hh_mem_age, replace
replace hh_mem_present = .m if child_valid_age >= 60

tab hh_mem_present, m
tab hh_mem_age, m

* ---------------------------------------------------------------------------- *
* REPORTING INDICATORS
* ---------------------------------------------------------------------------- *

//B. BREASTFEEDING INFORMATION
// child_bf 
destring child_bf, replace
replace child_bf = .d if child_bf == 999
replace child_bf = .m if hh_mem_present == 0
replace child_bf = .m if hh_mem_age >= 2
replace child_bf = .m if child_valid_age >= 24
tab child_bf, m

//B.1. Early Initiation of Breastfeeding
// child_eibf
destring child_eibf, replace
replace child_eibf = .d if child_eibf == 999
replace child_eibf = .m if child_bf  != 1
tab child_eibf, m

gen child_breastfeed_eibf		=  (child_eibf == 0 & child_valid_age < 24) 
replace child_breastfeed_eibf	= .m if mi(child_eibf) | mi(child_valid_age)
lab val child_breastfeed_eibf yesno
lab var child_breastfeed_eibf "Received early initiation of breastfeeding 0-23 months"
tab child_breastfeed_eibf, m

//B.2. Exclusive Breastfeeding under 6 months
* ~~~
* Indicator definition:
* Proportion of infants 0 to 5 months of age who are fed exclusively with breast milk.
* Infants 0 to 5 months of age who received only breast milk during the previous day
* if one obs missed information, that obs can't be included in analysis (according to def).
* ~~~

// child_bfyest
destring child_bfyest, replace
replace child_bfyest = .d if child_bfyest == 999
replace child_bfyest = .m if hh_mem_present == 0
replace child_bfyest = .m if hh_mem_age >= 2
replace child_bfyest = .m if child_valid_age >= 24

tab child_bfyest, m

* fluids   
local liquid child_vitdrop child_ors child_water child_juice child_broth child_porridge child_bms child_milk child_mproduct child_liquid 
foreach var of varlist `liquid' {
	destring `var', replace
	replace `var' = .d if `var' == 999
	replace `var' = .n if `var' == 777
	replace `var' = .m if hh_mem_present == 0
	replace `var' = .m if hh_mem_age >= 2
	replace `var' = .m if child_valid_age >= 24

	tab `var', m
}
                                                                       
egen child_liquid_consum	=	rowtotal(`liquid'), missing
replace child_liquid_consum	=	.n if 	mi(child_vitdrop) | mi(child_ors) | mi(child_water) | mi(child_juice) | ///
										mi(child_broth) | mi(child_porridge) | mi(child_bms) | mi(child_milk) | ///
										mi(child_mproduct) | mi(child_liquid)
lab var child_liquid_consum 	"Child Liquid Fluid Consumption Score - exclude Vitamin/medicine"
tab child_liquid_consum, m

* solids
local solid child_rice child_potatoes child_pumpkin child_beans child_leafyveg child_mango child_fruit child_organ child_beef child_fish child_insects child_eggs child_yogurt child_fat child_plam child_sweets child_condiments  
// child_othfood, need some data cleaning

foreach var of varlist `solid' {
	destring `var', replace
	replace `var' = .d if `var' == 999
	replace `var' = .n if `var' == 777
	replace `var' = .m if hh_mem_present == 0
	replace `var' = .m if hh_mem_age >= 2
	replace `var' = .m if child_valid_age >= 24
	tab `var', m
}


egen child_solid_consume	=	rowtotal(`solid'), missing
replace child_solid_consume	=	.n if	mi(child_rice) | mi(child_potatoes) | mi(child_pumpkin) | ///
										mi(child_beans) | mi(child_leafyveg) | mi(child_mango) | mi(child_fruit) | ///
										mi(child_organ) | mi(child_beef) | mi(child_fish) | mi(child_insects) | ///
										mi(child_eggs) | mi(child_yogurt) | mi(child_fat) | mi(child_plam) | ///
										mi(child_sweets) | mi(child_condiments)
lab var child_solid_consume 	"Child Solid Food Consumption Score - exclude Vitamin/medicine"
tab child_solid_consume, m


* exclusive breastfeeding <6m
destring child_bfyest, replace

gen child_breastfeed_ebf		=	(child_age_05 == 1 & child_bfyest == 1 & child_liquid_consum == 0 & child_solid_consume == 0)
replace child_breastfeed_ebf	= .m if mi(child_valid_age) | mi(child_liquid_consum) | mi(child_solid_consume) | mi(child_bfyest) | child_age_05 != 1 
lab val child_breastfeed_ebf yesno
lab var child_breastfeed_ebf 	"Received exclusive breastfeeding 0-5 months"
tab child_breastfeed_ebf, m

//B.3. Predominant Breastfeeding 0-6 months
* ~~~
* Indicator definition:
* Proportion of infants 0 to 5 months of age who are predominantly breastfed.
* Infants 0 to 5 months of age who received breast milk as 
* the predominant source of nourishment during the previous day.
* Predominant breastfeeding allows ORS, vitamin and/or mineral supplements, 
* ritual fluids, water and water-based drinks, and fruit juice. Other liquids, 
* including non-human milks and food-based fluids, are not allowed, and no semi-solid or solid foods are allowed.
* ~~~
* fluids
local liquid2 child_vitdrop child_ors child_juice child_broth child_porridge child_bms child_milk child_mproduct child_liquid 

egen child_liquid_consum_2		=	rowtotal(`liquid2'), missing
replace child_liquid_consum_2	=	.n if 	mi(child_vitdrop) | mi(child_ors) | mi(child_juice) | ///
											mi(child_broth) | mi(child_porridge) | mi(child_bms) | mi(child_milk) | ///
											mi(child_mproduct) | mi(child_liquid)
lab var child_liquid_consum_2 	"Child Liquid Fluid Consumption Score - exclude Water and Vitamin/medicine"
tab child_liquid_consum_2, m


* predominant breastfeeding <6m
gen child_breastfeed_predobf		=	(child_age_05 == 1 & child_bfyest == 1 & child_liquid_consum_2 == 0 & child_solid_consume == 0)
replace child_breastfeed_predobf	= .m if mi(child_valid_age) | mi(child_liquid_consum_2) | mi(child_solid_consume) | mi(child_bfyest) | child_age_05 != 1 
lab val child_breastfeed_predobf yesno
lab var child_breastfeed_predobf "Received predominant breastfeeding 0-5 months"
tab child_breastfeed_predobf, m

//B.4. Timely Complementary Feeding 6-9 months
* ~~~
* Indicator definition:
* Proportion of infants 6-9 months who received breastmilk and a solid or semi-solid
* food (based on 24-hour dietary recall). Solid and semi-solid foods are defined as mushy or solid foods, not fluids.
* ~~~
* timely complementary food intake
gen childdiet_timely_cf		=	(child_age_69 == 1 & child_bfyest == 1 & child_solid_consume != 0) 
replace childdiet_timely_cf	=	.m if child_age_69 != 1 | mi(child_bfyest) | mi(child_valid_age)
lab val childdiet_timely_cf yesno
lab var childdiet_timely_cf "Received timely complementary feeding 6-9 months"
tab childdiet_timely_cf, m

//B.5. Introduction of Solid, semi-solid or soft foods 6-8 months
* ~~~
* Indicator definition:
* Proportion of infants 6 to 8 months of age who receive solid, semi-solid or soft foods.
* Infants 6 to 8 months of age who received solid, semi-solid or soft foods during the previous day.
* ~~~
* solids/semi-solids/soft
gen childdiet_introfood		=	(child_age_68 == 1 & child_solid_consume != 0) 
replace childdiet_introfood	=	.m if child_age_68 != 1 | mi(child_solid_consume) | mi(child_valid_age)
lab val childdiet_introfood yesno
lab var childdiet_introfood "Introduced semi-solid food at 6-8 months"
tab childdiet_introfood, m

//B.6. Continued breastfeeding at 1 year – 12-15 months
* ~~~
* Indicator definition:
* Proportion of children 12 to 15 months of age who are fed with breast milk.
* Children 12 to 15 months of age who received breast milk during the previous day
* ~~~

gen child_breastfeed_cont_1yr		=	(child_age_1215 == 1 & child_bfyest == 1)
replace child_breastfeed_cont_1yr	=	.m if child_age_1215 != 1 | mi(child_bfyest)
lab val child_breastfeed_cont_1yr yesno
lab var child_breastfeed_cont_1yr "Received breastfeeding at one year 12-15 months"
tab child_breastfeed_cont_1yr, m

//B.7. Continued breastfeeding at ~2 years – 20-23 months
* ~~~
* Indicator definition:
* Proportion of children 20 to 23 months of age who are fed with breast milk.
* Children 20 to 23 months of age who received breast milk during the previous day
* ~~~

gen child_breastfeed_cont_2yr		=	(child_age_2023 == 1 & child_bfyest == 1) 
replace child_breastfeed_cont_2yr	=	.m if child_age_2023 != 1 | mi(child_bfyest) | mi(child_valid_age)
lab val child_breastfeed_cont_2yr yesno
lab var child_breastfeed_cont_2yr "Received breastfeeding at two years 20-23 months"
tab child_breastfeed_cont_2yr, m

order child_breastfeed_eibf child_liquid_consum child_solid_consume child_breastfeed_ebf child_liquid_consum_2 child_breastfeed_predobf childdiet_timely_cf ///
	  childdiet_introfood child_breastfeed_cont_1yr child_breastfeed_cont_2yr, before(child_rice)


//C. MINIMUM DIETARY DIVERSITY, FREQUENCY, AND ACCEPTABLE DIET
//C.1. 	Minimum dietary diversity 6-23 months
* ~~~
* Indicator definition:
* Proportion of children 6 to 23 months of age who receive foods from 4 or more food groups.
* Children 6 to 23 months of age who received foods from >=4 food groups during the previous day
* ~~~

tab1 child_rice child_potatoes child_pumpkin child_beans child_leafyveg child_mango child_fruit child_organ child_beef child_fish child_insects child_eggs child_yogurt child_fat child_plam child_sweets child_condiments  

* a. Grains
gen childdiet_fg_grains		=	(child_rice == 1 | child_potatoes == 1) 
replace childdiet_fg_grains = .m if mi(child_rice)  & mi(child_potatoes)
lab val childdiet_fg_grains yesno
lab var childdiet_fg_grains "Grain - child diet recall food group"
* b. Pulses
gen childdiet_fg_pulses	=	child_beans
lab val childdiet_fg_pulses yesno
lab var childdiet_fg_pulses "Pulses & Nut - child diet recall food group"
* c. Dairy
gen childdiet_fg_diary	=	child_yogurt
lab val childdiet_fg_diary yesno
lab var childdiet_fg_diary "Diary - child diet recall food group"
* d. Meat
gen childdiet_fg_meat		=	(child_organ == 1 | child_beef == 1 | child_fish == 1 | child_insects == 1) 
replace childdiet_fg_meat 	= .m if mi(child_organ) & mi(child_beef) & mi(child_fish) & mi(child_insects)
lab val childdiet_fg_meat yesno
lab var childdiet_fg_meat "Meat & Fishes - child diet recall food group"
* e. Eggs
gen childdiet_fg_eggs	=	child_eggs
lab val childdiet_fg_eggs yesno
lab var childdiet_fg_eggs "Eggs - child diet recall food group"
* f. Vitamin vegetables
gen childdiet_fg_vit_vegfruit		=	(child_pumpkin == 1 | child_leafyveg == 1 | child_mango == 1)
replace childdiet_fg_vit_vegfruit = .m if mi(child_pumpkin) | mi(child_leafyveg) | mi(child_mango)
lab val childdiet_fg_vit_vegfruit yesno
lab var childdiet_fg_vit_vegfruit "Vit riched Vegetable & Fruits - child diet recall food group"
* g. Other vegetables
gen childdiet_fg_vegfruit_oth		=	child_fruit
lab val childdiet_fg_vegfruit_oth yesno
lab var childdiet_fg_vegfruit_oth "Other Vegetable & Fruits - child diet recall food group"

sum childdiet_fg_grains-childdiet_fg_vegfruit_oth 

* dietary diversity score
egen childdiet_dds		=	rowtotal(childdiet_fg_grains childdiet_fg_pulses childdiet_fg_diary childdiet_fg_meat childdiet_fg_eggs childdiet_fg_vit_vegfruit ///
							childdiet_fg_vegfruit_oth), missing
replace childdiet_dds	=	.m if mi(childdiet_fg_grains) & mi(childdiet_fg_pulses) & mi(childdiet_fg_diary) & ///
							mi(childdiet_fg_meat) & mi(childdiet_fg_eggs) & mi(childdiet_fg_vit_vegfruit) & ///
							mi(childdiet_fg_vegfruit_oth)
replace childdiet_dds	=	. if mi(child_valid_age) | child_age_623 == 0
lab var childdiet_dds 	"Mean Child Dietary Diversity Score - 24 hours diet recall"
tab1 childdiet_dds child_valid_age, m

* reached minmimum dietary score: >=4 groups in past 24h
gen childdiet_min_dds		=	(childdiet_dds >= 4 & child_age_623 == 1) 
replace childdiet_min_dds	=	.m if mi(childdiet_dds) | child_age_623 != 1
lab val childdiet_min_dds yesno
lab var childdiet_min_dds "Received Minimum Dietary Diversity Score 6-23 months"
tab childdiet_min_dds, m

//C.2. Minimum meal frequency
* ~~~
* Indicator definition:
* Proportion of breastfed and non-breastfed children 6√±23 months of age 
* who receive solid, semi-solid, or soft foods (but also including milk feeds for non-breastfed children) the minimum number of times or more.
* BF children: Breastfed children 6√±23 months of age who received solid, semi-solid or soft foods
* the minimum number of times or more during the previous day
* Non BF children: Non-breastfed children 6√±23 months of age who received solid, semi-solid or soft foods or
* milk feeds the minimum number of times or more during the previous day
* Minimum is defined as:
* 2 times for breastfed infants 6-8 months
* 3 times for breastfed children 9-23 months
* 4 times for non-breastfed children 6-23 months
* ~~~
// child_food_freq
destring child_food_freq, replace
replace child_food_freq = .d if child_food_freq == 999
replace child_food_freq = .m if hh_mem_present == 0
replace child_food_freq = .m if hh_mem_age >= 2
replace child_food_freq = .m if child_valid_age >= 24

tab child_food_freq, m


//a. Breastfeeding Children
//a.1. 6-8 months (min num of times for solids: 2)
gen childdiet_68_bf_minfreq		=	(child_age_68 == 1 & child_bfyest == 1 & child_food_freq >= 2) 
replace childdiet_68_bf_minfreq	= .m if child_bfyest != 1
replace childdiet_68_bf_minfreq = .m if mi(child_food_freq) | mi(child_bfyest) | child_age_68 != 1
lab val childdiet_68_bf_minfreq yesno
lab var childdiet_68_bf_minfreq 	"% Breastfeeding children with Minimum Meal Frequency 6-8 months"
tab childdiet_68_bf_minfreq, m


//a.2. 9-23 months (min num of times for solids: 3)
gen childdiet_923_bf_minfreq		=	(child_age_923 == 1 & child_bfyest == 1 & child_food_freq >= 3)	
replace childdiet_923_bf_minfreq	= .m if child_bfyest != 1
replace childdiet_923_bf_minfreq 	= .m if mi(child_food_freq) | mi(child_bfyest) | child_age_923 != 1
lab val childdiet_923_bf_minfreq yesno
lab var childdiet_923_bf_minfreq 	"% Breastfeeding children with Minimum Meal Frequency 9-23 months"
tab childdiet_923_bf_minfreq, m

//a.2. 6-23 months (min num of times for solids: 4)
gen childdiet_bf_minfreq		=	(childdiet_68_bf_minfreq == 1 | childdiet_923_bf_minfreq == 1) 
replace childdiet_bf_minfreq	= .m if child_bfyest != 1 
replace childdiet_bf_minfreq 	= .m if mi(childdiet_923_bf_minfreq) & mi(childdiet_68_bf_minfreq)
lab val childdiet_bf_minfreq yesno
lab var childdiet_bf_minfreq 		"% Breastfeeding children with Minimum Meal Frequency 6-23 months"
tab childdiet_bf_minfreq, m

//b. Non-Breastfeeding Children 
* formula & complementary feeding
local milkfreq child_bms child_milk child_mproduct //child_bms_freq child_milk_freq child_mproduct_freq
foreach x in `milkfreq' {
	destring `x'_freq, replace
	replace `x'_freq = .d if `x'_freq == 999
	replace `x'_freq = .n if `x'_freq == 777
	replace `x'_freq = .m if `x' != 1
	replace `x'_freq = .m if hh_mem_present == 0
	replace `x'_freq = .m if hh_mem_age >= 2
	replace `x'_freq = .m if child_valid_age >= 24

	tab `x', m
}

egen childdiet_formulacf_num	=	rowtotal(child_food_freq child_bms_freq child_milk_freq child_mproduct_freq), missing
replace childdiet_formulacf_num = .m if mi(child_food_freq) & mi(child_bms_freq) & mi(child_milk_freq) & mi(child_mproduct_freq)
lab var childdiet_formulacf_num 	"% Formula feeding and complementary feeding times for non-breastfeeding children"
tab childdiet_formulacf_num, m

gen childdiet_nobf_minfreq		=	(child_age_623 == 1 & child_bfyest == 0 & childdiet_formulacf_num >= 4)	
replace childdiet_nobf_minfreq	= .m if child_bfyest != 0
replace childdiet_nobf_minfreq	= .m if mi(childdiet_formulacf_num) | mi(child_bfyest) | child_age_623 != 1
lab val childdiet_nobf_minfreq yesno
lab var childdiet_nobf_minfreq 		"% Non-breastfeeding children received Minimum Meal Frequency 6-23 months"
tab childdiet_nobf_minfreq, m

//c. Both Breastfeed or Non-Breastfeed Children 6-23 months
gen childdiet_min_mealfreq		= (childdiet_bf_minfreq==1 | childdiet_nobf_minfreq==1) 
replace childdiet_min_mealfreq	= .m if mi(childdiet_bf_minfreq) & mi(childdiet_nobf_minfreq)
lab val childdiet_min_mealfreq yesno
lab var childdiet_min_mealfreq 		"% Children received Minimum Meal Frequency 6-23 months"
tab childdiet_min_mealfreq, m

//C.3. Minimum acceptable diet
* ~~~
* Indicator definition:
* Proportion of children 6 to 23 months of age who receive a minimum acceptable diet (apart from breast milk).
* Breastfed children 6 to 23 months of age who had at least the minimum dietary diversity and the minimum meal frequency during the previous day
* Non-breastfed children 6 to 23 months of age who received at least 2 milk feedings and  had at least the minimum dietary diversity not including milk feeds and 
* the minimum meal frequency during the previous day
* It is recommended that the indicator be further disaggregated and reported for the following age groups: 
* 6-11 months, 12-17 months and 18-23 months of age, if sample size permits.
* ~~~
//a. Breastfeeding Children 
* minimum acceptable dietary score
gen childdiet_bf_min_acceptdiet		=	(child_bfyest == 1 & childdiet_min_dds == 1 & childdiet_bf_minfreq == 1) 				
replace childdiet_bf_min_acceptdiet = .m if child_bfyest != 1 | mi(childdiet_min_dds) | mi(childdiet_bf_minfreq)
lab val childdiet_bf_min_acceptdiet yesno
lab var childdiet_bf_min_acceptdiet 	"% Breastfeeding children with Minimum Acceptable Diet 6-23 months"
tab childdiet_bf_min_acceptdiet,m

//b. Non-Breastfeeding Children
egen childdiet_nomilk_dds	=	rowtotal(childdiet_fg_grains childdiet_fg_pulses childdiet_fg_meat childdiet_fg_eggs ///
								childdiet_fg_vit_vegfruit childdiet_fg_vegfruit_oth), missing
replace childdiet_nomilk_dds=	.m if mi(childdiet_fg_grains) & mi(childdiet_fg_pulses) & mi(childdiet_fg_diary) & ///
								mi(childdiet_fg_meat) & mi(childdiet_fg_eggs) & mi(childdiet_fg_vit_vegfruit) & mi(childdiet_fg_vegfruit_oth)
lab var childdiet_nomilk_dds 	"Child Non-milk Dietary Diversity Score - 24 hours diet recall"
tab childdiet_nomilk_dds, m

* milk feedings
egen childdiet_formula_num		=	rowtotal(child_food_freq child_bms_freq child_milk_freq child_mproduct_freq child_yogurt), missing
replace childdiet_formula_num = .m if mi(child_food_freq) & mi(child_bms_freq) & mi(child_milk_freq) & mi(child_mproduct_freq) & mi(child_yogurt)
lab var childdiet_formula_num 	"% of formula or milk-only feeding times for non-breastfeeding children"
tab childdiet_formula_num, m

* minimum acceptable dietary score
gen childdiet_nobf_min_acceptdiet		=	(child_bfyest == 0 & childdiet_formulacf_num >= 4 & childdiet_formula_num >= 2 & childdiet_nomilk_dds >= 4) 
replace childdiet_nobf_min_acceptdiet	=	.m if child_bfyest != 0 | mi(childdiet_formulacf_num) | mi(childdiet_formula_num) | mi(childdiet_nomilk_dds)
lab val childdiet_nobf_min_acceptdiet yesno
lab var childdiet_nobf_min_acceptdiet 		"% Non-breastfeeding children with Minimum Acceptable Diet 6-23 months"
tab childdiet_nobf_min_acceptdiet, m

//c. Both Breastfeed and Non-Breastfeed Children 6-23 months
* minimum acceptable diet
gen childdiet_min_acceptdiet	=	(child_age_623 == 1 & childdiet_bf_min_acceptdiet == 1 | childdiet_nobf_min_acceptdiet == 1) 
replace childdiet_min_acceptdiet=	.m if mi(childdiet_bf_min_acceptdiet) & mi(childdiet_nobf_min_acceptdiet)
replace childdiet_min_acceptdiet= 	.m if child_age_623 != 1
lab val childdiet_min_acceptdiet yesno
lab var childdiet_min_acceptdiet 	"% Children with Minimum Acceptable Diet 6-23 months"
tab childdiet_min_acceptdiet, m

* 6-11 months
gen childdiet_611_min_acceptdiet	=	(childdiet_min_acceptdiet == 1 & child_age_611 == 1)
replace childdiet_611_min_acceptdiet=	.m if mi(childdiet_min_acceptdiet) |  child_age_611 != 1
lab val childdiet_611_min_acceptdiet yesno
lab var childdiet_611_min_acceptdiet "% Children received Minimum Acceptable Diet 6-11 months"
tab childdiet_611_min_acceptdiet, m

* 12-17 months
gen childdiet_1217_min_acceptdiet		=  (childdiet_min_acceptdiet ==  1 & child_age_1217 == 1)
replace childdiet_1217_min_acceptdiet	=  .m if mi(childdiet_min_acceptdiet) |  child_age_1217 != 1
lab val childdiet_1217_min_acceptdiet yesno
lab var childdiet_1217_min_acceptdiet "% Children received Minimum Acceptable Diet 12-17 months"
tab childdiet_1217_min_acceptdiet, m

* 18-23 months
gen childdiet_1823_min_acceptdiet		=	(childdiet_min_acceptdiet == 1 & child_age_1823 == 1)
replace childdiet_1823_min_acceptdiet	=	.m if mi(childdiet_min_acceptdiet) | child_age_1823 != 1
lab val childdiet_1823_min_acceptdiet yesno
lab var childdiet_1823_min_acceptdiet "% Children received Minimum Acceptable Diet 18-23 months"
tab childdiet_1823_min_acceptdiet, m


//C.4. Consumption of iron-rich or iron-fortified foods
* ~~~
* Indicator definition:
* Proportion of children 6√±23 months of age who receive an iron-rich food or 
* iron-fortified food that is specially designed for infants and young children, or that is fortified in the home.
* Children 6√±23 months of age who received an iron-rich food
* or a food that was specially designed for infants and young children and was fortified with iron,
* or a food that was fortified in the home with a product that included iron during the previous day
* ~~~
* food: meat 
gen childdiet_iron_consum		=	(childdiet_fg_meat == 1 & child_age_623 == 1) 
replace childdiet_iron_consum	=	.m if mi(childdiet_fg_meat) | child_age_623 != 1
lab val childdiet_iron_consum yesno
lab var childdiet_iron_consum 		"% Children received iron riched food 6-23 months"
tab childdiet_iron_consum, m

order childdiet_fg_grains - childdiet_iron_consum, after (child_food_freq)



*** Reporting Variables ***
lab var child_bf					"breastfeed child"
lab var child_breastfeed_eibf 		"early initiaton of breastfeedig" 
lab var child_breastfeed_ebf 		"exclusive breastfeeding"
lab var child_breastfeed_predobf 	"predominant breastfeeding"
lab var childdiet_timely_cf 		"timely initiation of complementary feeding"
lab var childdiet_introfood 		"introduction of semi-solid food"
lab var child_breastfeed_cont_1yr 	"continious breastfeeding at 1 year"
lab var child_breastfeed_cont_2yr	"continious breastfeeding at 2 years"

lab var childdiet_fg_grains			"child diet - grains"
lab var childdiet_fg_pulses 		"child diet - pulses"
lab var childdiet_fg_diary 			"child diet - diary"
lab var childdiet_fg_meat 			"child diet - meat"
lab var childdiet_fg_eggs 			"child diet - eggs"
lab var childdiet_fg_vit_vegfruit 	"child diet - vitamin rich fruirt & vegetable"
lab var childdiet_fg_vegfruit_oth 	"child diet - other fruit & vegetable"
lab var childdiet_dds 				"child dietary diversity score"
lab var childdiet_min_dds 			"child met minimum dietary diversity" 

lab var childdiet_min_mealfreq		"child met minimum meal frequency"
lab var childdiet_bf_minfreq 		"breastfeed child meet minimum meal frequency"
lab var childdiet_68_bf_minfreq 	"6-8 months breastfeed child meet minimum meal frequency"
lab var childdiet_923_bf_minfreq 	"9-23 months breastfeed child meet minimum meal frequency"
lab var childdiet_nobf_minfreq 		"non breastfeed child meet minimum meal frequency"

lab var childdiet_min_acceptdiet		"child met minimum acceptable diet"
lab var childdiet_bf_min_acceptdiet		"breastfeed child met minimum acceptable diet"
lab var childdiet_nobf_min_acceptdiet	"non breastfeed child met minimum acceptable diet"
lab var childdiet_611_min_acceptdiet	"6-11 months child met minimum acceptable diet"
lab var childdiet_1217_min_acceptdiet	"12-27 months child met minimum acceptable diet"
lab var childdiet_1823_min_acceptdiet	"18-23 months child met minimum acceptable diet"

lab var childdiet_iron_consum			"child consumption of iron rich foods"

order		child_bf child_breastfeed_eibf child_breastfeed_ebf child_breastfeed_predobf childdiet_timely_cf childdiet_introfood child_breastfeed_cont_1yr child_breastfeed_cont_2yr ///				
			childdiet_fg_grains childdiet_fg_pulses childdiet_fg_diary childdiet_fg_meat childdiet_fg_eggs childdiet_fg_vit_vegfruit childdiet_fg_vegfruit_oth childdiet_dds childdiet_min_dds ///
			childdiet_min_mealfreq childdiet_bf_minfreq childdiet_68_bf_minfreq childdiet_923_bf_minfreq childdiet_nobf_minfreq ///
			childdiet_min_acceptdiet childdiet_bf_min_acceptdiet childdiet_nobf_min_acceptdiet childdiet_611_min_acceptdiet childdiet_1217_min_acceptdiet childdiet_1823_min_acceptdiet ///
			childdiet_iron_consum, before(child_vaccin)

global iycf		child_bf child_breastfeed_eibf child_breastfeed_ebf child_breastfeed_predobf childdiet_timely_cf childdiet_introfood child_breastfeed_cont_1yr child_breastfeed_cont_2yr ///				
				childdiet_fg_grains childdiet_fg_pulses childdiet_fg_diary childdiet_fg_meat childdiet_fg_eggs childdiet_fg_vit_vegfruit childdiet_fg_vegfruit_oth childdiet_dds childdiet_min_dds ///
				childdiet_min_mealfreq childdiet_bf_minfreq childdiet_68_bf_minfreq childdiet_923_bf_minfreq childdiet_nobf_minfreq ///
				childdiet_min_acceptdiet childdiet_bf_min_acceptdiet childdiet_nobf_min_acceptdiet childdiet_611_min_acceptdiet childdiet_1217_min_acceptdiet childdiet_1823_min_acceptdiet ///
				childdiet_iron_consum

*------------------------------------------------------------------------------*
***  HEALTH SEEKING BEHAVIOURS  ***
*------------------------------------------------------------------------------*
* -------------------------------------------------------------------- *
** CHILD HEALTH-SEEKING BEHAVIOUR: IMMUNIZATION RECORD **
* -------------------------------------------------------------------- *

// child_vaccin
destring child_vaccin, replace
replace child_vaccin = .m if hh_mem_present == 0
replace child_vaccin = .m if hh_mem_age >= 2
replace child_vaccin = .m if child_valid_age >= 24
tab child_vaccin, m

// child_vaccin_card
destring child_vaccin_card, replace
replace child_vaccin_card = .m if child_vaccin == 0
replace child_vaccin_card = .m if hh_mem_present == 0
replace child_vaccin_card = .m if hh_mem_age >= 2
replace child_vaccin_card = .m if child_valid_age >= 24
tab child_vaccin_card, m

 
// with card
local vc	child_vc_bcg child_vc_hepb child_vc_penta1 child_vc_penta2 child_vc_penta3 ///
			child_vc_polio1 child_vc_polioinj child_vc_polio2 child_vc_polio3 ///
			child_vc_measel1 child_vc_measel2 child_vc_rubella child_vc_encephalitis 

foreach var in `vc' {
	destring `var', replace
	replace `var' = .m if mi(child_vaccin_card)
	replace `var' = .m if child_vaccin_card == 0
	replace `var' = .m if hh_mem_present == 0
	replace `var' = .m if hh_mem_age >= 2
	replace `var' = .m if child_valid_age >= 24
	tab `var', m
}


// with no card
local nvc	child_novc_bcg child_novc_penta child_novc_polio child_novc_polio_inj ///
			child_novc_measel child_novc_rubella child_novc_encephalitis 
			
foreach var in `nvc' {
	destring `var', replace
	replace `var' = .m if `var' == 999
	replace `var' = .m if mi(child_vaccin_card)
	replace `var' = .m if child_vaccin_card == 1
	replace `var' = .m if hh_mem_present == 0
	replace `var' = .m if hh_mem_age >= 2
	replace `var' = .m if child_valid_age >= 24
	tab `var', m
}
			
local nvcnum	child_novc_penta child_novc_polio child_novc_measel 

foreach x in `nvcnum' {
	destring `x'_num, replace
	replace `x'_num = .d if `x'_num == 999
	replace `x'_num = .n if `x'_num == 777
	replace `x'_num = .m if `x' != 1
	replace `x'_num = .m if hh_mem_present == 0
	replace `x'_num = .m if hh_mem_age >= 2
	replace `x'_num = .m if child_valid_age >= 24

	tab `x', m
}

// child_vita 
destring child_vita, replace
replace child_vita = .d if child_vita == 999
replace child_vita = .n if child_vita == 777
replace child_vita = .m if hh_mem_present == 0
replace child_vita = .m if hh_mem_age >= 2
replace child_vita = .m if child_valid_age >= 24
tab child_vita, m

// child_deworm
destring child_deworm, replace
replace child_deworm = .d if child_deworm == 999
replace child_deworm = .n if child_deworm == 777
replace child_deworm = .m if hh_mem_present == 0
replace child_deworm = .m if hh_mem_age >= 2
replace child_deworm = .m if child_valid_age >= 24
tab child_deworm, m

// child_hepatitisb
destring child_hepatitisb, replace
replace child_hepatitisb = .d if child_hepatitisb == 999
replace child_hepatitisb = .n if child_hepatitisb == 777
replace child_hepatitisb = .m if hh_mem_present == 0
replace child_hepatitisb = .m if hh_mem_age >= 2
replace child_hepatitisb = .m if child_valid_age >= 24
tab child_hepatitisb, m 
	
// child_birthwt 
destring child_birthwt, replace
replace child_birthwt = .m if hh_mem_present == 0
replace child_birthwt = .m if hh_mem_age >= 2
replace child_birthwt = .m if child_valid_age >= 24
tab child_birthwt, m

// child_birthwt_unit 
// child_birthwt_unit1 child_birthwt_unit2 child_birthwt_unit3 
local wtunit	child_birthwt_unit1 child_birthwt_unit2 child_birthwt_unit3 
foreach var in `wtunit' {
	destring `var', replace
	replace `var' = .m if `var' == 999
	replace `var' = .m if mi(child_birthwt)
	replace `var' = .m if child_birthwt == 0
	replace `var' = .m if hh_mem_present == 0
	replace `var' = .m if hh_mem_age >= 2
	replace `var' = .m if child_valid_age >= 24
	tab `var', m
}

rename child_birthwt_unit1 child_birthwt_kgu
rename child_birthwt_unit2 child_birthwt_lbu
rename child_birthwt_unit3 child_birthwt_ozu

local bwt	child_birthwt_kg child_birthwt_lb child_birthwt_oz 
foreach x in `bwt' {
	destring `x', replace
	replace `x' = .d if `x' == 999
	replace `x' = .n if `x' == 777
	replace `x' = .m if `x'u != 1
	replace `x' = .m if hh_mem_present == 0
	replace `x' = .m if hh_mem_age >= 2
	replace `x' = .m if child_valid_age >= 24

	tab `x', m
}

// child_birthwt_doc
destring child_birthwt_doc, replace
replace child_birthwt_doc = .m if mi(child_birthwt)
replace child_birthwt_doc = .m if child_birthwt == 0
replace child_birthwt_doc = .m if hh_mem_present == 0
replace child_birthwt_doc = .m if hh_mem_age >= 2
replace child_birthwt_doc = .m if child_valid_age >= 24
tab child_birthwt_doc, m

* ---------------------------------------------------------------------------- *
* REPORTING INDICATORS
* ---------------------------------------------------------------------------- *
* ~~~
* Indicator definition:
* DHS Myanmar Report - page 183
* Percentage of children age 12-23 months who received specific vaccines at any time before the survey, 
* by source of information (vaccination card or mother’s report), 
* and percentage vaccinated by age 12 months, Myanmar DHS 2015-16

* For children whose information is based on the mother’s report, the proportion of vaccinations given 
* during the first year of life is assumed to be the same as for children with a written record of vaccination.
* ~~~


// child_vaccin
// with 12 - 23 months age only

gen child_vaccin_rpt 		= child_vaccin
replace child_vaccin_rpt	= .m if child_valid_age < 12 
tab child_vaccin_rpt, m	

//A. BCG
// either card or self-report
gen child_bcg_yes		= (child_vc_bcg == 1 | child_novc_bcg ==  1)
replace child_bcg_yes	= .m if mi(child_vc_bcg) * mi(child_novc_bcg)
replace child_bcg_yes = .m if hh_mem_present == 0
replace child_bcg_yes = .m if hh_mem_age >= 2
replace child_bcg_yes = .m if child_valid_age >= 24
tab child_bcg_yes, m

gen child_novc_bcgd		= child_novc_bcg
replace child_novc_bcgd = 0 if child_novc_bcg == 2
tab child_novc_bcgd, m

// with 12 - 23 months age only
local bcg	child_vc_bcg child_novc_bcgd child_bcg_yes
foreach x in `bcg' {
	gen `x'_rpt 	= `x'
	replace `x'_rpt	= .m if child_valid_age < 12 
	tab `x'_rpt, m	
}

// child_novc_bcgd child_bcg_yes child_vc_bcg_rpt child_novc_bcg_rpt child_bcg_yes_rpt 

//B. Hep B
tab child_hepatitisb, m
tab child_vc_hepb, m


//C. PENTA 5
// penta times without card
forvalue x = 1/3 {
	gen child_novc_penta_`x'		= child_novc_penta_num
	replace child_novc_penta_`x'	= 1 if child_novc_penta_num >= `x' & !mi(child_novc_penta_num)
	replace child_novc_penta_`x'	= 0 if child_novc_penta_num < `x' & !mi(child_novc_penta_num)
	tab child_novc_penta_`x', m
}

// either card or self-report
forvalue x = 1/3 {
	gen child_penta_yes_`x'		= (child_vc_penta`x' == 1 | child_novc_penta_`x' == 1)
	replace child_penta_yes_`x'	= .m if mi(child_vc_penta`x') & mi(child_novc_penta_`x')
	tab child_penta_yes_`x', m
}

// with 12 - 23 months age only
local penta	child_vc_penta1 child_vc_penta2 child_vc_penta3 child_novc_penta_1 ///
			child_novc_penta_2 child_novc_penta_3 child_penta_yes_1 child_penta_yes_2 child_penta_yes_3
foreach x in `penta' {
	gen `x'_rpt 	= `x'
	replace `x'_rpt	= .m if child_valid_age < 12 
	tab `x'_rpt, m	
}

// child_novc_penta_1 child_novc_penta_2 child_novc_penta_3 child_penta_yes_1 child_penta_yes_2 child_penta_yes_3 child_vc_penta1_rpt child_vc_penta2_rpt child_vc_penta3_rpt child_novc_penta_1_rpt child_novc_penta_2_rpt child_novc_penta_3_rpt child_penta_yes_1_rpt child_penta_yes_2_rpt child_penta_yes_3_rpt

//D. Polio
// polio times without card
forvalue x = 1/3 {
	gen child_novc_polio_`x'		= child_novc_polio_num
	replace child_novc_polio_`x'	= 1 if child_novc_polio_num >= `x' & !mi(child_novc_polio_num)
	replace child_novc_polio_`x'	= 0 if child_novc_polio_num < `x' & !mi(child_novc_polio_num)
	tab child_novc_polio_`x', m
}

// either card or self-report
forvalue x = 1/3 {
	gen child_polio_yes_`x'		= (child_vc_polio`x' == 1 | child_novc_polio_`x' == 1)
	replace child_polio_yes_`x'	= .m if mi(child_vc_polio`x') & mi(child_novc_polio_`x')
	tab child_polio_yes_`x', m
}

// polio injection either card or self-report
gen child_polioinj 		= (child_vc_polioinj == 1 | child_novc_polio_inj == 1)
replace child_polioinj 	= .m if mi(child_vc_polioinj) & mi(child_novc_polio_inj)
tab child_polioinj, m

// with 12 - 23 months age only
local polio	child_vc_polio1 child_vc_polio2 child_vc_polio3 child_novc_polio_1 ///
			child_novc_polio_2 child_novc_polio_3 child_polio_yes_1 ///
			child_polio_yes_2 child_polio_yes_3 child_vc_polioinj child_novc_polio_inj
foreach x in `polio' {
	gen `x'_rpt 	= `x'
	replace `x'_rpt	= .m if child_valid_age < 12 
	tab `x'_rpt, m	
}

//child_novc_polio_1 child_novc_polio_2 child_novc_polio_3 child_polio_yes_1 child_polio_yes_2 child_polio_yes_3 child_vc_polio1_rpt child_vc_polio2_rpt child_vc_polio3_rpt child_novc_polio_1_rpt child_novc_polio_2_rpt child_novc_polio_3_rpt child_polio_yes_1_rpt child_polio_yes_2_rpt child_polio_yes_3_rpt

//E. Measles
// measles times without card
forvalue x = 1/2 {
	gen child_novc_measel_`x'		= child_novc_measel_num
	replace child_novc_measel_`x'	= 1 if child_novc_measel_num >= `x' & !mi(child_novc_measel_num)
	replace child_novc_measel_`x'	= 0 if child_novc_measel_num < `x' & !mi(child_novc_measel_num)
	tab child_novc_measel_`x', m
}

// either card or self-report
forvalue x = 1/2 {
	gen child_measel_yes_`x'		= (child_vc_measel`x' == 1 | child_novc_measel_`x' == 1)
	replace child_measel_yes_`x'	= .m if mi(child_vc_measel`x') & mi(child_novc_measel_`x')
	tab child_measel_yes_`x', m
}

// with 12 - 23 months age only
local measel	child_vc_measel1 child_vc_measel2 child_novc_measel_1 ///
				child_novc_measel_2 child_measel_yes_1 child_measel_yes_2
foreach x in `measel' {
	gen `x'_rpt 	= `x'
	replace `x'_rpt	= .m if child_valid_age < 12 
	tab `x'_rpt, m	
}

// child_novc_measel_1 child_novc_measel_2 child_measel_yes_1 child_measel_yes_2 child_vc_measel1_rpt child_vc_measel2_rpt child_novc_measel_1_rpt child_novc_measel_2_rpt child_measel_yes_1_rpt child_measel_yes_2_rpt


//F. Rubella   
// either card or self-report
gen child_rubella_yes		= (child_vc_rubella == 1 | child_novc_rubella == 1)
replace child_rubella_yes	= .m if mi(child_vc_rubella) & mi(child_novc_rubella)
tab child_rubella_yes, m

// with 12 - 23 months age only
local rubella	child_vc_rubella child_novc_rubella child_rubella_yes

foreach x in `rubella' {
	gen `x'_rpt 	= `x'
	replace `x'_rpt	= .m if child_valid_age < 12 
	tab `x'_rpt, m	
}

// child_rubella_yes child_vc_rubella_rpt child_novc_rubella_rpt child_rubella_yes_rpt

//G. COMPLETE ALL BASIC IMMUNIZATION
* BCG, first dose of measles, and three doses each of pentavalent and polio vaccine

gen complete_cv_rpt	= 	(child_vc_bcg_rpt == 1 & child_vc_penta1_rpt == 1 & child_vc_penta2_rpt == 1 & ///
						child_vc_penta3_rpt == 1 & child_vc_polio1_rpt == 1 & child_vc_polio2_rpt == 1 & ///
						child_vc_polio3_rpt == 1 & child_vc_measel1_rpt == 1)
replace complete_cv	= .m if mi(child_vc_bcg_rpt) | mi(child_vc_penta1_rpt) | mi(child_vc_penta2_rpt) | ///
						mi(child_vc_penta3_rpt) | mi(child_vc_polio1_rpt) | mi(child_vc_polio2_rpt) | ///
						mi(child_vc_polio3_rpt) | mi(child_vc_measel1_rpt)
						
tab complete_cv_rpt, m

gen noimmu_cv_rpt		= 	(child_vc_bcg_rpt == 0 & child_vc_penta1_rpt == 0 & child_vc_penta2_rpt == 0 & ///
						child_vc_penta3_rpt == 0 & child_vc_polio1_rpt == 0 & child_vc_polio2_rpt == 0 & ///
						child_vc_polio3_rpt == 0 & child_vc_measel1_rpt == 0)
replace noimmu_cv_rpt	= .m if mi(child_vc_bcg_rpt) | mi(child_vc_penta1_rpt) | mi(child_vc_penta2_rpt) | ///
						mi(child_vc_penta3_rpt) | mi(child_vc_polio1_rpt) | mi(child_vc_polio2_rpt) | ///
						mi(child_vc_polio3_rpt) | mi(child_vc_measel1_rpt)
						
tab noimmu_cv_rpt, m

// complete_cv_rpt noimmu_cv_rpt 
//child_hepatitisb - immunization accessibility


//H. Low Birth Weight 
* ~~~
* Indicator definition:
* Standard Birth Weight: More than 2.5kg (UNICEF) 
* Babies are weighted within the first few hours after birth. 
* A birthweight less than 2,500 g (5 pounds 8 ounces) is diagnosed as low birthweight.
* ~~~

* child birth weight calculation 
gen child_birthwt_oz_cal = round(child_birthwt_oz/16, 0.1)

egen child_birthwt_lb_cal		=  rowtotal(child_birthwt_lb child_birthwt_oz_cal)
replace child_birthwt_lb_cal	= .m if mi(child_birthwt_lb)

gen child_birth_weight		=	child_birthwt_kg
replace child_birth_weight	=	round(child_birthwt_lb_cal/2.2,0.1) if !mi(child_birthwt_lb_cal)
lab var child_birth_weight "Average Child Birth Weight in kg"
tab child_birth_weight, m


* low weight at birth: <2.5kg
gen child_low_birthweight		=	(child_birth_weight < 2.5) 
replace child_low_birthweight	= .m if mi(child_birth_weight)
lab var child_low_birthweight "Low Birth Weight children"
tab child_low_birthweight, m


* birth weight source
tab child_birthwt_doc, m

local bwt child_birth_weight child_low_birthweight 

foreach var in `bwt' {
	gen `var'_vc		= `var'
	replace `var'_vc	= .m if child_birthwt_doc == 1
	tab `var'_vc, m
	
	gen `var'_novc		= `var'
	replace `var'_novc	= .m if child_birthwt_doc == 0
	tab `var'_novc, m
}


order child_bcg_yes - child_low_birthweight_novc, before(child_ill)


*** reporting variables ***
lab var child_vaccin_rpt			"reported received at least one vacination" 
lab var child_vc_bcg_rpt 			"immunized bcg with card"
lab var child_novc_bcgd_rpt 		"immunized bcg with no card"
lab var child_bcg_yes_rpt 			"immunized bcg"
lab var child_vc_penta1_rpt 		"immunized penta-1 with card"
lab var child_vc_penta2_rpt 		"immunized penta-2 with card"
lab var child_vc_penta3_rpt 		"immunized penta-3 with card"
lab var child_novc_penta_1_rpt 		"immunized penta-1 with no card"
lab var child_novc_penta_2_rpt 		"immunized penta-2 with no card"
lab var child_novc_penta_3_rpt 		"immunized penta-3 with no card"
lab var child_penta_yes_1_rpt 		"immunized penta-1"
lab var child_penta_yes_2_rpt 		"immunized penta-2"
lab var child_penta_yes_3_rpt 		"immunized penta-3"
lab var child_vc_polio1_rpt 		"immunized polio-1 with card"
lab var child_vc_polio2_rpt 		"immunized polio-2 with card"
lab var child_vc_polio3_rpt 		"immunized polio-3 with card"
lab var child_novc_polio_1_rpt 		"immunized polio-1 with no card"
lab var child_novc_polio_2_rpt 		"immunized polio-2 with no card"
lab var child_novc_polio_3_rpt 		"immunized polio-3 with no card"
lab var child_polio_yes_1_rpt 		"immunized polio-1"
lab var child_polio_yes_2_rpt 		"immunized polio-2"
lab var child_polio_yes_3_rpt 		"immunized polio-3"
lab var child_polioinj				"immunized polio-inj"
lab var child_vc_polioinj			"immunized polio-inj with card"
lab var child_novc_polio_inj_rpt 	"immunized polio-inj with no card"
lab var child_vc_measel1_rpt 		"immunized measel-1 with card"
lab var child_vc_measel2_rpt 		"immunized measel-2 with card"
lab var child_novc_measel_1_rpt 	"immunized measel-1 with no card"
lab var child_novc_measel_2_rpt 	"immunized measel-2 with no card"
lab var child_measel_yes_1_rpt 		"immunized measel-1"
lab var child_measel_yes_2_rpt 		"immunized measel-2"
lab var	child_vc_rubella_rpt 		"immunized rubella with card"
lab var child_novc_rubella_rpt 		"immunized rubella with no card"
lab var child_rubella_yes_rpt 		"immunized rubella"
lab var complete_cv_rpt 			"complete immunization child"
lab var noimmu_cv_rpt				"non immunized child"

lab var child_birth_weight 			"child birth weight"
lab var child_birth_weight_vc 		"child birth weight with card"
lab var child_birth_weight_novc		"child birth weight with no card"

lab var child_low_birthweight		"low birth weight"
lab var child_low_birthweight_vc 	"low birth weight with card"
lab var child_low_birthweight_novc	"low birth weight with no card"
			
order		child_vaccin_rpt child_bcg_yes_rpt child_vc_bcg_rpt child_novc_bcgd_rpt ///
			child_penta_yes_1_rpt child_vc_penta1_rpt child_novc_penta_1_rpt ///
			child_penta_yes_2_rpt child_vc_penta2_rpt child_novc_penta_2_rpt ///
			child_penta_yes_3_rpt child_vc_penta3_rpt child_novc_penta_3_rpt ///
			child_polio_yes_1_rpt child_vc_polio1_rpt child_novc_polio_1_rpt ///
			child_polio_yes_2_rpt child_vc_polio2_rpt child_novc_polio_2_rpt ///
			child_polio_yes_3_rpt child_vc_polio3_rpt child_novc_polio_3_rpt ///
			child_polioinj child_vc_polioinj child_novc_polio_inj_rpt ///
			child_measel_yes_1_rpt child_vc_measel1_rpt child_novc_measel_1_rpt ///
			child_measel_yes_2_rpt child_vc_measel2_rpt child_novc_measel_2_rpt ///
			child_rubella_yes_rpt child_vc_rubella_rpt child_novc_rubella_rpt ///
			complete_cv_rpt noimmu_cv_rpt ///
			child_birth_weight child_birth_weight_vc child_birth_weight_novc ///
			child_low_birthweight child_low_birthweight_vc child_low_birthweight_novc, after(child_ill)

global	vacin		child_vaccin_rpt child_bcg_yes_rpt child_vc_bcg_rpt child_novc_bcgd_rpt ///
					child_penta_yes_1_rpt child_vc_penta1_rpt child_novc_penta_1_rpt ///
					child_penta_yes_2_rpt child_vc_penta2_rpt child_novc_penta_2_rpt ///
					child_penta_yes_3_rpt child_vc_penta3_rpt child_novc_penta_3_rpt ///
					child_polio_yes_1_rpt child_vc_polio1_rpt child_novc_polio_1_rpt ///
					child_polio_yes_2_rpt child_vc_polio2_rpt child_novc_polio_2_rpt ///
					child_polio_yes_3_rpt child_vc_polio3_rpt child_novc_polio_3_rpt ///
					child_polioinj child_vc_polioinj child_novc_polio_inj_rpt ///
					child_measel_yes_1_rpt child_vc_measel1_rpt child_novc_measel_1_rpt ///
					child_measel_yes_2_rpt child_vc_measel2_rpt child_novc_measel_2_rpt ///
					child_rubella_yes_rpt child_vc_rubella_rpt child_novc_rubella_rpt ///
					complete_cv_rpt noimmu_cv_rpt ///
					child_birth_weight child_birth_weight_vc child_birth_weight_novc ///
					child_low_birthweight child_low_birthweight_vc child_low_birthweight_novc
					  

** tabout example **
//tabout *_rpt using "$out/tabel_meal_all.xls", c(row ci) stats(chi2) svy nwt(wt) per pop replace


*------------------------------------------------------------------------------*
*** CHILDHOOD ILLNESS ***
*------------------------------------------------------------------------------*
* ---------------------------------------------------------------------------- *
* CHILDHOOD ILLNESS RECALL
* ---------------------------------------------------------------------------- *

// child_ill 
replace child_ill = ".m" if hh_mem_present == 0
replace child_ill = ".m" if hh_mem_age >= 5
replace child_ill = ".m" if child_valid_age >= 60
tab child_ill, m

local ill child_ill0 child_ill1 child_ill2 child_ill3 child_ill888 
foreach var in `ill' {
	destring `var', replace
	replace `var' = .m if child_ill == ".m"
	replace `var' = .m if hh_mem_present == 0
	replace `var' = .m if hh_mem_age >= 5
	replace `var' = .m if child_valid_age >= 60
	tab `var', m
}

rename child_ill0		child_ill_no
rename child_ill1		child_ill_diarrhea
rename child_ill2 		child_ill_cough
rename child_ill3 		child_ill_fever
rename child_ill888		child_ill_other


tab child_ill_diarrhea, m

// child_diarrh_treat 
destring child_diarrh_treat, replace
replace child_diarrh_treat = .m if child_ill_diarrhea != 1
tab child_diarrh_treat, m

// child_diarrh_notreat 
destring child_diarrh_notreat, replace
replace child_diarrh_notreat = .m if child_diarrh_treat != 0
tab child_diarrh_notreat, m

// child_diarrh_notreat_oth 

// child_diarrh_notice
destring child_diarrh_notice, replace
replace child_diarrh_notice = .m if child_diarrh_treat != 1 
tab child_diarrh_notice, m

// child_diarrh_notice_unit 
destring child_diarrh_notice_unit, replace
replace child_diarrh_notice_unit = .m if child_diarrh_treat != 1 
tab child_diarrh_notice_unit, m

// child_diarrh_where 
destring child_diarrh_where, replace
replace child_diarrh_where = .m if child_diarrh_treat != 1 
tab child_diarrh_where, m

// child_diarrh_where_oth 

// child_diarrh_else 
destring child_diarrh_else, replace
replace child_diarrh_else = .m if child_diarrh_treat != 1 
tab child_diarrh_else, m

// child_diarrh_else_oth 

// child_diarrh_pay 
destring child_diarrh_pay, replace
replace child_diarrh_pay = .m if child_diarrh_treat != 1 
tab child_diarrh_pay, m

// child_diarrh_amount 
destring child_diarrh_amount, replace
replace child_diarrh_amount = 0 if child_diarrh_pay == 0 
replace child_diarrh_amount = .m if child_diarrh_treat != 1 
tab child_diarrh_amount, m

// child_diarrh_items 
local diaitem child_diarrh_items1 child_diarrh_items2 child_diarrh_items3 child_diarrh_items4 child_diarrh_items5 child_diarrh_items6 child_diarrh_items888 

foreach var in `diaitem' {
	destring `var', replace
	replace `var' = .m if mi(child_diarrh_amount)
	tab `var', m
}

// child_diarrh_loan 
destring child_diarrh_loan, replace
replace child_diarrh_loan = .m if child_diarrh_pay != 1 
tab child_diarrh_loan, m

// child_diarrh_items_oth 

// child_diarrh_still 
destring child_diarrh_still, replace
replace child_diarrh_still = .m if child_ill_diarrhea != 1 
tab child_diarrh_still, m

// child_diarrh_recover  
destring child_diarrh_recover, replace
replace child_diarrh_recover = .m if child_diarrh_still != 0
tab child_diarrh_recover, m

// child_diarrh_recoverunit
destring child_diarrh_recoverunit, replace
replace child_diarrh_recoverunit = .m if child_diarrh_still != 0
tab child_diarrh_recoverunit, m


tab child_ill_cough, m

// child_cough_treat 
destring child_cough_treat, replace
replace child_cough_treat = .m if child_ill_cough != 1
tab child_cough_treat, m

// child_cough_notreat 
destring child_cough_notreat, replace
replace child_cough_notreat = .d if child_cough_notreat == 999
replace child_cough_notreat = .m if child_cough_treat != 0
tab child_cough_notreat, m

// child_cough_notice 
destring child_cough_notice, replace
replace child_cough_notice = .m if child_cough_treat != 1 
tab child_cough_notice, m

// child_cough_notice_unit 
destring child_cough_notice_unit, replace
replace child_cough_notice_unit = .m if child_cough_treat != 1 
tab child_cough_notice_unit, m

// child_cough_where 
destring child_cough_where, replace
replace child_cough_where = .d if child_cough_where == 999 
replace child_cough_where = .m if child_cough_treat != 1 
tab child_cough_where, m

// child_cough_where_oth 

// child_cough_else 
destring child_cough_else, replace
replace child_cough_else = .d if child_cough_else == 999 
replace child_cough_else = .m if child_cough_treat != 1 
tab child_cough_else, m

// child_cough_else_oth 

// child_cough_pay 
destring child_cough_pay, replace
replace child_cough_pay = .m if child_cough_treat != 1 
tab child_cough_pay, m

// child_cough_amount 
destring child_cough_amount, replace
replace child_cough_amount = 0 if child_cough_pay == 0 
replace child_cough_amount = .m if child_cough_treat != 1 
tab child_cough_amount, m
 
// child_cough_items 
local coughitem child_cough_items1 child_cough_items2 child_cough_items3 child_cough_items4 child_cough_items5 child_cough_items6 child_cough_items888 
foreach var in `coughitem' {
	destring `var', replace
	replace `var' = .m if mi(child_cough_amount)
	tab `var', m
}

// child_cough_loan 
destring child_cough_loan, replace
replace child_cough_loan = .d if child_cough_loan == 999 
replace child_cough_loan = .m if child_cough_pay != 1 
tab child_cough_loan, m

// child_cough_items_oth 

// child_cough_still 
destring child_cough_still, replace
replace child_cough_still = .m if child_ill_cough != 1 
tab child_cough_still, m

// child_cough_recover 
destring child_cough_recover, replace
replace child_cough_recover = .m if child_cough_still != 0
tab child_cough_recover, m

// child_cough_recoverunit 
destring child_cough_recoverunit, replace
replace child_cough_recoverunit = .m if child_cough_still != 0
tab child_cough_recoverunit, m


tab child_ill_fever, m

// child_fever_treat 
destring child_fever_treat, replace
replace child_fever_treat = .m if child_ill_fever != 1
tab child_fever_treat, m

// child_fever_notreat 
destring child_fever_notreat, replace
replace child_fever_notreat = .d if child_fever_notreat == 999
replace child_fever_notreat = .m if child_fever_treat != 0
tab child_fever_notreat, m

// child_fever_notreat_oth

// child_fever_notice 
destring child_fever_notice, replace
replace child_fever_notice = .m if child_fever_treat != 1 
tab child_fever_notice, m

// child_fever_notice_unit 
destring child_fever_notice_unit, replace
replace child_fever_notice_unit = .m if child_fever_treat != 1 
tab child_fever_notice_unit, m

// child_fever_where 
destring child_fever_where, replace
replace child_fever_where = .m if child_fever_treat != 1 
tab child_fever_where, m

// child_fever_where_oth 

// child_fever_else 
destring child_fever_else, replace
replace child_fever_else = .m if child_fever_treat != 1 
tab child_fever_else, m

// child_fever_else_oth 

// child_fever_pay 
destring child_fever_pay, replace
replace child_fever_pay = .d if child_fever_pay == 999 
replace child_fever_pay = .m if child_fever_treat != 1 
tab child_fever_pay, m

// child_fever_amount 
destring child_fever_amount, replace
replace child_fever_amount = 0 if child_fever_pay == 0 
replace child_fever_amount = .m if child_fever_treat != 1 
replace child_fever_amount = .m if mi(child_fever_pay) 
tab child_fever_amount, m

// child_fever_items 
local feveritem	child_fever_items1 child_fever_items2 child_fever_items3 child_fever_items4 child_fever_items5 child_fever_items6 child_fever_items888 

foreach var in `feveritem' {
	destring `var', replace
	replace `var' = .m if mi(child_fever_amount)
	tab `var', m
}

// child_fever_loan 
destring child_fever_loan, replace
replace child_fever_loan = .r if child_fever_loan == 777 
replace child_fever_loan = .m if child_fever_pay != 1 
tab child_fever_loan, m

// child_fever_items_oth 

// child_fever_still 
destring child_fever_still, replace
replace child_fever_still = .m if child_ill_fever != 1 
tab child_fever_still, m

// child_fever_recover 
destring child_fever_recover, replace
replace child_fever_recover = .m if child_fever_still != 0
tab child_fever_recover, m

// child_fever_recoverunit 
destring child_fever_recoverunit, replace
replace child_fever_recoverunit = .m if child_fever_still != 0
tab child_fever_recoverunit, m

// child_fever_malaria
destring child_fever_malaria, replace
replace child_fever_malaria = .d if child_fever_malaria == 999 
replace child_fever_malaria = .m if child_ill_fever != 1 
tab child_fever_malaria, m


// SEEKING TREATMENT BY SKILLED HEALTHCARE PERSONNEL IN FIRST TIME

local where child_diarrh_where child_cough_where child_fever_where
local val 1 2 3 4 5 6 7 8 9 10 11 12 13 888

foreach var in `where' {
	foreach x in `val' {
		gen `var'_`x' 		= (`var' == `x')
		replace `var'_`x' 	= .m if mi(`var')
		order `var'_`x', after(`var')
	}
}

rename child_diarrh_where_888  child_diarrh_treat_oth
rename child_diarrh_where_13  child_diarrh_treat_amw
rename child_diarrh_where_12  child_diarrh_treat_ngo
rename child_diarrh_where_11  child_diarrh_treat_family
rename child_diarrh_where_10  child_diarrh_treat_eho
rename child_diarrh_where_9  child_diarrh_treat_shop
rename child_diarrh_where_8  child_diarrh_treat_quack
rename child_diarrh_where_7  child_diarrh_treat_healer
rename child_diarrh_where_6  child_diarrh_treat_chw
rename child_diarrh_where_5  child_diarrh_treat_doctor
rename child_diarrh_where_4  child_diarrh_treat_srhc
rename child_diarrh_where_3  child_diarrh_treat_rhc
rename child_diarrh_where_2  child_diarrh_treat_station
rename child_diarrh_where_1 child_diarrh_treat_hosp

rename child_cough_where_888  child_cough_treat_oth
rename child_cough_where_13  child_cough_treat_amw
rename child_cough_where_12  child_cough_treat_ngo
rename child_cough_where_11  child_cough_treat_family
rename child_cough_where_10  child_cough_treat_eho
rename child_cough_where_9  child_cough_treat_shop
rename child_cough_where_8  child_cough_treat_quack
rename child_cough_where_7  child_cough_treat_healer
rename child_cough_where_6  child_cough_treat_chw
rename child_cough_where_5  child_cough_treat_doctor
rename child_cough_where_4  child_cough_treat_srhc
rename child_cough_where_3  child_cough_treat_rhc
rename child_cough_where_2  child_cough_treat_station
rename child_cough_where_1 child_cough_treat_hosp

rename child_fever_where_888  child_fever_treat_oth
rename child_fever_where_13  child_fever_treat_amw
rename child_fever_where_12  child_fever_treat_ngo
rename child_fever_where_11  child_fever_treat_family
rename child_fever_where_10  child_fever_treat_eho
rename child_fever_where_9  child_fever_treat_shop
rename child_fever_where_8  child_fever_treat_quack
rename child_fever_where_7  child_fever_treat_healer
rename child_fever_where_6  child_fever_treat_chw
rename child_fever_where_5  child_fever_treat_doctor
rename child_fever_where_4  child_fever_treat_srhc
rename child_fever_where_3  child_fever_treat_rhc
rename child_fever_where_2  child_fever_treat_station
rename child_fever_where_1 child_fever_treat_hosp

// child_diarrh_treat_oth	child_diarrh_treat_amw	child_diarrh_treat_ngo	child_diarrh_treat_family	child_diarrh_treat_eho	child_diarrh_treat_shop	child_diarrh_treat_quack	child_diarrh_treat_healer	child_diarrh_treat_chw	child_diarrh_treat_doctor	child_diarrh_treat_srhc	child_diarrh_treat_rhc	child_diarrh_treat_station	child_diarrh_treat_hosp			child_cough_treat_oth	child_cough_treat_amw	child_cough_treat_ngo	child_cough_treat_family	child_cough_treat_eho	child_cough_treat_shop	child_cough_treat_quack	child_cough_treat_healer	child_cough_treat_chw	child_cough_treat_doctor	child_cough_treat_srhc	child_cough_treat_rhc	child_cough_treat_station	child_cough_treat_hosp			child_fever_treat_oth	child_fever_treat_amw	child_fever_treat_ngo	child_fever_treat_family	child_fever_treat_eho	child_fever_treat_shop	child_fever_treat_quack	child_fever_treat_healer	child_fever_treat_chw	child_fever_treat_doctor	child_fever_treat_srhc	child_fever_treat_rhc	child_fever_treat_station	child_fever_treat_hosp


local elsewhere child_diarrh_else child_cough_else child_fever_else
local val 0 1 2 3 4 5 6 7 8 9 10 11 12 13 888

foreach var in `elsewhere' {
	foreach x in `val' {
		gen `var'_`x' 		= (`var' == `x')
		replace `var'_`x' 	= .m if mi(`var')
		order `var'_`x', after(`var')
	}
}

rename child_diarrh_else_888 child_diarrh_else_othc
rename child_diarrh_else_13 child_diarrh_else_amw
rename child_diarrh_else_12 child_diarrh_else_ngo
rename child_diarrh_else_11 child_diarrh_else_family
rename child_diarrh_else_10 child_diarrh_else_eho
rename child_diarrh_else_9 child_diarrh_else_shop
rename child_diarrh_else_8 child_diarrh_else_quack
rename child_diarrh_else_7 child_diarrh_else_healer
rename child_diarrh_else_6 child_diarrh_else_chw
rename child_diarrh_else_5 child_diarrh_else_doctor
rename child_diarrh_else_4 child_diarrh_else_srhc
rename child_diarrh_else_3 child_diarrh_else_rhc
rename child_diarrh_else_2 child_diarrh_else_station
rename child_diarrh_else_1 child_diarrh_else_hosp
rename child_diarrh_else_0 child_diarrh_else_no

rename child_cough_else_888 child_cough_else_othc
rename child_cough_else_13 child_cough_else_amw
rename child_cough_else_12 child_cough_else_ngo
rename child_cough_else_11 child_cough_else_family
rename child_cough_else_10 child_cough_else_eho
rename child_cough_else_9 child_cough_else_shop
rename child_cough_else_8 child_cough_else_quack
rename child_cough_else_7 child_cough_else_healer
rename child_cough_else_6 child_cough_else_chw
rename child_cough_else_5 child_cough_else_doctor
rename child_cough_else_4 child_cough_else_srhc
rename child_cough_else_3 child_cough_else_rhc
rename child_cough_else_2 child_cough_else_station
rename child_cough_else_1 child_cough_else_hosp
rename child_cough_else_0 child_cough_else_no

rename child_fever_else_888 child_fever_else_othc
rename child_fever_else_13 child_fever_else_amw
rename child_fever_else_12 child_fever_else_ngo
rename child_fever_else_11 child_fever_else_family
rename child_fever_else_10 child_fever_else_eho
rename child_fever_else_9 child_fever_else_shop
rename child_fever_else_8 child_fever_else_quack
rename child_fever_else_7 child_fever_else_healer
rename child_fever_else_6 child_fever_else_chw
rename child_fever_else_5 child_fever_else_doctor
rename child_fever_else_4 child_fever_else_srhc
rename child_fever_else_3 child_fever_else_rhc
rename child_fever_else_2 child_fever_else_station
rename child_fever_else_1 child_fever_else_hosp
rename child_fever_else_0 child_fever_else_no


local notreat child_diarrh_notreat child_cough_notreat child_fever_notreat
local val 1 2 3 4 5 6 7 8 888

foreach var in `notreat' {
	foreach x in `val' {
		gen `var'_`x' 		= (`var' == `x')
		replace `var'_`x' 	= .m if mi(`var')
		order `var'_`x', after(`var')
	}
}

rename child_diarrh_notreat_888 child_diarrh_notx_oth
rename child_diarrh_notreat_8 child_diarrh_notx_dk
rename child_diarrh_notreat_7 child_diarrh_notx_alter
rename child_diarrh_notreat_6 child_diarrh_notx_askno
rename child_diarrh_notreat_5 child_diarrh_notx_nobl
rename child_diarrh_notreat_4 child_diarrh_notx_exp
rename child_diarrh_notreat_3 child_diarrh_notx_hfacc
rename child_diarrh_notreat_2 child_diarrh_notx_hffar
rename child_diarrh_notreat_1 child_diarrh_notx_hfno

rename child_cough_notreat_888 child_cough_notx_oth
rename child_cough_notreat_8 child_cough_notx_dk
rename child_cough_notreat_7 child_cough_notx_alter
rename child_cough_notreat_6 child_cough_notx_askno
rename child_cough_notreat_5 child_cough_notx_nobl
rename child_cough_notreat_4 child_cough_notx_exp
rename child_cough_notreat_3 child_cough_notx_hfacc
rename child_cough_notreat_2 child_cough_notx_hffar
rename child_cough_notreat_1 child_cough_notx_hfno

rename child_fever_notreat_888 child_fever_notx_oth
rename child_fever_notreat_8 child_fever_notx_dk
rename child_fever_notreat_7 child_fever_notx_alter
rename child_fever_notreat_6 child_fever_notx_askno
rename child_fever_notreat_5 child_fever_notx_nobl
rename child_fever_notreat_4 child_fever_notx_exp
rename child_fever_notreat_3 child_fever_notx_hfacc
rename child_fever_notreat_2 child_fever_notx_hffar
rename child_fever_notreat_1 child_fever_notx_hfno


// child_diarrh_else_oth	child_diarrh_else_amw	child_diarrh_else_ngo	child_diarrh_else_family	child_diarrh_else_eho	child_diarrh_else_shop	child_diarrh_else_quack	child_diarrh_else_healer	child_diarrh_else_chw	child_diarrh_else_doctor	child_diarrh_else_srhc	child_diarrh_else_rhc	child_diarrh_else_station	child_diarrh_else_hosp	child_diarrh_else_no		child_cough_else_oth	child_cough_else_amw	child_cough_else_ngo	child_cough_else_family	child_cough_else_eho	child_cough_else_shop	child_cough_else_quack	child_cough_else_healer	child_cough_else_chw	child_cough_else_doctor	child_cough_else_srhc	child_cough_else_rhc	child_cough_else_station	child_cough_else_hosp	child_cough_else_no		child_fever_else_oth	child_fever_else_amw	child_fever_else_ngo	child_fever_else_family	child_fever_else_eho	child_fever_else_shop	child_fever_else_quack	child_fever_else_healer	child_fever_else_chw	child_fever_else_doctor	child_fever_else_srhc	child_fever_else_rhc	child_fever_else_station	child_fever_else_hosp	child_fever_else_no

// child_ill_no child_ill_yes child_ill_diarrhea child_ill_cough child_ill_fever child_ill_other

gen child_ill_yes = (child_ill_diarrhea == 1 | child_ill_cough ==  1 | child_ill_fever ==  1)
replace child_ill_yes = .m if mi(child_ill_diarrhea) & mi(child_ill_cough) & mi(child_ill_fever)
order child_ill_yes, after(child_ill_no)
tab child_ill_yes, m


* any health personnel or health institution excluding CHWs
local trained	_ngo _eho _doctor _srhc _rhc _station _hosp
local where child_diarrh_ child_cough_ child_fever_

foreach var in `where' {
	gen `var'hp		= 0
	replace `var'hp	= .m if mi(`var'where)
	order `var'hp, after(`var'where)
	
	foreach x in `trained' {
		replace `var'hp = 1 if `var'treat`x' == 1
	}
}

gen child_ill_treat		= (child_diarrh_treat ==1 | child_cough_treat ==1 | child_fever_treat == 1)
replace child_ill_treat	= .m if mi(child_diarrh_treat) & mi(child_cough_treat) & mi(child_fever_treat)
tab child_ill_treat, m

gen child_ill_hp 		= (child_diarrh_hp == 1 | child_cough_hp == 1 | child_fever_hp ==1)
replace child_ill_hp 	= .m if mi(child_diarrh_hp) & mi(child_cough_hp) & mi(child_fever_hp)
tab child_ill_hp, m

order child_ill_yes child_ill_treat child_ill_hp, after(child_ill)

*** reporting variables ***
lab var child_ill_yes				"ill"
lab var child_ill_treat 			"ill take treatment"
lab var child_ill_hp				"ill take treatment with trained health personnel" 

lab var child_ill_diarrhea 			"diarrhea"
lab var child_diarrh_treat 			"diarrhea take treatment"
lab var child_diarrh_hp 			"diarrhea take treatment with trained health personnel" 
lab var child_diarrh_pay 			"diarrhea pay"
lab var child_diarrh_amount 		"diarrhea cost"
lab var child_diarrh_loan 			"diarrhea loan"
lab var child_diarrh_still			"diarrhea still"

lab var child_diarrh_treat_hosp 	"diarrhea treat at hospital"
lab var child_diarrh_treat_station 	"diarrhea treat at station hospital"
lab var child_diarrh_treat_rhc 		"diarrhea treat at RHC"
lab var child_diarrh_treat_srhc 	"diarrhea treat at SRHC"
lab var child_diarrh_treat_doctor 	"diarrhea treat at private clinic" 
lab var child_diarrh_treat_eho 		"diarrhea treat at EHO clinics"
lab var child_diarrh_treat_ngo		"diarrhea treat at NGO clinics"
	
lab var child_diarrh_treat_chw		"diarrhea treat with CHW"
lab var child_diarrh_treat_healer	"diarrhea treat with traditional healer"
lab var child_diarrh_treat_quack	"diarrhea treat with Quack"
lab var child_diarrh_treat_shop		"diarrhea treat with medicines from shop"
lab var child_diarrh_treat_family	"diarrhea treat with family members"
lab var child_diarrh_treat_amw		"diarrhea treat with AMW"
lab var child_diarrh_treat_oth		"diarrhea treat with other personnel" 

lab var child_diarrh_else_no 		"diarrhea take no treatment else"
lab var child_diarrh_else_hosp 		"diarrhea treat at hospital"
lab var child_diarrh_else_station 	"diarrhea treat at station hospital"
lab var child_diarrh_else_rhc 		"diarrhea treat at RHC"
lab var child_diarrh_else_srhc	 	"diarrhea treat at SRHC"
lab var child_diarrh_else_doctor 	"diarrhea treat at private clinic" 
lab var child_diarrh_else_eho 		"diarrhea treat at EHO clinics"
lab var child_diarrh_else_ngo		"diarrhea treat at NGO clinics"
	
lab var child_diarrh_else_chw		"diarrhea treat with CHW"
lab var child_diarrh_else_healer	"diarrhea treat with traditional healer"
lab var child_diarrh_else_quack		"diarrhea treat with Quack"
lab var child_diarrh_else_shop		"diarrhea treat with medicines from shop"
lab var child_diarrh_else_family	"diarrhea treat with family members"
lab var child_diarrh_else_amw		"diarrhea treat with AMW"
lab var child_diarrh_else_othc		"diarrhea treat with other personnel" 

lab var child_diarrh_notx_hfno		"diarrhea - no health facilities"
lab var child_diarrh_notx_hffar		"diarrhea - far from health facilities"
lab var child_diarrh_notx_hfacc		"diarrhea - not accessable to health facilities"
lab var child_diarrh_notx_exp		"diarrhea - expensive treatment"
lab var child_diarrh_notx_nobl		"diarrhea - no belive treatment was necessary"
lab var child_diarrh_notx_askno		"diarrhea - asked not to take treatment at health facilities"
lab var child_diarrh_notx_alter		"diarrhea - used alternative treatment"
lab var child_diarrh_notx_dk		"diarrhea - don't know about seeking treatment"
lab var child_diarrh_notx_oth		"diarrhea - other reason"

lab var child_ill_cough 			"cough"
lab var child_cough_treat 			"cough take treatment"
lab var child_cough_hp 				"cough take treatment with trained health personnel" 
lab var child_cough_pay 			"cough pay"
lab var child_cough_amount 			"cough cost"
lab var child_cough_loan 			"cough loan"
lab var child_cough_still			"cough still"

lab var child_cough_treat_hosp 		"cough treat at hospital"
lab var child_cough_treat_station 	"cough treat at station hospital"
lab var child_cough_treat_rhc 		"cough treat at RHC"
lab var child_cough_treat_srhc	 	"cough treat at SRHC"
lab var child_cough_treat_doctor 	"cough treat at private clinic" 
lab var child_cough_treat_eho 		"cough treat at EHO clinics"
lab var child_cough_treat_ngo		"cough treat at NGO clinics"

lab var child_cough_treat_chw		"cough treat with CHW"
lab var child_cough_treat_healer	"cough treat with traditional healer"
lab var child_cough_treat_quack		"cough treat with Quack"
lab var child_cough_treat_shop		"cough treat with medicines from shop"
lab var child_cough_treat_family	"cough treat with family members"
lab var child_cough_treat_amw		"cough treat with AMW"
lab var child_cough_treat_oth		"cough treat with other personnel" 

lab var child_cough_else_no 		"cough take no treatment else"
lab var child_cough_else_hosp 		"cough treat at hospital"
lab var child_cough_else_station 	"cough treat at station hospital"
lab var child_cough_else_rhc 		"cough treat at RHC"
lab var child_cough_else_srhc	 	"cough treat at SRHC"
lab var child_cough_else_doctor 	"cough treat at private clinic" 
lab var child_cough_else_eho 		"cough treat at EHO clinics"
lab var child_cough_else_ngo		"cough treat at NGO clinics"

lab var child_cough_else_chw		"cough treat with CHW"
lab var child_cough_else_healer		"cough treat with traditional healer"
lab var child_cough_else_quack		"cough treat with Quack"
lab var child_cough_else_shop		"cough treat with medicines from shop"
lab var child_cough_else_family		"cough treat with family members"
lab var child_cough_else_amw		"cough treat with AMW"
lab var child_cough_else_othc		"cough treat with other personnel" 

lab var child_cough_notx_hfno		"cough - no health facilities"
lab var child_cough_notx_hffar		"cough - far from health facilities"
lab var child_cough_notx_hfacc		"cough - not accessable to health facilities"
lab var child_cough_notx_exp		"cough - expensive treatment"
lab var child_cough_notx_nobl		"cough - no belive treatment was necessary"
lab var child_cough_notx_askno		"cough - asked not to take treatment at health facilities"
lab var child_cough_notx_alter		"cough - used alternative treatment"
lab var child_cough_notx_dk			"cough - don't know about seeking treatment"
lab var child_cough_notx_oth		"cough - other reason"
      
lab var child_ill_fever 			"fever"
lab var child_fever_treat 			"fever take treatment"
lab var child_fever_hp 				"fever take treatment with trained health personnel" 
lab var child_fever_pay 			"fever pay"
lab var child_fever_amount 			"fever cost"
lab var child_fever_loan 			"fever loan"
lab var child_fever_still			"fever still"
lab var child_fever_malaria			"fever tested maleria"

lab var child_fever_treat_hosp 		"fever treat at hospital"
lab var child_fever_treat_station 	"fever treat at station hospital"
lab var child_fever_treat_rhc 		"fever treat at RHC"
lab var child_fever_treat_srhc 		"fever treat at SRHC"
lab var child_fever_treat_doctor 	"fever treat at private clinic" 
lab var child_fever_treat_eho 		"fever treat at EHO clinics"
lab var child_fever_treat_ngo		"fever treat at NGO clinics"
	
lab var child_fever_treat_chw		"fever treat with CHW"
lab var child_fever_treat_healer	"fever treat with traditional healer"
lab var child_fever_treat_quack		"fever treat with Quack"
lab var child_fever_treat_shop		"fever treat with medicines from shop"
lab var child_fever_treat_family	"fever treat with family members"
lab var child_fever_treat_amw		"fever treat with AMW"
lab var child_fever_treat_oth		"fever treat with other personnel" 

lab var child_fever_else_no 		"fever take no treatment else"
lab var child_fever_else_hosp 		"fever treat at hospital"
lab var child_fever_else_station 	"fever treat at station hospital"
lab var child_fever_else_rhc 		"fever treat at RHC"
lab var child_fever_else_srhc	 	"fever treat at SRHC"
lab var child_fever_else_doctor 	"fever treat at private clinic" 
lab var child_fever_else_eho 		"fever treat at EHO clinics"
lab var child_fever_else_ngo		"fever treat at NGO clinics"

lab var child_fever_else_chw		"fever treat with CHW"
lab var child_fever_else_healer		"fever treat with traditional healer"
lab var child_fever_else_quack		"fever treat with Quack"
lab var child_fever_else_shop		"fever treat with medicines from shop"
lab var child_fever_else_family		"fever treat with family members"
lab var child_fever_else_amw		"fever treat with AMW"
lab var child_fever_else_othc		"fever treat with other personnel" 

lab var child_fever_notx_hfno		"fever - no health facilities"
lab var child_fever_notx_hffar		"fever - far from health facilities"
lab var child_fever_notx_hfacc		"fever - not accessable to health facilities"
lab var child_fever_notx_exp		"fever - expensive treatment"
lab var child_fever_notx_nobl		"fever - no belive treatment was necessary"
lab var child_fever_notx_askno		"fever - asked not to take treatment at health facilities"
lab var child_fever_notx_alter		"fever - used alternative treatment"
lab var child_fever_notx_dk			"fever - don't know about seeking treatment"
lab var child_fever_notx_oth		"fever - other reason"

lab var child_ill_other				"other type of illness" 
		
global illness	child_ill_yes child_ill_treat child_ill_hp ///
				child_ill_diarrhea child_diarrh_treat child_diarrh_hp child_diarrh_pay child_diarrh_amount child_diarrh_loan child_diarrh_still ///
				child_diarrh_treat_hosp child_diarrh_treat_station child_diarrh_treat_rhc child_diarrh_treat_srhc child_diarrh_treat_doctor child_diarrh_treat_eho child_diarrh_treat_ngo ///		
				child_diarrh_treat_chw child_diarrh_treat_healer child_diarrh_treat_quack child_diarrh_treat_shop child_diarrh_treat_family child_diarrh_treat_amw child_diarrh_treat_oth ///
				child_diarrh_else_no child_diarrh_else_hosp child_diarrh_else_station child_diarrh_else_rhc child_diarrh_else_srhc child_diarrh_else_doctor child_diarrh_else_eho child_diarrh_else_ngo ///
				child_diarrh_else_chw child_diarrh_else_healer child_diarrh_else_quack child_diarrh_else_shop child_diarrh_else_family child_diarrh_else_amw child_diarrh_else_othc ///
				child_diarrh_notx_hfno child_diarrh_notx_hffar child_diarrh_notx_hfacc child_diarrh_notx_exp child_diarrh_notx_nobl child_diarrh_notx_askno child_diarrh_notx_alter child_diarrh_notx_dk child_diarrh_notx_oth ///
				child_ill_cough child_cough_treat child_cough_hp child_cough_pay child_cough_amount child_cough_loan child_cough_still ///
				child_cough_treat_hosp child_cough_treat_station child_cough_treat_rhc child_cough_treat_srhc child_cough_treat_doctor child_cough_treat_eho child_cough_treat_ngo ///								
				child_cough_treat_chw child_cough_treat_healer child_cough_treat_quack child_cough_treat_shop child_cough_treat_family child_cough_treat_amw child_cough_treat_oth ///
				child_cough_else_no child_cough_else_hosp child_cough_else_station child_cough_else_rhc child_cough_else_srhc child_cough_else_doctor child_cough_else_eho child_cough_else_ngo ///									
				child_cough_else_chw child_cough_else_healer child_cough_else_quack child_cough_else_shop child_cough_else_family child_cough_else_amw child_cough_else_othc ///
				child_cough_notx_hfno child_cough_notx_hffar child_cough_notx_hfacc child_cough_notx_exp child_cough_notx_nobl child_cough_notx_askno child_cough_notx_alter child_cough_notx_dk child_cough_notx_oth ///
				child_ill_fever child_fever_treat child_fever_hp child_fever_pay child_fever_amount child_fever_loan child_fever_still child_fever_malaria ///
				child_fever_treat_hosp child_fever_treat_station child_fever_treat_rhc child_fever_treat_srhc child_fever_treat_doctor child_fever_treat_eho child_fever_treat_ngo ///
				child_fever_treat_chw child_fever_treat_healer child_fever_treat_quack child_fever_treat_shop child_fever_treat_family child_fever_treat_amw child_fever_treat_oth ///
				child_fever_else_no child_fever_else_hosp child_fever_else_station child_fever_else_rhc child_fever_else_srhc child_fever_else_doctor child_fever_else_eho child_fever_else_ngo ///
				child_fever_else_chw child_fever_else_healer child_fever_else_quack child_fever_else_shop child_fever_else_family child_fever_else_amw child_fever_else_othc ///
				child_fever_notx_hfno child_fever_notx_hffar child_fever_notx_hfacc child_fever_notx_exp child_fever_notx_nobl child_fever_notx_askno child_fever_notx_alter child_fever_notx_dk child_fever_notx_oth ///
				child_ill_other

				
				
save "$cdta/child_nonanthro_cleanded.dta", replace

