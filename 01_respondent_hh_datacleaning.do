/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROJECT:		CPI - CHDN Nutrition Security Report

PURPOSE: 		Prepare Respondent and HH dataset

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:
   

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

**-----------------------------------------------------**
** PPI Score
**-----------------------------------------------------**
** vi dataset 
use "$dta/hh_roster_vi.dta", clear

destring test hh_mem_age hh_mem_highedu hh_mem_relation, replace

* hh head education 
* note some hh with no hh head 
gen hh_head = (hh_mem_relation == 1)
replace hh_head = .m if mi(hh_mem_relation) |  hh_mem_relation == 999
tab hh_head, m

bysort key: egen hh_head_count = total(hh_head)
tab hh_head_count, m

* assume number one hh member position as hh head
gen hh_head_edu 	= hh_mem_highedu
replace hh_head_edu = .m if hh_mem_relation != 1
replace hh_head_edu = .m if hh_mem_highedu == 999
tab hh_head_edu, m

bysort key: replace hh_head_edu = hh_mem_highedu if hh_head_count == 0 & test == 1


* hh member 0 - 5 years old numbers
gen hh_mem_u5 		= (hh_mem_age < 5)
replace hh_mem_u5 	= .m if mi(hh_mem_age) 
tab hh_mem_u5, m

bysort key: egen hh_u5_count = total(hh_mem_u5)
tab hh_u5_count, m


* hh member 5 - 9 years old members
gen hh_mem_5to9 		= (hh_mem_age >= 5 & hh_mem_age <10)
replace hh_mem_5to9 	= .m if mi(hh_mem_age) 
tab hh_mem_5to9, m

bysort key: egen hh_5to9_count = total(hh_mem_5to9)
tab hh_5to9_count, m

//drop if hh_mem_relation != 1

//destring test hh_mem_relation, replace
sort test key
keep if !mi(hh_head_edu)

duplicates drop key, force

keep hh_mem_name hh_head_edu hh_u5_count hh_5to9_count hh_mem_relation hh_mem_key key

save "$dta/hh_roster_ppi_vi.dta", replace

** chdn dataset 
use "$dta/hh_roster_chdn.dta", clear

destring test hh_mem_age hh_mem_highedu hh_mem_relation, replace

* hh head education 
* note some hh with no hh head 
gen hh_head = (hh_mem_relation == 1)
replace hh_head = .m if mi(hh_mem_relation) |  hh_mem_relation == 999
tab hh_head, m

bysort key: egen hh_head_count = total(hh_head)
tab hh_head_count, m

* assume number one hh member position as hh head
gen hh_head_edu 	= hh_mem_highedu
replace hh_head_edu = .m if hh_mem_relation != 1
replace hh_head_edu = .m if hh_mem_highedu == 999
tab hh_head_edu, m

bysort key: replace hh_head_edu = hh_mem_highedu if hh_head_count == 0 & test == 1


* hh member 0 - 5 years old numbers
gen hh_mem_u5 		= (hh_mem_age < 5)
replace hh_mem_u5 	= .m if mi(hh_mem_age) 
tab hh_mem_u5, m

bysort key: egen hh_u5_count = total(hh_mem_u5)
tab hh_u5_count, m


* hh member 5 - 9 years old members
gen hh_mem_5to9 		= (hh_mem_age >= 5 & hh_mem_age <10)
replace hh_mem_5to9 	= .m if mi(hh_mem_age) 
tab hh_mem_5to9, m

bysort key: egen hh_5to9_count = total(hh_mem_5to9)
tab hh_5to9_count, m

//drop if hh_mem_relation != 1

//destring test hh_mem_relation, replace
sort test key
keep if !mi(hh_head_edu)

duplicates drop key, force

keep hh_mem_name hh_head_edu hh_u5_count hh_5to9_count hh_mem_relation hh_mem_key key

save "$dta/hh_roster_ppi_chdn.dta", replace
clear

**-----------------------------------------------------**
**  PREPARE DATASETS FOR DATA CLEANING  **
**-----------------------------------------------------**

use "$dta/respondent_chdn.dta", clear
merge 1:1 key using "$dta/hh_roster_ppi_chdn.dta", keepusing(hh_head_edu hh_u5_count hh_5to9_count)
drop _merge

