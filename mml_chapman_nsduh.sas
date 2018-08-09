
ods noproctitle; 
options nodate;

***********************************************************************************************************************************************
************************************************PAST MONTH USE ANALYSIS************************************************************************
***********************************************************************************************************************************************

 *importing data for past month use; 

proc import out = age1
 	datafile = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_month\past_month_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "12-17"; 
run; 

proc import out = age2
	datafile = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_month\past_month_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "18-25"; 
run; 

proc import out = age3
	datafile = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_month\past_month_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "26+"; 
run; 

*stacking data; 

data past_month_wide; 
	set age1 age2 age3; 
run; 

*tranposing data; 

proc sort data = past_month_wide; 
	by state age_grp; 
run; 

proc transpose data = past_month_wide out = past_month
		(drop = _LABEL_ rename = (col1 = use)); 
	by state age_grp; 
	var estimate_2003 estimate_2004 estimate_2005 estimate_2006 estimate_2007 
		estimate_2008 estimate_2009 estimate_2010 estimate_2011 estimate_2012 
		estimate_2013 estimate_2014 estimate_2015 estimate_2016; 
run; 

data past_month; 
	set past_month; 
	drop _NAME_; 
	year = input(transtrn(_NAME_, "estimate_", ""), 5.); 
run; 

*removing DC; 

data past_month; 
	set past_month; 
	if state = 'District of Columbia' then delete;
run; 

*creating abbreviation; 

data past_month; 
	set past_month; 
	if state = 'Alabama' then abbrev = 'AL'; 
	if state = 'Alaska' then abbrev = 'AK'; 
	if state = 'Arizona' then abbrev = 'AZ'; 
	if state = 'Arkansas' then abbrev = 'AR'; 
	if state = 'California' then abbrev = 'CA'; 
	if state = 'Colorado' then abbrev = 'CO'; 
	if state = 'Connecticut' then abbrev = 'CT'; 
	if state = 'Delaware' then abbrev = 'DE'; 
	if state = 'Florida' then abbrev = 'FL'; 
	if state = 'Georgia' then abbrev = 'GA'; 
	if state = 'Hawaii' then abbrev = 'HI'; 
	if state = 'Idaho' then abbrev = 'ID'; 
	if state = 'Illinois' then abbrev = 'IL'; 
	if state = 'Indiana' then abbrev = 'IN'; 
	if state = 'Iowa' then abbrev = 'IA'; 
	if state = 'Kansas' then abbrev = 'KS'; 
	if state = 'Kentucky' then abbrev = 'KY'; 
	if state = 'Louisiana' then abbrev = 'LA'; 
	if state = 'Maine' then abbrev = 'ME'; 
	if state = 'Maryland' then abbrev = 'MD'; 
	if state = 'Massachusetts' then abbrev = 'MA'; 
	if state = 'Michigan' then abbrev = 'MI'; 
	if state = 'Minnesota' then abbrev = 'MN'; 
	if state = 'Mississippi' then abbrev = 'MS'; 
	if state = 'Missouri' then abbrev = 'MO'; 
	if state = 'Montana' then abbrev = 'MT'; 
	if state = 'Nebraska' then abbrev = 'NE'; 
	if state = 'Nevada' then abbrev = 'NV'; 
	if state = 'New Hampshire' then abbrev = 'NH'; 
	if state = 'New Jersey' then abbrev = 'NJ'; 
	if state = 'New Mexico' then abbrev = 'NM'; 
	if state = 'New York' then abbrev = 'NY'; 
	if state = 'North Carolina' then abbrev = 'NC'; 
	if state = 'North Dakota' then abbrev = 'ND'; 
	if state = 'Ohio' then abbrev = 'OH'; 
	if state = 'Oklahoma' then abbrev = 'OK'; 
	if state = 'Oregon' then abbrev = 'OR'; 
	if state = 'Pennsylvania' then abbrev = 'PA'; 
	if state = 'Rhode Island' then abbrev = 'RI'; 
	if state = 'South Carolina' then abbrev = 'SC'; 
	if state = 'South Dakota' then abbrev = 'SD'; 
	if state = 'Tennessee' then abbrev = 'TN'; 
	if state = 'Texas' then abbrev = 'TX'; 
	if state = 'Utah' then abbrev = 'UT'; 
	if state = 'Vermont' then abbrev = 'VT'; 
	if state = 'Virginia' then abbrev = 'VA'; 
	if state = 'Washington' then abbrev = 'WA'; 
	if state = 'West Virginia' then abbrev = 'WV'; 
	if state = 'Wisconsin' then abbrev = 'WI'; 
	if state = 'Wyoming' then abbrev = 'WY'; 
run;

*reordering variables; 

data past_month; 
	retain abbrev state year age_grp use; 
	set past_month;  
run; 

*creating information regarding medical marijuana laws; 

data past_month; 
	set past_month; 
	if abbrev in ("AK" "AZ" "CA" "CO" "CT"
				  "DE" "HI" "IL" "ME" "MD"
				  "MA" "MI" "MN" "MT" "NV"
				  "NH" "NJ" "NM" "NY" "OR" 
                  "RI" "VT" "WA") 
		then ever_pass = 1; 
		else ever_pass = 0; 
	law_status = ever_pass; 
		if abbrev = "MD" and year < 2003 then law_status = 0; 
		if abbrev = "MT" and year < 2004 then law_status = 0;
		if abbrev = "VT" and year < 2004 then law_status = 0;
		if abbrev = "RI" and year < 2006 then law_status = 0;
		if abbrev = "NM" and year < 2007 then law_status = 0;
		if abbrev = "MI" and year < 2008 then law_status = 0; 
		if abbrev = "NJ" and year < 2010 then law_status = 0;
		if abbrev = "AZ" and year < 2010 then law_status = 0;
		if abbrev = "DE" and year < 2011 then law_status = 0;
		if abbrev = "CT" and year < 2012 then law_status = 0;
		if abbrev = "MA" and year < 2012 then law_status = 0;
		if abbrev = "IL" and year < 2013 then law_status = 0;
		if abbrev = "NH" and year < 2013 then law_status = 0;
		if abbrev = "MN" and year < 2014 then law_status = 0;
		if abbrev = "NY" and year < 2014 then law_status = 0;
	if abbrev in ("CA","OR","WA","AK","ME","CO","NV","HI", "MD") then early_pass = 1;
		else early_pass = 0; 
	if ever_pass = 1 and law_status = 0 then mml_pass = "before"; 
		else if ever_pass = 1 and law_status = 1 then mml_pass = "after"; 
		else if ever_pass = 0 then mml_pass = "never"; 
