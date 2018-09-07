
* creating frequency tables of type of data for MML by restrictevenss; 

proc freq data = past_month_MD_2014; 
	table mml_pass*restrict; 
run;

proc freq data = past_month; 
	table mml_pass*restrict; 
run;

* creating datasets for monthly use in the years 2015 and 2016;  

data rank_2015 rank_2016; 
	set past_month_MD_2014; 
	if year = 2015 then output rank_2015; 
		else if year = 2016 then output rank_2016;
run;

* ranking monthly use by states in 2015;  

proc sort data = rank_2015; 
	by age_grp; 
run; 

proc rank data = rank_2015 out = rank_2015 descending; 
	by age_grp; 
	var use; 
	ranks use_rank; 
run; 

proc print data = rank_2015; 
	by age_grp; 
	var abbrev use use_rank; 
run; 

* ranking monthly use among states in 2016; 

proc sort data = rank_2016; 
	by age_grp; 
run; 

proc rank data = rank_2016 out = rank_2016 descending; 
	by age_grp; 
	var use; 
	ranks use_rank; 
run; 

proc print data = rank_2016; 
	by age_grp; 
	var abbrev use use_rank; 
run; 
