ods noproctitle; 
options nodate;

* creating data set that only contains MML states; 

data mml_states_all_use; 
	set all_use; 
	if ever_pass = 1 then output; 
run; 

* calculating quantiles for restriction categories; 

proc means data = mml_states_all_use q1 median q3; 
	var overall init dist quant; 
run;  

************************************** PAST MONTH USE **********************************************************************; 

* overall restrictveness; 

ods pdf file = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\reports\cont_chapman\past_month_cont_chapman.pdf" style = journal2; 


proc mixed data = mml_states_all_use; 
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

*initiation restrictiveness;

proc mixed data = mml_states_all_use; 
	title "Past month marijuana use: Cubic spline, age, continuous Chapman initiation index"; 
	class abbrev age_grp mml_pass; 
	model month_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init
				age_grp*mml_pass age_grp*init mml_pass*init age_grp*mml_pass*init / solution ddfm = bw;
	random abbrev / group = age_grp;  
	estimate "Age 12-17: After to Before, Median initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Median initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Median initiation Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q1 initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q1 Oinitiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Q1 initiation Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q3 initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 4 -4 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q3 initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 0 0 4 -4 0 0 / cl;
	estimate "Age 26+: After to Before, Q3 initiation Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 4 -4
			 age_grp*mml_pass*init 0 0 0 0 4 -4 / cl;
run; 

* Distribution restrictiveness; 

proc mixed data = mml_states_all_use; 
	title "Past month marijuana use: Cubic spline, age, continuous Chapman distribution index"; 
	class abbrev age_grp mml_pass; 
	model month_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init
				age_grp*mml_pass age_grp*init mml_pass*init age_grp*mml_pass*init / solution ddfm = bw;
	random abbrev / group = age_grp;  
	estimate "Age 12-17: After to Before, Median distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Median distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Median distribution Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q1 distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 1 -1 
			 age_grp*mml_pass*init 1 -1 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q1 distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 1 -1 
			 age_grp*mml_pass*init 0 0 1 -1 0 0 / cl;
	estimate "Age 26+: After to Before, Q1 distribution Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 1 -1
			 age_grp*mml_pass*init 0 0 0 0 1 -1 / cl; 

	estimate "Age 12-17: After to Before, Q3 distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 4 -4 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q3 distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 0 0 4 -4 0 0 / cl;
	estimate "Age 26+: After to Before, Q3 distribution Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 4 -4
			 age_grp*mml_pass*init 0 0 0 0 4 -4 / cl;
run; 

* Quantity restricteveness;

proc mixed data = mml_states_all_use; 
	title "Past month marijuana use: Cubic spline, age, continuous Chapman quantity index"; 
	class abbrev age_grp mml_pass; 
	model month_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init
				age_grp*mml_pass age_grp*init mml_pass*init age_grp*mml_pass*init / solution ddfm = bw;
	random abbrev / group = age_grp;  
	estimate "Age 12-17: After to Before, Median quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Median quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Median quantity Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q1 quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 2 -2 
			 age_grp*mml_pass*init 2 -2 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q1 quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 2 -2 
			 age_grp*mml_pass*init 0 0 2 -2 0 0 / cl;
	estimate "Age 26+: After to Before, Q1 quantity Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 2 -2
			 age_grp*mml_pass*init 0 0 0 0 2 -2 / cl; 

	estimate "Age 12-17: After to Before, Q3 quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 4 -4 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q3 quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 0 0 4 -4 0 0 / cl;
	estimate "Age 26+: After to Before, Q3 quantity Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 4 -4
			 age_grp*mml_pass*init 0 0 0 0 4 -4 / cl;
run;

ods pdf close; 
 

************************************** PAST YEAR USE **********************************************************************;

ods pdf file = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\reports\cont_chapman\past_year_cont_chapman.pdf" style = journal2;  

* overall restrictveness; 

proc mixed data = mml_states_all_use; 
	title "Past year marijuana use: Cubic spline, age, continuous Chapman index"; 
	class abbrev age_grp mml_pass; 
	model year_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
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

*initiation restrictiveness;

proc mixed data = mml_states_all_use; 
	title "Past year marijuana use: Cubic spline, age, continuous Chapman initiation index"; 
	class abbrev age_grp mml_pass; 
	model year_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init
				age_grp*mml_pass age_grp*init mml_pass*init age_grp*mml_pass*init / solution ddfm = bw;
	random abbrev / group = age_grp;  
	estimate "Age 12-17: After to Before, Median initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Median initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Median initiation Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q1 initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q1 initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Q1 initiation Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q3 initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 4 -4 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q3 initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 0 0 4 -4 0 0 / cl;
	estimate "Age 26+: After to Before, Q3 initiation Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 4 -4
			 age_grp*mml_pass*init 0 0 0 0 4 -4 / cl;
run; 

* Distribution restrictiveness; 

proc mixed data = mml_states_all_use; 
	title "Past year marijuana use: Cubic spline, age, continuous Chapman distribution index"; 
	class abbrev age_grp mml_pass; 
	model year_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init
				age_grp*mml_pass age_grp*init mml_pass*init age_grp*mml_pass*init / solution ddfm = bw;
	random abbrev / group = age_grp;  
	estimate "Age 12-17: After to Before, Median distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Median distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Median distribution Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q1 distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 1 -1 
			 age_grp*mml_pass*init 1 -1 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q1 distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 1 -1 
			 age_grp*mml_pass*init 0 0 1 -1 0 0 / cl;
	estimate "Age 26+: After to Before, Q1 distribution Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 1 -1
			 age_grp*mml_pass*init 0 0 0 0 1 -1 / cl; 

	estimate "Age 12-17: After to Before, Q3 distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 4 -4 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q3 distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 0 0 4 -4 0 0 / cl;
	estimate "Age 26+: After to Before, Q3 distribution Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 4 -4
			 age_grp*mml_pass*init 0 0 0 0 4 -4 / cl;
