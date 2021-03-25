function analysis_behavior_pop(addr,ftype,config_main,config_analysis,sbjs,models)


%% general analysis
%--------------------------------------------------------------------------
% power_analysis(length(sbjs.indx));

%% Learning Phase
%--------------------------------------------------------------------------
% report_performance1(config_analysis,sbjs);
% report_performance2(addr,config_main,config_analysis);
% plot_pop_choice_hist(config_analysis,sbjs);
% plot_pop_recent_rw_trend(config_analysis,sbjs,10); 
% plot_pop_pref_trend_learning1(config_analysis,ftype,sbjs);
% plot_pop_pref_trend_learning2(config_analysis,ftype,sbjs);
% steepness_choice_curve(addr,config_main);

%% Transfer Phase: Choice
%--------------------------------------------------------------------------
% test_transfer_effect(config_main,config_analysis,sbjs);
% test_transfer_effect_within(config_main,config_analysis,sbjs);
% test_transfer_effect_between(addr,config_main); %todo...
% test_difference_between_first_mean(addr,ftype,sbjs);
% plot_pop_pref_transfer(addr,config_main,ftype,sbjs,'real');
% regression_confidence(addr,ftype,config_main,sbjs);

%% Value Estimation phase
%--------------------------------------------------------------------------
% test_value_within(addr,config_main,ftype,sbjs);
% plot_pop_value(addr,ftype,config_main,sbjs);
% regression_value(addr,ftype,config_main,sbjs);
% test_value_between(addr,config_main);

%% Founding and Confounding Factors
%--------------------------------------------------------------------------
% check_validity_rewards(addr,ftype,sbjs);
% regression_transfer_effect_confounding(addr,ftype,config_main,sbjs);
% regression_recent_choice_effect(addr,config_main,ftype,sbjs,20); 
% test_motor_perseveration_effect(addr,ftype,config_main,sbjs);


%% Iterations: Transfer, Value, Variance
%--------------------------------------------------------------------------
% test_transfer_effect_iterations(config_main,config_analysis,sbjs);
% test_transfer_effect_estimation(config_main,config_analysis,sbjs);
% plot_iters_transfer(addr,ftype,sbjs);
% plot_iters_value(addr,ftype,sbjs);


%% regressions: regret effect on p(choice = left) or switching behavior
%--------------------------------------------------------------------------
% reg = create_regression_structure(addr,config_main,'switch',ftype);  %switch or pleft
% regression_regret_effect_on_decision(addr,reg);
% regression_regret_effect_on_rt(addr,reg);
% report_table_outcome_dif_effect(addr,ftype)



%% regression: Reaction Time - partial vs complete
%--------------------------------------------------------------------------
% sbjs_partl = config_main.subjects{1}.indx;
% sbjs_cmplt = config_main.subjects{2}.indx;
% analysis_RT(addr,sbjs_partl,sbjs_cmplt);



