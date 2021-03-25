function output = redesign_data_transfer(data)

prefs = [];
confs = [];

stim      = data(:,3:4);
action    = data(:,5);
chosen    = data(:,6);
conf      = data(:,10);
rt_pref   = data(:,9);
rt_conf   = data(:,11);

for i = 1:size(data,1) %test trials
    if stim(i,action(i)) == min(stim(i,:))
        prefs(i,:) = [1 0]; %[left,right] 
    else
        prefs(i,:) = [0 1]; %[left,right] 
    end
end

for i = 1:size(data,1) %test trials
    if stim(i,action(i)) == min(stim(i,:))
        confs(i,:) = [conf(i) nan]; %[left,right] 
    else
        confs(i,:) = [nan conf(i)]; %[left,right] 
    end
end

output = [stim, prefs, confs, rt_pref, rt_conf];