run; 

*creating spline; 

data past_month; 
	set past_month; 
	yearcont = year - 2003; 
	yearsp = max(yearcont - 5, 0); 
run;

*adding Chapman information; 

data past_month; 
	set past_month; 
		if abbrev = 'AK' then init = 1; 
		if abbrev = 'AZ' then init = 3; 
		if abbrev = 'CA' then init = 5; 
		if abbrev = 'CO' then init = 4; 
		if abbrev = 'CT' then init = 3; 
		if abbrev = 'DE' then init = 3; 
		if abbrev = 'HI' then init = 4; 
		if abbrev = 'IL' then init = 4; 
		if abbrev = 'ME' then init = 5; 
		if abbrev = 'MA' then init = 4; 
		if abbrev = 'MD' then init = 3; 
		if abbrev = 'MI' then init = 4; 
		if abbrev = 'MN' then init = 2; 
		if abbrev = 'MT' then init = 4; 
		if abbrev = 'NV' then init = 3; 
		if abbrev = 'NH' then init = 3; 
		if abbrev = 'NJ' then init = 2; 
		if abbrev = 'NM' then init = 4; 
		if abbrev = 'NY' then init = 2; 
		if abbrev = 'OR' then init = 3; 
		if abbrev = 'RI' then init = 4; 
		if abbrev = 'VT' then init = 3; 
		if abbrev = 'WA' then init = 5; 

		if abbrev = 'AK' then quant = 3; 
		if abbrev = 'AZ' then quant = 3; 
		if abbrev = 'CA' then quant = 4; 
		if abbrev = 'CO' then quant = 3; 
		if abbrev = 'CT' then quant = 1; 
		if abbrev = 'DE' then quant = 2; 
		if abbrev = 'HI' then quant = 3; 
		if abbrev = 'IL' then quant = 2; 
		if abbrev = 'ME' then quant = 3; 
		if abbrev = 'MA' then quant = 4; 
		if abbrev = 'MD' then quant = 2; 
		if abbrev = 'MI' then quant = 3; 
		if abbrev = 'MN' then quant = 1; 
		if abbrev = 'MT' then quant = 4; 
		if abbrev = 'NV' then quant = 2; 
		if abbrev = 'NH' then quant = 2; 
		if abbrev = 'NJ' then quant = 1; 
		if abbrev = 'NM' then quant = 4; 
		if abbrev = 'NY' then quant = 1; 
		if abbrev = 'OR' then quant = 5; 
		if abbrev = 'RI' then quant = 4; 
		if abbrev = 'VT' then quant = 2; 
		if abbrev = 'WA' then quant = 5; 
 
		if abbrev = 'AK' then dist = 5; 
		if abbrev = 'AZ' then dist = 3; 
		if abbrev = 'CA' then dist = 4; 
		if abbrev = 'CO' then dist = 3; 
		if abbrev = 'CT' then dist = 1; 
		if abbrev = 'DE' then dist = 1; 
		if abbrev = 'HI' then dist = 5; 
		if abbrev = 'IL' then dist = 2; 
		if abbrev = 'ME' then dist = 4; 
		if abbrev = 'MA' then dist = 4; 
		if abbrev = 'MD' then dist = 1; 
		if abbrev = 'MI' then dist = 5; 
		if abbrev = 'MN' then dist = 1; 
		if abbrev = 'MT' then dist = 5; 
		if abbrev = 'NV' then dist = 3; 
		if abbrev = 'NH' then dist = 2; 
		if abbrev = 'NJ' then dist = 1; 
		if abbrev = 'NM' then dist = 2; 
		if abbrev = 'NY' then dist = 1; 
		if abbrev = 'OR' then dist = 3; 
		if abbrev = 'RI' then dist = 3; 
		if abbrev = 'VT' then dist = 2; 
		if abbrev = 'WA' then dist = 4;
 
		if abbrev = 'AK' then overall = 9; 
		if abbrev = 'AZ' then overall = 9; 
		if abbrev = 'CA' then overall = 13; 
		if abbrev = 'CO' then overall = 10; 
		if abbrev = 'CT' then overall = 5; 
		if abbrev = 'DE' then overall = 6; 
		if abbrev = 'HI' then overall = 12; 
		if abbrev = 'IL' then overall = 8; 
		if abbrev = 'ME' then overall = 12; 
		if abbrev = 'MA' then overall = 12; 
		if abbrev = 'MD' then overall = 6; 
		if abbrev = 'MI' then overall = 12; 
		if abbrev = 'MN' then overall = 4; 
		if abbrev = 'MT' then overall = 13; 
		if abbrev = 'NV' then overall = 8; 
		if abbrev = 'NH' then overall = 7; 
		if abbrev = 'NJ' then overall = 4; 
		if abbrev = 'NM' then overall = 10; 
		if abbrev = 'NY' then overall = 4; 
		if abbrev = 'OR' then overall = 11; 
		if abbrev = 'RI' then overall = 11; 
		if abbrev = 'VT' then overall = 7; 
		if abbrev = 'WA' then overall = 14;
run; 

proc format; 
	value illegal_fmt . = "illegal";
run;  

data past_month; 
	set past_month;
	format init illegal_fmt.;  
	format quant illegal_fmt.;
	format dist illegal_fmt.; 
	format overall illegal_fmt.; 
run; 

*calculating median index scores;  

proc means data = past_month median;
	var overall; 
proc freq data = past_month; 
	table overall; 
run; 

proc means data = past_month median; 
	var init; 
proc freq data = past_month; 
	table init; 
run; 

proc means data = past_month median; 
	var quant; 
proc freq data = past_month; 
	table quant; 
run; 

proc means data = past_month median; 
	var dist; 
proc freq data = past_month; 
	table dist; 
run; 

*creating binary variable based on median values; 

