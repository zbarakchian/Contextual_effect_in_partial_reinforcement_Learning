function output = get_pairs(data,nt) %left-right

%--------------------------------------------------------------------------   
pairs   = []; %left-right: A1B, or left-right:A2C

stims   = data(1:nt,5:6); 
action  = data(1:nt,7);

for i = 1:nt    %learning trials
    if action(i) == 0 || action(i) == 99
        pairs(i,:) = [nan nan]; %[left,right] 
    else
        if stims(i,action(i)) == min(stims(i,:))
            pairs(i,:) = [1 0]; %[left,right] 
        else
            pairs(i,:) = [0 1]; %[left,right] 
        end
    end
end

output = pairs;


