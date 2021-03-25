function regression_value(addr,ftype,config,sbjs)
%% Whether the Estimated Value has been affected by Several Factors?


%-load data
%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Transfer.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Estimation.mat']);

FC          = info_learning.statistics.normal.FC;
hist        = info_learning.hist;
Values      = info_estimation.valuation.estimate;
vtype       = config.vtype;
%% Regressors
stim                = 2; %A1,A2,B,C
Dummy(:,1)          = Values(stim,vtype,sbjs.indx);
Y                   = Dummy;

%-Total    DT = difference of stats in total trials
%--------------------------------------------------------------------------
%Value
value_rate           = hist(sbjs.indx,stim);
value_mean           = FC.mean(sbjs.indx,stim);
value_max            = FC.max(sbjs.indx,stim);
value_min            = FC.min(sbjs.indx,stim);
value_std            = FC.std(sbjs.indx,stim);
value_var            = FC.std(sbjs.indx,stim).^2;
value_cv             = FC.std( sbjs.indx,stim)./FC.mean(sbjs.indx,stim);
value_range          = value_max - value_min;

%-Normalize Regressors
%--------------------------------------------------------------------------
zvalue_rate        = zscore(value_rate);
zvalue_mean        = zscore(value_mean);
zvalue_max         = zscore(value_max);
zvalue_min         = zscore(value_min);
zvalue_std         = zscore(value_std);
zvalue_var         = zscore(value_var);
zvalue_cv          = zscore(value_cv);
zvalue_range       = zscore(value_range);

%% table one specific stimulus
tbl               =  table(Y,value_mean );
modelspec         =  strcat('Y ~ value_mean');
lm = fitlm(tbl,modelspec);
display(lm);


%% table all stimuli
FC.mean_z          = zscore(FC.mean(sbjs.indx,:));
X1                 = [FC.mean_z(:,1);FC.mean_z(:,2);FC.mean_z(:,3);FC.mean_z(:,4)];
X2                 = [sbjs.indx,sbjs.indx,sbjs.indx,sbjs.indx]';
X2                 = nominal(X2);
% X1                 = [FC.mean(sbjs.indx,1);   FC.mean(sbjs.indx,2);   FC.mean(sbjs.indx,3);   FC.mean(sbjs.indx,4)];
Y                  = [squeeze(Values(1,vtype,sbjs.indx));squeeze(Values(2,vtype,sbjs.indx));squeeze(Values(3,vtype,sbjs.indx));squeeze(Values(4,vtype,sbjs.indx))];
%%
tbl                =  table(Y,X1,X2);
modelspec          =  strcat('Y ~ X1 + X2');
% lm                 = fitlm(tbl,modelspec); display(lm);
lme                = fitlme(tbl,modelspec); disp(lme);




