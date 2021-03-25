function rw = get_reward(option,t,info)

rw = nan;
if     option == info.stim_l(t)
    rw = info.rw_l(t);
elseif option == info.stim_r(t)
    rw = info.rw_r(t);
end
