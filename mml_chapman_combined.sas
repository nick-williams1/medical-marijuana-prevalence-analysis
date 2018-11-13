ods noproctitle; 
options nodate;

* PAST MONTH USE ANALYSIS WITH WITH ILLEGAL CODED AS HIGH ON CHAPMAN;

 *importing data for past month use; 

proc import out = age1
 	datafile = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_month\past_month_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "12-17"; 
run; 

proc import out = age2
	datafile = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_month\past_month_2003_2016.xlsx"
	dbms = xlsx replace; 
	getnames = yes; 
	sheet = "18-25"; 
run; 

proc import out = age3
	datafile = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\data\NSDUH\past_month\past_month_2003_2016.xlsx"
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

*creating binary variable based on median values; 

data past_month; 
	set past_month;
	restrict = "high or illegal";  
	if overall >= 10 then restrict = "low"; 

	init_binary = "high or illegal"; 
	if init >= 4 then init_binary = "low"; 

	quant_binary = "high or illegal"; 
	if quant >= 3 then quant_binary = "low"; 

	dist_binary = "high or illegal"; 
	if dist >= 3 then dist_binary = "low"; 
run; 

* overall Chapman past-month use; 

ods pdf file = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\reports\combined_illegal_chapman_past_month.pdf"
	style = journal2;

proc mixed data = past_month; 
	title "Past month combined illegal and high: Cubic spline, age, binary MML Chapman index";
	class abbrev age_grp mml_pass restrict; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass restrict 
				age_grp*restrict mml_pass*restrict age_grp*mml_pass age_grp*mml_pass*restrict / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*restrict / pdiff cl; 
	estimate "Age 12-17: After to Before, High or illegal" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 
				age_grp*mml_pass*restrict 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 0 1 0 -1 0 
				age_grp*mml_pass*restrict 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High or illegal" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 
				age_grp*mml_pass*restrict 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*restrict 0 1 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High or illegal" 
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

* looking at the grouping the opposite way; 

proc transpose data = past_month_wide out = past_month2
		(drop = _LABEL_ rename = (col1 = use)); 
	by state age_grp; 
	var estimate_2003 estimate_2004 estimate_2005 estimate_2006 estimate_2007 
		estimate_2008 estimate_2009 estimate_2010 estimate_2011 estimate_2012 
		estimate_2013 estimate_2014 estimate_2015 estimate_2016; 
run; 

data past_month2; 
	set past_month2; 
	drop _NAME_; 
	year = input(transtrn(_NAME_, "estimate_", ""), 5.); 
run; 

*removing DC; 

data past_month2; 
	set past_month2; 
	if state = 'District of Columbia' then delete;
run; 

*creating abbreviation; 

data past_month2; 
	set past_month2; 
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

data past_month2; 
	retain abbrev state year age_grp use; 
	set past_month2;  
run; 

*creating information regarding medical marijuana laws; 

data past_month2; 
	set past_month2; 
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

data past_month2; 
	set past_month2; 
	yearcont = year - 2003; 
	yearsp = max(yearcont - 5, 0); 
run;

*adding Chapman information; 

data past_month2; 
	set past_month2; 
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

proc format; 
	value illegal_fmt . = "illegal";
run;  

data past_month2; 
	set past_month2;
	format init illegal_fmt.;  
	format quant illegal_fmt.;
	format dist illegal_fmt.; 
	format overall illegal_fmt.; 
run; 

*creating binary variable based on median values; 

data past_month2; 
	set past_month2;
	restrict = "low or illegal";  
	if 3 < overall < 10 then restrict = "high"; 

	init_binary = "low or illegal"; 
	if 0 < init < 4 then init_binary = "high"; 

	quant_binary = "low or illegal"; 
	if 0 < quant < 3 then quant_binary = "high"; 

	dist_binary = "low or illegal"; 
	if 0 < dist < 3 then dist_binary = "high"; 
run; 

* overall Chapman past month; 

proc mixed data = past_month2; 
	title "Past month combined illegal and low: Cubic spline, age, binary MML Chapman index";
	class abbrev age_grp mml_pass restrict; 
	model use = yearcont yearcont*yearcont yearcont*yearcont*yearcont
				yearsp*yearsp*yearsp
				age_grp*yearcont age_grp*yearcont*yearcont age_grp*yearcont*yearcont*yearcont
				age_grp*yearsp*yearsp*yearsp
				age_grp mml_pass restrict 
				age_grp*restrict mml_pass*restrict age_grp*mml_pass age_grp*mml_pass*restrict / solution ddfm = bw; 
	random abbrev / group = age_grp; 
	*lsmeans age_grp*mml_pass*restrict / pdiff cl; 
	estimate "Age 12-17: After to Before, High or illegal" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 
				age_grp*mml_pass*restrict 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 12-17: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 1 -1 0 0 0 0 0 0 0 
				mml_pass*restrict 0 1 0 -1 0 
				age_grp*mml_pass*restrict 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 / cl;
	estimate "Age 18-25: After to Before, High or illegal" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0 
				mml_pass*restrict 1 0 -1 0 0 
				age_grp*mml_pass*restrict 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 / cl; 
	estimate "Age 18-25: After to Before, Low Restrictiveness" 
				mml_pass 1 -1 0 
				age_grp*mml_pass 0 0 0 1 -1 0 0 0 0
				mml_pass*restrict 0 1 0 -1 0
				age_grp*mml_pass*restrict 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 / cl; 
	estimate "Age 26+: After to Before, High or illegal" 
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
