function organize_level2(addr,ftype,config_sim,models)
disp('starting 2nd level organization...');

nmodel     = length(models);

ntimes     = config_sim.ntimes;
simtype    = config_sim.simtype;
agents     = config_sim.agents;


% load([config_sim.addr filesep simtype '_level1_' ftype ]);     

for m = 1:nmodel  
    
%-learning: data,task,hist,performance,statistics,rt,regret
%--------------------------------------------------------------------------
%stim_cond  = [1 3;2 4]; %A1B, A2C

load([config_sim.addr filesep simtype '_level1_' ftype '_' models{m}.name]);  

for sub = agents{m}.indx

    tmp = level1{sub}.learning.datac1;

    n = size(tmp,1);
    datac1.mean(1:n, 1,   sub) = tmp(:,1,1);
    datac1.mean(1:n, 2:3, sub) = nanmean(tmp(:, 2:3, 1:ntimes),3);

    datac1.std (1:n, 1,   sub) = tmp(:,1,1);        
    datac1.std (1:n, 2:3, sub) = nanstd (tmp(:, 2:3, 1:ntimes),0,3);        
end
level2.learning.datac1 = datac1;


%stim_cond  = [1 3;2 4]; %A1B, A2C
for c = 1:2
    for sub = agents{m}.indx  
        tmp = level1{sub}.learning.datac2{c};
        n = size(tmp,1);

        datac2.mean{c}(1:n,:,sub) = nanmean(tmp(:,:,1:ntimes),3);
        datac2.std {c}(1:n,:,sub) = nanstd (tmp(:,:,1:ntimes),0,3);            
    end
end
level2.learning.datac2 = datac2;



for sub = agents{m}.indx
    hist.mean(sub,:) = nanmean(level1{sub}.learning.hist(1:ntimes,:),1);
    hist.std(sub,:)  = nanstd (level1{sub}.learning.hist(1:ntimes,:),1);
end
level2.learning.hist = hist;
    
    
for sub = agents{m}.indx
    perf.mean(sub)   = nanmean(level1{sub}.learning.performance(1:ntimes));
    perf.std(sub)    = nanstd (level1{sub}.learning.performance(1:ntimes));
end
level2.learning.performance = perf;


for sub = agents{m}.indx
    perfs.mean(sub,:) = nanmean(level1{sub}.learning.performances(1:ntimes,:),1);
    perfs.std(sub,:)  = nanstd (level1{sub}.learning.performances(1:ntimes,:),1);
end
level2.learning.performances = perfs;


for sub = agents{m}.indx
    for c = 1:2
        conds_ratio.mean{c}(:,:,sub)  = nanmean(level1{sub}.learning.conds_ratio{c}(:,:,1:ntimes),3);
        conds_ratio.std{c}(:,:,sub)   = nanstd (level1{sub}.learning.conds_ratio{c}(:,:,1:ntimes),0,3);
    end
end
level2.learning.conds_ratio = conds_ratio;