data past_month; 
	set past_month;
	restrict = "illegal";  
	if overall >= 10 then restrict = "low"; 
		else if 3 < overall < 10 then restrict = "high"; 

	init_binary = "illegal"; 
	if init >= 4 then init_binary = "low"; 
		else if 0 < init < 4 then init_binary = "high"; 

	quant_binary = "illegal"; 
	if quant >= 3 then quant_binary = "low"; 
		else if 0 < quant < 3 then quant_binary = "high"; 

	dist_binary = "illegal"; 
	if dist >= 3 then dist_binary = "low"; 
		else if 0 < dist < 3 then dist_binary = "high"; 
run; 

*creating data set that has mml_pass coding for states that passed MML in 2016; 

data past_month_newStates; 
	set past_month; 
	if abbrev in ("ND" "FL" "OH" "PA")
		then ever_pass = 1; 
	if abbrev = "ND" and year < 2016 then law_status = 0; 
	if abbrev = "FL" and year < 2016 then law_status = 0; 
	if abbrev = "OH" and year < 2016 then law_status = 0; 
	if abbrev = "PA" and year < 2016 then law_status = 0; 
	if ever_pass = 1 and law_status = 0 then mml_pass = "before"; 
		else if ever_pass = 1 and law_status = 1 then mml_pass = "after"; 
		else if ever_pass = 0 then mml_pass = "never"; 
run;  

*model looking at after vs. before past month use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_month\past_month_2003_2016_noChapman.pdf" style = journal2; 

proc mixed data = past_month;
	title "Past month marijuana use: Cubic spline, age";
	class abbrev age_grp mml_pass; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass age_grp*mml_pass / solution dfm = bw; 
	random abbrev / group = age_grp;
	estimate "Age 12-17: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0;
	estimate "Age 18-25: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0;
	estimate "Age 26+: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0;
run; 

ods pdf close; 

*after vs before including new states; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_month\new_states_past_month_2003_2016_noChapman.pdf" style = journal2;


proc mixed data = past_month_newStates;
	title "Past month marijuana use (including new states): Cubic spline, age";
	class abbrev age_grp mml_pass; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass age_grp*mml_pass / solution dfm = bw; 
	random abbrev / group = age_grp;
	*lsmeans age_grp*mml_pass / pdiff cl;
	estimate "Age 12-17: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0;
	estimate "Age 18-25: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0;
	estimate "Age 26+: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0;
run;

ods pdf close; 

*model for overall restrictiveness: past month use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_month\past_month_2003_2016_overall_Chapman.pdf" style = journal2;

proc mixed data = past_month; 
	title "Past month marijuana use: Cubic spline, age, binary MML Chapman index";
	class abbrev age_grp mml_pass restrict; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass restrict 
				age_grp*restrict mml_pass*restrict age_grp*mml_pass age_grp*mml_pass*restrict / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*restrict / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 
				age_grp*mml_pass*restrict 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 0 1 0 -1 0 
				age_grp*mml_pass*restrict 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 
				age_grp*mml_pass*restrict 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*restrict 0 1 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*restrict 1 0 -1 0 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*restrict 0 1 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 / cl; ; 
run;

ods pdf close; 

*model for overall restrictiveness: past month use including new states; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_month\new_states_past_month_2003_2016_overall_Chapman.pdf" style = journal2;

proc mixed data = past_month_newStates; 
	title "Past month marijuana use (including new states): Cubic spline, age, binary MML Chapman index";
	class abbrev age_grp mml_pass restrict; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass restrict 
				age_grp*restrict mml_pass*restrict age_grp*mml_pass age_grp*mml_pass*restrict / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*restrict / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 0
				age_grp*mml_pass*restrict 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 0 1 0 0 -1 0
				age_grp*mml_pass*restrict 0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*restrict 0 1 0 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*restrict 1 0 -1 0 0 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*restrict 0 1 0 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 / cl; ; 
run;

ods pdf close; 

*initiation binary model: past month use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_month\past_month_2003_2016_binary_initiation.pdf" style = journal2;

proc mixed data = past_month; 
	title "Marijuana use in last month: Cubic spline, age, binary initiation MML Chapman index";
	class abbrev age_grp mml_pass init_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init_binary 
				age_grp*init_binary mml_pass*init_binary age_grp*mml_pass age_grp*mml_pass*init_binary / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*init_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*init_binary 1 0 -1 0 0 
				age_grp*mml_pass*init_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*init_binary 0 1 0 -1 0 
				age_grp*mml_pass*init_binary 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*init_binary 1 0 -1 0 0 
				age_grp*mml_pass*init_binary 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*init_binary 0 1 0 -1 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*init_binary 1 0 -1 0 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*init_binary 0 1 0 -1 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 / cl; ; 
run;

ods pdf close; 

*initiation binary model (including new states): past month use;

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_month\new_states_past_month_2003_2016_initiation_Chapman.pdf" style = journal2;

proc mixed data = past_month_newStates; 
	title "Past month marijuana use (including new states): Cubic spline, age, binary initiation MML Chapman index";
	class abbrev age_grp mml_pass init_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init_binary 
				age_grp*init_binary mml_pass*init_binary age_grp*mml_pass age_grp*mml_pass*init_binary / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*init_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*init_binary 1 0 -1 0 0 0
				age_grp*mml_pass*init_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*init_binary 0 1 0 0 -1 0
				age_grp*mml_pass*init_binary 0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*init_binary 1 0 -1 0 0 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*init_binary 0 1 0 0 -1 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*init_binary 1 0 -1 0 0 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*init_binary 0 1 0 0 -1 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 / cl; ; 
run;

ods pdf close; 

*quantity binary model: past month use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_month\past_month_2003_2016_binary_quantity.pdf" style = journal2;

proc mixed data = past_month; 
	title "Marijuana use in last month: Cubic spline, age, binary quantity MML Chapman index";
	class abbrev age_grp mml_pass quant_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass quant_binary 
				age_grp*quant_binary mml_pass*quant_binary age_grp*mml_pass age_grp*mml_pass*quant_binary / solution ddfm = bw outpm = pred; 
	random abbrev / group = age_grp;
	*lsmeans age_grp*mml_pass*quant_binary / pdiff cl; 
	estimate "AGE 12-17: After to Before, High Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*quant_binary 1 0 -1 0 0 
				age_grp*mml_pass*quant_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "AGE 12-17: After to Before, Low Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*quant_binary 0 1 0 -1 0 
				age_grp*mml_pass*quant_binary 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "AGE 18-25: After to Before, High Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*quant_binary 1 0 -1 0 0 
				age_grp*mml_pass*quant_binary 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "AGE 18-25: After to Before, Low Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*quant_binary 0 1 0 -1 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*quant_binary 1 0 -1 0 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*quant_binary 0 1 0 -1 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 / cl; ; 