run; 

* Quantity restricteveness;

proc mixed data = mml_states_all_use; 
	title "Past year marijuana use: Cubic spline, age, continuous Chapman quantity index"; 
	class abbrev age_grp mml_pass; 
	model year_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init
				age_grp*mml_pass age_grp*init mml_pass*init age_grp*mml_pass*init / solution ddfm = bw;
	random abbrev / group = age_grp;  
	estimate "Age 12-17: After to Before, Median quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Median quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Median quantity Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q1 quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 2 -2 
			 age_grp*mml_pass*init 2 -2 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q1 quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 2 -2 
			 age_grp*mml_pass*init 0 0 2 -2 0 0 / cl;
	estimate "Age 26+: After to Before, Q1 quantity Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 2 -2
			 age_grp*mml_pass*init 0 0 0 0 2 -2 / cl; 

	estimate "Age 12-17: After to Before, Q3 quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 4 -4 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q3 quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 0 0 4 -4 0 0 / cl;
	estimate "Age 26+: After to Before, Q3 quantity Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 4 -4
			 age_grp*mml_pass*init 0 0 0 0 4 -4 / cl;
run;

ods pdf close; 

************************************** FIRST USE **********************************************************************;

ods pdf file = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\reports\cont_chapman\first_use_cont_chapman.pdf" style = journal2;  

* overall restrictveness; 

proc mixed data = mml_states_all_use; 
	title "First use of marijuana: Cubic spline, age, continuous Chapman index"; 
	class abbrev age_grp mml_pass; 
	model first_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
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

*initiation restrictiveness;

proc mixed data = mml_states_all_use; 
	title "First use of marijuana: Cubic spline, age, continuous Chapman initiation index"; 
	class abbrev age_grp mml_pass; 
	model first_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init
				age_grp*mml_pass age_grp*init mml_pass*init age_grp*mml_pass*init / solution ddfm = bw;
	random abbrev / group = age_grp;  
	estimate "Age 12-17: After to Before, Median initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Median initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Median initiation Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q1 initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q1 initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Q1 initiation Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q3 initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 4 -4 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q3 initiation Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 0 0 4 -4 0 0 / cl;
	estimate "Age 26+: After to Before, Q3 initiation Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 4 -4
			 age_grp*mml_pass*init 0 0 0 0 4 -4 / cl;
run; 

* Distribution restrictiveness; 

proc mixed data = mml_states_all_use; 
	title "First use of marijuana: Cubic spline, age, continuous Chapman distribution index"; 
	class abbrev age_grp mml_pass; 
	model first_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init
				age_grp*mml_pass age_grp*init mml_pass*init age_grp*mml_pass*init / solution ddfm = bw;
	random abbrev / group = age_grp;  
	estimate "Age 12-17: After to Before, Median distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 3 -3 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Median distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Median distribution Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q1 distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 1 -1 
			 age_grp*mml_pass*init 1 -1 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q1 distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 1 -1 
			 age_grp*mml_pass*init 0 0 1 -1 0 0 / cl;
	estimate "Age 26+: After to Before, Q1 distribution Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 1 -1
			 age_grp*mml_pass*init 0 0 0 0 1 -1 / cl; 

	estimate "Age 12-17: After to Before, Q3 distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 4 -4 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q3 distribution Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 0 0 4 -4 0 0 / cl;
	estimate "Age 26+: After to Before, Q3 distribution Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 4 -4
			 age_grp*mml_pass*init 0 0 0 0 4 -4 / cl;
run; 

* Quantity restricteveness;

proc mixed data = mml_states_all_use; 
	title "First use of marijuana: Cubic spline, age, continuous Chapman quantity index"; 
	class abbrev age_grp mml_pass; 
	model first_use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
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
	estimate "Age 18-25: After to Before, Median quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 3 -3 
			 age_grp*mml_pass*init 0 0 3 -3 0 0 / cl;
	estimate "Age 26+: After to Before, Median quantity Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 3 -3
			 age_grp*mml_pass*init 0 0 0 0 3 -3 / cl; 

	estimate "Age 12-17: After to Before, Q1 quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 2 -2 
			 age_grp*mml_pass*init 2 -2 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q1 quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 2 -2 
			 age_grp*mml_pass*init 0 0 2 -2 0 0 / cl;
	estimate "Age 26+: After to Before, Q1 quantity Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 2 -2
			 age_grp*mml_pass*init 0 0 0 0 2 -2 / cl; 

	estimate "Age 12-17: After to Before, Q3 quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 1 -1 0 0 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 4 -4 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, Q3 quantity Restrictiveness" 
		     mml_pass 1 -1
			 age_grp*mml_pass 0 0 1 -1 0 0 
			 mml_pass*init 4 -4 
			 age_grp*mml_pass*init 0 0 4 -4 0 0 / cl;
	estimate "Age 26+: After to Before, Q3 quantity Restrictiveness" 
			 mml_pass 1 -1
			 age_grp*mml_pass 0 0 0 0 1 -1
			 mml_pass*init 4 -4
			 age_grp*mml_pass*init 0 0 0 0 4 -4 / cl;
run;

ods pdf close; 
