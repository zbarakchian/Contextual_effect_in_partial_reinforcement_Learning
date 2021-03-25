function analysis_fitted_params(addr,ftype,config_fit,sbjs,models)

file = ([addr.fit filesep 'data_fit_',ftype,'_Learning1',...
                     '_Transfer',num2str(config_fit.fit_transfer),...
                     '_Prior',   num2str(config_fit.use_prior),'.mat']);
                 
load(file);
%--------------------------------------------------------------------------
nmodel = length(models);


%-organize_the data
%--------------------------------------------------------------------------
for m = 1:nmodel
    model  = models{m};
    
    params.num   = model.parameters.num;
    params.name  = model.parameters.name;
    
    params.data = [];
    for sub = sbjs.indx
        params.data(sub,:)  = data_fit.(model.name)(sub).params;
    end
    params.stats = [nanmean(params.data(sbjs.indx,:),1); nanstd(params.data(sbjs.indx,:),1)];
    
    
    disp(model.name);
    disp(params.name);
    disp(params.stats);
    disp('------------'); 
       
    [RHO,PVAL] = corr(params.data(sbjs.indx,:));
    params.corr.coef = RHO;
    params.corr.pval = PVAL;
    
    info_params.(model.name) = params;   
end
save([addr.params filesep 'data_parameters_', ftype],'info_params');



