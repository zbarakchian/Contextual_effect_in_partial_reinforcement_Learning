function test_value_between(addr,config_main)
% Between conditions (Partial vs. Complete)

vtype = config_main.vtype;

%-load data
%--------------------------------------------------------------------------
partial  = load([addr.bhv, filesep, 'data_', 'Partial',  '_Estimation.mat']);
complete = load([addr.bhv, filesep, 'data_', 'Complete', '_Estimation.mat']);

values{1}  = partial.info_estimation.valuation.estimate;
values{2}  = complete.info_estimation.valuation.estimate;

partial  = load([addr.bhv, filesep, 'data_', 'Partial',  '_Transfer.mat']);
complete = load([addr.bhv, filesep, 'data_', 'Complete', '_Transfer.mat']);

confs{1}  = partial.info_transfer.conf;
confs{2}  = complete.info_transfer.conf;

%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_behavioral.mat']);
subjects = config_main.subjects;



%-BETWEEN ESTIMATED 
%--------------------------------------------------------------------------

disp('Value std');

partial_A1  = squeeze(values{1}(1,6,subjects{1}.indx));
partial_A2  = squeeze(values{1}(2,6,subjects{1}.indx));
partial_B   = squeeze(values{1}(3,6,subjects{1}.indx));
partial_C   = squeeze(values{1}(4,6,subjects{1}.indx));


complete_A1 = squeeze(values{2}(1,6,subjects{2}.indx));
complete_A2 = squeeze(values{2}(2,6,subjects{2}.indx));
complete_B  = squeeze(values{2}(3,6,subjects{2}.indx));
complete_C  = squeeze(values{2}(4,6,subjects{2}.indx));


[h,pA1,ci,stats] = ttest2(partial_A1,complete_A1); 
[h,pA2,ci,stats] = ttest2(partial_A2,complete_A2); 
[h,pB,ci,stats]  = ttest2(partial_B, complete_B); 
[h,pC,ci,stats]  = ttest2(partial_C, complete_C); 
pValues = [pA1,pA2,pB,pC];
disp(pValues);

partial_all  = [partial_A1; partial_A2; partial_B; partial_C];
complete_all = [complete_A1; complete_A2; complete_B; complete_C];


[h,pall,ci,stats]  = ttest2(partial_all, complete_all); 
pValues = [pall];
disp(pValues);

value.partial_all  = partial_all;
value.complete_all = complete_all;

%%
%ttest2 treats NaN values as missing data and ignores them. 
disp('Confidence mean');

pValues  = [];
    
partial_A1 = [  nanmean([squeeze(confs{1}.mean_left (subjects{1}.indx,1)), ...
                         squeeze(confs{1}.mean_left (subjects{1}.indx,2)), ...
                         squeeze(confs{1}.mean_left (subjects{1}.indx,3))],2)];
    
partial_A2 = [  nanmean([squeeze(confs{1}.mean_right(subjects{1}.indx,1)), ...
                         squeeze(confs{1}.mean_left (subjects{1}.indx,4)), ...
                         squeeze(confs{1}.mean_left (subjects{1}.indx,5))],2)];
       
partial_B  = [  nanmean([squeeze(confs{1}.mean_right(subjects{1}.indx,2)), ...
                         squeeze(confs{1}.mean_right(subjects{1}.indx,4)), ...
                         squeeze(confs{1}.mean_left (subjects{1}.indx,6))],2)];

partial_C  = [  nanmean([squeeze(confs{1}.mean_right(subjects{1}.indx,3)), ...
                         squeeze(confs{1}.mean_right(subjects{1}.indx,5)), ...
                         squeeze(confs{1}.mean_right(subjects{1}.indx,6))],2)];            
%------- 

complete_A1 = [ nanmean([squeeze(confs{2}.mean_left (subjects{2}.indx,1)), ...
                         squeeze(confs{2}.mean_left (subjects{2}.indx,2)), ...
                         squeeze(confs{2}.mean_left (subjects{2}.indx,3))],2)];
    
complete_A2 = [ nanmean([squeeze(confs{2}.mean_right(subjects{2}.indx,1)), ...
                         squeeze(confs{2}.mean_left (subjects{2}.indx,4)), ...
                         squeeze(confs{2}.mean_left (subjects{2}.indx,5))],2)];
       
complete_B  = [ nanmean([squeeze(confs{2}.mean_right(subjects{2}.indx,2)), ...
                         squeeze(confs{2}.mean_right(subjects{2}.indx,4)), ...
                         squeeze(confs{2}.mean_left (subjects{2}.indx,6))],2)];

complete_C  = [ nanmean([squeeze(confs{2}.mean_right(subjects{2}.indx,3)), ...
                         squeeze(confs{2}.mean_right(subjects{2}.indx,5)), ...
                         squeeze(confs{2}.mean_right(subjects{2}.indx,6))],2)];
            
            
            
