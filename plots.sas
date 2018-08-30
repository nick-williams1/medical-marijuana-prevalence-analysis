ods noproctitle; 
options nodate; 

ods pdf file = "C:\Users\niwi8\OneDrive - cumc.columbia.edu\Practicum\MML_analysis\MML_chapman_index\reports\histograms";

title "Distribution of Overrall Restrictiveness"; 
proc sgplot data = past_month; 
	histogram overall / binwidth = 1
						fillattrs = (color = verylightmoderateorange); 
	density overall / type = kernel lineattrs = (color = black);
	refline 10 / axis = x lineattrs = (color = black pattern = 2);
	xaxis label = "Overall Restricteveness"; 
run; 

title "Distribution of Initiation Restrictiveness"; 
proc sgplot data = past_month; 
	histogram init / binwidth = 1
					 fillattrs = (color = verylightmoderateorange);
	density init / type = kernel lineattrs = (color = black);
	refline 4 / axis = x lineattrs = (color = black pattern = 2); 
	xaxis label = "Initiation Restricteveness";
run; 

title "Distribution of Quantity Restrictveness"; 
proc sgplot data = past_month; 
	histogram quant / binwidth = 1
					  fillattrs = (color = verylightmoderateorange);
	density quant / type = kernel lineattrs = (color = black); 
	refline 3 / axis = x lineattrs = (color = black pattern = 2);
	xaxis label = "Quantity Restricteveness";
run; 

title "Distribution of Distribution Restrictevness"; 
proc sgplot data = past_month; 
	histogram dist / binwidth = 1 
					 fillattrs = (color = verylightmoderateorange);
	density dist / type = kernel lineattrs = (color = black);
	refline 3 / axis = x lineattrs = (color = black pattern = 2); 
	xaxis label = "Distribution Restricteveness";
run; 

ods pdf close; 
