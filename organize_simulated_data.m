function organize_simulated_data(addr,ftype,config_sim,models)
%-convert the structure to that of the behavioral data


%-extract each iteration and get the output for all iterations of each subject
organize_level1(addr,ftype,config_sim,models);                                 %create 'sim_..._summary_level1_'

%-extract each subject, and get the output for all subjects
organize_level2(addr,ftype,config_sim,models);                                 %save the extracted data