[h,pA1,ci,stats] = ttest2(partial_A1,complete_A1); 
[h,pA2,ci,stats] = ttest2(partial_A2,complete_A2); 
[h,pB, ci,stats] = ttest2(partial_B, complete_B); 
[h,pC, ci,stats] = ttest2(partial_C, complete_C); 

pValues = [pA1,pA2,pB,pC];
disp(pValues);


partial_all  = [partial_A1;  partial_A2;  partial_B;  partial_C];
complete_all = [complete_A1; complete_A2; complete_B; complete_C];

[h,p,ci,stats] = ttest2(partial_all,complete_all); 
[h,p,ci,stats] = ttest2(partial_all,complete_all,'Tail','left'); 
pValues = p;
disp(pValues);


conf.partial_all  = partial_all;
conf.complete_all = complete_all;

%% confidence vs value
disp('Correlation');

[rho1,pval1] = corr(value.partial_all, conf.partial_all,  'Rows','pairwise'); 
[rho2,pval2] = corr(value.complete_all,conf.complete_all, 'Rows','pairwise'); 

disp([rho1, rho2]);
disp([pval1,pval2]);

disp('DONE!');


%% condifence std

disp('Confidence std');

pValues  = [];
    
partial_A1 = [  squeeze(confs{1}.std_left (subjects{1}.indx,1)); ...
                squeeze(confs{1}.std_left (subjects{1}.indx,2));
                squeeze(confs{1}.std_left (subjects{1}.indx,3))];
    
partial_A2 = [  squeeze(confs{1}.std_right(subjects{1}.indx,1)); ...
                squeeze(confs{1}.std_left (subjects{1}.indx,4));
                squeeze(confs{1}.std_left (subjects{1}.indx,5))];
       
partial_B  = [  squeeze(confs{1}.std_right(subjects{1}.indx,2)); ...
                squeeze(confs{1}.std_right(subjects{1}.indx,4));
                squeeze(confs{1}.std_left (subjects{1}.indx,6))];

partial_C  = [  squeeze(confs{1}.std_right(subjects{1}.indx,3)); ...
                squeeze(confs{1}.std_right(subjects{1}.indx,5));
                squeeze(confs{1}.std_right(subjects{1}.indx,6))];            
%------- 

complete_A1 = [ squeeze(confs{2}.std_left (subjects{2}.indx,1)); ...
                squeeze(confs{2}.std_left (subjects{2}.indx,2));
                squeeze(confs{2}.std_left (subjects{2}.indx,3))];
    
complete_A2 = [ squeeze(confs{2}.std_right(subjects{2}.indx,1)); ...
                squeeze(confs{2}.std_left (subjects{2}.indx,4));
                squeeze(confs{2}.std_left (subjects{2}.indx,5))];
       
complete_B  = [ squeeze(confs{2}.std_right(subjects{2}.indx,2)); ...
                squeeze(confs{2}.std_right(subjects{2}.indx,4));
                squeeze(confs{2}.std_left (subjects{2}.indx,6))];

complete_C  = [ squeeze(confs{2}.std_right(subjects{2}.indx,3)); ...
                squeeze(confs{2}.std_right(subjects{2}.indx,5));
                squeeze(confs{2}.std_right(subjects{2}.indx,6))];
            
            
            
[h,pA1,ci,stats] = ttest2(partial_A1,complete_A1); 
[h,pA2,ci,stats] = ttest2(partial_A2,complete_A2); 
[h,pB, ci,stats] = ttest2(partial_B, complete_B); 
[h,pC, ci,stats] = ttest2(partial_C, complete_C); 

pValues = [pA1,pA2,pB,pC];
disp(pValues);


partial_all  = [partial_A1;  partial_A2;  partial_B;  partial_C];
complete_all = [complete_A1; complete_A2; complete_B; partial_C];
[h,p,ci,stats] = ttest2(partial_all,complete_all); 
pValues = p;
disp(pValues);




%%ttest2 treats NaN values as missing data and ignores them. 
pValues  = [];
for cmb = 1:6
    tmp1 = [squeeze(confs{1}.mean_left (subjects{1}.indx,cmb)); ...
             squeeze(confs{1}.mean_right(subjects{1}.indx,cmb))];
         
    tmp2 = [squeeze(confs{2}.mean_left (subjects{2}.indx,cmb));...
             squeeze(confs{2}.mean_right(subjects{2}.indx,cmb))];
       
    [h,p,ci,stats] = ttest2(tmp1,tmp2); 
    pValues = [pValues,p];
end
disp('Confidence mean');
disp(pValues);



pValues  = [];
for cmb = 1:6
    tmp1 = [squeeze(confs{1}.std_left (subjects{1}.indx,cmb)); ...
             squeeze(confs{1}.std_right(subjects{1}.indx,cmb))];
         
    tmp2 = [squeeze(confs{2}.std_left (subjects{2}.indx,cmb)); ...
             squeeze(confs{2}.std_right(subjects{2}.indx,cmb))];
         
    [h,p,ci,stats] = ttest2(tmp1,tmp2); 
    pValues = [pValues,p];
end
disp('Confidence std');
disp(pValues);






