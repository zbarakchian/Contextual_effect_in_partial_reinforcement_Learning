function output = redesign_data_learning(data)

%-redesign the data
%--------------------------------------------------------------------------   
prefs   = []; %left-right: A1B, or left-right:A2C

cond      = data(:,4);
stims     = data(:,5:6);
action    = data(:,7);
chosen    = data(:,8);
rews      = data(:,9:10);
rews_FCCF = data(:,11:12);
rsp       = data(:,13);
acc       = data(:,14);
rt        = data(:,15);


for i = 1:size(data,1) %learning trials
    if action(i) == 0 || action(i) == 99
            prefs(i,:) = [nan nan]; %[left,right] 
    else
        if stims(i,action(i)) == min(stims(i,:))
            prefs(i,:) = [1 0]; %[left,right] 
        else
            prefs(i,:) = [0 1]; %[left,right] 
        end
    end
end

output = [cond, stims, chosen, prefs, rews, rews_FCCF, rsp,acc, rt];


