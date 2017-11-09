
*******************************************************************************
///////////////////////////Building a directory for my project/////////////////
*******************************************************************************
*******************************************************************************
cd "E:/Dissertation/Data/NC Data/NC Data/"
loc e="E:/Dissertation/Data/NC Data/NC Schools Report Card Data Excel/" //For all raw data file in excel*//
loc s="E:/Dissertation/Data/NC Data/NC Schools Report Card Data Stata/" //For all merged data and datasets*//
*******************************************************************************
//////////////////////////End Directory Building///////////////////////////////

/////Building a dataset from 2014 to 2016 using NC Report Card Data from those years.*//

//and looking forward to an early draft of your brown bag seminar presentation!
//i'd put in there a lot of graphs!
//again i cannot check or run any of that becasue i dont have these files!
//again just upload them to the google drive as zipped

*****Start with bringing together the separate SPG files from 2014 to 2016*******
import excel "`e'NC Schools SPG 2014.xlsx", sheet("Sheet1") firstrow
gen year = 2014
rename LEAName DistrictName
save "`s'NC Schools SPG 2014.dta", replace
clear
import excel "`e'\NC Schools SPG 2015.xlsx", sheet("Sheet1") firstrow
gen year = 2015
save "`s'NC Schools SPG 2015.dta", replace 
clear
import excel "`e'NC Schools SPG 2016.xlsx", sheet("acctsumm16") firstrow
gen year = 2016
save "`s'NC Schools SPG 2016.dta", replace
clear
use "`s'NC Schools SPG 2014.dta"
append using "`s'SPG 2015.dta"
append using "`s'SPG 2016.dta"
recode year (2014=13)(2015=14)(2016=15)
label define yr 1 2002 2 2003 3 2004 4 2005 5 2006 6 2007 7 2008 8 2009 9 2010 10 2011 11 2012 12 2013 13 2014 14 2015 15 2016
label values year yr
save "`s'SPG Combined 2014 to 2016.dta", replace

******************Merging of separate files*************************************

//////////////////////////////////SPG to School Profile///////////////////////////////
clear
import excel "`e'NC School Profiles 2006 to 2016.xlsx", sheet("PROFILE") firstrow
encode year, gen(year2)
recode year2 (1=5)(2=6)(3=7)(4=8)(5=9)(6=10)(7=11)(8=12)(9=13)(10=14)(11=15)
label define yr 1 2002 2 2003 3 2004 4 2005 5 2006 6 2007 7 2008 8 2009 9 2010 10 2011 11 2012 12 2013 13 2014 14 2015 15 2016
label values year2 yr
drop if year2 < 13
//the above seems quite convoluted simply do it right away: 1=2002 2=2003 etcc

