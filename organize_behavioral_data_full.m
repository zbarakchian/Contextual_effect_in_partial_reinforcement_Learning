function organize_behavioral_data_full(addr)

subjects{1} = [1:41]; %Partial
subjects{2} = [1:47]; %Complete

task = {'Partial','Complete'}; 

for version = 1:2
    
    sbjs.indx = subjects{version};
    sbjs.nt   = find_end_trial(task{version},sbjs);
    nsub      = length(sbjs);
    
    for sub = sbjs.indx
        nt   = sbjs.nt(sub);

        load(['Data' filesep, 'S',int2str(sub), '_Learn_', task{version}, '.mat']);   

        learning(sub).cond       = data_Learning(1:nt,4); 
        learning(sub).stim_l     = data_Learning(1:nt,5); 
        learning(sub).stim_r     = data_Learning(1:nt,6); 
        learning(sub).action     = data_Learning(1:nt,7); 
        learning(sub).chosen     = data_Learning(1:nt,8); 
        learning(sub).unchosen   = 4 + 2.*(rem(learning(sub).chosen,2)==0) - learning(sub).chosen; 
        learning(sub).pair       = get_pairs(data_Learning,nt);
        learning(sub).rw_l       = data_Learning(1:nt,9);
        learning(sub).rw_r       = data_Learning(1:nt,10);
        learning(sub).rw_FC      = data_Learning(1:nt,11);
        learning(sub).rw_CF      = data_Learning(1:nt,12);
        learning(sub).rsp        = data_Learning(1:nt,13);
        learning(sub).acc        = data_Learning(1:nt,14);
        learning(sub).rt         = data_Learning(1:nt,15);  
        
        if iszero(learning(sub).rw_CF)
            learning(sub).rw_CF = nan(nt,1);
        end
            
    end
    data.(task{version}).learning = learning;    
end 




save([addr.bhv filesep 'data_behavioral'], 'data');




