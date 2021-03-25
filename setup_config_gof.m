function config = setup_config_gof(models)

%-setup specific config and run 
%--------------------------------------------------------------------------
config.save          = 1; % save the data
config.type          = 1; % 1 = learning (greedy ratio for transfer), 2 = Transfer, 3 = Both phases
config.transfer.iter = 1; % 1 = first iteration, 4 = all four iterations 
config.transfer.cmb  = 1; % 1=A1A2, 2=A1B, 3=A1C, 4=A2B, 5=A2C, 6=BC, 7=(1+2+3+4+5+6), 8=(1+6), 9=(2+3+4+5)

if config.type == 1 
config.transfer.iter = 0; 
config.transfer.cmb  = 0;  
end

