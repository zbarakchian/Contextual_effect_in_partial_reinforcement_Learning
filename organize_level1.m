function organize_level1_new(addr,ftype,config_sim,models)
disp('starting 1st level organization...');

nmodel     = length(models);

ntimes     = config_sim.ntimes;
simtype    = config_sim.simtype;
agents     = config_sim.agents;

%--------------------------------------------------------------------------

for m = 1:nmodel 
    disp(models{m}.name);
    disp('---------------------------------');

    %-extract data: learning
    %----------------------------------------------------------------------
    disp('learning phase....');
    load([config_sim.addr filesep simtype,'_learning_' ftype '_' models{m}.name]);   
    
    for sub = agents{m}.indx
        disp([sub]);
        itrs.indx = 1:ntimes;
        itrs.nt   = repmat(agents{m}.nt(sub),1,ntimes);
    
        %-learning
        %------------------------------------------------------------------
        data = [];
        for i = 1:ntimes
            data{i} = sim_learning{sub}.itr{i}.data; %.(models{m}.name)
        end 
        info_learning = extract_info_learning(ftype,itrs,data);        
        level1{sub}.learning = info_learning;
    end
        
    %-extract data: transfer
    %----------------------------------------------------------------------
    disp('transfer phase....');
    load([config_sim.addr filesep simtype '_transfer_' ftype '_' models{m}.name]);

    %-transfer phase
    %----------------------------------------------------------------------
    for sub = agents{m}.indx
        disp([sub]);
        itrs.indx = 1:ntimes;
        itrs.nt   = repmat(agents{m}.nt(sub),1,ntimes);
            
        %-transfer greedy
        %------------------------------------------------------------------
        data = [];
        for i = 1:ntimes
            data{i} = sim_transfer{sub}.itr{i}.greedy; %.(models{m}.name)
        end        
        info_transfer = extract_info_transfer(ftype,itrs,data);        
        level1{sub}.transfer.greedy = info_transfer;
        
        %-transfer softmax
        %------------------------------------------------------------------
        data = [];        
        for i = 1:ntimes
            data{i} = sim_transfer{sub}.itr{i}.softmax; %.(models{m}.name)
        end        
        info_transfer = extract_info_transfer(ftype,itrs,data);        
        level1{sub}.transfer.softmax = info_transfer;

    end
    save([config_sim.addr filesep simtype '_level1_' ftype '_' models{m}.name],'level1');     
    
end



