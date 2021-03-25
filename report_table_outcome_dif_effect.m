function report_table_outcome_dif_effect(addr,ftype)

%% choice
load([addr.glme filesep 'glme_regret_onchoice_switch_' ftype]);


data(:,1)   = glme.Coefficients.Estimate;
data(:,2)   = glme.Coefficients.SE;
data(:,3)   = glme.Coefficients.tStat;
data(:,4)   = glme.Coefficients.DF;
data(:,5)   = glme.Coefficients.pValue;
data(:,6)   = glme.Coefficients.Lower;
data(:,7)   = glme.Coefficients.Upper;

tble.rows    = glme.CoefficientNames'; 
tble.columns = glme.Coefficients.Properties.VarNames;
tble.data    = data; 

%% rt
load([addr.glme filesep 'glme_regret_onrt_switch_' ftype]);


data(:,1)   = glme.Coefficients.Estimate;
data(:,2)   = glme.Coefficients.SE;
data(:,3)   = glme.Coefficients.tStat;
data(:,4)   = glme.Coefficients.DF;
data(:,5)   = glme.Coefficients.pValue;
data(:,6)   = glme.Coefficients.Lower;
data(:,7)   = glme.Coefficients.Upper;

tble.rows    = glme.CoefficientNames'; 
tble.columns = glme.Coefficients.Properties.VarNames;
tble.data    = data; 

disp(tble);
