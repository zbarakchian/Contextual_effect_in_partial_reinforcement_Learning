function regression_regret_effect_on_rt2(addr,reg)

%-nominal-ization :)
%--------------------------------------------------------------------------
task        = nominal(reg.task);
sbj         = nominal(reg.subject);
cond        = nominal(reg.condition);

%-normal-ization: z-score
%--------------------------------------------------------------------------
vdif        = zscore(reg.value_dif);
ratedif     = zscore(reg.rate_dif);
odif        = zscore(reg.outcome_dif);
regret      = zscore(reg.regret);
relief      = zscore(reg.relief);

%-nothing to do 
%--------------------------------------------------------------------------
action      = reg.action;
rt          = reg.rt;

%-using logarithm of reaction times
%--------------------------------------------------------------------------
logrt       = log(rt);


%-General Linear Mixed model (Fixed effect + Random effect): fitlme
%--------------------------------------------------------------------------
tbl  = table(logrt,  action,  odif,  regret,  relief,  ratedif,  vdif,  cond,  sbj,  task, 'VariableNames',...
           {'logrt','action','odif','regret','relief','ratedif','vdif','cond','sbj','task'});

% modelspec = 'logrt ~ 1 + vdif * ratedif * (regret + relief) * cond * task + (1 + vdif * ratedif * (regret + relief) * cond * task | sbj)';
modelspec = 'logrt ~ 1 + vdif + odif + cond  + (1 + vdif + odif + cond | sbj)';

glme = fitglme(tbl,modelspec,'Verbose',2);
save([addr.glme filesep 'glme_regret_onrt_' reg.type reg.name],'glme');
disp(glme);

disp('Finish');

%-Check correlation and collinearity between regressors with pearson correlation
%--------------------------------------------------------------------------
% regrs = [vdif,ratedif,odif,regret,relief];
% 
% [RHO,PVAL]  = corr(regrs(:,4),regrs(:,5));
% disp([RHO,PVAL]);