drop year 
rename year2 year
order year
drop if strpos(unit_code , "LEA") !=0 //This will drop all of the observations that are just at the LEA level, which is necessary because on these observations, the SchoolCode is not unique due to information being presented for Elementary, Middle, and High School levels.*//
drop if unit_code=="NC-SEA"
drop if Lea_Name=="Charter and Non-District Affiliated Schools"
rename unit_code SchoolCode
merge 1:1 SchoolCode year using "`s'SPG Combined 2014 to 2016.dta"
drop if _merge==2 //The ones that didn't merge only came from the using dataset, which had not been previously deleted for charter schools and LEAs"
drop _merge
save "`s'Merged SPG and School Profile Data 2014 to 2016.dta", replace
//////////////////////////////Next merge is to the School Environment Data//////////////////
clear
import excel "`e'NC Schools Environment Data 2006 to 2016.xlsx", sheet("ENVIRONMENT") firstrow
encode year, gen(year2)
recode year2 (1=5)(2=6)(3=7)(4=8)(5=9)(6=10)(7=11)(8=12)(9=13)(10=14)(11=15)
label define yr 1 2002 2 2003 3 2004 4 2005 5 2006 6 2007 7 2008 8 2009 9 2010 10 2011 11 2012 12 2013 13 2014 14 2015 15 2016
label values year2 yr
drop year
rename year2 year
drop if year < 13
drop if strpos(unit_code , "LEA") !=0
drop if unit_code=="NC-SEA"
drop if Lea_Name=="Charter and Non-District Affiliated Schools"
rename unit_code SchoolCode
merge 1:1 SchoolCode year using "`s'Merged SPG and School Profile Data 2014 to 2016.dta"
drop _merge 
save "`s'SPG School Profile Environment Dataset.dta", replace
/////////////////////////Next merge is to the Funding table//////////////////////////////////
clear
import excel "`e'NC Schools Funding Data 2002 to 2016.xlsx", sheet("FUNDING") firstrow
encode year, gen(year2)
label define yr 1 2002 2 2003 3 2004 4 2005 5 2006 6 2007 7 2008 8 2009 9 2010 10 2011 11 2012 12 2013 13 2014 14 2015 15 2016
label values year2 yr
drop year
rename year2 year
drop if year < 13
drop if strpos(unit_code , "LEA") !=0
drop if unit_code=="NC-SEA"
drop if Lea_Name=="Charter and Non-District Affiliated Schools"
rename unit_code SchoolCode
merge 1:1 SchoolCode year using "`s'SPG School Profile Environment Dataset.dta"
drop _merge
save "`s'Data with Funding.dta", replace
/////////////////////////Next merge is with the Personnel Data table//////////
clear
import excel "`e'NC School Personnel Data 2006 to 2016.xlsx", sheet("Sheet1") firstrow
encode year, gen(year2)
recode year2 (1=5)(2=6)(3=7)(4=8)(5=9)(6=10)(7=11)(8=12)(9=13)(10=14)(11=15)
label define yr 1 2002 2 2003 3 2004 4 2005 5 2006 6 2007 7 2008 8 2009 9 2010 10 2011 11 2012 12 2013 13 2014 14 2015 15 2016
label values year2 yr
drop if year2 < 13
drop year 
rename year2 year
drop if strpos(unit_code , "LEA") !=0 //This will drop all of the observations that are just at the LEA level, which is necessary because on these observations, the SchoolCode is not unique due to information being presented for Elementary, Middle, and High School levels.*//
drop if unit_code=="NC-SEA"
drop if Lea_Name=="Charter and Non-District Affiliated Schools"
rename unit_code SchoolCode
merge 1:1 SchoolCode year using "`s'Data with Funding.dta"
drop _merge
save "`s'Data with Funding merged with Personnel Data.dta", replace
//////////////////////////Now, I will merge with School Indicators data*///////
clear
import excel "`e'NC School Indicators 2002 to 2016.xlsx", sheet("SCHOOL_INDICATORS") firstrow
encode Year, gen(year2)
recode year2 (1=5)(2=6)(3=7)(4=8)(5=9)(6=10)(7=11)(8=12)(9=13)(10=14)(11=15)
label define yr 1 2002 2 2003 3 2004 4 2005 5 2006 6 2007 7 2008 8 2009 9 2010 10 2011 11 2012 12 2013 13 2014 14 2015 15 2016
label values year2 yr
drop if year < 13
drop Year
rename year2 year
drop if strpos(Unit_Code , "LEA") !=0
drop if Unit_Code=="NATION"
drop if Lea_Name=="Charter and Non-District Affiliated Schools"
rename Unit_Code SchoolCode
duplicates drop SchoolCode year, force
merge 1:1 SchoolCode year using "E:\Dissertation\Data\NC Data\NC Schools Report Card Data Stata\Data with Funding merged with Personnel Data.dta"
drop _merge
save "`s'Master NC School Report Card Dataset.dta", replace
//Dropping some unneccesary variables*//
//note that if you drop really many then can say keep instead!
//or use * say drop lea_* to drop all that start this way

