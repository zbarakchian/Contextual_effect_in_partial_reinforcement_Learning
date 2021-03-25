function do_simulation(addr,ftype,config_sim,models)

%==========================================================================
%-do the simulation,organize the data and save them
%==========================================================================
simulate_agents(ftype,config_sim,models);                     %create 'sim_...' file
organize_simulated_data(addr,ftype,config_sim,models);        %create 'sim_..._level1_' and save the exctracted data
organize_qvalues(ftype,config_sim,models);