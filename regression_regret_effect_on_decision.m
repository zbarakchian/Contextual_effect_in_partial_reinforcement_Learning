function regression_regret_effect_on_decision2(addr,reg)


%-reg structure:
%--------------------------------------------------------------------------
%     regression.task   
%     regression.subject      
%     regression.condition 
%     regression.choice         
%     regression.rt            
%     regression.value_dif    
%     regression.rate_dif   
%     regression.outcome_dif 
%     regression.regret       
%     regression.relief


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


%-General Linear Mixed model (Fixed effect + Random effect): fitlme
%--------------------------------------------------------------------------
tbl  = table(rt,  action,  odif,  regret,  relief,  ratedif,  vdif,  cond,  sbj,  task, 'VariableNames',...
           {'rt','action','odif','regret','relief','ratedif','vdif','cond','sbj','task'});

% modelspec = 'action ~ vdif + ratedif + regret + relief + cond + task + (regret + relief|sbj)';
% modelspec = 'action ~ (vdif + ratedif) * (regret + relief) * cond * task + (regret + relief|sbj)';
modelspec = 'action ~ 1 + vdif + odif + cond + (1 + vdif + odif + cond | sbj)';

glme = fitglme(tbl,modelspec,'Distribution','binomial','Verbose',2);
save([addr.glme filesep 'glme_regret_onchoice_' reg.type reg.name],'glme');
disp(glme);

disp('Finish');

%-Check correlation and collinearity between regressors with pearson correlation
%--------------------------------------------------------------------------
% regrs = [vdif,ratedif,odif,regret,relief];
% 
% [RHO,PVAL]  = corr(regrs(:,4),regrs(:,5));
% disp([RHO,PVAL]);