drop lea_sat_participation_pct st_sat_participation_pct nat_sat_participation_pct lea_esea_attendance lea_ap_participation_pct st_ap_participation_pct lea_ap_pct_3_or_above st_ap_pct_3_or_above
drop lea_sat_avg_score_num st_sat_avg_score_num nat_sat_avg_score_num
drop lea_ib_participation_pct st_ib_participation_pct lea_ib_pct_4_or_above st_ib_pct_4_or_above
drop lea_class_teach_num lea_nbpts_num lea_advance_dgr_pct lea_1yr_tchr_trnovr_pct lea_emer_prov_teach_pct lea_lateral_teach_pct lea_highqual_class_pct lea_highqual_class_hp_pct lea_highqual_class_lp_pct lea_highqual_class_all_pct lea_not_highqual_class_hp_pct lea_not_highqual_class_lp_pct lea_not_highqual_class_all_pct st_flicensed_teach_pct st_tchyrs_0thru3_pct st_tchyrs_4thru10_pct st_tchyrs_11plus_pct st_class_teach_num st_nbpts_num st_advance_dgr_pct st_1yr_tchr_trnovr_pct st_emer_prov_teach_pct st_lateral_teach_pct st_highqual_class_pct st_highqual_class_hp_pct st_highqual_class_lp_pct st_highqual_class_all_pct st_not_highqual_class_hp_pct st_not_highqual_class_lp_pct st_not_highqual_class_all_pct st_prinyrs_0thru3_pct st_prinyrs_4thru10_pct st_prinyrs_11plus_pct st_prin_advance_dgr_pct st_1yr_prin_trnovr_pct st_prin_male_pct st_prin_female_pct st_prin_black_pct st_prin_white_pct st_prin_other_pct
drop prin_other_pct prinyrs_0thru3_pct prinyrs_4thru10_pct prinyrs_11plus_pct prin_advance_dgr_pct _1yr_prin_trnovr_pct prin_male_pct prin_female_pct prin_black_pct prin_white_pct lea_flicensed_teach_pct lea_tchyrs_0thru3_pct lea_tchyrs_4thru10_pct lea_tchyrs_11plus_pct lea_total_expense_num lea_salary_expense_pct lea_benefits_expense_pct lea_services_expense_pct lea_supplies_expense_pct lea_instruct_equip_exp_pct lea_other_expense_pct lea_federal_perpupil_num lea_local_perpupil_num lea_state_perpupil_num st_total_expense_num st_salary_expense_pct st_salary_expense_pct st_benefits_expense_pct st_benefits_expense_pct st_services_expense_pct st_supplies_expense_pct st_instruct_equip_exp_pct st_other_expense_pct st_federal_perpupil_num st_local_perpupil_num st_state_perpupil_num
drop federal_perpupil_num state_perpupil_num lea_building_expense_pct st_building_expense_pct lea_avg_daily_attend_pct lea_crime_per_c_num lea_short_susp_per_c_num lea_long_susp_per_c_num lea_expelled_per_c_num lea_stud_internet_comp_num st_avg_daily_attend_pct st_crime_per_c_num st_short_susp_per_c_num st_long_susp_per_c_num st_expelled_per_c_num st_stud_internet_comp_num digital_media_pct Byod grades_BYOD lea_avg_age_media_collection lea_books_per_student st_avg_age_media_collection st_books_per_student lea_wap_num lea_wap_per_classroom st_wap_num st_wap_per_classroom closed_ind new_ind super_nm url_ad calendar_type_txt sna_pgm_type_cd cover_letter_ad school_type_txt calendar_only_txt lea_avg_student_num st_avg_student_num stem url avg_age_media_collection
drop DistrictName vphone_ad street_ad state_ad SchoolName
drop TitleISchool Category_Cd State_Name
//Ordering the variables*//
order year Lea_Name SchoolCode School_Name scity_ad szip_ad type_cd category_cd grade_range_cd title1_type_cd
save "`s'Master NC School Report Card Dataset.dta", replace
//Some variables need to be changed to enable analysis*//
encode title1_type_cd, gen(title1code)
recode title1code (. = 0), gen(title1)
label define t1 1 Yes 0 No
label values title1 t1
label var title1 "School Receives Title I Funding"
drop title1_type_cd title1code
order title1, before(grade_range_cd)
encode EVAASGrowthStatus, gen(egs)
gen met =(egs<=2) if egs !=. 
label var met "School Met or Exceeded EVAAS Growth Goals"
gen SPG = SPGGrade+SchoolPerformanceGradeSPG
encode SPG, gen(spg)
recode spg (2=6)(1=5)(3=4)(4=3)(5=2)(6=1)(7=0)(8=0)
label define sgrade 6 ANG 5 A 4 B 3 C 2 D 1 F 0 NA
label values spg sgrade
drop SPG
drop SPGGrade
drop SchoolPerformanceGradeSPG
label var spg "School Performance Grade"
rename short_susp_per_c_num sts
label var sts "number of short term suspensions per 100 students"
rename long_susp_per_c_num lts
label var lts "number of long term suspensions per 100 students"
rename expelled_per_c_num exp
label var exp "number of expulsions per 100 students"
rename crime_per_c_num crime
label var crime "number of crimes or acts of violence per 100 students"
drop ttl_crimes_num
encode category_cd, gen(cat)
drop esea_attendance
////////////All funding data is at the LEA level only//////////////////////////
drop total_expense_num salary_expense_pct benefits_expense_pct services_expense_pct supplies_expense_pct instruct_equip_exp_pct other_expense_pct local_perpupil_num building_expense_pct
rename stud_internet_comp_num sint
label var sint "ratio of students ot internet connected computers"
rename _1_to_1_access otoa
label var otoa "School provides 1:1 access to technology"
encode otoa, gen(att)
recode att (1=0)(2=0)(3=1)(4=1)
label define d 0 No 1 Yes
label values att d
rename books_per_student books
label var books "Book titles per student"
drop grades_1_to_1_access
drop wap_num wap_per_classroom
drop summer_program_ind
drop GradeSpan
drop SummerProgram
foreach denom in YearCohortGraduationRateDe AA {
destring `denom', replace force
}
foreach percent in YearCohortGraduationRatePe AB {
replace `percent' = "95" if `percent'==">95"
destring `percent', replace force
}
rename YearCohortGraduationRateDe grad4de
rename YearCohortGraduationRatePe grad4pct
rename AA grad5de
rename AB grad5pct

foreach denom in PerformanceCompositeDenominato MathIDenominator BiologyDenominator EnglishIIDenominator Grade3MathDenominator Grade4MathDenominator Grade5MathDenominator Grade6MathDenominator Grade7MathDenominator Grade8MathDenominator Grade3ReadingDenominator Grade4ReadingDenominator Grade5ReadingDenominator Grade6ReadingDenominator Grade7ReadingDenominator Grade8ReadingDenominator Grade5ScienceDenominator Grade8ScienceDenominator {
destring `denom', replace force
}

