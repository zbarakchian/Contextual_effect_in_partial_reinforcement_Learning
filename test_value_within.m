function test_value_within(addr,config,ftype,sbjs)
%-load data
%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Transfer.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Estimation.mat']);

FC          = info_learning.statistics.normal.FC;
FCCF        = info_learning.statistics.normal.FCCF;
Values      = info_estimation.valuation.estimate;
vtype       = config.vtype;


%% ttest BETWEEN ESTIMATED

%-Paired t-test 
PH_pttest = [];
%A1,A2
a(1,:) = Values(1,vtype,sbjs.indx);
b(1,:) = Values(2,vtype,sbjs.indx);
[h,p,ci,stats] = ttest(a,b);
PH_pttest = [PH_pttest; [12, p stats(1).tstat stats(1).df]];

%A1,B
a(1,:) = Values(1,vtype,sbjs.indx);
b(1,:) = Values(3,vtype,sbjs.indx);
[h,p,ci,stats] = ttest(a,b);
PH_pttest = [PH_pttest; [13, p stats(1).tstat stats(1).df]];

%A1,C
a(1,:) = Values(1,vtype,sbjs.indx);
b(1,:) = Values(4,vtype,sbjs.indx);
[h,p,ci,stats] = ttest(a,b);
PH_pttest = [PH_pttest; [14, p stats(1).tstat stats(1).df]];

%A2,B
a(1,:) = Values(2,vtype,sbjs.indx);
b(1,:) = Values(3,vtype,sbjs.indx);
[h,p,ci,stats] = ttest(a,b);
PH_pttest = [PH_pttest; [23, p stats(1).tstat stats(1).df]];

%A2,C
a(1,:) = Values(2,vtype,sbjs.indx);
b(1,:) = Values(4,vtype,sbjs.indx);
[h,p,ci,stats] = ttest(a,b);
PH_pttest = [PH_pttest; [24, p stats(1).tstat stats(1).df]];

%B,C
a(1,:) = Values(3,vtype,sbjs.indx);
b(1,:) = Values(4,vtype,sbjs.indx);
[h,p,ci,stats] = ttest(a,b);
PH_pttest = [PH_pttest; [34, p stats(1).tstat stats(1).df]];

disp('ttest BETWEEN ESTIMATED (A1A2 A1B A1C A2B A2C BC)');
disp(PH_pttest);

%% ttest BETWEEN ESTIMATED VS EXPERIENCED
%%
PH_pttest1 = [];
PH_pttest2 = [];
for i=1:4
    a(1,:) = Values(i,vtype,sbjs.indx);
    b(1,:) = FC.mean(sbjs.indx,i)';
    c(1,:) = FCCF.mean(sbjs.indx,i)';
    
    [h,p,ci,stats] = ttest(a,b);
    PH_pttest1 = [PH_pttest1; [p stats(1).tstat stats(1).df]];
    [h,p,ci,stats] = ttest(a,c);
    PH_pttest2 = [PH_pttest2; [p stats(1).tstat stats(1).df]];
end
disp('ttest BETWEEN ESTIMATED VS EXPERIENCED (individual stimuli), FC;FCCF');
disp(PH_pttest1);
disp(PH_pttest2);

%%
X                 = [FC.mean(sbjs.indx,1);  FC.mean(sbjs.indx,2);  FC.mean(sbjs.indx,3);  FC.mean(sbjs.indx,4)];
Y                 = [squeeze(Values(1,vtype,sbjs.indx));squeeze(Values(2,vtype,sbjs.indx));squeeze(Values(3,vtype,sbjs.indx));squeeze(Values(4,vtype,sbjs.indx))];
%% ttest
[h,p,ci,stats]    = ttest(X,Y);
disp('ttest BETWEEN ESTIMATED VS EXPERIENCED (total stimuli)');
disp(p);
disp(stats);
%% Correlation between estimated and experienced, totally
%% Correlation
% [r,p] = corrcoef(X,Y);
[rho,p] = corr(X,Y);
disp('Correlation BETWEEN ESTIMATED and experienced (total stimuli)------');
disp([rho,p]);

%% Correlation BETWEEN ESTIMATED and experienced, individually
corrs = [];
for i=1:4
    ES(1,:)  = Values(i,vtype,sbjs.indx);
    EX(1,:)  = FC.mean(sbjs.indx,i); %partial
%     EX(1,:)  = FCCF.mean(sbjs.indx,i); %complete

    [rho,p]  = corr(ES',EX');
    corrs    = [corrs; [i rho,p]];
end
disp('Correlation BETWEEN ESTIMATED and experienced (individual stimuli)------');
disp(corrs);


%% Correlation BETWEEN ESTIMATED 
corrs = [];
for i=1:3
    for j = i+1:4
        a(1,:) = Values(i,vtype,sbjs.indx);
        b(1,:) = Values(j,vtype,sbjs.indx);

        [r,p]  = corrcoef(a,b);
        corrs = [corrs; [i,j,r(1,2),p(1,2)]];
    end
end
% disp('Correlation BETWEEN ESTIMATED------');
% disp(corrs);