run; 

ods pdf close; 

*quantity binary model (including new states): past month use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_month\new_states_past_month_2003_2016_quantity_Chapman.pdf" style = journal2;

proc mixed data = past_month_newStates; 
	title "Past month marijuana use (including new states): Cubic spline, age, binary quantity MML Chapman index";
	class abbrev age_grp mml_pass quant_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass quant_binary 
				age_grp*quant_binary mml_pass*quant_binary age_grp*mml_pass age_grp*mml_pass*quant_binary / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*quant_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*quant_binary 1 0 -1 0 0 0
				age_grp*mml_pass*quant_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*quant_binary 0 1 0 0 -1 0
				age_grp*mml_pass*quant_binary 0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*quant_binary 1 0 -1 0 0 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*quant_binary 0 1 0 0 -1 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*quant_binary 1 0 -1 0 0 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*quant_binary 0 1 0 0 -1 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 / cl; ; 
run;

ods pdf close; 


*distribution binary model: past month use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_month\past_month_2003_2016_binary_distribution.pdf" style = journal2;

proc mixed data = past_month; 
	title "Marijuana use in last month: Cubic spline, age, binary distribution MML Chapman index";
	class abbrev age_grp mml_pass dist_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass dist_binary 
				age_grp*dist_binary mml_pass*dist_binary age_grp*mml_pass age_grp*mml_pass*dist_binary / solution ddfm = bw outpm = pred; 
	random abbrev / group = age_grp;
	*lsmeans age_grp*mml_pass*dist_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*dist_binary 1 0 -1 0 0 
				age_grp*mml_pass*dist_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*dist_binary 0 1 0 -1 0 
				age_grp*mml_pass*dist_binary 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*dist_binary 1 0 -1 0 0 
				age_grp*mml_pass*dist_binary 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*dist_binary 0 1 0 -1 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*dist_binary 1 0 -1 0 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*dist_binary 0 1 0 -1 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 / cl; ; 
run; 

ods pdf close;

*distribution binary model (including new states): past month use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_month\new_states_past_month_2003_2016_distribution_Chapman.pdf" style = journal2;

proc mixed data = past_month_newStates; 
	title "Past month marijuana use (including new states): Cubic spline, age, binary distribution MML Chapman index";
	class abbrev age_grp mml_pass dist_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass dist_binary 
				age_grp*dist_binary mml_pass*dist_binary age_grp*mml_pass age_grp*mml_pass*dist_binary / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*dist_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*dist_binary 1 0 -1 0 0 0
				age_grp*mml_pass*dist_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*dist_binary 0 1 0 0 -1 0
				age_grp*mml_pass*dist_binary 0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*dist_binary 1 0 -1 0 0 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*dist_binary 0 1 0 0 -1 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*dist_binary 1 0 -1 0 0 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*dist_binary 0 1 0 0 -1 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 / cl; ; 
run;

ods pdf close; 


***********************************************************************************************************************************************
************************************************FIRST USE ANALYSIS*****************************************************************************
***********************************************************************************************************************************************

importing data for first use of marijuana; 

proc import out = first1
 	datafile = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\first_use\first_use_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "12-17"; 
run; 

proc import out = first2
	datafile = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\first_use\first_use_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "18-25"; 
run; 

proc import out = first3
	datafile = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\first_use\first_use_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "26+"; 
run; 

*stacking data; 

data first_use_wide; 
	set first1 first2 first3; 
	if state = "" | state = "District of Columbia" then delete; 
run; 

*tranposing data; 

proc sort data = first_use_wide; 
	by state age_grp; 
run; 

proc transpose data = first_use_wide out = first_use
		(drop = _LABEL_ rename = (col1 = use)); 
	by state age_grp; 
	var estimate_2003 estimate_2004 estimate_2005 estimate_2006 estimate_2007 
		estimate_2008 estimate_2009 estimate_2010 estimate_2011 estimate_2012 
		estimate_2013 estimate_2014 estimate_2015 estimate_2016; 
run; 

data first_use; 
	set first_use; 
	drop _NAME_; 
	year = input(transtrn(_NAME_, "estimate_", ""), 5.); 
run; 

*creating abbreviation; 

data first_use; 
	set first_use; 
	if state = 'Alabama' then abbrev = 'AL'; 
	if state = 'Alaska' then abbrev = 'AK'; 
	if state = 'Arizona' then abbrev = 'AZ'; 
	if state = 'Arkansas' then abbrev = 'AR'; 
	if state = 'California' then abbrev = 'CA'; 
	if state = 'Colorado' then abbrev = 'CO'; 
	if state = 'Connecticut' then abbrev = 'CT'; 
	if state = 'Delaware' then abbrev = 'DE'; 
	if state = 'Florida' then abbrev = 'FL'; 
	if state = 'Georgia' then abbrev = 'GA'; 
	if state = 'Hawaii' then abbrev = 'HI'; 
	if state = 'Idaho' then abbrev = 'ID'; 
	if state = 'Illinois' then abbrev = 'IL'; 
	if state = 'Indiana' then abbrev = 'IN'; 
	if state = 'Iowa' then abbrev = 'IA'; 
	if state = 'Kansas' then abbrev = 'KS'; 
	if state = 'Kentucky' then abbrev = 'KY'; 
	if state = 'Louisiana' then abbrev = 'LA'; 
	if state = 'Maine' then abbrev = 'ME'; 
	if state = 'Maryland' then abbrev = 'MD'; 
	if state = 'Massachusetts' then abbrev = 'MA'; 
	if state = 'Michigan' then abbrev = 'MI'; 
	if state = 'Minnesota' then abbrev = 'MN'; 
	if state = 'Mississippi' then abbrev = 'MS'; 
	if state = 'Missouri' then abbrev = 'MO'; 
	if state = 'Montana' then abbrev = 'MT'; 
	if state = 'Nebraska' then abbrev = 'NE'; 
	if state = 'Nevada' then abbrev = 'NV'; 
	if state = 'New Hampshire' then abbrev = 'NH'; 
	if state = 'New Jersey' then abbrev = 'NJ'; 
	if state = 'New Mexico' then abbrev = 'NM'; 
	if state = 'New York' then abbrev = 'NY'; 
	if state = 'North Carolina' then abbrev = 'NC'; 
	if state = 'North Dakota' then abbrev = 'ND'; 
	if state = 'Ohio' then abbrev = 'OH'; 
	if state = 'Oklahoma' then abbrev = 'OK'; 
	if state = 'Oregon' then abbrev = 'OR'; 
	if state = 'Pennsylvania' then abbrev = 'PA'; 
	if state = 'Rhode Island' then abbrev = 'RI'; 
	if state = 'South Carolina' then abbrev = 'SC'; 
	if state = 'South Dakota' then abbrev = 'SD'; 
	if state = 'Tennessee' then abbrev = 'TN'; 
	if state = 'Texas' then abbrev = 'TX'; 
	if state = 'Utah' then abbrev = 'UT'; 
	if state = 'Vermont' then abbrev = 'VT'; 
	if state = 'Virginia' then abbrev = 'VA'; 
	if state = 'Washington' then abbrev = 'WA'; 
	if state = 'West Virginia' then abbrev = 'WV'; 
	if state = 'Wisconsin' then abbrev = 'WI'; 
	if state = 'Wyoming' then abbrev = 'WY'; 