%-transfer(greedy): data,pref,conf,rt
%--------------------------------------------------------------------------
for sub = agents{m}.indx

    tmp = level1{sub}.transfer.greedy; 

    all_lefts  = []; 
    all_rights = [];
    for itr = 1:ntimes
        all_lefts    = [all_lefts;    tmp.pref.all{itr}.left];
        all_rights   = [all_rights;   tmp.pref.all{itr}.right];
    end
    %-mean
    %------------------------------------------------------------------
    pref.mean.all{sub}.left            = nanmean(all_lefts, 1);
    pref.mean.all{sub}.right           = nanmean(all_rights,1);

    pref.mean.first_left (sub,:)       = nanmean(tmp.pref.first_left (1:ntimes,:),1);
    pref.mean.first_right(sub,:)       = nanmean(tmp.pref.first_right(1:ntimes,:),1);

    pref.mean.rate_left (sub,:)        = nanmean(tmp.pref.rate_left (1:ntimes,:),1);
    pref.mean.rate_right(sub,:)        = nanmean(tmp.pref.rate_right(1:ntimes,:),1);

    pref.mean.bin_left (sub,:)         = nanmean(tmp.pref.bin_left (1:ntimes,:),1);
    pref.mean.bin_right(sub,:)         = nanmean(tmp.pref.bin_right(1:ntimes,:),1);

    %-std
    %------------------------------------------------------------------
    pref.std.all{sub}.left             = nanstd(all_lefts, 1);
    pref.std.all{sub}.right            = nanstd(all_rights,1);

    pref.std.first_left(sub,:)         = nanstd(tmp.pref.first_left(1:ntimes,:),1);
    pref.std.first_right(sub,:)        = nanstd(tmp.pref.first_right(1:ntimes,:),1);

    pref.std.rate_left(sub,:)          = nanstd(tmp.pref.rate_left(1:ntimes,:),1);
    pref.std.rate_right(sub,:)         = nanstd(tmp.pref.rate_right(1:ntimes,:),1);

    pref.std.bin_left(sub,:)           = nanstd(tmp.pref.bin_left(1:ntimes,:),1);
    pref.std.bin_right(sub,:)          = nanstd(tmp.pref.bin_right(1:ntimes,:),1);

end
level2.transfer.greedy.pref = pref;


for sub = agents{m}.indx

    tmp = level1{sub}.transfer.greedy; 

    all_lefts  = []; 
    all_rights = [];
    for itr = 1:ntimes
        all_lefts    = [all_lefts;    tmp.conf.all{itr}.left];
        all_rights   = [all_rights;   tmp.conf.all{itr}.right];
    end
    %-mean
    %------------------------------------------------------------------
    conf.mean.all{sub}.left            = nanmean(all_lefts, 1);
    conf.mean.all{sub}.right           = nanmean(all_rights,1);

    conf.mean.first_left(sub,:)        = nanmean(tmp.conf.first_left(1:ntimes,:),1);
    conf.mean.first_right(sub,:)       = nanmean(tmp.conf.first_right(1:ntimes,:),1);

    conf.mean.mean_left(sub,:)         = nanmean(tmp.conf.mean_left(1:ntimes,:),1);
    conf.mean.mean_right(sub,:)        = nanmean(tmp.conf.mean_right(1:ntimes,:),1);

    conf.mean.std_left(sub,:)          = nanmean(tmp.conf.std_left(1:ntimes,:),1);
    conf.mean.std_right(sub,:)         = nanmean(tmp.conf.std_right(1:ntimes,:),1);

    %-std
    %------------------------------------------------------------------
    conf.std.all{sub}.left             = nanstd(all_lefts, 1);
    conf.std.all{sub}.right            = nanstd(all_rights,1);

    conf.std.first_left(sub,:)         = nanstd(tmp.conf.first_left(1:ntimes,:),1);
    conf.std.first_right(sub,:)        = nanstd(tmp.conf.first_right(1:ntimes,:),1);

    conf.std.mean_left(sub,:)          = nanstd(tmp.conf.mean_left(1:ntimes,:),1);
    conf.std.mean_right(sub,:)         = nanstd(tmp.conf.mean_right(1:ntimes,:),1);

    conf.std.std_left(sub,:)           = nanstd(tmp.conf.std_left(1:ntimes,:),1);
    conf.std.std_right(sub,:)          = nanstd(tmp.conf.std_right(1:ntimes,:),1);

end
level2.transfer.greedy.conf = conf;

