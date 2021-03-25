function do_gof_frq(addr,ftype,config_main,config_fit,sbjs,models)

%-goodness of fit of both phases simultaneously and 
%--------------------------------------------------------------------------
%-------------gof structure:
%----- 1- negloglik(sub,m)
%----- 2- AIC(sub,m)       
%----- 3- BIC(sub,m)             
%----- 4- ABIC(sub,m)    


%% all types
%-setup all possible configs and run 
%--------------------------------------------------------------------------
%-for the first type
config_gof.save          = 1; % save the data

config_gof.type          = 1;
config_gof.transfer.iter = 0; 
config_gof.transfer.cmb  = 0; 

goodnessOFfit(addr,ftype,config_main,config_fit,config_gof,sbjs,models);
  
%-for the rest of types
for itype = [2,3]
    for iitr  = [1,4]
        for icmb  = [1,7]    
            config_gof.type = itype; 
            config_gof.transfer.iter = iitr; 
            config_gof.transfer.cmb  = icmb; 

            goodnessOFfit(addr,ftype,config_main,config_fit,config_gof,sbjs,models);
       end
    end
end



