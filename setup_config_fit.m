function config = setup_config_fit()

%-setup config variables
%--------------------------------------------------------------------------   
config.fit_type     = 'Standard';   % specify 'Standard' or 'Cross-Validation'!;
config.use_prior    = 1;            % specify whether use prior in fitting or not!
config.fit_transfer = 0;            % specify whether fit transfer phase or not!
config.inits_res    = 0.2;          % specify the initial points resolution! for exampple if the resolution is 0.1 -> all initial points for the alpha parameter will be: 0:0.1:1 
config.Q0           = [0 0; 0 0];   % specify the initial Q-value for fitting
config.save         = 1;            % do you want to save the data?

