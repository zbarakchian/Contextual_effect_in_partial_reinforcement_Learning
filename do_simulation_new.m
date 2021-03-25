function do_simulation_new(addr,ftype,model)

ntimes   = 100;
ntrials  = 1000;
Q0       = [0 0];
sd       = [1 1];
mu       = [10 9; 10 8; 10 7; 10 6; 10 5; 10 4; 10 3; 10 2; 10 1; 10 0;];

%%
betas1   = 0.1:0.1:1;
betas2   = 0:0.025:0.4;
alphas   = 0.1:0.1:1;


% agents   = [1,0.2,0.1];
agents   = [];
for b = betas2
    for a1 = alphas 
        agents = [agents; [b a1 0]];
        a2 = 0;
        for i = 1:10
            d = a1*power((1/2),i);
            a2 = a2 + d;
            agents = [agents; [b a1 a2]];
        end
        agents = [agents; [b a1 a1]];
    end
end
save([addr.optimal filesep 'sim_pure_agents_p2.mat'],'agents');


%%
tasks    = mu;
ntasks   = size(tasks,1);
nagents  = size(agents,1);
nparams  = size(agents,2);

for tsk  = 1:ntasks 
    for sub  = 1:nagents
        for rpt  = 1:ntimes 
            disp([tsk sub rpt]);
            params          = agents(sub,:);    
            rw_stat.mu      = [mu(tsk,1),mu(tsk,2)];
            rw_stat.sigma   = [sd(1),sd(2)];
            result1{rpt}    = model.simulate_pure(params,rw_stat,Q0,ntrials);   
        end
        result2{sub} = result1;
    end
    result3{tsk} = result2;
    
    save([addr.optimal filesep 'sim_' ftype '_' model.name '_task_' int2str(tsk) '_p2.mat'],'result2','-v7.3');     %'-v7.3' is fot the large file   
end
result = result3;







