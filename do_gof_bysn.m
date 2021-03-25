function bms_results = do_gof_bysn(addr,ftype,config_fit,sbjs,models,flag)

nmodel = length(models);

%% Bayesian Model Comparison: Exceedance Probability
%%%---gershman mfit-master

%% Learning
%-Hessian or BIC
%--------------------------------------------------------------------------
if flag == 1
    
load([addr.fit filesep 'data_fit_',ftype,'_Learning1_Transfer',num2str(config_fit.fit_transfer),'_Prior',num2str(config_fit.use_prior),'.mat']);
load([addr.fit filesep 'data_fit_BIC_' ftype]);

use_bic = 1;

lme  = [];
lme0 = [];
bms_results = [];

results = data_fit;
for m1 = 1:nmodel
    model = models{m1};
%     K = length(results.(model.name)(sbjs.indx(1)).params);
    K = model.parameters.num;
    for sub = sbjs.indx
%         lme0(sub,m1) = -0.5 * results.(model.name)(sub).bic;
        lme0(sub,m1) = -0.5 * info_criterion.(model.name)(sub,2);  %1:nll, 2:BIC         
    end
    logpost = [];
    for sub = sbjs.indx
        h(sub,1) = log(det(results.(model.name)(sub).hessian)); 
%         logpost(sub,1) = -results.(model.name)(sub).negloglik;
        logpost(sub,1) = - info_criterion.(model.name)(sub,1);
    end
    lme(:,m1) = logpost(sbjs.indx) + 0.5 * (K * log(2*pi) - h(sbjs.indx));
end

ix = isnan(lme)|isinf(lme)|imag(lme)~=0; % use BIC if any Hessians are degenerate
if any(ix(:))
    lme = lme0;
end
if use_bic==1; lme = lme0; end

lme(any(isnan(lme)|isinf(lme),2),:) = [];

[bms_results.alpha, bms_results.exp_r, bms_results.xp, bms_results.pxp, bms_results.bor] = bms(lme);
disp(bms_results);    


end

%% Both 
%--------------------------------------------------------------------------   
if flag == 2

%-Learning? type1 
%-Transfer? type2 
%-Both?     type3
%--------------------------------------------------------------------------   
%-load the learning one (type1) 
load([addr.gof filesep ...
             'data_gof_',       ftype,...
             '_type',           num2str(1),...
             '_transfer','_itr',num2str(0),...
             '_cmb',            num2str(0)],...
      'output');

tmp.model_names     = output.model_names;
tmp.learning        = output.lik;
tmp.transfer.greedy = output.greedy;

%--------------------------------------------------------------------------
%-load the transfer (type 2) 
load([addr.gof filesep ...
             'data_gof_',       ftype,...
             '_type',           num2str(2),...
             '_transfer','_itr',num2str(1),...
             '_cmb',            num2str(1)],...
      'output');
 
tmp.transfer.lik21    = output.lik;

%--------------------------------------------------------------------------
%-load the transfer (type 2) 
load([addr.gof filesep ...
             'data_gof_',       ftype,...
             '_type',           num2str(2),...
             '_transfer','_itr',num2str(1),...
             '_cmb',            num2str(7)],...
      'output');
  
tmp.transfer.lik27    = output.lik;

%--------------------------------------------------------------------------
%-load the transfer (type 3) 
load([addr.gof filesep ...
             'data_gof_',       ftype,...
             '_type',           num2str(3),...
             '_transfer','_itr',num2str(1),...
             '_cmb',            num2str(1)],...
      'output');
 
tmp.transfer.lik31    = output.lik;

%--------------------------------------------------------------------------
%-load the transfer (type 3) 
load([addr.gof filesep ...
             'data_gof_',       ftype,...
             '_type',           num2str(3),...
             '_transfer','_itr',num2str(1),...
             '_cmb',            num2str(7)],...
      'output');
  
tmp.transfer.lik37    = output.lik;

clearvars output;
%--------------------------------------------------------------------------
%% 
results{1} = tmp.transfer.lik21;
results{2} = tmp.transfer.lik27;
results{3} = tmp.transfer.lik31;
results{4} = tmp.transfer.lik37;
results{5} = tmp.learning;
% results{6} = tmp.transfer.greedy;

for m = 1:nmodel
    model = models{m};
    mname = model.name;     
%     disp(mname);   
    mindxs = find(contains(tmp.model_names,mname));
    
    mindx = 0;
    if length(mindxs) > 1
        for i = 1:length(mindxs)
            if isequal(mname, tmp.model_names{mindxs(i)})
                mindx = mindxs(i);
                break;
            end
        end
    else
        mindx = mindxs;
    end
    
    K = model.parameters.num;
    for sub = sbjs.indx
        lme0_21(sub,m) = - 0.5 * results{1}.persbj.BIC(sub,mindx);
        lme0_27(sub,m) = - 0.5 * results{2}.persbj.BIC(sub,mindx);
        lme0_31(sub,m) = - 0.5 * results{3}.persbj.BIC(sub,mindx);
        lme0_37(sub,m) = - 0.5 * results{4}.persbj.BIC(sub,mindx);
        lme0_10(sub,m) = - 0.5 * results{5}.persbj.BIC(sub,mindx);
    end
end

use_bic = 1;
if use_bic == 1
    lme_21 = lme0_21; 
    lme_27 = lme0_27; 
    lme_31 = lme0_31; 
    lme_37 = lme0_37; 
    lme_10 = lme0_10; 
end

lme_21(any(isnan(lme_21)|isinf(lme_21),2),:) = [];
lme_27(any(isnan(lme_27)|isinf(lme_27),2),:) = [];
lme_31(any(isnan(lme_31)|isinf(lme_31),2),:) = [];
lme_37(any(isnan(lme_37)|isinf(lme_37),2),:) = [];
lme_10(any(isnan(lme_10)|isinf(lme_10),2),:) = [];

[bms_results(1).alpha, bms_results(1).exp_r, bms_results(1).xp, bms_results(1).pxp, bms_results(1).bor] = bms(lme_21);
[bms_results(2).alpha, bms_results(2).exp_r, bms_results(2).xp, bms_results(2).pxp, bms_results(2).bor] = bms(lme_27);
[bms_results(3).alpha, bms_results(3).exp_r, bms_results(3).xp, bms_results(3).pxp, bms_results(3).bor] = bms(lme_31);
[bms_results(4).alpha, bms_results(4).exp_r, bms_results(4).xp, bms_results(4).pxp, bms_results(4).bor] = bms(lme_37);
[bms_results(5).alpha, bms_results(5).exp_r, bms_results(5).xp, bms_results(5).pxp, bms_results(5).bor] = bms(lme_10);

disp(bms_results);    
end
