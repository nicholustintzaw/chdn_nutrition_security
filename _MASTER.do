/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROJECT:		CPI - CHDN Nutrition Security Report

PURPOSE: 		MASTER Dofile to run all dofile involve in this project

AUTHOR:  		Nicholus

CREATED: 		02 Dec 2019

MODIFIED:
   

THINGS TO DO:

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

// Settings for stata
pause on
clear all
clear mata
set more off
set scrollbufsize 100000

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// ***SET ROOT DIRECTORY HERE AND ONLY HERE***
do "_dir_setting.do"

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

** STEP 1: Import and Combined Dataset
do "$do/00_data_import_and_combined.do"

** STEP 2: Create Child Level Dataset
do "$do/01_combine_dataset_childlevel.do"

** STEP 3: Child Health data Cleaning
do "$do/02_child_datacleaning.do"

** STEP 4: Child Anthro data Cleaning
do "$do/03_child_anthro_datacleaning.do"

** STEP 5: Create Mother Level Dataset
do "$do/04_combine_dataset_momlevel.do"

** STEP 6: Mother Health Data Cleaning
do "$do/05_mom_health_datacleaning.do"

** STEP 7: Mother Anthro Data Cleaning
do "$do/06_mom_anthro_datacleaning.do"

** STEP 8: Data Analysis
do "$do/07_analysis.do"