tempfile chdn
save `chdn', replace
clear

use "$dta/respondent_vi.dta", clear

** data correction **
drop if mi(geo_villward)
drop if geo_vill == "168652" & sample_component == "1"
drop if key == "350"

gen _index = key
destring _index, replace

if !mi("$raw/correction/mcct_baseline_correction.xlsx") {
	readreplace using "$raw/correction/mcct_baseline_correction.xlsx", ///
	    id("_index") ///
		variable("variable") ///
		value("newvalue") ///
		excel ///
		import(firstrow)
}

drop _index

merge 1:1 key using "$dta/hh_roster_ppi_vi.dta", keepusing(hh_head_edu hh_u5_count hh_5to9_count)

drop if _merge == 2
drop _merge

append using `chdn', gen(source) 

// will_participate
destring will_participate, replace
tab will_participate, m

destring respd_who, replace
replace respd_who = .m if will_participate == 0
tab respd_who, m

**-----------------------------------------------------**
** GEOGRAPHICAL AREA
**-----------------------------------------------------**
destring geo_rural, replace
lab def geo_rural 0"Rural" 1"Urban" 2"Hard to reach"
lab val geo_rural geo_rural
tab geo_rural, m

forvalue x = 0/2 {
	gen geo_rural_`x' = (geo_rural == `x')
	replace geo_rural_`x'	= .m if mi(geo_rural)
	order geo_rural_`x', after(geo_rural)
	tab geo_rural_`x', m
}

rename geo_rural_0	rural 
rename geo_rural_1	urban
rename geo_rural_2 	eho

forvalue x = 0/2 {
	gen consent_yes_`x' 	= (will_participate == 1 & geo_rural == `x')
	replace consent_yes_`x'	= .m if geo_rural != `x' | mi(will_participate)
	order consent_yes_`x', after(will_participate)
	tab consent_yes_`x', m
}

rename consent_yes_0	consent_yes_rural  
rename consent_yes_1	consent_yes_urban 
rename consent_yes_2	consent_yes_eho 


** reporting variables **
lab var geo_rural	"geographical area"
lab var urban		"Urban"
lab var rural		"Rural"
lab var eho			"Heard to reach area"

lab var will_participate	"consent yes"
lab var consent_yes_urban	"consent yes - urban"
lab var consent_yes_rural	"consent yes - rural"
lab var consent_yes_eho		"consent yes - hard to reach area"

global geo	geo_rural urban rural eho will_participate consent_yes_urban consent_yes_rural consent_yes_eho 

**-----------------------------------------------------**
** Poverty Propobility Index
**-----------------------------------------------------**
destring	house_electric water_rain house_roof1 house_roof2 house_roof3 ///
			house_wall1 house_wall2 house_wall3 house_wall4 house_wall5 house_wall6 ///
			house_cooking hhbeef_freq , replace

* ppi score generation 
gen ppi_1		= 0 if geo_state == "MMR002" | geo_state == "MMR003"
replace ppi_1	= .m if mi(geo_state)
tab ppi_1, m

gen ppi_2		= 0 if hh_u5_count >= 2
replace ppi_2	= 8 if hh_u5_count == 1
replace ppi_2	= 14 if hh_u5_count == 0
replace ppi_2	= .m if mi(hh_u5_count)
tab ppi_2, m

gen ppi_3		= 0 if hh_5to9_count >= 2
replace ppi_3	= 8 if hh_5to9_count == 1
replace ppi_3	= 12 if hh_5to9_count == 0
replace ppi_3	= .m if mi(hh_5to9_count)
tab ppi_3, m

gen ppi_4		= 0 
replace ppi_4 	= 9 if house_electric == 1
replace ppi_4	= .m if mi(house_electric)
tab ppi_4, m

gen ppi_5		= 0 
replace ppi_5 	= 11 if water_rain == 1 | water_rain == 5 | water_rain == 12
replace ppi_5	= .m if mi(water_rain)
tab ppi_5, m

gen ppi_6		= 0 if house_roof1 == 1
replace ppi_6 	= 7 if house_roof1 != 1 & !mi(house_roof1)
replace ppi_6	= .m if mi(house_roof)
tab ppi_6, m

gen ppi_7		= 0 if house_wall3 == 1
replace ppi_7 	= 10 if house_wall3 != 1 & !mi(house_wall3)
replace ppi_7	= .m if mi(house_wall)
tab ppi_7, m // vi took 9 instead of 10

gen ppi_8		= 8 if house_cooking == 4
replace ppi_8 	= 0 if house_cooking != 4 & !mi(house_cooking)
replace ppi_8	= .m if mi(house_cooking)
tab ppi_8, m

gen ppi_9		= 0 
replace ppi_9	= 7 if hh_head_edu == 3
replace ppi_9 	= 12 if hh_head_edu == 4 | hh_head_edu == 6
replace ppi_9	= .m if mi(hh_head_edu)
tab ppi_9, m

