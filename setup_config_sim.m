function config = setup_config_sim(type,addr,ftype,config_fit,sbjs,models)

%% which type of simulation?
switch type
 
%==========================================================================
case 'sim_pure'
%==========================================================================

%-setup the configuration
%--------------------------------------------------------------------------
ntimes                  = 1;
ntrials                 = 500;             %should be multiplier of 4 (creat_rewards code)
Q0                      = [0 0; 0 0];
parameters              = [0.1, 0.1 0];
mu                      = [0,0; 0,0];      %[10,9; 10,8]; %[64,54; 64,44];
std                     = 1;               %(mu(1,1)-mu(1,2))*(10/10); %mu(1,1)/6  %13
adr                     = addr.simp;


rewards  = [[mu(1,1),std]; [mu(2,1), std]; [mu(1,2), std]; [mu(2,2), std]];
nmodel   = length(models);
for m = 1:nmodel    
    ptemp{m}         = parameters; %models{m}.parameters.inits();
    agents{m}.indx   = 1:size(ptemp{m},1);
    agents{m}.nt     = repmat(ntrials, 1, size(agents{m}.indx,1));
    
    for sub = agents{m}.indx     
        params{m,sub}             = ptemp{m}(sub,:);
        
        args{m,sub}.arg_learn     = design_rewards2(rewards, ntrials);
        args{m,sub}.Q0            = Q0;
        args{m,sub}.sub           = sub;
        args{m,sub}.model         = nan;
    end
end    


    
%==========================================================================
case 'sim_fitted'
%==========================================================================

%-setup the configuration
%--------------------------------------------------------------------------
ntimes                  = 100;
ntrials                 = 500;             %should be multiplier of 4 (creat_rewards code)
Q0                      = [0 0; 0 0];
adr                     = addr.simf;

load([addr.fit filesep 'data_fit_',ftype,'_Learning1_Transfer',num2str(config_fit.fit_transfer),'_Prior',num2str(config_fit.use_prior),'.mat']);

nmodel   = length(models);
for m = 1:nmodel
    agents{m}.indx  = sbjs.indx;
    agents{m}.nt    = sbjs.nt;
    
    for sub = sbjs.indx     
        params{m}(sub,:)       = data_fit.(models{m}.name)(sub).params;
        
        args{m,sub}.arg_learn  = design_rewards([[64,13]; [64, 13]; [54, 13]; [44, 13]],ntrials);
       %args{m,sub}.arg_learn  = extract_data_for_sim2(addr,ftype,sub);
       %args{m,sub}.arg_learn  = extract_data_for_sim1(config_main,ftype,sub); %Extract Data:[con,stim,rws]
        args{m,sub}.Q0         = Q0;
        args{m,sub}.sub        = sub;
        args{m,sub}.model      = nan; 
    end
end
end


%-fill in the configuration
%--------------------------------------------------------------------------
config.simtype          = type;
config.datatype         = 'fake';
config.dolearning       = 1;
config.dotransfer       = 1;
config.Q0               = Q0;
config.ntrials          = ntrials;
config.ntimes           = ntimes;
config.params           = params;
config.args             = args;
config.agents           = agents;
config.addr             = adr;