run;

*reordering variables; 

data first_use; 
	retain abbrev state year age_grp use; 
	set first_use;  
run; 

*adding Chapman index info from past_month dataset; 

proc sort data = first_use; 
	by abbrev year; 
run; 

proc sort data = past_month; 
	by abbrev year; 
run; 

data first_use;
   merge first_use past_month (drop = state year use);
   by abbrev;
run;

*adding info for new states; 

data first_use_newStates; 
	set first_use; 
	if abbrev in ("ND" "FL" "OH" "PA")
		then ever_pass = 1; 
	if abbrev = "ND" and year < 2016 then law_status = 0; 
	if abbrev = "FL" and year < 2016 then law_status = 0; 
	if abbrev = "OH" and year < 2016 then law_status = 0; 
	if abbrev = "PA" and year < 2016 then law_status = 0; 
	if ever_pass = 1 and law_status = 0 then mml_pass = "before"; 
		else if ever_pass = 1 and law_status = 1 then mml_pass = "after"; 
		else if ever_pass = 0 then mml_pass = "never"; 
run;

*after vs. before: first use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\first_use\first_use_2003_2016_noChapman.pdf" style = journal2; 

proc mixed data = first_use;
	title "First use of marijuana: Cubic spline, age";
	class abbrev age_grp mml_pass; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass age_grp*mml_pass / solution dfm = bw; 
	random abbrev / group = age_grp;
	lsmeans age_grp*mml_pass / pdiff cl; 
	estimate "Age 12-17: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0;
	estimate "Age 18-25: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0;
	estimate "Age 26+: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0;
run; 

ods pdf close; 

*after vs. before (including new states): first use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\first_use\new_states_first_use_2003_2016_noChapman.pdf" style = journal2;


proc mixed data = first_use_newStates;
	title "First use of marijuana (including new states): Cubic spline, age";
	class abbrev age_grp mml_pass; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass age_grp*mml_pass / solution dfm = bw; 
	random abbrev / group = age_grp;
	*lsmeans age_grp*mml_pass / pdiff cl;
	estimate "Age 12-17: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0;
	estimate "Age 18-25: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0;
	estimate "Age 26+: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0;
run;

ods pdf close;

*overall restrictiveness model: first use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\first_use\first_use_2003_2016_overall_Chapman.pdf" style = journal2;

proc mixed data = first_use; 
	title "First use of marijuna: Cubic spline, age, binary MML Chapman index";
	class abbrev age_grp mml_pass restrict; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass restrict 
				age_grp*restrict mml_pass*restrict age_grp*mml_pass age_grp*mml_pass*restrict / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*restrict / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 
				age_grp*mml_pass*restrict 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 0 1 0 -1 0 
				age_grp*mml_pass*restrict 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 
				age_grp*mml_pass*restrict 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*restrict 0 1 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*restrict 1 0 -1 0 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*restrict 0 1 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 / cl; ; 
run;

ods pdf close; 

*overall restrictiveness (including new states): first use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\first_use\new_states_first_use_2003_2016_overall_Chapman.pdf" style = journal2;

proc mixed data = first_use_newStates; 
	title "First use of marijuana (including new states): Cubic spline, age, binary MML Chapman index";
	class abbrev age_grp mml_pass restrict; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass restrict 
				age_grp*restrict mml_pass*restrict age_grp*mml_pass age_grp*mml_pass*restrict / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*restrict / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 0
				age_grp*mml_pass*restrict 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 0 1 0 0 -1 0
				age_grp*mml_pass*restrict 0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*restrict 0 1 0 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*restrict 1 0 -1 0 0 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*restrict 0 1 0 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 / cl; ; 
run;

ods pdf close; 

*initiation binary model: first use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\first_use\first_use_2003_2016_binary_initiation.pdf" style = journal2;

proc mixed data = first_use; 
	title "First use of marijuana: Cubic spline, age, binary initiation MML Chapman index";
	class abbrev age_grp mml_pass init_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init_binary 
				age_grp*init_binary mml_pass*init_binary age_grp*mml_pass age_grp*mml_pass*init_binary / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*init_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*init_binary 1 0 -1 0 0 
				age_grp*mml_pass*init_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*init_binary 0 1 0 -1 0 
				age_grp*mml_pass*init_binary 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*init_binary 1 0 -1 0 0 
				age_grp*mml_pass*init_binary 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*init_binary 0 1 0 -1 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*init_binary 1 0 -1 0 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*init_binary 0 1 0 -1 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 / cl; ; 
run;

ods pdf close; 

*initiation binary model (including new states): first use;

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\first_use\new_states_first_use_2003_2016_initiation_Chapman.pdf" style = journal2;

proc mixed data = first_use_newStates; 
	title "First use of marijuana (including new states): Cubic spline, age, binary initiation MML Chapman index";
	class abbrev age_grp mml_pass init_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init_binary 
				age_grp*init_binary mml_pass*init_binary age_grp*mml_pass age_grp*mml_pass*init_binary / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*init_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*init_binary 1 0 -1 0 0 0
				age_grp*mml_pass*init_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*init_binary 0 1 0 0 -1 0
				age_grp*mml_pass*init_binary 0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*init_binary 1 0 -1 0 0 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*init_binary 0 1 0 0 -1 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*init_binary 1 0 -1 0 0 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*init_binary 0 1 0 0 -1 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 / cl; ; 
