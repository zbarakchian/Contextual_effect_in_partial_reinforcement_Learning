function do_parameter_recovery(addr,ftype,config_fit,sbjs,models,ntimes)

ntrial = 300;
nmodel = length(models);

%get recovered parameters
%--------------------------------------------------------------------------
for m = 1:nmodel    
    model  = models{m};    
    params0 = get_fitted_params(addr,ftype,config_fit,sbjs,model); %[0.05,0.1,0.3]   
    
    for sub = sbjs.indx
        param1 = params0(sub,:);
        param2_ntimes = [];
        
        for i = 1:ntimes            
            param2 = parameter_recovery(model,param1,ntrial);
            param2_ntimes(i,:) = param2;
        end
        
        params{sub}.old = param1;
        params{sub}.new = param2_ntimes;
    end
    info.(model.name) = params;
end

save([addr.precovery filesep 'parameter_recovery_ntimes_' ftype],'info');