gen ppi_10		= 0 
replace ppi_10	= 11 if hhbeef_freq > 0 & !mi(hhbeef_freq)
replace ppi_10	= .m if mi(hhbeef_freq)
tab ppi_10, m

egen ppi_score 		= rowtotal(ppi_1 ppi_2 ppi_3 ppi_4 ppi_5 ppi_6 ppi_7 ppi_8 ppi_9 ppi_10)
replace ppi_score 	= .m if mi(ppi_1) | mi(ppi_2) | mi(ppi_3) | mi(ppi_4) | ///
							mi(ppi_5) | mi(ppi_6) | mi(ppi_7) | mi(ppi_8) | ///
							mi(ppi_9) | mi(ppi_10)
tab ppi_score, m

merge m:1 ppi_score using "$dta/ppi_lookup_table.dta", keepusing(national_povt_line extreme_povt_line)

drop if _merge == 2
drop _merge

* wealth quantile ranking
sum extreme_povt_line, d
_pctile national_povt_line, p(20, 40, 60, 80)

gen wealth_quintile 	= (national_povt_line > `r(r4)')
replace wealth_quintile	= 2 if (national_povt_line > `r(r3)' & national_povt_line <= `r(r4)')
replace wealth_quintile	= 3 if (national_povt_line > `r(r2)' & national_povt_line <= `r(r3)')
replace wealth_quintile	= 4 if (national_povt_line > `r(r1)' & national_povt_line <= `r(r2)')
replace wealth_quintile	= 5 if (national_povt_line <= `r(r1)')
replace wealth_quintile	= .m if mi(national_povt_line)

lab def wealth_quintile	1"Poorest" 2"Poor" 3"Medium" 4"Wealthy" 5"Wealthiest"
lab val wealth_quintile wealth_quintile
tab wealth_quintile, m

forvalue x = 1/5 {
	gen wealth_quintile`x' = (wealth_quintile == `x')
	replace wealth_quintile`x'	= .m if mi(wealth_quintile)
	order wealth_quintile`x', after(wealth_quintile)
	tab wealth_quintile`x', m
}


rename wealth_quintile5 wealth_wealthiest 
rename wealth_quintile4 wealth_wealthy 
rename wealth_quintile3 wealth_medium
rename wealth_quintile2 wealth_poor
rename wealth_quintile1 wealth_poorest

** reporting variables **
lab var national_povt_line		"poverty likelihood - National Poverty Line"
lab var wealth_quintile			"wealth quantile ranking"
lab var wealth_poorest 			"wealth quantile - poorest"
lab var wealth_poor 			"wealth quantile - poor"
lab var wealth_medium 			"wealth quantile - medium"
lab var wealth_wealthy 			"wealth quantile - wealthy"
lab var wealth_wealthiest		"wealth quantile - wealthiest"

global ppi	national_povt_line wealth_quintile ///
			wealth_poorest wealth_poor wealth_medium wealth_wealthy wealth_wealthiest

**-----------------------------------------------------**
** Women Dietary Diversity 
**-----------------------------------------------------**

local momdiet mom_rice mom_potatoes mom_pumpkin mom_beans mom_nuts mom_yogurt mom_organ mom_beef mom_fish mom_eggs mom_leafyveg mom_mango mom_veg mom_fruit mom_fat mom_sweets mom_condiments 
foreach var in `momdiet' {
	destring `var', replace
	replace `var' = .m if respd_who != 1
	tab `var', m
}

* Grains
gen momdiet_fg_grains		=	(mom_rice == 1 | mom_potatoes == 1)
replace momdiet_fg_grains	=	.m if mi(mom_rice) & mi(mom_potatoes)
lab var momdiet_fg_grains "Women - Grain"
tab momdiet_fg_grains, m

* Vit Vegetables
gen momdiet_fg_vitveg		=	(mom_leafyveg == 1)
replace momdiet_fg_vitveg	=	.m if mi(mom_leafyveg) 
lab var momdiet_fg_vitveg "Women - Vitamin A riched vegetable"
tab momdiet_fg_vitveg, m

* Vit Fruit
gen momdiet_fg_vitfruit		=	(mom_pumpkin == 1 | mom_mango == 1) 
replace momdiet_fg_vitfruit	=	.m if mi(mom_pumpkin) & mi(mom_mango)
lab var momdiet_fg_vitfruit "Women - Vitamin A riched fruits"
tab momdiet_fg_vitfruit, m

* Fruit
gen momdiet_fg_othfruit		=	(mom_fruit == 1)
replace momdiet_fg_othfruit	=	.m if mi(mom_fruit)
lab var momdiet_fg_othfruit "Women - Other fruit"
tab momdiet_fg_othfruit, m

* Vegetables
gen momdiet_fg_othveg		=	(mom_veg == 1)
replace momdiet_fg_othveg	=	.m if mi(mom_veg)
lab var momdiet_fg_othveg "Women - Other vegetable"
tab momdiet_fg_othveg, m

* Proteins
gen momdiet_fg_meat			=	(mom_beef == 1 | mom_fish == 1 | mom_organ == 1)
replace momdiet_fg_meat		=	.m if mi(mom_beef) & mi(mom_fish) & mi(mom_organ)
lab var momdiet_fg_meat "Women - Meat"
tab momdiet_fg_meat, m

* Eggs
gen momdiet_fg_eggs			=	(mom_eggs == 1)
replace momdiet_fg_eggs		=	.m if mi(mom_eggs)
lab var momdiet_fg_eggs "Women - Eggs"
tab momdiet_fg_eggs, m

* Pulses
gen momdiet_fg_pulses		=	(mom_beans == 1)
replace momdiet_fg_pulses	=	.m if mi(mom_beans) 
lab var momdiet_fg_pulses "Women - Pulses"
tab momdiet_fg_pulses, m

* Nuts
gen momdiet_fg_nut			=	(mom_nuts == 1)
replace momdiet_fg_nut		=	.m if mi(mom_nuts)
lab var momdiet_fg_nut "Women - Nut"
tab momdiet_fg_nut, m

* Dairy
gen momdiet_fg_diary		=	(mom_yogurt == 1)
replace momdiet_fg_diary	=	.m if mi(mom_yogurt)
lab var momdiet_fg_diary "Women - Diary"
tab momdiet_fg_diary, m

** 3) MINIMUM DIETERY DIETARY DIVERSITY SCORE FOR WOMEN
egen momdiet_ddsw	=	rowtotal(momdiet_fg_grains momdiet_fg_vitveg momdiet_fg_vitfruit ///
								momdiet_fg_othfruit momdiet_fg_othveg momdiet_fg_meat ///
								momdiet_fg_eggs momdiet_fg_pulses momdiet_fg_nut ///
								momdiet_fg_diary), missing
replace momdiet_ddsw = .m if respd_who != 1   
//replace `var' = .m if respd_who != 1                   
lab var momdiet_ddsw "Dietary Diversity Score for Women" 
tab momdiet_ddsw, m
sum momdiet_ddsw

** Indicator definition: MDD-W (FAO, FANTA and FHI 360)
** consumed at least five out of ten defined food groups the previous day or night
** proxy indicator for higher micronutrient adequacy, one important dimension of diet quality

gen momdiet_min_ddsw		=	(momdiet_ddsw >= 5)
replace momdiet_min_ddsw	=	.m if mi(momdiet_ddsw)
lab var momdiet_min_ddsw "Women met minimum dietary diversity score"
tab momdiet_min_ddsw, m

// mom_meal_freq
destring mom_meal_freq, replace
replace mom_meal_freq = .m if respd_who != 1 
replace mom_meal_freq = .n if mom_meal_freq == 444 
tab mom_meal_freq, m


** reporting variables **

lab var momdiet_fg_grains 	"women - grain"
lab var momdiet_fg_vitveg 	"women - viamin rich vegetable"
lab var momdiet_fg_vitfruit "women - vitamin rich fruit"
lab var momdiet_fg_othfruit "women - other fruit"
lab var momdiet_fg_othveg 	"women - other vegetable"
lab var momdiet_fg_meat 	"women - meat"
lab var momdiet_fg_eggs 	"women - eggs"
lab var momdiet_fg_pulses 	"women - pulses"
lab var momdiet_fg_nut 		"women - nut"
lab var momdiet_fg_diary	"women - diary"

lab var momdiet_ddsw 		"dietary diversty score - women"
lab var momdiet_min_ddsw	"met minimum dds-w"

lab var mom_meal_freq		"women meal frequency"


global ddsw		momdiet_fg_grains momdiet_fg_vitveg momdiet_fg_vitfruit momdiet_fg_othfruit momdiet_fg_othveg ///
				momdiet_fg_meat momdiet_fg_eggs momdiet_fg_pulses momdiet_fg_nut momdiet_fg_diary ///
				momdiet_ddsw momdiet_min_ddsw ///
				mom_meal_freq

**-----------------------------------------------------**
** Food Consumption Score
**-----------------------------------------------------**
local fcs	hhrice_freq hhpotatoes_freq hhpumpkin_freq hhbeans_freq hhnuts_freq ///
			hhleafyveg_freq hhvitveg_freq hhveg_freq hhmango_freq hhfruit_freq ///
			hhorgan_freq hhbeef_freq hhfish_freq hheggs_freq hhyogurt_freq ///
			hhfat_freq hhsweets_freq 

foreach var in `fcs' {
	destring `var', replace
	replace `var' = .d if `var' == 999
	replace `var' = .m if `var' == 777 |  `var' == 444
}

egen fcs_g1		= rowtotal(hhrice_freq hhpotatoes_freq hhpumpkin_freq)
replace fcs_g1	= .m if will_participate == 0
tab fcs_g1, m

egen fcs_g2		= rowtotal(hhbeans_freq hhnuts_freq)
replace fcs_g2	= .m if will_participate == 0
tab fcs_g2, m

egen fcs_g3		= rowtotal(hhleafyveg_freq hhvitveg_freq hhveg_freq)
replace fcs_g3	= .m if will_participate == 0
tab fcs_g3, m

egen fcs_g4		= rowtotal(hhmango_freq hhfruit_freq)
replace fcs_g4	= .m if will_participate == 0
tab fcs_g4, m
  
egen fcs_g5		= rowtotal(hhorgan_freq hhbeef_freq hhfish_freq hheggs_freq)
replace fcs_g5	= .m if will_participate == 0
tab fcs_g5, m
 
egen fcs_g6		= rowtotal(hhyogurt_freq)
replace fcs_g6	= .m if will_participate == 0
tab fcs_g6, m

egen fcs_g7		= rowtotal(hhfat_freq)
replace fcs_g7	= .m if will_participate == 0
tab fcs_g7, m
  
egen fcs_g8		= rowtotal(hhsweets_freq)
replace fcs_g8	= .m if will_participate == 0
tab fcs_g8, m


forvalue x = 1/8 {
	replace fcs_g`x' = 7 if fcs_g`x' > 7 & !mi(fcs_g`x')
	tab fcs_g`x', m
}

gen fcs_score 		= 	(fcs_g1 * 2) + (fcs_g2 * 3) + (fcs_g3 * 1) + (fcs_g4 * 1) + (fcs_g5 * 4) + ///
						(fcs_g6 * 4) + (fcs_g7 * 0.5) + (fcs_g8 * 0.5)

replace fcs_score 	= .m if will_participate == 0
tab fcs_score, m

gen fcs_poor		= (fcs_score <= 21)
replace fcs_poor 	= .m if mi(fcs_score)
tab fcs_poor, m

gen fcs_borderline		= (fcs_score > 21 & fcs_score <= 35)
replace fcs_borderline 	= .m if mi(fcs_score)
tab fcs_borderline, m

gen fcs_acceptable		= (fcs_score > 35)
replace fcs_acceptable 	= .m if mi(fcs_score)
tab fcs_acceptable, m

** reporting variable **
lab var fcs_score		"food consumption score"
lab var fcs_acceptable	"FCS - acceptable"
lab var fcs_borderline 	"FCS - borderline"
lab var fcs_poor 		"FCS - poor"

global fcs	fcs_score fcs_acceptable fcs_borderline fcs_poor 

**-----------------------------------------------------**
** Coping Strategy Index 
**-----------------------------------------------------**

** consumption based index

local index conindex_prices conindex_borrow conindex_sizelimit conindex_restrictage conindex_reducefreq
foreach var in `index' {
	destring `var', replace
	replace `var' = .m if will_participate == 0 
	
	replace `var' = .d if `var' == 999
	replace `var' = .m if `var' == 666
	replace `var' = .m if `var' == 444
	tab `var', m
}

gen conindex_prices_w 		= conindex_prices * 1
replace conindex_prices_w 	= .m if mi(conindex_prices)
tab conindex_prices_w, m
 
gen conindex_borrow_w 		= conindex_borrow * 2
replace conindex_borrow_w 	= .m if mi(conindex_borrow)
tab conindex_borrow_w, m

gen conindex_sizelimit_w 		= conindex_sizelimit * 1
replace conindex_sizelimit_w 	= .m if mi(conindex_sizelimit)
tab conindex_sizelimit_w, m

gen conindex_restrictage_w 		= conindex_restrictage * 3
replace conindex_restrictage_w 	= .m if mi(conindex_restrictage)
tab conindex_restrictage_w, m

gen conindex_reducefreq_w 		= conindex_reducefreq * 1
replace conindex_reducefreq_w 	= .m if mi(conindex_reducefreq)
tab conindex_reducefreq_w, m

gen csi_score		= 	conindex_prices_w + conindex_borrow_w + conindex_sizelimit_w + ///
						conindex_restrictage_w + conindex_reducefreq_w
replace csi_score	= .m if will_participate == 0 
replace csi_score	= .m if mi(conindex_prices_w) | mi(conindex_borrow_w) | mi(conindex_sizelimit_w) | ///
							mi(conindex_restrictage_w) | mi(conindex_reducefreq_w)
tab  csi_score, m


** livelihood based index
local stress		liveindex_soldhh liveindex_soldanimal liveindex_senthhmem ///
					liveindex_creditfood liveindex_spentsave liveindex_borrow ///
					liveindex_moveschool 
foreach var in `stress' {
	destring `var', replace
	replace `var' = .m if will_participate == 0 
	
	replace `var' = .d if `var' == 999
	replace `var' = .m if `var' == 666
	replace `var' = .m if `var' == 444
	tab `var', m
}

local crisis		liveindex_reducehealth liveindex_harvest liveindex_conseed liveindex_farmexp ///
					liveindex_soldassets liveindex_withdschool
foreach var in `crisis' {
	destring `var', replace
	replace `var' = .m if will_participate == 0 
	
	replace `var' = .d if `var' == 999
	replace `var' = .m if `var' == 666
	replace `var' = .m if `var' == 444
	tab `var', m
}
	
local emergency		 	liveindex_illegal liveindex_newjob liveindex_advance liveindex_soldland ///
						liveindex_femaleanimals liveindex_begged liveindex_hhmigrate
foreach var in `emergency' {
	destring `var', replace
	replace `var' = .m if will_participate == 0 
	
	replace `var' = .d if `var' == 999
	replace `var' = .m if `var' == 666
	replace `var' = .m if `var' == 444
	tab `var', m
}

egen lcis_stress	= rowtotal(liveindex_soldhh liveindex_soldanimal liveindex_spentsave liveindex_borrow)
replace lcis_stress = .m if mi(liveindex_soldhh) | mi(liveindex_soldanimal) | mi(liveindex_spentsave) | mi(liveindex_borrow)
replace lcis_stress = 1 if lcis_stress > 0 & !mi(lcis_stress)
tab lcis_stress, m

egen lcis_crisis	= rowtotal(liveindex_soldassets liveindex_withdschool liveindex_reducehealth)
replace lcis_crisis = .m if mi(liveindex_soldassets) | mi(liveindex_withdschool) | mi(liveindex_reducehealth)
replace lcis_crisis = 1 if lcis_crisis > 0 & !mi(lcis_crisis)
tab lcis_crisis, m

egen lcis_emergency		= rowtotal(liveindex_soldland liveindex_femaleanimals liveindex_begged)
replace lcis_emergency 	= .m if mi(liveindex_soldland) | mi(liveindex_femaleanimals) | mi(liveindex_begged)
replace lcis_emergency  = 1 if lcis_emergency > 0 & !mi(lcis_emergency)
tab lcis_emergency, m

gen lcis_secure			= (lcis_stress == 0 & lcis_crisis == 0 & lcis_emergency == 0)
replace lcis_secure		= .m if mi(lcis_stress) | mi(lcis_crisis) | mi(lcis_emergency)
tab lcis_secure, m

** reporting variables **
lab var csi_score		"consumption based coping strategies index score"
lab var lcis_secure		"livelihood based CSI - secure"
lab var lcis_stress		"livelihood based CSI - stress"
lab var lcis_crisis		"livelihood based CSI - crisis"
lab var lcis_emergency 	"livelihood based CSI - emergency"

global csi	csi_score lcis_secure lcis_stress lcis_crisis lcis_emergency 


**-----------------------------------------------------**
** WASH
**-----------------------------------------------------**

** Water services ladder 
local source water_sum water_rain water_winter

foreach var in `source' {
	destring `var', replace
	tab `var', m
	gen `var'_ladder		= (`var' < 8 | `var' == 9 | `var' == 11 | `var' == 12) 
	replace `var'_ladder	= 3 if `var' == 13
	replace `var'_ladder	= 2 if `var'_ladder == 0
	replace `var'_ladder 	= .m if mi(`var')
	tab `var'_ladder, m
	order `var'_ladder, after(`var')
	
	forvalue x = 1/3 {
		gen `var'_ladder_`x' 		= (`var'_ladder == `x')
		replace `var'_ladder_`x' 	= .m if mi(`var'_ladder)
		tab `var'_ladder_`x', m
		order `var'_ladder_`x', after(`var'_ladder)
	}
}

