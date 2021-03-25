function regression_transfer_effect_confounding(addr,ftype,config,sbjs)
%-Whether  the Aj or Ai test rate is because of Several Other Factors?

%-load data
%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Transfer.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Estimation.mat']);
load([addr.bhv, filesep, 'data_behavioral.mat']);

FC   = info_learning.statistics.normal.FC;
hist = info_learning.hist;
data = data.(ftype).learning;

%% Regressors 


%-Y variable
%--------------------------------------------------------------------------
switch config.ttype
    case {'rate','binary'}
        Ys = [info_transfer.pref.bin_left(sbjs.indx,1),  info_transfer.pref.bin_right(sbjs.indx,1)];
    case 'first'
        Ys = [info_transfer.pref.first_left(sbjs.indx,1),info_transfer.pref.first_right(sbjs.indx,1)];
end
Y  = Ys(:,2);%-Ys(sbjs.indx,2); %A1 from (A1,A2)


%-First ,  DF = difference of stats in first trials
%--------------------------------------------------------------------------
lastnTr     = 20;
firstnTr    = 10;

whichward   = 'forward'; %'backward' or 'forwaqrd'
regressors  = {'rate' 'mean' 'std' 'cv' 'cvinv' 'max' 'min' 'range'}; 

for i = 1:length(regressors)
    reg_dif.(regressors{i}) = creat_regstruct_recencyeffect(addr,ftype,sbjs,regressors{i},whichward,firstnTr);  
end


%-Total dif = difference of stats in total trials
%--------------------------------------------------------------------------
dif_mean         = FC.mean(sbjs.indx,2)     - FC.mean(sbjs.indx,1);
dif_std          = FC.std( sbjs.indx,2)     - FC.std(sbjs.indx,1);
dif_cv           = FC.std( sbjs.indx,2) ./ FC.mean(sbjs.indx,2) - FC.std(sbjs.indx,1) ./ FC.mean(sbjs.indx,1);
dif_max          = FC.max( sbjs.indx,2)     - FC.max(sbjs.indx,1);
dif_min          = FC.min( sbjs.indx,2)     - FC.min(sbjs.indx,1);
dif_range        = dif_max - dif_min;
dif_rate         = hist(sbjs.indx,2)  - hist(sbjs.indx,1);

%-Normalize Regressors
%--------------------------------------------------------------------------
zdif_mean       = zscore(dif_mean);
zdif_std        = zscore(dif_std);
zdif_cv         = zscore(dif_cv);
zdif_max        = zscore(dif_max);
zdif_min        = zscore(dif_min);
zdif_range      = zscore(dif_range);
zdif_rate       = zscore(dif_rate);

%-stimulus rewards
%--------------------------------------------------------------------------
rw_stim = [];
for sub = sbjs.indx
    Rew1 = [];    Rew2 = [];    Rew3 = [];    Rew4 = [];
    for i = 1:length(data(sub).chosen)
        switch data(sub).chosen(i)
            case 1
                Rew1 = [Rew1, data(sub).rw_FC(i)] ;
            case 2
                Rew2 = [Rew2, data(sub).rw_FC(i)] ;
            case 3
                Rew3 = [Rew3, data(sub).rw_FC(i)] ;
            case 4
                Rew4 = [Rew4, data(sub).rw_FC(i)] ;
        end
    end
    rw_stim{sub,1} = Rew1;
    rw_stim{sub,2} = Rew2;
    rw_stim{sub,3} = Rew3;
    rw_stim{sub,4} = Rew4;
end

%-T:TOP, D:DOWN of the reward distributions
%--------------------------------------------------------------------------
len_T1 = [];len_T2 = [];
len_D1 = [];len_D2 = [];
sum_T1 = [];sum_T2 = [];
sum_D1 = [];sum_D2 = [];

for sub = sbjs.indx
    sd = std(rw_stim{sub,1},1); 
    mn = mean(rw_stim{sub,1});
    T1 = rw_stim{sub,1}(rw_stim{sub,1} >= mn + 2.5*sd );
    D1 = rw_stim{sub,1}(rw_stim{sub,1} <= mn - 2.5*sd );
    
    sd = std(rw_stim{sub,2},1); 
    mn = mean(rw_stim{sub,2});
    T2 = rw_stim{sub,2}(rw_stim{sub,2} >= mn + 2.5*sd );
    D2 = rw_stim{sub,2}(rw_stim{sub,2} <= mn - 2.5*sd );
    
    len_T1 = [len_T1; length(T1)];  len_T2 = [len_T2; length(T2)];    
    len_D1 = [len_D1; length(D1)];  len_D2 = [len_D2; length(D2)];    
    sum_T1 = [sum_T1; sum(T1)];     sum_T2 = [sum_T2; sum(T2)];    
    sum_D1 = [sum_D1; sum(D1)];     sum_D2 = [sum_D2; sum(D2)];
end

%-Difference
%--------------------------------------------------------------------------
dif_Top_sum        = sum_T2 - sum_T1;
dif_Down_sum       = sum_D2 - sum_D1;
dif_Top_len        = len_T2 - len_T1;
dif_Down_len       = len_D2 - len_D1;

zdif_Top_sum       = zscore(dif_Top_sum);
zdif_Down_sum      = zscore(dif_Down_sum);
zdif_Top_len       = zscore(dif_Top_len);
zdif_Down_len      = zscore(dif_Down_len);


%% do glm
%--------------------------------------------------------------------------
tbl         =  table(Y,zdif_mean,zdif_rate,zdif_Top_sum, zdif_Down_sum );
modelspec   =  'Y ~ zdif_mean + zdif_rate';
% modelspec   =  'Y ~  zdif_Top_sum';
% modelspec   =  'Y ~  zdif_Down_sum';

glm          = fitglm(tbl,modelspec,'Distribution','binomial');
display(glm);