save "E:/Dissertation/Data/NC Data/NC Schools Report Card Data Stata/Master NC School Report Card Dataset.dta", replace


foreach percent in PerformanceCompositePercentCo PerformanceCompositePercentGr MathIPercentCollegeCareerRe MathIPercentGradeLevelProfi BiologyPercentCollegeCareerR BiologyPercentGradeLevelProf EnglishIIPercentCollegeCaree EnglishIIPercentGradeLevelP Grade3MathPercentCollegeCar Grade3MathPercentGradeLevel Grade4MathPercentCollegeCar Grade4MathPercentGradeLevel Grade5MathPercentCollegeCar Grade5MathPercentGradeLevel Grade6MathPercentCollegeCar Grade6MathPercentGradeLevel Grade7MathPercentCollegeCar Grade7MathPercentGradeLevel Grade8MathPercentCollegeCar Grade8MathPercentGradeLevel Grade3ReadingPercentCollege Grade3ReadingPercentGradeLe Grade4ReadingPercentCollege Grade4ReadingPercentGradeLe Grade5ReadingPercentCollege Grade5ReadingPercentGradeLe Grade6ReadingPercentCollege Grade6ReadingPercentGradeLe Grade7ReadingPercentCollege Grade7ReadingPercentGradeLe Grade8ReadingPercentCollege Grade8ReadingPercentGradeLe Grade5SciencePercentCollege Grade5SciencePercentGradeLe Grade8SciencePercentCollege Grade8SciencePercentGradeLe {
replace `percent' = "95" if `percent'==">95"
replace `percent' = "5" if `percent'=="<5"
destring `percent', replace ignore("*")force
}

save "E:/Dissertation/Data/NC Data/NC Schools Report Card Data Stata/Master NC School Report Card Dataset.dta", replace

//good!
rename sat_avg_score_num satavg
rename sat_participation_pct satpct
rename ap_participation_pct appart
rename ap_pct_3_or_above appass
rename ib_participation_pct ibpart
rename ib_pct_4_or_above ibpass

label var satavg "Average SAT score"
label var satpct "Percent particpated in SAT test"
label var appart "Percent participated in AP program" 
label var appass "Percent of participants who received a 3 or above on AP exams"
label var ibpart "Percent participated in IB program" 
label var ibpass "Percent of particpants who receive a 4 or above on IB exams" 
