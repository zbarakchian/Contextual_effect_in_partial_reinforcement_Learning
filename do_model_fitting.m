function do_model_fitting(addr,ftype,config_main,config_fit,sbjs,models)

load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);


%=======================================================================
%-fitting in an standard way
%=======================================================================

config_fit.begin        = repmat(1,1,length(sbjs.nt));
config_fit.end          = sbjs.nt;
for sub = sbjs.indx 
    arg_learn{sub}    = extract_data_for_fit_learning(addr,ftype,config_main,sub);  %arguments: [con,cho,out,cou,resp];    
    arg_transfer{sub} = extract_data_for_fit_transfer(addr,ftype,config_main,sub);  %arguments: [con,cho,out,cou,resp];            
end     

mdl_fitting_learning(addr,ftype,config_fit,sbjs,models,arg_learn,arg_transfer);