run;

ods pdf close; 

*quantity binary model: first use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\first_use\first_use_2003_2016_binary_quantity.pdf" style = journal2;

proc mixed data = first_use; 
	title "First use of marijuana: Cubic spline, age, binary quantity MML Chapman index";
	class abbrev age_grp mml_pass quant_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass quant_binary 
				age_grp*quant_binary mml_pass*quant_binary age_grp*mml_pass age_grp*mml_pass*quant_binary / solution ddfm = bw outpm = pred; 
	random abbrev / group = age_grp;
	*lsmeans age_grp*mml_pass*quant_binary / pdiff cl; 
	estimate "AGE 12-17: After to Before, High Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*quant_binary 1 0 -1 0 0 
				age_grp*mml_pass*quant_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "AGE 12-17: After to Before, Low Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*quant_binary 0 1 0 -1 0 
				age_grp*mml_pass*quant_binary 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "AGE 18-25: After to Before, High Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*quant_binary 1 0 -1 0 0 
				age_grp*mml_pass*quant_binary 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "AGE 18-25: After to Before, Low Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*quant_binary 0 1 0 -1 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*quant_binary 1 0 -1 0 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*quant_binary 0 1 0 -1 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 / cl; ; 
run; 

ods pdf close; 

*quantity binary model (including new states): past month use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\first_use\new_states_first_use_2003_2016_quantity_Chapman.pdf" style = journal2;

proc mixed data = first_use_newStates; 
	title "First use of marijuana (including new states): Cubic spline, age, binary quantity MML Chapman index";
	class abbrev age_grp mml_pass quant_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass quant_binary 
				age_grp*quant_binary mml_pass*quant_binary age_grp*mml_pass age_grp*mml_pass*quant_binary / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*quant_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*quant_binary 1 0 -1 0 0 0
				age_grp*mml_pass*quant_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*quant_binary 0 1 0 0 -1 0
				age_grp*mml_pass*quant_binary 0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*quant_binary 1 0 -1 0 0 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*quant_binary 0 1 0 0 -1 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*quant_binary 1 0 -1 0 0 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*quant_binary 0 1 0 0 -1 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 / cl; ; 
run;

ods pdf close; 

*distribution binary model: first use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\first_use\first_use_2003_2016_binary_distribution.pdf" style = journal2;

proc mixed data = first_use; 
	title "First use of marijuana: Cubic spline, age, binary distribution MML Chapman index";
	class abbrev age_grp mml_pass dist_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass dist_binary 
				age_grp*dist_binary mml_pass*dist_binary age_grp*mml_pass age_grp*mml_pass*dist_binary / solution ddfm = bw outpm = pred; 
	random abbrev / group = age_grp;
	*lsmeans age_grp*mml_pass*dist_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*dist_binary 1 0 -1 0 0 
				age_grp*mml_pass*dist_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*dist_binary 0 1 0 -1 0 
				age_grp*mml_pass*dist_binary 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*dist_binary 1 0 -1 0 0 
				age_grp*mml_pass*dist_binary 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*dist_binary 0 1 0 -1 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*dist_binary 1 0 -1 0 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*dist_binary 0 1 0 -1 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 / cl; ; 
run; 

ods pdf close;

*distribution binary model (including new states): first use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\first_use\new_states_first_use_2003_2016_distribution_Chapman.pdf" style = journal2;

proc mixed data = first_use_newStates; 
	title "First use of marijuana (including new states): Cubic spline, age, binary distribution MML Chapman index";
	class abbrev age_grp mml_pass dist_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass dist_binary 
				age_grp*dist_binary mml_pass*dist_binary age_grp*mml_pass age_grp*mml_pass*dist_binary / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*dist_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*dist_binary 1 0 -1 0 0 0
				age_grp*mml_pass*dist_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*dist_binary 0 1 0 0 -1 0
				age_grp*mml_pass*dist_binary 0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*dist_binary 1 0 -1 0 0 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*dist_binary 0 1 0 0 -1 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*dist_binary 1 0 -1 0 0 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*dist_binary 0 1 0 0 -1 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 / cl; ; 
run;

ods pdf close; 


***********************************************************************************************************************************************
************************************************PAST YEAR USE ANALYSIS*************************************************************************
***********************************************************************************************************************************************

importing data for past year use of marijuana; 

proc import out = age12
 	datafile = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_year\past_year_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "12-17"; 
run; 

proc import out = age18
	datafile = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_year\past_year_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "18-25"; 
run; 

proc import out = age26
	datafile = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_year\past_year_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "26+"; 
run; 

*stacking data; 

data past_year_wide; 
	set age12 age18 age26; 
	if state = "" | state = "District of Columbia" then delete; 
run; 

*tranposing data; 

proc sort data = past_year_wide; 
	by state age_grp; 
run; 

proc transpose data = past_year_wide out = past_year
		(drop = _LABEL_ rename = (col1 = use)); 
	by state age_grp; 
	var estimate_2003 estimate_2004 estimate_2005 estimate_2006 estimate_2007 
		estimate_2008 estimate_2009 estimate_2010 estimate_2011 estimate_2012 
		estimate_2013 estimate_2014 estimate_2015 estimate_2016; 
run; 

data past_year; 
	set past_year; 
	drop _NAME_; 
	year = input(transtrn(_NAME_, "estimate_", ""), 5.); 
run;

*creating abbreviation; 

