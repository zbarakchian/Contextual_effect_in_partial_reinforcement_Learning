function analysis_simulation_new(addr,ftype,model)

do_square_perf      = 1;
do_square_qvalues   = 0;

%% config
ntimes      = 100;
ntrials     = 1000;
Q0          = [0 0];
sd          = [1 1];
mu          = [10 9; 10 8; 10 7; 10 6; 10 5; 10 4; 10 3; 10 2; 10 1; 10 0;];
tasks       = mu;

p           = 2;
betas{1}    = 0:0.025:0.4; 
betas{2}    = 0.1:0.1:1; 
alphas      = 0.1:0.1:1;

%% agents
agents = [];
for beta = betas{p}
    for alpha1 =  alphas
        agents = [agents; [beta alpha1 0]];
        alpha2 = 0;
        for i = 1:10
            d = alpha1*power((1/2),i);
            alpha2 = alpha2 + d;
            agents = [agents; [beta alpha1 alpha2]];
        end
        agents = [agents; [beta alpha1 alpha1]];
    end
end

%%
ntasks   = size(tasks,1);
nagents  = size(agents,1);
nparams  = size(agents,2);

%%

if do_square_perf
    
square_perf = [];
square_gain = [];
for tsk  = 1:ntasks
    
    load([addr.optimal filesep 'data_sim_pure_all' filesep 'sim_' ftype '_' model.name '_task_' int2str(tsk) '_p'  num2str(p)]);%result2 
    indx_agent  = 0;
    
    b = 0;
    for beta = betas{p}
        b = b + 1;
        
        indxa1 = find(agents(:,1) == beta);
        
        a1 = 0;
        for alpha1 = 0.1:0.1:1 
            a1 = a1 + 1;
            
            indxa2  = find(agents(indxa1,2) == alpha1);
            alpha2s = unique(agents(indxa2,3,:)); 
            
            a2 = 0;
            for alpha2 = alpha2s'
                indx_agent = indx_agent + 1;
                a2 = a2 + 1;

                cum_perf    = [];
                cum_gain    = [];
                for rpt  = 1:ntimes 
                    result1  = result2{indx_agent}{rpt}; 
                    data     = result1.data;
                    %qvalues  = result1.value;
                    %plot_Q2(qvalues);

                    accs  = 2-data(:,1);
                    gains = data(:,2);

                    cum_perf(:,rpt) = cumsum(accs);
                    cum_gain(:,rpt) = cumsum(gains);
                end              
                
                perf_m = mean(cum_perf,2);
                gain_m = mean(cum_gain,2);
                
                perf_s = std(cum_perf,0,2);
                gain_s = std(cum_gain,0,2);
                

                square_perf.mean(a1,a2,b,tsk) = perf_m(end); 
                square_perf.std( a1,a2,b,tsk) = perf_s(end); 
                
                square_gain.mean(a1,a2,b,tsk) = gain_m(end); 
                square_gain.std( a1,a2,b,tsk) = gain_s(end); 
            end
        end
    end
end
save([addr.optimal filesep 'square_perf_' ftype '_p'  num2str(p) '.mat'],'square_perf','-v7.3');
save([addr.optimal filesep 'square_gain_' ftype '_p'  num2str(p) '.mat'],'square_gain','-v7.3');
disp('hoho');

end

%% qvalues
if do_square_qvalues
    
square_qvalues = [];
for tsk  = 1:ntasks
    
    load(['data_sim_pure_all' filesep 'sim_' ftype '_' model.name '_task_' int2str(tsk) '_p' num2str(p)]);%result2 
    indx_agent  = 0;
    
    b = 0;
    for beta = betas{p}
        b = b + 1;
        
        indxa1 = find(agents(:,1) == beta);
        
        a1 = 0;
        for alpha1 = 0.1:0.1:1 
            a1 = a1 + 1;
            
            indxa2  = find(agents(indxa1,2) == alpha1);
            alpha2s = unique(agents(indxa2,3,:)); 
            
            a2 = 0;
            for alpha2 = alpha2s'
                indx_agent = indx_agent + 1;
                a2 = a2 + 1;

                qvalue_rpt    = [];
                for rpt  = 1:ntimes 
                    result1  = result2{indx_agent}{rpt}; 
                    data     = result1.data;
                    qvalues  = result1.value;
                    %plot_Q2(qvalues);

                    qvalue_rpt(:,rpt) = qvalues(ntrials,:)';
                end              
                
                square_qvalues.mean(a1,a2,b,tsk,:) = mean(qvalue_rpt,2); 
                square_qvalues.std(a1,a2,b,tsk,:)  = std(qvalue_rpt,0,2); 
            end
        end
    end
end
save([addr.optimal filesep 'square_qvalue_' ftype '_p'  num2str(p) '.mat'],'square_qvalues','-v7.3');
disp('hoho');    
end




