/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROJECT:		CPI - CHDN Nutrition Security Report

PURPOSE: 		Combined raw data from both VI and CHDN server

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:
   

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

** 	HH LEVEL DATASET  **
** 	IMPORT DATASET FROM DIFERENT SERVERS **

local org vi chdn

foreach x in `org' {

	import excel using "$raw/`x'/baseline_mcct_`x'.xls", describe 


	local n_sheets `r(N_worksheet)'
	forvalues j = 1/`n_sheets' {
		local sheet_`j' `r(worksheet_`j')'
	}

	forvalues i = 1/`n_sheets' {
		local range_`i' `r(range_`i')'
	}

	forvalues j = 1/`n_sheets' {
		import excel using "$raw/`x'/baseline_mcct_`x'.xls", ///
							sheet("`sheet_`j''") ///
							firstrow case(lower) ///
							cellrange(`range_`j'') ///
							allstring clear
		
		if _N > 0 {
		
			save "$dta/hh_`sheet_`j''_`x'.dta", replace
			}
	}

}

clear
/*
** COMBINED AS ONE DATASET FOR EACH SUB-SET OF DATASET **

forvalues j = 1/`n_sheets' {

	capture confirm file "$dta/`sheet_`j''_vi.dta"
	
	if !_rc {
	
		use "$dta/`sheet_`j''_vi.dta", clear
		
		capture confirm file "$dta/`sheet_`j''_chdn.dta"
			if !_rc {
				append using "$dta/`sheet_`j''_chdn.dta"
				}
	
		save "$dta/`sheet_`j''_combined.dta", replace					
		}
}

clear
*/
***************************************************************************************
***************************************************************************************

** 	CHILD ANTHRO DATASET  **
** 	IMPORT DATASET FROM DIFERENT SERVERS **

local org vi chdn

foreach x in `org' {

	import excel using "$raw/`x'/baseline_mcct_anthro_`x'.xls", describe 


	local n_sheets `r(N_worksheet)'
	forvalues j = 1/`n_sheets' {
		local sheet_`j' `r(worksheet_`j')'
	}

	forvalues i = 1/`n_sheets' {
		local range_`i' `r(range_`i')'
	}

	forvalues j = 1/`n_sheets' {
		import excel using "$raw/`x'/baseline_mcct_anthro_`x'.xls", ///
							sheet("`sheet_`j''") ///
							firstrow case(lower) ///
							cellrange(`range_`j'') ///
							allstring clear
		
		if _N > 0 {
		
			save "$dta/anthro_`sheet_`j''_`x'.dta", replace
			}
	}

}

clear
/*
** COMBINED AS ONE DATASET FOR EACH SUB-SET OF DATASET **

forvalues j = 1/`n_sheets' {

	capture confirm file "$dta/`sheet_`j''_vi.dta"
	
	if !_rc {
	
		use "$dta/`sheet_`j''_vi.dta", clear
		
		capture confirm file "$dta/`sheet_`j''_chdn.dta"
			if !_rc {
				append using "$dta/`sheet_`j''_chdn.dta"
				}
	
		save "$dta/`sheet_`j''_combined.dta", replace					
		}
}

clear
*/
***************************************************************************************
***************************************************************************************

** 	PPI TABLE  **
import excel using "$raw/ppi/Myanmar 2015 PPI_Scorecards+Look-Up Tables_English.xlsx", ///
					sheet("Look-up Tables") ///
					firstrow case(lower) ///
					cellrange(A9:T111) ///
					clear

rename ppiscore 			ppi_score
rename nationalpovertyline	national_povt_line 
rename extremepovertyline	extreme_povt_line

rename national national_150_percent
rename e		national_200_percent


rename f 		ppp_2011_1usdperday 
rename g 		ppp_2011_1_9usdperday 
rename h 		ppp_2011_3_2usdperday 
rename i 		ppp_2011_5_5usdperday 
rename j 		ppp_2011_8usdperday 
rename k 		ppp_2011_11usdperday 
rename l 		ppp_2011_15usdperday 
rename m 		ppp_2011_21_7usdperday 
rename n 		ppp_2005_1_25usdperday 
rename o 		ppp_2005_2_5usdperday 
rename p		ppp_2005_5usdperday 

rename bottom20thpercentile bot_20_percentil
rename bottom40thpercentile bot_40_percentil
rename bottom60thpercentile bot_60_percentil
rename bottom80thpercentile	bot_80_percentil

save "$dta/ppi_lookup_table.dta", replace
					
