clear;

%==========================================================================
%-specify your configuration
%==========================================================================


%-specify your feedback type, models, and transfer type(greedy or softmax)!
%--------------------------------------------------------------------------
feedback_type                       = 1; %feedback: Partial=1, Complete=2            
models_torun{1}                     = 10; %[1:11]; %Specify the models for the Pertial  version!  %see the models numbers in the "define_models" file
models_torun{2}                     = 14;%[1:15];  %Specify the models for the Complete version!  %see the models numbers in the "define_models" file
transfer_greedy                     = 1; %transfer: greedy=1, softmax=0
%--------------------------------------------------------------------------
feedback                            = {'Partial','Complete'}; ftype = feedback{feedback_type};                  
transfer                            = {'first','binary','rate'}; %The first iteration (from 4 iterations), The overal binary, The overal rate

%-Pre-processing analysis!
%--------------------------------------------------------------------------
section_organize_bhv_data           = 0; %For doing the behavioral analysis, you are required to run 
                                         %this section ('organization' section) once. Then you can use 
                                         %the corresponding mat files in the following analyses.
                                         %you need to run this section only once! 


%-specify which analysis do you want to do!
%--------------------------------------------------------------------------
section_analyze_behavioral          = 0;  % Do the behavioral analysis!
section_do_fitting                  = 0;  % Do the model fitting procedure!
section_do_parameter_recovery       = 0;  % Do the parameter recovery procedure!
section_do_goodnessoffit_frq        = 0;  % Calculate the negative log-likelihoods and corresponding BICs. (gof: goodness of fit)
section_do_goodnessoffit_bys        = 0;  % Calculate the Bayesian exceedance probability. (gof: goodness of fit)
section_do_mdoel_validation         = 0;  % Simulate the model using fitted parameters to see whether the model can predict the behavioral data.
section_do_pure_simulation          = 0;  % Simulate the model (pure: unrelated to the fitting and behavioral procedures. Just to see how the model works)
section_report_analysis             = 0;  % Report and plot the reported analyses in the paper.



% _______
% ______ (¯`v´¯)
% ______(¯`(?)´¯)__(¯`v´¯)
% _______(_.^._)__(¯`(?)´¯)
% _________(¯`v´¯)´(_.^._)
% ________(¯`(?)´¯)(¯`v´¯)
% _________(_.^._)(¯`(?)´¯)
% ________________ (_.^._)


%==========================================================================
%-create necessary folders
%==========================================================================   
subfolder.bhv                       = 'data_sumbhv';  %sumbhv: summarized behavioral data           
subfolder.sumsim                    = 'data_sumsim';  %sumsim: summarized simmulated data           
subfolder.glme                      = 'data_glme';             
subfolder.fit                       = 'data_fit';             
subfolder.params                    = 'data_params';             
subfolder.precovery                 = 'data_precovery';             
subfolder.gof                       = 'data_gof';             
subfolder.simf                      = 'data_simf';   %simf: simulation with fitted parameters           
subfolder.simp                      = 'data_simp';   %simf: simulation with desired parameters           
subfolder.optimal                   = 'data_optimal'; 

fields = fieldnames(subfolder);
for i = 1:length(fields)
    results.(fields{i}) = ['results' filesep subfolder.(fields{i})];
%     mkdir(results.(fields{i}));
end
addr                                = results;


%==========================================================================
%-organize behavioral data
%==========================================================================
if section_organize_bhv_data
    
organize_behavioral_data_full(addr);
organize_behavioral_data(addr);

end


% _______
% ______ (¯`v´¯)
% ______(¯`(?)´¯)__(¯`v´¯)
% _______(_.^._)__(¯`(?)´¯)
% _________(¯`v´¯)´(_.^._)
% ________(¯`(?)´¯)(¯`v´¯)
% _________(_.^._)(¯`(?)´¯)
% ________________ (_.^._)


