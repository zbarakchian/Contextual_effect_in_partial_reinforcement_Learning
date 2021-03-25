function regression_confidence(addr,ftype,config,sbjs)
%-Whether  the Aj or Ai test confidence is because of Several Factors?


%-load data
%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Transfer.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Estimation.mat']);
load([addr.bhv, filesep, 'data_behavioral.mat']);

FC   = info_learning.statistics.normal.FC;
hist = info_learning.hist;
data = data.(ftype).learning;


%% confidence of A1 or A2
%--------------------------------------------------------------------------
disp('confidence of A1 or A2');
%-Regressors
k1 = 1;
k2 = 3 - k1;
switch config.ttype
    case {'rate','binary'}
        Ys = [info_transfer.conf.mean_left(sbjs.indx,1),info_transfer.conf.mean_right(sbjs.indx,1)];
    case 'first'
        Ys = [info_transfer.conf.first_left(sbjs.indx,1),info_transfer.conf.first_right(sbjs.indx,1)];
end
Y  = Ys(:,k1);%A2 from (A1,A2)


%-Total    DT = difference of stats in total trials
%--------------------------------------------------------------------------
%Value
%--------------------------------------------------------------------------
value_rate          = hist(sbjs.indx,k1);
value_mean          = FC.mean(sbjs.indx,k1);
value_max           = FC.max(sbjs.indx,k1);
value_min           = FC.min(sbjs.indx,k1);
value_std           = FC.std(sbjs.indx,k1);
value_cv            = FC.std( sbjs.indx,k1)./FC.mean(sbjs.indx,k1);
value_range         = value_max - value_min;

%-Difference
%--------------------------------------------------------------------------
dif_rate12          = hist(sbjs.indx,k1)         - hist(sbjs.indx,k2);
dif_rate13          = hist(sbjs.indx,1)          - hist(sbjs.indx,3);
dif_rate24          = hist(sbjs.indx,2)          - hist(sbjs.indx,4);
dif_mean12          = FC.mean(sbjs.indx,k1)      - FC.mean(sbjs.indx,k2);
dif_mean13          = FC.mean(sbjs.indx,1)       - FC.mean(sbjs.indx,3);
dif_mean24          = FC.mean(sbjs.indx,2)       - FC.mean(sbjs.indx,4);
dif_mean34          = FC.mean(sbjs.indx,3)       - FC.mean(sbjs.indx,4);
dif_std             = FC.std( sbjs.indx,k1)      - FC.std(sbjs.indx,k2);
dif_cv              = FC.std( sbjs.indx,k1)./FC.mean(sbjs.indx,k1) - FC.std(sbjs.indx,k2)./FC.mean(sbjs.indx,k2);
dif_max             = FC.max( sbjs.indx,k1)      - FC.max(sbjs.indx,k2);
dif_min             = FC.min( sbjs.indx,k1)      - FC.min(sbjs.indx,k2);
dif_range           = dif_max - dif_min;

%-Division
%--------------------------------------------------------------------------
div_rate12          = hist(sbjs.indx,k1) ./ hist(sbjs.indx,k2);
div_rate13          = hist(sbjs.indx,1)  ./ hist(sbjs.indx,3);
div_rate24          = hist(sbjs.indx,2)  ./ hist(sbjs.indx,4);
div_rate34          = hist(sbjs.indx,3)  ./ hist(sbjs.indx,4);
div_meand2d1        = log(dif_mean24 ./ dif_mean13);
div_mean12          = log(FC.mean(sbjs.indx,1) ./ FC.mean(sbjs.indx,2));
div_mean13          = log(FC.mean(sbjs.indx,1) ./ FC.mean(sbjs.indx,3));
div_mean24          = log(FC.mean(sbjs.indx,2) ./ FC.mean(sbjs.indx,4));
div_mean34          = log(FC.mean(sbjs.indx,3) ./ FC.mean(sbjs.indx,4));
div_std             = FC.std( sbjs.indx,k1)    ./ FC.std(sbjs.indx,k2);
div_cv              = (FC.mean( sbjs.indx,k1)./FC.std(sbjs.indx,k1)) ./ (FC.mean( sbjs.indx,k1)./FC.std(sbjs.indx,k1));
div_max             = FC.max( sbjs.indx,k1)    ./ FC.max(sbjs.indx,k2);
div_min             = FC.min( sbjs.indx,k1)    ./ FC.min(sbjs.indx,k2);
div_range           = div_max ./ div_min;