data past_year; 
	set past_year; 
	if state = 'Alabama' then abbrev = 'AL'; 
	if state = 'Alaska' then abbrev = 'AK'; 
	if state = 'Arizona' then abbrev = 'AZ'; 
	if state = 'Arkansas' then abbrev = 'AR'; 
	if state = 'California' then abbrev = 'CA'; 
	if state = 'Colorado' then abbrev = 'CO'; 
	if state = 'Connecticut' then abbrev = 'CT'; 
	if state = 'Delaware' then abbrev = 'DE'; 
	if state = 'Florida' then abbrev = 'FL'; 
	if state = 'Georgia' then abbrev = 'GA'; 
	if state = 'Hawaii' then abbrev = 'HI'; 
	if state = 'Idaho' then abbrev = 'ID'; 
	if state = 'Illinois' then abbrev = 'IL'; 
	if state = 'Indiana' then abbrev = 'IN'; 
	if state = 'Iowa' then abbrev = 'IA'; 
	if state = 'Kansas' then abbrev = 'KS'; 
	if state = 'Kentucky' then abbrev = 'KY'; 
	if state = 'Louisiana' then abbrev = 'LA'; 
	if state = 'Maine' then abbrev = 'ME'; 
	if state = 'Maryland' then abbrev = 'MD'; 
	if state = 'Massachusetts' then abbrev = 'MA'; 
	if state = 'Michigan' then abbrev = 'MI'; 
	if state = 'Minnesota' then abbrev = 'MN'; 
	if state = 'Mississippi' then abbrev = 'MS'; 
	if state = 'Missouri' then abbrev = 'MO'; 
	if state = 'Montana' then abbrev = 'MT'; 
	if state = 'Nebraska' then abbrev = 'NE'; 
	if state = 'Nevada' then abbrev = 'NV'; 
	if state = 'New Hampshire' then abbrev = 'NH'; 
	if state = 'New Jersey' then abbrev = 'NJ'; 
	if state = 'New Mexico' then abbrev = 'NM'; 
	if state = 'New York' then abbrev = 'NY'; 
	if state = 'North Carolina' then abbrev = 'NC'; 
	if state = 'North Dakota' then abbrev = 'ND'; 
	if state = 'Ohio' then abbrev = 'OH'; 
	if state = 'Oklahoma' then abbrev = 'OK'; 
	if state = 'Oregon' then abbrev = 'OR'; 
	if state = 'Pennsylvania' then abbrev = 'PA'; 
	if state = 'Rhode Island' then abbrev = 'RI'; 
	if state = 'South Carolina' then abbrev = 'SC'; 
	if state = 'South Dakota' then abbrev = 'SD'; 
	if state = 'Tennessee' then abbrev = 'TN'; 
	if state = 'Texas' then abbrev = 'TX'; 
	if state = 'Utah' then abbrev = 'UT'; 
	if state = 'Vermont' then abbrev = 'VT'; 
	if state = 'Virginia' then abbrev = 'VA'; 
	if state = 'Washington' then abbrev = 'WA'; 
	if state = 'West Virginia' then abbrev = 'WV'; 
	if state = 'Wisconsin' then abbrev = 'WI'; 
	if state = 'Wyoming' then abbrev = 'WY'; 
run;

*reordering variables; 

data past_year; 
	retain abbrev state year age_grp use; 
	set past_year;  
run; 

*adding Chapman index info from past_month dataset; 

proc sort data = past_year; 
	by abbrev year; 
run; 

proc sort data = past_month; 
	by abbrev year; 
run; 

data past_year;
   merge past_year past_month (drop = state year use);
   by abbrev;
run;

*adding info for new states; 

data past_year_newStates; 
	set past_year; 
	if abbrev in ("ND" "FL" "OH" "PA")
		then ever_pass = 1; 
	if abbrev = "ND" and year < 2016 then law_status = 0; 
	if abbrev = "FL" and year < 2016 then law_status = 0; 
	if abbrev = "OH" and year < 2016 then law_status = 0; 
	if abbrev = "PA" and year < 2016 then law_status = 0; 
	if ever_pass = 1 and law_status = 0 then mml_pass = "before"; 
		else if ever_pass = 1 and law_status = 1 then mml_pass = "after"; 
		else if ever_pass = 0 then mml_pass = "never"; 
run;

*model looking at after vs. before past_year; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_year\past_year_2003_2016_noChapman.pdf" style = journal2; 

proc mixed data = past_year;
	title "Past year use of marijuana: Cubic spline, age";
	class abbrev age_grp mml_pass; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass age_grp*mml_pass / solution dfm = bw; 
	random abbrev / group = age_grp;
	*lsmeans age_grp*mml_pass / pdiff cl; 
	estimate "Age 12-17: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0;
	estimate "Age 18-25: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0;
	estimate "Age 26+: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0;
run; 

ods pdf close; 

*after vs. before (including new states): past year; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_year\new_states_past_year_2003_2016_noChapman.pdf" style = journal2;


proc mixed data = past_year_newStates;
	title "Past year use of marijuana (including new states): Cubic spline, age";
	class abbrev age_grp mml_pass; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass age_grp*mml_pass / solution dfm = bw; 
	random abbrev / group = age_grp;
	*lsmeans age_grp*mml_pass / pdiff cl;
	estimate "Age 12-17: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0;
	estimate "Age 18-25: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0;
	estimate "Age 26+: After to Before" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0;
run;

ods pdf close;

*overall restrictiveness model: past year use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_year\past_year_2003_2016_overall_Chapman.pdf" style = journal2;

proc mixed data = past_year; 
	title "Past year use of marijuna: Cubic spline, age, binary MML Chapman index";
	class abbrev age_grp mml_pass restrict; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass restrict 
				age_grp*restrict mml_pass*restrict age_grp*mml_pass age_grp*mml_pass*restrict / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*restrict / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 
				age_grp*mml_pass*restrict 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 0 1 0 -1 0 
				age_grp*mml_pass*restrict 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 
				age_grp*mml_pass*restrict 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*restrict 0 1 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*restrict 1 0 -1 0 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*restrict 0 1 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 / cl; ; 
run;

ods pdf close; 

*overall restrictiveness (including new states): past year use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_year\new_states_past_year_2003_2016_overall_Chapman.pdf" style = journal2;

proc mixed data = past_year_newStates; 
	title "Past year use of marijuana (including new states): Cubic spline, age, binary MML Chapman index";
	class abbrev age_grp mml_pass restrict; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass restrict 
				age_grp*restrict mml_pass*restrict age_grp*mml_pass age_grp*mml_pass*restrict / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*restrict / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 0
				age_grp*mml_pass*restrict 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 0 1 0 0 -1 0
				age_grp*mml_pass*restrict 0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*restrict 0 1 0 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*restrict 1 0 -1 0 0 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*restrict 0 1 0 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 / cl; ; 
run;

ods pdf close; 

