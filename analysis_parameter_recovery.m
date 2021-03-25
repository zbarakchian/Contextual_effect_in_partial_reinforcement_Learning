function analysis_parameter_recovery(addr,ftype,sbjs,models)

%%
%-get mean of ntimes repetitions
%--------------------------------------------------------------------------
load([addr.precovery filesep 'parameter_recovery_ntimes_' ftype]);

nmodel = length(models);
for m = 1:nmodel
    model  = models{m};
    params = info.(model.name);
    
    params_initial    = [];
    params_recovered  = [];
    
    for sub = sbjs.indx
        
        param1  = params{sub}.old;
        params2 = params{sub}.new;
        
        param2.mean  = nanmean(params2,1);
        param2.std   = nanstd(params2,1);
        
        params_initial      = [params_initial;    param1];
        params_recovered    = [params_recovered;  param2.mean];
    end
    
    parameters.(model.name).old   = params_initial;
    parameters.(model.name).new   = params_recovered;
end


%% correlation
%--------------------------------------------------------------------------
for m = 1:nmodel   
    model = models{m};
    nparams = model.parameters.num;
    PARAM = parameters.(model.name);
    
    for i = 1:nparams
        for j = 1:nparams
            [RHO,PVAL]  = corr(PARAM.old(:,i), PARAM.new(:,j));
            correlation.fr.(model.name)(i,j,:) = [RHO, PVAL];
        end
    end
    
    for i = 1:nparams
        for j = 1:nparams
            [RHO,PVAL]  = corr(PARAM.old(:,i), PARAM.old(:,j));
            correlation.ff.(model.name)(i,j,:) = [RHO, PVAL];
        end
    end
    
    for i = 1:nparams
        for j = 1:nparams
            [RHO,PVAL]  = corr(PARAM.new(:,i), PARAM.new(:,j));
            correlation.rr.(model.name)(i,j,:) = [RHO, PVAL];
        end
    end
    
end
% save([addr.precovery filesep 'parameter_recovery_',ftype],'parameters','correlation');


%%
if m == 1
    model   = models{m};
    PARAM   = parameters.(model.name);
    
    [RHO,PVAL]  = corr(PARAM.old(:,1), PARAM.new(:,2)./PARAM.new(:,1));
    corr_ba = [RHO, PVAL];      
    disp(corr_ba);
end
