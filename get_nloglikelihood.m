function nLL = get_nloglikelihood(addr,ftype,config_fit,sub,model,args)


load([addr.fit filesep 'data_fit_',ftype,'_Learning1_Transfer',num2str(config_fit.fit_transfer),'_Prior',num2str(config_fit.use_prior),'.mat']);
%--------------------------------------------------------------------------
args.use_prior = 0;
params = data_fit.(model.name)(sub).params;
nLL = model.func(params,args);
