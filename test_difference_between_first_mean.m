function test_difference_between_first_mean(addr,ftype,sbjs)
%-load data
%--------------------------------------------------------------------------
load([addr.bhv filesep, 'data_', ftype, '_Learning.mat']);
load([addr.bhv filesep, 'data_', ftype, '_Transfer.mat']);
load([addr.bhv filesep, 'data_', ftype, '_Estimation.mat']);

pref_rate_left  = info_transfer.pref.rate_left;
pref_rate_right = info_transfer.pref.rate_right;

pref_bin_left    = info_transfer.pref.bin_left;
pref_bin_right   = info_transfer.pref.bin_right;

pref_first_left  = info_transfer.pref.first_left;
pref_first_right = info_transfer.pref.first_right;

Values     = info_estimation.valuation.estimate;

%% Fisrt VS Mean
%% Test
PH_pttest1 = [];
PH_pttest2 = [];
PH_pttest3 = [];
for i=1:6
    [h,p1,ci,stats] = ttest(pref_first_left(sbjs.indx,i) ,pref_bin_left(sbjs.indx,i)); 
    [h,p2,ci,stats] = ttest(pref_first_right(sbjs.indx,i),pref_bin_right(sbjs.indx,i)); 
    PH_pttest1 = [PH_pttest1; p1, p2];

    [h,p1,ci,stats] = ttest(pref_first_left(sbjs.indx,i) ,pref_rate_left(sbjs.indx,i)); 
    [h,p2,ci,stats] = ttest(pref_first_right(sbjs.indx,i),pref_rate_right(sbjs.indx,i)); 
    PH_pttest2 = [PH_pttest2; p1, p2];

    [h,p1,ci,stats] = ttest(pref_bin_left(sbjs.indx,i) ,pref_rate_left(sbjs.indx,i)); 
    [h,p2,ci,stats] = ttest(pref_bin_right(sbjs.indx,i),pref_rate_right(sbjs.indx,i)); 
    PH_pttest3 = [PH_pttest3; p1, p2];
end
disp('A1A2,A1B,A1C,A2B,A2C,BC');
disp('Choice Test - first vs bin');
disp(PH_pttest1);
% disp('Choice Test - first vs rate');
% disp(PH_pttest2);
% disp('Choice Test - bin vs rate');
% disp(PH_pttest3);

%% Value 
PH_pttest = [];
for i=1:4
    a(1,:) = Values(i,1,sbjs.indx);
    b(1,:) = Values(i,5,sbjs.indx);
    
    [h,p,stats] = ttest(a,b);
    PH_pttest = [PH_pttest; p];
end
disp('Value (A1,A2,B,C)');
disp(PH_pttest');