%-transfer(softmax): data,pref,conf,rt
%--------------------------------------------------------------------------
for sub = agents{m}.indx

    tmp = level1{sub}.transfer.softmax;

    all_lefts  = []; 
    all_rights = [];
    for itr = 1:ntimes
        all_lefts    = [all_lefts;    tmp.pref.all{itr}.left];
        all_rights   = [all_rights;   tmp.pref.all{itr}.right];
    end
    %-mean
    %------------------------------------------------------------------
    pref.mean.all{sub}.left            = nanmean(all_lefts, 1);
    pref.mean.all{sub}.right           = nanmean(all_rights,1);

    pref.mean.first_left(sub,:)        = nanmean(tmp.pref.first_left(1:ntimes,:),1);
    pref.mean.first_right(sub,:)       = nanmean(tmp.pref.first_right(1:ntimes,:),1);

    pref.mean.rate_left(sub,:)         = nanmean(tmp.pref.rate_left(1:ntimes,:),1);
    pref.mean.rate_right(sub,:)        = nanmean(tmp.pref.rate_right(1:ntimes,:),1);

    pref.mean.bin_left(sub,:)          = nanmean(tmp.pref.bin_left(1:ntimes,:),1);
    pref.mean.bin_right(sub,:)         = nanmean(tmp.pref.bin_right(1:ntimes,:),1);

    %-std
    %------------------------------------------------------------------
    pref.std.all{sub}.left        = nanstd(all_lefts, 1);
    pref.std.all{sub}.right       = nanstd(all_rights,1);

    pref.std.first_left(sub,:)    = nanstd(tmp.pref.first_left(1:ntimes,:),1);
    pref.std.first_right(sub,:)   = nanstd(tmp.pref.first_right(1:ntimes,:),1);

    pref.std.rate_left(sub,:)     = nanstd(tmp.pref.rate_left(1:ntimes,:),1);
    pref.std.rate_right(sub,:)    = nanstd(tmp.pref.rate_right(1:ntimes,:),1);

    pref.std.bin_left(sub,:)      = nanstd(tmp.pref.bin_left(1:ntimes,:),1);
    pref.std.bin_right(sub,:)     = nanstd(tmp.pref.bin_right(1:ntimes,:),1);

end
level2.transfer.softmax.pref = pref;

for sub = agents{m}.indx

    tmp = level1{sub}.transfer.softmax;

    all_lefts  = []; 
    all_rights = [];
    for itr = 1:ntimes
        all_lefts    = [all_lefts;    tmp.conf.all{itr}.left];
        all_rights   = [all_rights;   tmp.conf.all{itr}.right];
    end
    %-mean
    %------------------------------------------------------------------
    conf.mean.all{sub}.left            = nanmean(all_lefts, 1);
    conf.mean.all{sub}.right           = nanmean(all_rights,1);

    conf.mean.first_left(sub,:)        = nanmean(tmp.conf.first_left(1:ntimes,:),1);
    conf.mean.first_right(sub,:)       = nanmean(tmp.conf.first_right(1:ntimes,:),1);

    conf.mean.mean_left(sub,:)         = nanmean(tmp.conf.mean_left(1:ntimes,:),1);
    conf.mean.mean_right(sub,:)        = nanmean(tmp.conf.mean_right(1:ntimes,:),1);

    conf.mean.std_left(sub,:)          = nanmean(tmp.conf.std_left(1:ntimes,:),1);
    conf.mean.std_right(sub,:)         = nanmean(tmp.conf.std_right(1:ntimes,:),1);

    %-std
    %------------------------------------------------------------------
    conf.std.all{sub}.left             = nanstd(all_lefts, 1);
    conf_std.all{sub}.right            = nanstd(all_rights,1);

    conf.std.first_left(sub,:)         = nanstd(tmp.conf.first_left(1:ntimes,:),1);
    conf.std.first_right(sub,:)        = nanstd(tmp.conf.first_right(1:ntimes,:),1);

    conf.std.mean_left(sub,:)          = nanstd(tmp.conf.mean_left(1:ntimes,:),1);
    conf.std.mean_right(sub,:)         = nanstd(tmp.conf.mean_right(1:ntimes,:),1);

    conf.std.std_left(sub,:)           = nanstd(tmp.conf.std_left(1:ntimes,:),1);
    conf.std.std_right(sub,:)          = nanstd(tmp.conf.std_right(1:ntimes,:),1);

end
level2.transfer.softmax.conf = conf;

save([config_sim.addr filesep simtype '_level2_' ftype '_' models{m}.name],'level2');
end


