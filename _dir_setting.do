/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROJECT:		CPI - CHDN Nutrition Security Report

PURPOSE: 		directory setting

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:
   

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// ***SET ROOT DIRECTORY HERE AND ONLY HERE***

// create a local to identify current user
local user = c(username)
di "`user'"

// Set root directory depending on current user
if "`user'" == "nicholustintzaw" {
	global		dir			/Users/nicholustintzaw/Documents/PERSONAL/Projects/07_CPI_CHDN/01_workflow

	global		raw			$dir/01_raw
	global		do			$dir/00_do
	global		dta			$dir/02_dta
	global		cdta		$dir/03_cleaned_dta
	global		out			$dir/04_out
}


else if "`user'" == "nicholustintzaw" {
	global		dir			/Users/nicholustintzaw/Documents/PERSONAL/Projects/07_CPI_CHDN/01_workflow

	global		raw			$dir/01_raw
	global		do			$dir/00_do
	global		dta			$dir/02_dta
	global		cdta		$dir/03_cleaned_dta
	global		out			$dir/04_out
}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