%-Normalize Regressors
%--------------------------------------------------------------------------
zvalue_rate         = zscore(value_rate);
zvalue_mean         = zscore(value_mean);
zvalue_max          = zscore(value_max);
zvalue_min          = zscore(value_min);
zvalue_std          = zscore(value_std);
zvalue_cv           = zscore(value_cv);
zvalue_range        = zscore(value_range);
%--------------------------------------------------------------------------
zdif_rate12         = zscore(dif_rate12);
zdif_rate13         = zscore(dif_rate13);
zdif_rate24         = zscore(dif_rate24);
zdif_mean13         = zscore(dif_mean13);
zdif_mean24         = zscore(dif_mean24);
zdif_mean34         = zscore(dif_mean34);
zdif_meand2d1       = zscore(dif_mean24 - dif_mean13);
zdif_mean           = zscore(dif_mean12);
zdif_std            = zscore(dif_std);
zdif_cv             = zscore(dif_cv);
zdif_max            = zscore(dif_max);
zdif_min            = zscore(dif_min);
zdif_range          = zscore(dif_range);
%--------------------------------------------------------------------------
zdiv_meand2d1       = zscore(div_meand2d1);
zdiv_rate12         = zscore(div_rate12);
zdiv_rate13         = zscore(div_rate13);
zdiv_rate24         = zscore(div_rate24);
zdiv_rate34         = zscore(div_rate34);
zdiv_mean13         = zscore(div_mean13);
zdiv_mean24         = zscore(div_mean24);
zdiv_meand2d1       = zscore(div_mean24 - div_mean13);
zdiv_mean           = zscore(div_mean12);
zdiv_std            = zscore(div_std);
zdiv_cv             = zscore(div_cv);
zdiv_max            = zscore(div_max);
zdiv_min            = zscore(div_min);
zdiv_range          = zscore(div_range);


%% Check collinearity between regressors with pearson correlation
%--------------------------------------------------------------------------
regrs = [div_meand2d1, dif_std, dif_range, dif_rate12];
corr(regrs,regrs);

%% glm
%--------------------------------------------------------------------------
tbl         =  table(Y,zdif_max );
modelspec   =  strcat('Y ~ zdif_max');
lm          = fitlm(tbl,modelspec);
display(lm);

%%  stepwise glm          
X = [div_meand2d1,dif_rate12];
y = Y;
mdl = stepwiseglm(X,y,'constant','upper','linear');
% mdl = stepwiseglm(tbl,modelspec);
disp(mdl);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%%  confidence of A1 and A2 
disp('confidence of A1 and A2');

Y                 = [Ys(:,k1);Ys(:,k2)]; %A1+A2
%% Total    DT = difference of stats in total trials
%Value
value_rate          = [hist(sbjs.indx,k1); hist(sbjs.indx,k2)];
value_mean          = [FC.mean(sbjs.indx,k1);    FC.mean(sbjs.indx,k2 )];
value_max           = [FC.max(sbjs.indx,k1);     FC.max(sbjs.indx,k2)];
value_min           = [FC.min(sbjs.indx,k1);     FC.min(sbjs.indx,k2)];
value_std           = [FC.std(sbjs.indx,k1);     FC.std(sbjs.indx,k2)];
value_cv            = [FC.std( sbjs.indx,k1)./FC.mean(sbjs.indx,k1);  FC.std( sbjs.indx,k2)./FC.mean(sbjs.indx,k2)];
value_range         = [value_max - value_min];

