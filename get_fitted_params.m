function params = get_fitted_params(addr,ftype,config_fit,sbjs,model)

%-load Data
%--------------------------------------------------------------------------
load([addr.fit filesep 'data_fit_',ftype,'_Learning1_Transfer',num2str(config_fit.fit_transfer),'_Prior',num2str(config_fit.use_prior),'.mat']);
%--------------------------------------------------------------------------

params = [];
for sub = sbjs.indx  
    params(sub,:) = [data_fit.(model.name)(sub).params];
end