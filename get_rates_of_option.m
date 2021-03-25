function rate = get_rates_of_option(ftype,t,option,info)

options = [info.chosen, info.unchosen];

indxs_in_chs = find(option == options(1:t-1,1));                      
indxs_in_uns = find(option == options(1:t-1,2));  

rate_in_chs = length(indxs_in_chs);
rate_in_uns = length(indxs_in_uns);

switch ftype
    case 'Partial'
        rate  = rate_in_chs;
    case 'Complete'
        rate  = rate_in_chs;% + rate_in_uns;
end