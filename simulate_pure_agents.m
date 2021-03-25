function simulate_pure_agents(config,config_simpure,models)
%-Simulation with fake parameters

ntimes  = config_simpure.ntimes;
ntrials = config_simpure.ntrials;
nmodel  = length(models);

%==========================================================================
%-Learning
%==========================================================================
if config_simpure.learning
for m = 1:nmodel
    disp(models{m}.name);
    disp('learning phase ...')
    %----------------------------------------------------------------------
    agents    = models{m}.parameters.inits();
    agents.nt = repmat(ntrials,1,length(agents.indx));
    for indx = agents.indx     
        params          = agents.params(indx,:);
        rw_stats        = config_simpure.rewards;
        args.arg_learn  = design_rewards(rw_stats,ntrials);
        args.Q0         = config_simpure.Q0;
        args.sub        = indx;
        args.model      = nan;
        %------------------------------------------------------------------
        for i = 1:ntimes
            itr{i} = dosimulate(models{m},params,args);
        end
        %----------------------------------------------------------------------
        tmp{indx}.itr   = itr;
        tmp{indx}.param = params;
    end
    sim_learning.(models{m}.name) = tmp;
end
%-save the simulated data
%--------------------------------------------------------------------------
if config_simpure.save   
save(['psimulation_learning_' config.ftype],'sim_learning','-v7.3');     %'-v7.3' is fot the large file   
end 
end



%==========================================================================
%-Transfer
%==========================================================================
if config_simpure.transfer
load(['psimulation_learning_' config.ftype]);

for m = 1:nmodel
    disp('transfer phase ...')
    %----------------------------------------------------------------------
    for indx = agents.indx       
        nt = agents.nt(indx);
        for i = 1:ntimes
            beta   = sim_learning.(models{m}.name){indx}.param(1);
            Qend   = sim_learning.(models{m}.name){indx}.itr{i}.value(nt,:); 
            itr{i} = simulate_transfer(Qend,beta);
        end
        tmp{indx}.itr = itr;        
    end
    sim_transfer.(models{m}.name) = tmp;
end

%-save the simulated data
%--------------------------------------------------------------------------
if config_simpure.save   
save(['psimulation_transfer_' config.ftype],'sim_transfer','-v7.3');     %'-v7.3' is fot the large file   
end
end




