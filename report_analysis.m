function report_analysis(addr,ftype,config_main,config_analysis,config_fit,sbjs,models)

% power_analysis(length(sbjs.indx));

%% performance
% report_performance1(config_analysis,sbjs);
% report_performance2(addr,config_main,config_analysis);

%% transfer
% test_transfer_effect(config_main,config_analysis,sbjs);
% test_transfer_effect_within(config_main,config_analysis,sbjs);
% test_transfer_effect_between(addr,config_main); 

%% confounding factors
% regression_transfer_effect_confounding(addr,ftype,config_main,sbjs); %todo
% regression_recent_choice_effect(addr,config_main,ftype,sbjs,20); 
% test_motor_perseveration_effect(addr,ftype,config_main,sbjs);

%% value
% test_value_within(addr,config_main,ftype,sbjs);

%% outcome-difference
% reg = create_regression_structure(addr,config_main,'switch',ftype);  
% regression_regret_effect_on_decision(addr,reg);
% regression_regret_effect_on_rt(addr,reg);
% report_table_outcome_dif_effect(addr,ftype);

%% fitting
% report_params(addr,ftype,models);
% report_gof_frq(addr,ftype,sbjs,models);

