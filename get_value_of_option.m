function value = get_value_of_option(ftype,t,option,info)

options = [info.chosen, info.unchosen];

if     t == 1
    indxs_in_chs = [];
    indxs_in_uns = [];
else% if t > 1
    indxs_in_chs = find(option == options(1:t-1,1));                      
    indxs_in_uns = find(option == options(1:t-1,2));  
end

rws_in_chs = nan;
if ~isempty(indxs_in_chs)
    rws_in_chs   = info.rw_FC(indxs_in_chs);
end

rws_in_uns = nan;
if ~isempty(indxs_in_uns)
    rws_in_uns   = info.rw_CF(indxs_in_uns);
end

switch ftype
    case 'Partial'
        value  = nanmean(rws_in_chs);
    case 'Complete'
        rws    = [rws_in_chs; rws_in_uns];
        value  = nanmean(rws);
end

if isnan(value)
    value = 0;
end