*initiation binary model: past year use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_year\past_year_2003_2016_binary_initiation.pdf" style = journal2;

proc mixed data = past_year; 
	title "Past year use of marijuana: Cubic spline, age, binary initiation MML Chapman index";
	class abbrev age_grp mml_pass init_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init_binary 
				age_grp*init_binary mml_pass*init_binary age_grp*mml_pass age_grp*mml_pass*init_binary / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	lsmeans age_grp*mml_pass*init_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*init_binary 1 0 -1 0 0 
				age_grp*mml_pass*init_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*init_binary 0 1 0 -1 0 
				age_grp*mml_pass*init_binary 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*init_binary 1 0 -1 0 0 
				age_grp*mml_pass*init_binary 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*init_binary 0 1 0 -1 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*init_binary 1 0 -1 0 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Initiation Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*init_binary 0 1 0 -1 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 / cl; ; 
run;

ods pdf close; 

*initiation binary model (including new states): past year use;

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_year\new_states_past_year_2003_2016_initiation_Chapman.pdf" style = journal2;

proc mixed data = past_year_newStates; 
	title "Past year use of marijuana (including new states): Cubic spline, age, binary initiation MML Chapman index";
	class abbrev age_grp mml_pass init_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass init_binary 
				age_grp*init_binary mml_pass*init_binary age_grp*mml_pass age_grp*mml_pass*init_binary / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*init_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*init_binary 1 0 -1 0 0 0
				age_grp*mml_pass*init_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*init_binary 0 1 0 0 -1 0
				age_grp*mml_pass*init_binary 0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*init_binary 1 0 -1 0 0 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*init_binary 0 1 0 0 -1 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*init_binary 1 0 -1 0 0 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*init_binary 0 1 0 0 -1 0
				age_grp*mml_pass*init_binary 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 / cl; ; 
run;

ods pdf close; 

*quantity binary model: past year use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_year\past_year_2003_2016_binary_quantity.pdf" style = journal2;

proc mixed data = past_year; 
	title "Past year use of marijuana: Cubic spline, age, binary quantity MML Chapman index";
	class abbrev age_grp mml_pass quant_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass quant_binary 
				age_grp*quant_binary mml_pass*quant_binary age_grp*mml_pass age_grp*mml_pass*quant_binary / solution ddfm = bw outpm = pred; 
	random abbrev / group = age_grp;
	*lsmeans age_grp*mml_pass*quant_binary / pdiff cl; 
	estimate "AGE 12-17: After to Before, High Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*quant_binary 1 0 -1 0 0 
				age_grp*mml_pass*quant_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "AGE 12-17: After to Before, Low Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*quant_binary 0 1 0 -1 0 
				age_grp*mml_pass*quant_binary 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "AGE 18-25: After to Before, High Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*quant_binary 1 0 -1 0 0 
				age_grp*mml_pass*quant_binary 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "AGE 18-25: After to Before, Low Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*quant_binary 0 1 0 -1 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*quant_binary 1 0 -1 0 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Quantity Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*quant_binary 0 1 0 -1 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 / cl; ; 
run; 

ods pdf close;

*quantity binary model (including new states): past year use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_year\new_states_past_year_2003_2016_quantity_Chapman.pdf" style = journal2;

proc mixed data = past_year_newStates; 
	title "Past year use of marijuana (including new states): Cubic spline, age, binary quantity MML Chapman index";
	class abbrev age_grp mml_pass quant_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass quant_binary 
				age_grp*quant_binary mml_pass*quant_binary age_grp*mml_pass age_grp*mml_pass*quant_binary / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*quant_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*quant_binary 1 0 -1 0 0 0
				age_grp*mml_pass*quant_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*quant_binary 0 1 0 0 -1 0
				age_grp*mml_pass*quant_binary 0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*quant_binary 1 0 -1 0 0 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*quant_binary 0 1 0 0 -1 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*quant_binary 1 0 -1 0 0 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*quant_binary 0 1 0 0 -1 0
				age_grp*mml_pass*quant_binary 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 / cl; ; 
run;

ods pdf close; 

*distribution binary model: past year use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_year\past_year_2003_2016_binary_distribution.pdf" style = journal2;

proc mixed data = past_year; 
	title "Past year use of marijuana: Cubic spline, age, binary distribution MML Chapman index";
	class abbrev age_grp mml_pass dist_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass dist_binary 
				age_grp*dist_binary mml_pass*dist_binary age_grp*mml_pass age_grp*mml_pass*dist_binary / solution ddfm = bw outpm = pred; 
	random abbrev / group = age_grp;
	*lsmeans age_grp*mml_pass*dist_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*dist_binary 1 0 -1 0 0 
				age_grp*mml_pass*dist_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*dist_binary 0 1 0 -1 0 
				age_grp*mml_pass*dist_binary 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*dist_binary 1 0 -1 0 0 
				age_grp*mml_pass*dist_binary 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*dist_binary 0 1 0 -1 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*dist_binary 1 0 -1 0 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Distribution Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*dist_binary 0 1 0 -1 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 / cl; ; 
run; 

ods pdf close;

*distribution binary model (including new states): past year use; 

ods pdf file = "C:\Users\niwi8\OneDrive\Documents\Practicum\MML_analysis\MML_chapman_index\reports\past_year\new_states_past_year_2003_2016_distribution_Chapman.pdf" style = journal2;

proc mixed data = past_year_newStates; 
	title "Past year use of marijuana (including new states): Cubic spline, age, binary distribution MML Chapman index";
	class abbrev age_grp mml_pass dist_binary; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass dist_binary 
				age_grp*dist_binary mml_pass*dist_binary age_grp*mml_pass age_grp*mml_pass*dist_binary / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*dist_binary / pdiff cl; 
	estimate "Age 12-17: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*dist_binary 1 0 -1 0 0 0
				age_grp*mml_pass*dist_binary 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*dist_binary 0 1 0 0 -1 0
				age_grp*mml_pass*dist_binary 0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*dist_binary 1 0 -1 0 0 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*dist_binary 0 1 0 0 -1 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*dist_binary 1 0 -1 0 0 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 / cl; 
	estimate "Age 26+: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 0 0 0 1 -1 0
				mml_pass*dist_binary 0 1 0 0 -1 0
				age_grp*mml_pass*dist_binary 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 / cl; ; 
run;

ods pdf close; 
