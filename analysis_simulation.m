function analysis_simulation(addr,ftype,config_main,config_sim,sbjs,models)

%==========================================================================
%-do analysis
%==========================================================================

nmodel = length(models);
agents = config_sim.agents;


%% general analysis
%--------------------------------------------------------------------------
for m = 1:nmodel   
    model = models{m};
    sbjs  = agents{m};
      
    config_analysis = setup_config_analysis('fake',addr,ftype,config_sim,model);
    analysis_behavior_pop(addr,ftype,config_main,config_analysis,sbjs); %todo
end








