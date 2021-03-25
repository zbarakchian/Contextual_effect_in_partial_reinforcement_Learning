function test_transfer_effect_within(config,config_analysis,sbjs)
info_transfer = config_analysis.info_transfer;


pref_rate_left  = info_transfer.pref.rate_left;
pref_rate_right = info_transfer.pref.rate_right;

pref_bin_left    = info_transfer.pref.bin_left;
pref_bin_right   = info_transfer.pref.bin_right;

pref_first_left  = info_transfer.pref.first_left;
pref_first_right = info_transfer.pref.first_right;

conf_mean_left  = info_transfer.conf.mean_left;
conf_mean_right = info_transfer.conf.mean_right;

conf_first_left  = info_transfer.conf.first_left;
conf_first_right = info_transfer.conf.first_right;

%--------------------------------------------------------------------------
switch config.ttype
    case 'rate'
        %% Rate
        pref_left         = pref_rate_left(sbjs.indx,:);
        pref_right        = pref_rate_right(sbjs.indx,:);
        %% Conf
        conf_left         = conf_mean_left(sbjs.indx,:);
        conf_right        = conf_mean_right(sbjs.indx,:);
        
    case 'binary'
        %% Rate
        pref_left         = pref_bin_left(sbjs.indx,:);
        pref_right        = pref_bin_right(sbjs.indx,:);
        %% Conf
        conf_left         = conf_mean_left(sbjs.indx,:);
        conf_right        = conf_mean_right(sbjs.indx,:);
        
    case 'first'
        %% Rate
        pref_left         = pref_first_left(sbjs.indx,:);
        pref_right        = pref_first_right(sbjs.indx,:);
        %% Conf
        conf_left         = conf_first_left(sbjs.indx,:);
        conf_right        = conf_first_right(sbjs.indx,:);
end

%% left vs right
prefs_left  = [pref_left(:,2);    pref_left(:,3);  pref_left(:,4);  pref_left(:,5);  pref_left(:,6)];
prefs_right = [pref_right(:,2);   pref_right(:,3); pref_right(:,4); pref_right(:,5); pref_right(:,6)];
confs_left  = [conf_left(:,2);    conf_left(:,3);  conf_left(:,4);  conf_left(:,5);  conf_left(:,6)];
confs_right = [conf_right(:,2);   conf_right(:,3); conf_right(:,4); conf_right(:,5); conf_right(:,6)];

[h,p,ci,stats] = ttest2(prefs_left, prefs_right); 
disp(p); disp([stats.tstat,stats.df]);

[h,p,ci,stats] = ttest2(confs_left, confs_right); 
disp(p); disp([stats.tstat,stats.df]);



