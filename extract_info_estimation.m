function output = extract_info_estimation(ftype,sbjs)

nsub = length(sbjs.indx);

%% Valuation Phase
%-put the data of all participants into one cell array data
%--------------------------------------------------------------------------
for sub = sbjs.indx 
    load(['Data' filesep, 'S',int2str(sub), '_Mean_', ftype, '.mat']);      
    data{sub} = data_Mean; % 'data_Mean' is the name of variable after loading
end
info_estimation.valuation.data = data;

Values = zeros(4,6,nsub);
for sub = sbjs.indx 
    
    stim{sub}  = data{sub}(:,3);  
    value{sub} = data{sub}(:,4); 
    
    I = find(stim{sub} == 1);
    Val1 = value{sub}(I);
    
    I = find(stim{sub} == 2);
    Val2 = value{sub}(I);
    
    I = find(stim{sub} == 3);
    Val3 = value{sub}(I);
    
    I = find(stim{sub} == 4);
    Val4 = value{sub}(I);
    
    MEAN = [mean(Val1),mean(Val2),mean(Val3),mean(Val4)];
    SEM  = [std(Val1), std(Val2), std(Val3), std(Val4) ];  
    Values(:,:,sub) = [ [Val1(:)',MEAN(1),SEM(1)];...
                        [Val2(:)',MEAN(2),SEM(2)];...
                        [Val3(:)',MEAN(3),SEM(3)];...
                        [Val4(:)',MEAN(4),SEM(4)]];
end
info_estimation.valuation.estimate = Values;
output = info_estimation;


