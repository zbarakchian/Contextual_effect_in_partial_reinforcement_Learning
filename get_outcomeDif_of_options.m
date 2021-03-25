function output = get_outcomeDif_of_options(ftype,t,option1,option2,info) %option1-option2

% in this function we can consider several senarios:
% 1.1- go back to previous trial to see the effect of left-right regret and relief
% 1.2- go back to the previous trial of the same condition to see the effect of option's regret and relief
% 2.1- we use regret/relief of the option only if that option is   chosen in the previous trial with the same context.
% 2.2- we use regret/relief of the option even if that option is unchosen in the previous trial with the same context,
% with regert(unchosen) = relief(chosen), relief(unchosen) = regret(chosen)
%
% we use the 1.2 and 2.2 senarios
% end.  

%--------------------------------------------------------------------------
%-previous trial(1.1)
%--------------------------------------------------------------------------
% t_1 = t - 1; 
% rw = get_reward(option,t_1,info);


%--------------------------------------------------------------------------
%-previous trial of the same condition(1.2) 
%--------------------------------------------------------------------------
%- here is all of the options we are going through it to find our specific option
%- find the trials in which our option has been observed, whether chosen or not-chosen
%- choose the last trial that our option has been appeared (only chosen ones(2.1)) or (whether chosen or not-chosen (2.2))

options = [info.chosen, info.unchosen];

indx_in_chs = find(option1 == options(1:t-1,1));                      
indx_in_uns = find(option1 == options(1:t-1,2));  

%(2.2)
tlast = nanmax(indx_in_chs);
% tlast = nanmax([indx_in_chs;indx_in_uns]);

%-if there is any trial
if isempty(tlast) 
    outcome_dif = 0;
    
else
switch ftype
    
case 'Partial'
    if option1 == info.chosen(tlast)
        reward1 = get_reward(option1,tlast,info);
        value2  = get_value_of_option(ftype,tlast,option2,info);
        outcome_dif = (reward1 - value2); 
    else        
        value1  = get_value_of_option(ftype,tlast,option1,info);
        reward2 = get_reward(option2,tlast,info);
        outcome_dif = (value1 - reward2); 
    end

case 'Complete'
    reward1 = get_reward(option1,tlast,info);
    reward2 = get_reward(option2,tlast,info);
    outcome_dif = (reward1 - reward2); 
end
end

output = outcome_dif;



