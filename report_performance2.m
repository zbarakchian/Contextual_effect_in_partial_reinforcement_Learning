function report_performance2(addr,config,config_analysis)

switch config_analysis.type
case 'real'
    partial  = load([addr.bhv, filesep, 'data_', 'Partial',  '_Learning.mat']);
    complete = load([addr.bhv, filesep, 'data_', 'Complete', '_Learning.mat']);
    
case 'fake'    
    load([addr.simf filesep  'sim_fitted_level2_Partial']);
    model       = config.models{1};
    
    learning    = level2.(model.name).learning;
    transfer    = level2.(model.name).transfer.greedy;

    %-convert the level2 structure to level1 structure: remove stds
    fields = fieldnames(learning);
    for i = 1:length(fields)
        info_learning.(fields{i}) = learning.(fields{i}).mean;
    end

    fields = fieldnames(transfer);
    for i = 1:length(fields)
        info_transfer.(fields{i}) = transfer.(fields{i}).mean;
    end
    partial.info_learning = info_learning;
    partial.info_transfer = info_transfer;
    %----------------------------------------------------------------------
    load([addr.simf filesep 'sim_fitted_level2_Complete']);
    model       = config.models{2};

    learning    = level2.(model.name).learning;
    transfer    = level2.(model.name).transfer.greedy;

    %-convert the level2 structure to level1 structure: remove stds
    fields = fieldnames(learning);
    for i = 1:length(fields)
        info_learning.(fields{i}) = learning.(fields{i}).mean;
    end

    fields = fieldnames(transfer);
    for i = 1:length(fields)
        info_transfer.(fields{i}) = transfer.(fields{i}).mean;
    end
    complete.info_learning = info_learning;
    complete.info_transfer = info_transfer;
end


sbjs_prtl  = config.subjects{1}.indx;
sbjs_cmplt = config.subjects{2}.indx;

%% TTEST
prf_pr =  partial.info_learning.performance;
prf_cm = complete.info_learning.performance;

%%
[h,p,ci,stats] = ttest(prf_pr(sbjs_prtl),0.5,'tail','right'); 
disp(p);
disp(stats);
[h,p,ci,stats] = ttest(prf_cm(sbjs_cmplt),0.5,'tail','right'); 
disp(p);
disp(stats);

%%
[h,p,ci,stats] = ttest2(prf_cm(sbjs_cmplt),prf_pr(sbjs_prtl),'tail','right'); 
disp(p);
disp(stats);

%%
m = mean(prf_pr(sbjs_prtl));
s = std(prf_pr(sbjs_prtl));
disp('partial: mean, std');
disp([m,s]);

disp('complete: mean, std');
m = mean(prf_cm(sbjs_cmplt));
s = std(prf_cm(sbjs_cmplt));
disp([m,s]);








%%
% [p,tbl,stats] = anova2();