%==========================================================================
%-setup configurations
%==========================================================================
%--Config_fit
config_fit              = setup_config_fit();
models_all              = define_models(config_fit);
models                  = choose_models(ftype,models_all,models_torun{feedback_type});

%--Config_main
config_main.ttype       = transfer{1};           % 1 = first iteration,   2 = overal binary, 3 = overal rate
config_main.vtype       = 1;                     % value type: 1 = first iteration,   5 = average of 4 repetitions;
config_main.cnvrg       = 1;                     % convergence almost-equal distance 

subjects{1}.indx        = exert_exclusion_criteria(addr,'Partial',config_main);
subjects{1}.nt          = find_end_trial('Partial',subjects{1});
subjects{2}.indx        = exert_exclusion_criteria(addr,'Complete',config_main);
subjects{2}.nt          = find_end_trial('Complete',subjects{2});
config_main.subjects    = subjects;

config_main.models      = { models_all.models_partial{models_torun{1}}, ...
                            models_all.models_complete{models_torun{2}} };


%==========================================================================
%-excluding invalid subjects
%==========================================================================    
sbjs.indx               = exert_exclusion_criteria(addr,ftype,config_main);
sbjs.nt                 = find_end_trial(ftype,sbjs);


%==========================================================================
%-analysis: behavior
%==========================================================================
if section_analyze_behavioral
    
config_analysis = setup_config_analysis('real',addr,ftype,config_main);
analysis_behavior_pop(addr,ftype,config_main,config_analysis,sbjs,models);

end


   
%==========================================================================
%-analysis: model-fitting
%==========================================================================
if section_do_fitting
  
do_model_fitting(addr,ftype,config_main,config_fit,sbjs,models);                
analysis_fitted_params(addr,ftype,config_fit,sbjs,models); 
output = report_params(addr,ftype,models);

end

%==========================================================================
%-analysis: parameter-recovery
%==========================================================================

if section_do_parameter_recovery
    
do_parameter_recovery(addr,ftype,config_fit,sbjs,models,100);  
analysis_parameter_recovery(addr,ftype,sbjs,models);  

end

%==========================================================================
%-analysis: model-comparison: frequency-based
%==========================================================================
if section_do_goodnessoffit_frq

do_gof_frq(addr,ftype,config_main,config_fit,sbjs,models); 
report_gof_frq(addr,ftype,sbjs,models);

end

%==========================================================================
%-analysis: model-comparison: bayesian
%==========================================================================
if section_do_goodnessoffit_bys

flag = 1;   % flag= 1:Only Learning phase, 2: Learning and Transfer phases
bms_results = do_gof_bysn(addr,ftype,config_fit,sbjs,models,flag);                         
report_gof_bys(addr,ftype,sbjs,models,bms_results,flag);

end



%==========================================================================
%-model-validation: simulation the fitted parameters
%==========================================================================
if section_do_mdoel_validation

config_sim  = setup_config_sim('sim_fitted',addr,ftype,config_fit,sbjs,models);
do_simulation(addr,ftype,config_sim,models);
analysis_simulation(addr,ftype,config_main,config_sim,sbjs,models);



end

%==========================================================================
%-modeling-pure: simulation by parameters cover all the range
%==========================================================================
if section_do_pure_simulation

config_sim = setup_config_sim('sim_pure',addr,ftype,config_fit,[],models);
do_simulation(addr,ftype,config_sim,models);
analysis_simulation(addr,ftype,config_main,config_sim,[],models);

%-new version for producing/saving large matrices 'square_perf_' and 'square_gain_'
do_simulation_new(addr,ftype,models{1});
analysis_simulation_new(addr,ftype,models{1});

end



%==========================================================================
%-Reporting and plotting
%==========================================================================

if section_report_analysis 

config_analysis = setup_config_analysis('real',addr,ftype,config_main);
report_analysis(addr,ftype,config_main,config_analysis,config_fit,sbjs,models);
plot_figures(addr,ftype,config_main,config_fit,sbjs,models,transfer_greedy);
    
end




