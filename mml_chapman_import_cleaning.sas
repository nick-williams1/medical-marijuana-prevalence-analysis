ods noproctitle; 
options nodate; 

* importing data for past month use;  

proc import out = month1
 	datafile = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_month\past_month_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "12-17"; 
run; 

proc import out = month2
	datafile = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_month\past_month_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "18-25"; 
run; 

proc import out = month3
	datafile = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_month\past_month_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "26+"; 
run;

* importing data for past year use; 

proc import out = year1
 	datafile = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_year\past_year_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "12-17"; 
run; 

proc import out = year2
	datafile = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_year\past_year_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "18-25"; 
run; 

proc import out = year3
	datafile = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_year\past_year_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "26+"; 
run; 


* importing data for first use of marijuana; 

proc import out = first1
 	datafile = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\first_use\first_use_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "12-17"; 
run; 

proc import out = first2
	datafile = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\first_use\first_use_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "18-25"; 
run; 

proc import out = first3
	datafile = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\first_use\first_use_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "26+"; 
run; 

* stacking data sets; 

data past_month_wide; 
	set month1 month2 month3; 
	if state = "" | state = "District of Columbia" then delete; 
run; 

data past_year_wide; 
	set year1 year2 year3; 
	if state = "" | state = "District of Columbia" then delete; 
run; 

data first_use_wide; 
	set first1 first2 first3; 
	if state = "" | state = "District of Columbia" then delete; 
run; 

* tranposing data sets; 

proc sort data = past_month_wide; 
	by state age_grp; 
run; 

proc transpose data = past_month_wide out = past_month
		(drop = _LABEL_ rename = (col1 = month_use)); 
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


proc sort data = past_year_wide; 
	by state age_grp; 
run; 

proc transpose data = past_year_wide out = past_year
		(drop = _LABEL_ rename = (col1 = year_use)); 
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


proc sort data = first_use_wide; 
	by state age_grp; 
run; 

proc transpose data = first_use_wide out = first_use
		(drop = _LABEL_ rename = (col1 = first_use)); 
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

* merging 3 data sets; 

data all_use; 
	merge past_month past_year first_use; 
	by state age_grp; 
run; 

* creating abbreviations; 

data all_use; 
	set all_use; 
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

* reordering variables; 

data all_use; 
	retain abbrev state year age_grp month_use year_use first_use; 
	set all_use;  
run; 

* creating information regarding medical marijuana laws; 

data all_use; 
	set all_use; 
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

data all_use; 
	set all_use; 
	yearcont = year - 2003; 
	yearsp = max(yearcont - 5, 0); 
run;

*adding Chapman information; 

data all_use; 
	set all_use; 
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
			if abbrev = 'VT' and year < 2006 then init = 2; 
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
			if abbrev = 'CO' and year < 2010 then dist = 4;  
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
			if abbrev = 'NV' and year < 2013 then dist = 5; 
		if abbrev = 'NH' then dist = 2; 
		if abbrev = 'NJ' then dist = 1; 
		if abbrev = 'NM' then dist = 2; 
		if abbrev = 'NY' then dist = 1; 
		if abbrev = 'OR' then dist = 3;
			if abbrev = 'OR' and year < 2013 then dist = 5; 
		if abbrev = 'RI' then dist = 3; 
			if abbrev = 'RI' and year < 2009 then dist = 4;
		if abbrev = 'VT' then dist = 2; 
			if abbrev = 'VT' and year < 2011 then dist = 4;
		if abbrev = 'WA' then dist = 4;

		overall = sum(init, quant, dist); 
run;  

* creating formats for illegal states; 

proc format; 
	value illegal_fmt . = "illegal";
run;  

data all_use; 
	set all_use;
	format init illegal_fmt.;  
	format quant illegal_fmt.;
	format dist illegal_fmt.; 
	format overall illegal_fmt.; 
run; 

*creating binary variables based on median values of chapman index; 

data all_use; 
	set all_use;
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
