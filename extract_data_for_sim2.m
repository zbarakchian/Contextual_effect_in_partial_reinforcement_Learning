function output = extract_data_for_sim2(addr,ftype,sub)
%-load data
%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
data_Learning = info_learning.data{sub};

%-extract data
%--------------------------------------------------------------------------                        
con    = data_Learning(:,1);
stim   = data_Learning(:,2:3);                                                
rws    = data_Learning(:,7:8);
out    = data_Learning(:,9);                                                
cou    = data_Learning(:,10);                                               
resp   = data_Learning(:,11);

for i = 1:size(data_Learning(:,4),1) %[1,2,3,4]=[A1,A2,B,C] -> S1=[A1,B],S2=[A2,B]
    if     (data_Learning(i,4) == 1)||(data_Learning(i,4) == 2)       cho(i,1)  = 1; 
    elseif (data_Learning(i,4) == 3)||(data_Learning(i,4) == 4)       cho(i,1)  = 2; 
    else                                                              cho(i,1)  = 0; 
    end   
end

output = [con,stim,rws,cho,out,cou,resp];
