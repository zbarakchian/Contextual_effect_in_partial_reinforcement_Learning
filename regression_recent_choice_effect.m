function regression_recent_choice_effect(addr,config,ftype,sbjs,nLast)
%-load data
%--------------------------------------------------------------------------
load(strcat(addr.bhv, filesep, 'data_', ftype, '_Learning.mat'));
load(strcat(addr.bhv, filesep, 'data_', ftype, '_Transfer.mat'));

pref_rate_left  = info_transfer.pref.rate_left;
pref_rate_right = info_transfer.pref.rate_right;

pref_bin_left    = info_transfer.pref.bin_left;
pref_bin_right   = info_transfer.pref.bin_right;

pref_first_left  = info_transfer.pref.first_left;
pref_first_right = info_transfer.pref.first_right;

%%  GLM
%-Y 
%--------------------------------------------------------------------------
switch config.ttype
    case {'rate','binary'}
        YY = [pref_bin_left(sbjs,1),pref_bin_right(sbjs,1)];
    case 'first'
        YY = [pref_first_left(sbjs.indx,1),pref_first_right(sbjs.indx,1)];
end
Y  = YY(:,2);%-YY(sbjs,2); %A1 from (A1,A2)


%-Regressors
%--------------------------------------------------------------------------
whichward       = 'backward'; %'forward'
regressor       = 'rate' ;%{'mean' 'std' 'cv' 'cvinv' 'max' 'min' 'range' 'rate'} 
reg_dif_pairs   = creat_regstruct_recencyeffect(addr,ftype,sbjs,regressor,whichward,nLast);  
reg_dif         = reg_dif_pairs(:,1); 
zreg_dif        = zscore(reg_dif);
reg1            = zreg_dif;

regressor       = 'mean' ;%{'mean' 'std' 'cv' 'cvinv' 'max' 'min' 'range'} 
reg_dif_pairs   = creat_regstruct_recencyeffect(addr,ftype,sbjs,regressor,whichward,nLast);  
reg_dif         = reg_dif_pairs(:,1); 
zreg_dif        = zscore(reg_dif);
reg2            = zreg_dif;

% Run glm
%--------------------------------------------------------------------------
tbl             =  table(Y,reg1,reg2);
modelspec       =  'Y ~ reg1';
glm             = fitglm(tbl,modelspec,'Distribution','binomial');
display(glm);