rename water_sum_ladder_3 		water_sum_surface
rename water_sum_ladder_1 		water_sum_limited
rename water_sum_ladder_2		water_sum_unimprove

rename water_rain_ladder_3		water_rain_surface
rename water_rain_ladder_1 		water_rain_limited
rename water_rain_ladder_2 		water_rain_unimprove

rename water_winter_ladder_3 	water_winter_surface
rename water_winter_ladder_1 	water_winter_limited
rename water_winter_ladder_2	water_winter_unimprove


** Drinking Water Treatment
local treat water_sum_treatmethod water_rain_treatmethod water_winter_treatmethod
gen water_sum_treat_yes 	= 0
gen water_rain_treat_yes 	= 0 
gen water_winter_treat_yes	= 0

forvalue x = 1/7 {
	destring `var', replace
	
	replace water_sum_treat_yes 	= 1 if water_sum_treatmethod`x' == 1
	replace water_sum_treat_yes 	= .m if mi(water_sum_treatmethod)
	replace water_sum_treat_yes = 0 if water_sum_treat == 0
	order water_sum_treat_yes, after(water_sum_treatmethod)
	tab water_sum_treat_yes, m

	replace water_rain_treat_yes 	= 1 if water_rain_treatmethod`x' == 1
	replace water_rain_treat_yes 	= .m if mi(water_rain_treatmethod)
	replace water_rain_treat_yes = 0 if water_rain_treat == 0
	order water_rain_treat_yes, after(water_rain_treatmethod)
	tab water_rain_treat_yes, m
	
	replace water_winter_treat_yes 	= 1 if water_winter_treatmethod`x' == 1
	replace water_winter_treat_yes 	= .m if mi(water_winter_treatmethod)
	replace water_winter_treat_yes = 0 if water_winter_treat == 0
	order water_winter_treat_yes, after(water_winter_treatmethod)
	tab water_winter_treat_yes, m	
}


