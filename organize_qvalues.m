function organize_qvalues(ftype,config_sim,models)

filename = [config_sim.addr filesep config_sim.simtype ,'_learning_', ftype];
load(filename);

ntimes  = config_sim.ntimes;
agents  = config_sim.agents;
nmodel  = length(models);

%-level1
%--------------------------------------------------------------------------
for m = 1:nmodel
    model   = models{m};   
    dataq   = sim_learning.(model.name); 
    
    for sub = agents{m}.indx
        qvalues1 = [];    
        for i = 1:ntimes
            qvalues1(:,:,i) = dataq{sub}.itr{i}.value; %(A1,A2,B,C)
        end
        qlevel1.(model.name){sub} = qvalues1;
    end             
end

%-level2
%--------------------------------------------------------------------------
for m = 1:nmodel
    model   = models{m};   
    
    qvalues2 = [];
    for sub = agents{m}.indx
        level1 = qlevel1.(model.name){sub};
        n = size(level1,1);
        qvalues2.mean(1:n,:,sub) = nanmean(level1,3);
        qvalues2.std (1:n,:,sub) = nanstd (level1,0,3);
    end             
    qlevel2.(model.name) = qvalues2;
end

disp('');
save([config_sim.addr filesep config_sim.simtype ,'_qvalues_', ftype], 'qlevel1','qlevel2');


