function ntrial = find_end_trial(ftype,sbjs)

ntrial = [];
for sub = sbjs.indx    
    load(['Data' filesep 'S' int2str(sub) '_Learn_' ftype,'.mat']);  
    
    trial_number{sub} = data_Learning(:,3); %trial number 
    I = find(trial_number{sub}(:)== 0);
    nt = length(data_Learning);
    if ~isempty(I)  
        nt = I(1)-1;
    end
    ntrial(sub) = nt;
end