** Sanitation services ladder
destring latrine_type latrine_share, replace
local value 1 2 3 4 5 6 888


foreach x in `value' {
	gen latrine_type_`x' 		= (latrine_type == `x')
	replace latrine_type_`x' 	= .m if mi(latrine_type)
	tab latrine_type_`x', m
	order latrine_type_`x', after(latrine_type)
}

rename latrine_type_1 		latrine_septict
rename latrine_type_2 		latrine_notank
rename latrine_type_3 		latrine_pitproof
rename latrine_type_4 		latrine_pitnoproof
rename latrine_type_5 		latrine_floting
rename latrine_type_6 		latrine_open
rename latrine_type_888		latrine_other

gen latrine_ladder		= (latrine_type < 4 & latrine_share == 0)
replace latrine_ladder	= 2 if latrine_type <4 & latrine_share == 1
replace latrine_ladder	= 3 if latrine_type >= 4 & !mi(latrine_type)
replace latrine_ladder	= 4 if latrine_type == 6
replace latrine_ladder 	= .m if mi(latrine_type) //| mi(latrine_share)
tab latrine_ladder, m

order latrine_ladder, after(latrine_other)

forvalue x = 1/4 {
	gen latrine_ladder`x' 	= (latrine_ladder == `x')
	replace latrine_ladder`x'	= .m if mi(latrine_ladder)
	order latrine_ladder`x', after(latrine_ladder)
	tab latrine_ladder`x', m
}

rename latrine_ladder4	latrine_opendef 
rename latrine_ladder3 	latrine_unimprove
rename latrine_ladder2 	latrine_limited
rename latrine_ladder1 	latrine_basic


** Handwashing service ladders

destring observ_washplace0 observ_washplace1 observ_washplace2 observ_washplace3 observ_washplace4 observ_washplace888 observ_water soap_present, replace

gen handwash_ladder 	=	(observ_washplace1 == 1 | observ_washplace2 == 1 | observ_washplace3 == 1 & ///
							(observ_water == 1 & soap_present == 1))
replace handwash_ladder = 2 if handwash_ladder == 0
replace handwash_ladder = 3 if observ_washplace4 == 1
replace handwash_ladder = .m if mi(observ_water) | mi(soap_present) | observ_washplace0 == 1
tab handwash_ladder, m

order handwash_ladder, after(soap_present)

forvalue x = 1/3 {
	gen handwash_ladder`x' 	= (handwash_ladder == `x')
	replace handwash_ladder`x'	= .m if mi(handwash_ladder)
	order handwash_ladder`x', after(handwash_ladder)
	tab handwash_ladder`x', m
}

rename handwash_ladder3 handwash_no
rename handwash_ladder2 handwash_limited
rename handwash_ladder1 handwash_basic

** reporting variable **
lab var water_sum_limited 		"summer - limited"
lab var water_sum_unimprove 	"summer - unimproved"	
lab var water_sum_surface 		"summer - surface water"
lab var water_rain_limited 		"rain - limited"
lab var water_rain_unimprove 	"rain - unimproved"
lab var water_rain_surface 		"rain - surface water"
lab var water_winter_limited 	"winter - limited"
lab var water_winter_unimprove 	"winter - unimproved"
lab var water_winter_surface 	"winter - surface water"

lab var water_sum_treat_yes 	"summer - treated"
lab var water_rain_treat_yes 	"rain - treated"
lab var water_winter_treat_yes	"winter - treated"

lab var latrine_ladder 			"latrine - ladder"
lab var latrine_basic 			"latrine - basic" 
lab var latrine_limited 		"latrine - limited"
lab var latrine_unimprove 		"latrine - unimproved"
lab var latrine_opendef			"latrine - open defication"

lab var handwash_ladder 		"handwashing ladder"
lab var handwash_basic 			"handwashing - basic"
lab var handwash_limited 		"handwashing - limited"
lab var handwash_no  			"handwashing - no facility"

global wash		water_sum_limited water_sum_unimprove water_sum_surface ///
				water_rain_limited water_rain_unimprove water_rain_surface ///
 				water_winter_limited water_winter_unimprove water_winter_surface ///
				water_sum_treat_yes water_rain_treat_yes water_winter_treat_yes ///
				latrine_ladder latrine_basic latrine_limited latrine_unimprove latrine_opendef ///
				handwash_ladder handwash_basic handwash_limited handwash_no  
				
				
save "$cdta/respondent_cleanded.dta", replace

preserve
keep if source == 0
drop source
save "$cdta/respondent_cleanded_vi.dta", replace
restore

keep if source == 1
drop source
save "$cdta/respondent_cleanded_chdn.dta", replace

clear
**-----------------------------------------------------**
**-----------------------------------------------------**


**-----------------------------------------------------**
**  PREPARE DATASETS FOR ANTHRO DATA CLEANING  **
**-----------------------------------------------------**

use "$dta/anthro_respondent_vi.dta", clear

** data correction **
gen _index = key
destring _index, replace

if !mi("$raw/correction/mcct_baseline_anthro_correction.xlsx") {
	readreplace using "$raw/correction/mcct_baseline_anthro_correction.xlsx", ///
	    id("_index") ///
		variable("variable") ///
		value("newvalue") ///
		excel ///
		import(firstrow)
}

if !mi("$raw/correction/mcct_baseline_anthro_id_matching.xlsx") {
	readreplace using "$raw/correction/mcct_baseline_anthro_id_matching.xlsx", ///
	    id("_index") ///
		variable("variable") ///
		value("newvalue") ///
		excel ///
		import(firstrow)
}

drop if geo_vill == "168652" 
drop _index

append using "$dta/anthro_respondent_chdn.dta", gen(source)


**-----------------------------------------------------**
** GEOGRAPHICAL AREA
**-----------------------------------------------------**
destring geo_rural, replace
lab def geo_rural 0"Urban" 1"Rural" 2"Hard to reach"
lab val geo_rural geo_rural
tab geo_rural, m

forvalue x = 0/2 {
	gen geo_rural_`x' = (geo_rural == `x')
	replace geo_rural_`x'	= .m if mi(geo_rural)
	order geo_rural_`x', after(geo_rural)
	tab geo_rural_`x', m
}

rename geo_rural_0	urban
rename geo_rural_1	rural
rename geo_rural_2 	eho

** reporting variables **
lab var geo_rural	"geographical area"
lab var urban		"Urban"
lab var rural		"Rural"
lab var eho			"Heard to reach area"

global geo	geo_rural urban rural eho


save "$cdta/anthro_respondent_cleanded.dta", replace

preserve
keep if source == 0
drop source
save "$cdta/anthro_respondent_cleanded_vi.dta", replace
restore

keep if source == 1
drop source 
save "$cdta/anthro_respondent_cleanded_chdn.dta", replace

clear


