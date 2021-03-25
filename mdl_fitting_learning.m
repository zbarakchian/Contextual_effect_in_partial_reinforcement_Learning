function data_fit = mdl_fitting_learning(addr,ftype,config_fit,sbjs,models,arg_learn,arg_transfer)

do_fitting = 0;
do_BIC     = 1;

nmodel = length(models);

%%
if do_fitting
    
data_fit = [];
for m = 1:nmodel
    for sub = sbjs.indx 
        model = models{m};       

        %-run optimization procedure
        %----------------------------------------------------------------------    
        args.arg_learn      = arg_learn{sub};
        args.arg_transfer   = arg_transfer{sub};
        args.t1             = config_fit.begin(sub);
        args.t2             = length(arg_learn{sub}); %config_fit.end(sub) - length(find(arg_learn{sub}(:,5) == 99)); %update endT: nonresp_num
        args.Q0             = config_fit.Q0;
        args.funcType       = config_fit.fit_type;
        args.use_prior      = config_fit.use_prior;
        args.fit_transfer   = config_fit.fit_transfer;
    

        %------------------------------------------------------------------  
        optimal = Minimize(sub,model,args); %TODO: it gets max a posteriori not max likelihood...
        
        if ~isnan(optimal.params)
            data_fit.(model.name)(sub) = optimal;  
        end
    end
end

%-saving the data
%--------------------------------------------------------------------------
if config_fit.save
    disp('saving the fitting data ...');
    save([ addr.fit filesep ...
                'data_fit_',ftype,...
                '_Learning','1',...
                '_Transfer',num2str(config_fit.fit_transfer),...
                '_Prior',   num2str(config_fit.use_prior),...
                ''],...
        'data_fit');
    
end
end

%%
if do_BIC
    
for m = 1:nmodel
    for sub = sbjs.indx 
        model = models{m};       

        %-run optimization procedure
        %----------------------------------------------------------------------    
        args.arg_learn      = arg_learn{sub};
        args.arg_transfer   = arg_transfer{sub};
        args.t1             = config_fit.begin(sub);
        args.t2             = length(arg_learn{sub}); %config_fit.end(sub) - length(find(arg_learn{sub}(:,5) == 99)); %update endT: nonresp_num
        args.Q0             = config_fit.Q0;
        args.funcType       = config_fit.fit_type;
        args.use_prior      = config_fit.use_prior;
        args.fit_transfer   = config_fit.fit_transfer;
    
        %-calculate AIC & BIC
        %------------------------------------------------------------------    
        nfpm  = model.parameters.num;
        negloglik = get_nloglikelihood(addr,ftype,config_fit,sub,model,args);
        BIC       = 2 * negloglik + nfpm * log(config_fit.end(sub));        
        info_criterion.(model.name)(sub,:) = [negloglik, BIC];        
    end
end

%-saving the data
%--------------------------------------------------------------------------
if config_fit.save    
    save([ addr.fit filesep 'data_fit_BIC_',ftype],'info_criterion');
end
end


disp('Saving finished');



