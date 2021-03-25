function simulate_agents(ftype,config_sim,models)

nmodel = length(models);
ntimes = config_sim.ntimes;   


%==========================================================================
%-Learning
%==========================================================================
if config_sim.dolearning
    
for m = 1:nmodel
    model = models{m};
    disp(model.name);
    disp('learning phase ...');
    %----------------------------------------------------------------------
    agents = config_sim.agents{m};
    for indx = agents.indx     
        params = config_sim.params{m}(indx,:);
        args   = config_sim.args{m,indx};
        %------------------------------------------------------------------
        for i = 1:ntimes
            itr{i} = dosimulate(model,params,args); %(A1,A2,B,C)
        end
        %------------------------------------------------------------------
        tmp{indx}.itr   = itr;
        tmp{indx}.param = params;
    end
    sim_learning = tmp;
    save([config_sim.addr filesep config_sim.simtype,'_learning_' ftype '_' models{m}.name],'sim_learning');       %'-v7.3' is fot the large file   
end
end



%==========================================================================
%-Transfer
%==========================================================================
if config_sim.dotransfer

for m = 1:nmodel
    disp('transfer phase ...')
    load([config_sim.addr filesep config_sim.simtype, '_learning_' ftype '_' models{m}.name],'sim_learning');
    %----------------------------------------------------------------------
    for indx = agents.indx       
        %nt = config_fit.ntrials; 
        nt = agents.nt(indx);
        for i = 1:ntimes
            beta   = sim_learning{indx}.param(1); %removed .(models{m}.name)
            Qend   = sim_learning{indx}.itr{i}.value(nt,:); %.(models{m}.name)
            itr{i} = simulate_transfer(Qend,beta);
        end
        tmp{indx}.itr = itr;        
    end
    sim_transfer = tmp;
    save([config_sim.addr filesep config_sim.simtype, '_transfer_' ftype '_' models{m}.name],'sim_transfer');
end
end




