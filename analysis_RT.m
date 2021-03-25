function analysis_RT(addr,sbjs_prtl,sbjs_cmplt)
%%
Nsub_prtl  = size(sbjs_prtl,2);
Nsub_cmplt = size(sbjs_cmplt,2);

%% load Data
ftype = 'Partial';
load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Transfer.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Estimation.mat']);

%--------------------------------------------------------------------------

ftype  = 'Partial';
RT_cntxt_prtl  = [];
RT_prtl        = zeros(300/2,2,Nsub_prtl);

indx  = 0;
for sub = sbjs_prtl   
    load(['Data', filesep, 'S',int2str(sub), '_Learn_', ftype, '.mat']);      

    RT_cntxt_prtl{sub} = data_Learning(:,[4,15]);

    indx   = indx + 1;
    dump1  = RT_cntxt_prtl{sub}(find(RT_cntxt_prtl{sub}(:,1)==1),2);    
    dump2  = RT_cntxt_prtl{sub}(find(RT_cntxt_prtl{sub}(:,1)==2),2);
    
    RT_prtl(1:size(dump1,1),1,indx) = dump1;
    RT_prtl(1:size(dump2,1),2,indx) = dump2;
end


%%
ftype = 'Complete';
load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Transfer.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Estimation.mat']);

%--------------------------------------------------------------------------

ftype  = 'Complete';
RT_cntxt_cmplt = [];
RT_cmplt       = zeros(300/2,2,Nsub_cmplt);

indx  = 0;
for sub = sbjs_cmplt   
    load(['Data', filesep, 'S',int2str(sub), '_Learn_', ftype, '.mat']);      

    RT_cntxt_cmplt{sub}       = data_Learning(:,[4,15]);     

    indx = indx + 1;
    dump1  = RT_cntxt_cmplt{sub}(find(RT_cntxt_cmplt{sub}(:,1)==1),2);    
    dump2  = RT_cntxt_cmplt{sub}(find(RT_cntxt_cmplt{sub}(:,1)==2),2);
    
    RT_cmplt(1:size(dump1,1),1,indx) = dump1;
    RT_cmplt(1:size(dump2,1),2,indx) = dump2;
end
%%
RT_prtl( RT_prtl == 0)  = NaN;
RT_cmplt(RT_cmplt == 0) = NaN;
%% between partial and complete
RT_prtl_mean  = nanmean(nanmean(RT_prtl,1) ,2);
RT_cmplt_mean = nanmean(nanmean(RT_cmplt,1),2);

[h,p,stats] = ttest2(RT_prtl_mean,RT_cmplt_mean); 
disp('RT: Partial vs Complete');
disp(p);

%% between context 1 and 2 in partial
Dump = nanmean(RT_prtl,1);
X = Dump(1,1,:);
Y = Dump(1,2,:);
[h,p,stats] = ttest2(X,Y); 
disp('RT: Contex1 vs Context2 in Partial');
disp(p);

%% between context 1 and 2 in complete
Dump = nanmean(RT_cmplt,1);
X = Dump(1,1,:);
Y = Dump(1,2,:);
[h,p,stats] = ttest2(X,Y); 
disp('RT: Contex1 vs Context2 in Complete');
disp(p);


%% Draw
f  = figure;
x  = 1:1:150;

subplot(1,2,1);
% y          = zeros(Nsub_prtl,150);
dummy      = []; 
y          = [];
dummy(:,:) = RT_prtl(:,1,:);
y          = dummy';
shadedErrorBar(x,y,{@mean,@std}, 'lineprops', '-r');

hold on

dummy(:,:) = RT_prtl(:,2,:);
y          = dummy';
shadedErrorBar(x,y,{@mean,@std}, 'lineprops', '-b');

xlabel('Trials');
ylabel('Reaction Time');
grid on
title('Partial');

%%
subplot(1,2,2)
dummy      = []; 
y          = [];
dummy(:,:) = RT_cmplt(:,1,:);
y          = dummy';
shadedErrorBar(x,y,{@mean,@std}, 'lineprops', '-r');

hold on

dummy(:,:) = RT_cmplt(:,2,:);
y          = dummy';
shadedErrorBar(x,y,{@mean,@std}, 'lineprops', '-b');

xlabel('Trials');
ylabel('Reaction Time');
grid on
title('Complete');
