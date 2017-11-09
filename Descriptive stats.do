loc do="E:/Dissertation/Data/NC Data/Do Files/" 
do `do'NC School Report Card Master 

///using the master file- I will now work on some descriptive statistics///
foreach value in satavg satpct appart appass ibpart ibpass total_class_teacher_num total_nbpts_num flicensed_teach_pct tchyrs_0thru3_pct tchyrs_4thru10_pct tchyrs_11plus_pct class_teach_num nbpts_num advance_dgr_pct _1yr_tchr_trnovr_pct emer_prov_teach_pct lateral_teach_pct highqual_class_pct avg_daily_attend_pct crime sts lts exp sint books student_num grad4pct grad5pct spg met egs att {
 sum `value'
}
//just sum at once
sum satavg satpct appart appass ibpart ibpass total_class_teacher_num total_nbpts_num flicensed_teach_pct tchyrs_0thru3_pct tchyrs_4thru10_pct tchyrs_11plus_pct class_teach_num nbpts_num advance_dgr_pct _1yr_tchr_trnovr_pct emer_prov_teach_pct lateral_teach_pct highqual_class_pct avg_daily_attend_pct crime sts lts exp sint books student_num grad4pct grad5pct spg met egs att {



//////////////////////////////////correlations//////////////////////////////////////
foreach value in crime sts lts exp{
correlate `value' spg
}

//again instead of that i'd just do:
pwcorr seg value in crime sts lts exp, sig



scatter spg sts if year==13
graph save Graph "E:\Dissertation\Data\NC Data\Graphs\Scatterplot of spg sts in 2014.gph"
scatter spg sts if year==14
graph save Graph "E:\Dissertation\Data\NC Data\Graphs\Scatterplot of spg sts in 2015.gph"
scatter spg sts if year==15
graph save Graph "E:\Dissertation\Data\NC Data\Graphs\Scatterplot of spg sts in 2016.gph"


graph pie, over(spg)
//i'd avoid pie charts and rather fo par charts! more about it next week in data mgmt class



scatter met sts
graph bar, over(spg)
graph bar (count), over(spg)
graph bar, over(met)
// Model for doing a scatterplot with variables: scatter lea_adva lea_lat,mlab(SchoolCode)*//
