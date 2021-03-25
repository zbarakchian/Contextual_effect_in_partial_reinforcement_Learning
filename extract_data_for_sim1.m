function output = extract_data_for_sim1(config,ftype,sub)
%-load data
%--------------------------------------------------------------------------
load(strcat(config.addr_bhv, filesep, 'data_', ftype, '_Learning.mat'));
data_Learning = info_learning.data{sub};
%%

con    = data_Learning(:,1);
stim   = data_Learning(:,2:3);                                                
rws    = data_Learning(:,7:8);  

output = [con,stim,rws];
%%    

