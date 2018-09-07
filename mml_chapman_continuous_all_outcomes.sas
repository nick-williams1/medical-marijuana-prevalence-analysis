ods noproctitle; 
options nodate;

* calculating quantiles for restriction categories; 

proc means data = all_use q1 median q3; 
	var overall init dist quant; 
run;  

************************************** PAST MONTH USE **********************************************************************; 

* overall restrictveness; 

proc mixed data = all_use; 
	title "Past month marijuana use: Cubic spline, age, continuous Chapman index"; 
	class abbrev age_grp mml_pass; 
	model month_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass overall
				age_grp*mml_pass age_grp*overall mml_pass*overall age_grp*mml_pass*overall / solution ddfm = bw;
	random abbrev / group = age_grp;  
	estimate "Age 12-17: After to Before, Median Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*overall 10 -10 
			 age_grp*mml_pass*overall 10 -10 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Median Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*overall 10 -10 
			 age_grp*mml_pass*overall 0 0 10 -10 0 0 / cl;
	estimate "Age 26+: After to Before, Median Overall Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*overall 10 -10
			 age_grp*mml_pass*overall 0 0 0 0 10 -10 / cl; 

	estimate "Age 12-17: After to Before, Q1 Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*overall 6 -6 
			 age_grp*mml_pass*overall 6 -6 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q1 Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*overall 6 -6 
			 age_grp*mml_pass*overall 0 0 6 -6 0 0 / cl;
	estimate "Age 26+: After to Before, Q1 Overall Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*overall 6 -6
			 age_grp*mml_pass*overall 0 0 0 0 6 -6 / cl; 

	estimate "Age 12-17: After to Before, Q3 Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*overall 12 -12 
			 age_grp*mml_pass*overall 12 -12 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q3 Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*overall 12 -12 
			 age_grp*mml_pass*overall 0 0 12 -12 0 0 / cl;
	estimate "Age 26+: After to Before, Q3 Overall Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*overall 12 -12
			 age_grp*mml_pass*overall 0 0 0 0 12 -12 / cl;
run; 

*initiation restrictivenss;

proc mixed data = all_use; 
	title "Past month marijuana use: Cubic spline, age, continuous Chapman index"; 
	class abbrev age_grp mml_pass; 
	model month_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init
				age_grp*mml_pass age_grp*init mml_pass*init age_grp*mml_pass*init / solution ddfm = bw;
	random abbrev / group = age_grp;  
	estimate "Age 12-17: After to Before, Median Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Median Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Median Overall Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q1 Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q1 Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Q1 Overall Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 4-17: After to Before, Q3 Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 4 -4 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q3 Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 0 0 4 -4 0 0 / cl;
	estimate "Age 26+: After to Before, Q3 Overall Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 4 -4
			 age_grp*mml_pass*init 0 0 0 0 4 -4 / cl;
run; 

* Distribution restrictiveness; 

proc mixed data = all_use; 
	title "Past month marijuana use: Cubic spline, age, continuous Chapman index"; 
	class abbrev age_grp mml_pass; 
	model month_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init
				age_grp*mml_pass age_grp*init mml_pass*init age_grp*mml_pass*init / solution ddfm = bw;
	random abbrev / group = age_grp;  
	estimate "Age 12-17: After to Before, Median Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Median Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Median Overall Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q1 Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 1 -1 
			 age_grp*mml_pass*init 1 -1 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q1 Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 1 -1 
			 age_grp*mml_pass*init 0 0 1 -1 0 0 / cl;
	estimate "Age 26+: After to Before, Q1 Overall Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 1 -1
			 age_grp*mml_pass*init 0 0 0 0 1 -1 / cl; 

	estimate "Age 4-17: After to Before, Q3 Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 4 -4 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q3 Overall Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 0 0 4 -4 0 0 / cl;
	estimate "Age 26+: After to Before, Q3 Overall Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 4 -4
			 age_grp*mml_pass*init 0 0 0 0 4 -4 / cl;
run; 