%% Difference
dif_rate12       = [hist(sbjs.indx,k1)   - hist(sbjs.indx,k2); hist(sbjs.indx,k2)   - hist(sbjs.indx,k1)];
dif_rate_pairs   = [hist(sbjs.indx,1)    - hist(sbjs.indx,3);  hist(sbjs.indx,2)    - hist(sbjs.indx,4)];
dif_mean12       = [FC.mean(sbjs.indx,k1)      - FC.mean(sbjs.indx,k2);    FC.mean(sbjs.indx,k2)      - FC.mean(sbjs.indx,k1)];
dif_mean_pairs   = [FC.mean(sbjs.indx,1)       - FC.mean(sbjs.indx,3);     FC.mean(sbjs.indx,2)       - FC.mean(sbjs.indx,4)];
dif_std          = [FC.std( sbjs.indx,k1)      - FC.std(sbjs.indx,k2);     FC.std( sbjs.indx,k2)      - FC.std(sbjs.indx,k1)];
dif_cv           = [FC.std( sbjs.indx,k1)./FC.mean(sbjs.indx,k1) - FC.std(sbjs.indx,k2)./FC.mean(sbjs.indx,k2); FC.std( sbjs.indx,k2)./FC.mean(sbjs.indx,k2) - FC.std(sbjs.indx,k1)./FC.mean(sbjs.indx,k1)];
dif_max          = [FC.max( sbjs.indx,k1)      - FC.max(sbjs.indx,k2);     FC.max( sbjs.indx,k2)      - FC.max(sbjs.indx,k1)];
dif_min          = [FC.min( sbjs.indx,k1)      - FC.min(sbjs.indx,k2);     FC.min( sbjs.indx,k2)      - FC.min(sbjs.indx,k1)];
dif_range        = dif_max - dif_min;

%% Division
div_rate12       = [hist(sbjs.indx,k1) ./ hist(sbjs.indx,k2);   hist(sbjs.indx,k2) ./ hist(sbjs.indx,k1)];
div_rate_pairs   = [hist(sbjs.indx,1)  ./ hist(sbjs.indx,3);    hist(sbjs.indx,2)  ./ hist(sbjs.indx,4)];
div_mean12       = [log(FC.mean(sbjs.indx,1) ./ FC.mean(sbjs.indx,2));      log(FC.mean(sbjs.indx,1) ./ FC.mean(sbjs.indx,2))];
div_mean_pairs   = [log(FC.mean(sbjs.indx,1) ./ FC.mean(sbjs.indx,3));      log(FC.mean(sbjs.indx,2) ./ FC.mean(sbjs.indx,4))];
div_std          = [FC.std( sbjs.indx,k1)    ./ FC.std(sbjs.indx,k2);       FC.std( sbjs.indx,k2)    ./ FC.std(sbjs.indx,k1)];
div_cv           = [(FC.mean( sbjs.indx,k1)./FC.std(sbjs.indx,k1)) ./ (FC.mean( sbjs.indx,k1)./FC.std(sbjs.indx,k1));  (FC.mean( sbjs.indx,k2)./FC.std(sbjs.indx,k2)) ./ (FC.mean( sbjs.indx,k2)./FC.std(sbjs.indx,k2))];
div_max          = [FC.max( sbjs.indx,k1)    ./ FC.max(sbjs.indx,k2);       FC.max( sbjs.indx,k2)    ./ FC.max(sbjs.indx,k1)];
div_min          = [FC.min( sbjs.indx,k1)    ./ FC.min(sbjs.indx,k2);       FC.min( sbjs.indx,k2)    ./ FC.min(sbjs.indx,k1)];
div_range        = div_max ./ div_min;

%% Normalize Regressors
zvalue_rate        = zscore(value_rate);
zvalue_mean        = zscore(value_mean);
zvalue_max         = zscore(value_max);
zvalue_min         = zscore(value_min);
zvalue_std         = zscore(value_std);
zvalue_cv          = zscore(value_cv);
zvalue_range       = zscore(value_range);
%----------------------------------
zdif_rate12     = zscore(dif_rate12);
dif_rate_pairs  = zscore(dif_rate_pairs);
zdif_mean       = zscore(dif_mean12);
zdif_std        = zscore(dif_std);
zdif_cv         = zscore(dif_cv);
zdif_max        = zscore(dif_max);
zdif_min        = zscore(dif_min);
zdif_range      = zscore(dif_range);
%----------------------------------
zdiv_meand2d1   = zscore(div_meand2d1);
zdiv_rate12     = zscore(div_rate12);
div_rate_pairs  = zscore(div_rate_pairs);
zdiv_mean       = zscore(div_mean12);
zdiv_std        = zscore(div_std);
zdiv_cv         = zscore(div_cv);
zdiv_max        = zscore(div_max);
zdiv_min        = zscore(div_min);
zdiv_range      = zscore(div_range);


%% glm
tbl         =  table(Y,zdif_max );
modelspec   =  'Y ~ zdif_max';
lm          =  fitlm(tbl,modelspec);
display(lm);

