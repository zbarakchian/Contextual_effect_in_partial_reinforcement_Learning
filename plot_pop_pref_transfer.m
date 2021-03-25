function plot_pop_pref_transfer(addr,config_main,ftype,sbjs,name)
%-load data
%--------------------------------------------------------------------------
load([addr.bhv  filesep  'data_'  ftype '_Transfer.mat']);

pref_rate_left   = info_transfer.pref.rate_left;
pref_rate_right  = info_transfer.pref.rate_right;

pref_bin_left    = info_transfer.pref.bin_left;
pref_bin_right   = info_transfer.pref.bin_right;

pref_first_left  = info_transfer.pref.first_left;
pref_first_right = info_transfer.pref.first_right;

conf_mean_left   = info_transfer.conf.mean_left;
conf_mean_right  = info_transfer.conf.mean_right;

conf_first_left  = info_transfer.conf.first_left;
conf_first_right = info_transfer.conf.first_right;

nsub = length(sbjs.indx);
%--------------------------------------------------------------------------
switch config_main.ttype
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

pref_left_mean         = nanmean(pref_left,1);
pref_right_mean        = nanmean(pref_right,1);

pref_left_std          = nanstd(pref_left,1);
pref_right_std         = nanstd(pref_right,1);
pref_left_sem          = nanstd(pref_left,1)/sqrt(nsub);
pref_right_sem         = nanstd(pref_right,1)/sqrt(nsub);

conf_left_mean         = nanmean(conf_left,1);
conf_right_mean        = nanmean(conf_right,1);

conf_left_std          = nanstd(conf_left,1);
conf_right_std         = nanstd(conf_right,1);
conf_left_sem          = nanstd(conf_left,1)/sqrt(nsub);
conf_right_sem         = nanstd(conf_right,1)/sqrt(nsub);

%--------------------------------------------------------------------------
uniNames1 = {'A1','A2'};
uniNames2 = {'A1-A2','A1-B','A1-C','A2-B','A2-C','B-C'};
uniNames3 = {'A1','A2','B','C'};
uniNames4 = {'Correct','Wrong'};

%% A1A2 pair
f = figure;  
%--------------------------------------------------------------------------
subplot(1,2,1);
y = [pref_left_mean(1), pref_right_mean(1)];

h = bar(1,y(1));
set(h, 'FaceColor', [0 0 0.5]);
set(h, 'LineWidth',1.5);
hold on
h = bar(2,y(2));
set(h, 'FaceColor', [0.5 0 0]); 
set(h, 'LineWidth',1.5);

x = [1];
errorbar(x,  [pref_left_mean(1)], [pref_left_sem(1)], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);
errorbar(x+1,[pref_right_mean(1)],[pref_right_sem(1)],'Color',[0 0 0],'LineStyle','none','LineWidth',2);

% grid;
xlim([0 3]);
ylim([0 1]);
ylabel('rating freq');

set(gca, 'XTickLabel', '')
xlabetxt = uniNames1([1 2]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1 2],repmat(ypos,2,1), ...
     xlabetxt','horizontalalignment','right','FontSize',10);

%--------------------------------------------------------------------------
subplot(1,2,2);
y = [conf_left_mean(1), conf_right_mean(1)];

h = bar(1,y(1));
set(h, 'FaceColor', 'c');
set(h, 'LineWidth',1.5);
hold on
h = bar(2,y(2));
set(h, 'FaceColor', 'r'); 
set(h, 'LineWidth',1.5);

% grid;
xlim([0 3]);
ylim([0 1]);
ylabel('conf freq');

hold on
x = [1];
errorbar(x,  [conf_left_mean(1)], [conf_left_sem(1)], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);
errorbar(x+1,[conf_right_mean(1)],[conf_right_sem(1)],'Color',[0 0 0],'LineStyle','none','LineWidth',2);
%----------------
% X = ;
% Y = ;
% plot(X,Y, 'o','MarkerSize',15,'MarkerFaceColor','r','Color','r');
%----------------
set(gca, 'XTickLabel', '')
xlabetxt = uniNames1([1 2]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1 2],repmat(ypos,2,1), ...
     xlabetxt','horizontalalignment','right','FontSize',10);
%----------------
tit = strcat(ftype,'-',config_main.ttype);
supertitle(tit);
%--------------------------------------------------------------------------
nameRate = strcat('Figures', filesep, 'pop_transfer1_',ftype,'_',name,'.png');
saveas(gcf,nameRate);
close(f);

%% SIX PAIRS
f = figure;  
pairs = [1:6];
%-------------------
subplot(2,1,1);

x = [1:6];
y = [pref_left_mean(1), pref_right_mean(1);...
     pref_left_mean(2), pref_right_mean(2);...
     pref_left_mean(3), pref_right_mean(3);...
     pref_left_mean(4), pref_right_mean(4);...
     pref_left_mean(5), pref_right_mean(5);...
     pref_left_mean(6), pref_right_mean(6)];

b = bar(x,y,1,'LineWidth',1.5);
b(1).FaceColor = [0   0 0.5];
b(2).FaceColor = [0.5 0 0  ]; 
hold on
errorbar(x-.15,[pref_left_mean(:)],[pref_left_sem(:)],'Color',[0 0 0],'LineStyle','none','LineWidth',2);
hold on
errorbar(x+.15,[pref_right_mean(:)],[pref_right_sem(:)],'Color',[0 0 0],'LineStyle','none','LineWidth',2);

ylim([0 1]);
ylabel('rating freq');

set(gca, 'XTickLabel', '')
xlabetxt = uniNames2(pairs);
ypos     = -0.1;
text(pairs+0.2,repmat(ypos,6,1), xlabetxt','horizontalalignment','right','FontSize',10);
% grid on;
%-------------------
subplot(2,1,2);

x = [1:6];
y = [conf_left_mean(1), conf_right_mean(1);...
     conf_left_mean(2), conf_right_mean(2);...
     conf_left_mean(3), conf_right_mean(3);...
     conf_left_mean(4), conf_right_mean(4);...
     conf_left_mean(5), conf_right_mean(5);...
     conf_left_mean(6), conf_right_mean(6)];

b = bar(x,y,1,'LineWidth',1.5);
b(1).FaceColor = 'c';
b(2).FaceColor = 'r';  

hold on
errorbar(x-.15,[conf_left_mean(:)],[conf_left_sem(:)],'Color',[0 0 0],'LineStyle','none','LineWidth',2);
hold on
errorbar(x+.15,[conf_right_mean(:)],[conf_right_sem(:)],'Color',[0 0 0],'LineStyle','none','LineWidth',2);

ylim([0 1]);
ylabel('conf freq');    

set(gca, 'XTickLabel', '')
xlabetxt = uniNames2(pairs);
ypos     = -.1;
text(pairs+0.2,repmat(ypos,6,1), xlabetxt','horizontalalignment','right','FontSize',10);
% grid on;
%----------------
tit = strcat(ftype,'-',config_main.ttype);
supertitle(tit);
%--------------------------------------------------------------------------
nameRate = strcat('Figures', filesep, 'pop_transfer2_',ftype,'_',name,'.png');
saveas(gcf,nameRate);
close(f);


%% Total rates
f = figure;  
%--------------------------------------------------------------------------
subplot(1,2,1);
A1_mean = nanmean([pref_left_mean(1)  , pref_left_mean(2)  , pref_left_mean(3)]);
A2_mean = nanmean([pref_right_mean(1) , pref_left_mean(4)  , pref_left_mean(5)]);
B_mean  = nanmean([pref_right_mean(2) , pref_right_mean(4) , pref_left_mean(6)]);
C_mean  = nanmean([pref_right_mean(3) , pref_right_mean(5) , pref_right_mean(6)]);

%mean(vars) + var(means)
A1_var = nanmean([pref_left_std(1)^2  , pref_left_std(2)^2  , pref_left_std(3)^2]) ...
        + nanvar([pref_left_mean(1)   , pref_left_mean(2)   , pref_left_mean(3)] );
A2_var = nanmean([pref_right_std(1)^2 , pref_left_std(4)^2  , pref_left_std(5)^2]) ...
        + nanvar([pref_right_mean(1)  , pref_left_mean(4)   , pref_left_mean(5)] );
B_var  = nanmean([pref_right_std(2)^2 , pref_right_std(4)^2 , pref_left_std(6)^2]) ...
        + nanvar([pref_right_mean(2)  , pref_right_mean(4)  , pref_left_mean(6)] );
C_var  = nanmean([pref_right_std(3)^2 , pref_right_std(5)^2 , pref_right_std(6)^2]) ...
        + nanvar([pref_right_mean(3)  , pref_right_mean(5)  , pref_right_mean(6)] );
    
    
A1_sem = sqrt(A1_var)/sqrt(nsub); 
A2_sem = sqrt(A2_var)/sqrt(nsub); 
B_sem  = sqrt(B_var) /sqrt(nsub); 
C_sem  = sqrt(C_var) /sqrt(nsub); 

y = [A1_mean, A2_mean,B_mean,C_mean];
b = bar(y);
set(b, 'FaceColor', [0 .5 0]);
set(b, 'LineWidth',1.5);


hold on
x = [1:4];
errorbar(x, y, [A1_sem, A2_sem, B_sem, C_sem], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);

grid;
% xlim([0 3]);
% ylim([0 1]);
% ylabel('rating freq');
title('Choice');

set(gca, 'XTickLabel', '')
xlabetxt = uniNames3([1 2 3 4]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1:4],repmat(ypos,4,1), ...
     xlabetxt','horizontalalignment','right','FontSize',10);

%-------------------
subplot(1,2,2);
A1_mean = nanmean([conf_left_mean(1)  , conf_left_mean(2)  , conf_left_mean(3)]);
A2_mean = nanmean([conf_right_mean(1) , conf_left_mean(4)  , conf_left_mean(5)]);
B_mean  = nanmean([conf_right_mean(2) , conf_right_mean(4) , conf_left_mean(6)]);
C_mean  = nanmean([conf_right_mean(3) , conf_right_mean(5) , conf_right_mean(6)]);

%mean(vars) + var(means)
A1_var = nanmean([conf_left_std(1)^2  , conf_left_std(2)^2  , conf_left_std(3)^2]) ...
        + nanvar([conf_left_mean(1)   , conf_left_mean(2)   , conf_left_mean(3)] );
A2_var = nanmean([conf_right_std(1)^2 , conf_left_std(4)^2  , conf_left_std(5)^2]) ...
        + nanvar([conf_right_mean(1)  , conf_left_mean(4)   , conf_left_mean(5)] );
B_var  = nanmean([conf_right_std(2)^2 , conf_right_std(4)^2 , conf_left_std(6)^2]) ...
        + nanvar([conf_right_mean(2)  , conf_right_mean(4)  , conf_left_mean(6)] );
C_var  = nanmean([conf_right_std(3)^2 , conf_right_std(5)^2 , conf_right_std(6)^2]) ...
        + nanvar([conf_right_mean(3)  , conf_right_mean(5)  , conf_right_mean(6)] );
    
    
A1_sem = sqrt(A1_var)/sqrt(nsub); 
A2_sem = sqrt(A2_var)/sqrt(nsub); 
B_sem  = sqrt(B_var) /sqrt(nsub); 
C_sem  = sqrt(C_var) /sqrt(nsub);

y = [A1_mean, A2_mean, B_mean, C_mean];
b = bar(y);
set(b, 'FaceColor', [0 1 0]);
set(b, 'LineWidth',1.5);

grid;
% xlim([0 3]);
% ylim([0 1]);
% ylabel('conf freq');
title('Confidence');
 
hold on
x = [1:4];
errorbar(x, y, [A1_sem, A2_sem, B_sem, C_sem], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);
%----------------
set(gca, 'XTickLabel', '')
xlabetxt = uniNames3([1:4]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1:4],repmat(ypos,4,1), ...
     xlabetxt','horizontalalignment','right','FontSize',10);
%----------------
tit = strcat(ftype,'-',config_main.ttype);
supertitle(tit);
%--------------------------------------------------------------------------
nameRate = strcat('Figures', filesep, 'pop_transfer3_',ftype,'_',name,'.png');
saveas(gcf,nameRate);
close(f);


%% Left vs Right
f = figure;  
%--------------------------------------------------------------------------
subplot(1,2,1);

% prefs_left  = [pref_left(:,1);  pref_left(:,2);    pref_left(:,3);  pref_left(:,4);  pref_left(:,5);  pref_left(:,6)];
% prefs_right = [pref_right(:,1); pref_right(:,2);   pref_right(:,3); pref_right(:,4); pref_right(:,5); pref_right(:,6)];
prefs_left  = [pref_left(:,2);    pref_left(:,3);  pref_left(:,4);  pref_left(:,5);  pref_left(:,6)];
prefs_right = [pref_right(:,2);   pref_right(:,3); pref_right(:,4); pref_right(:,5); pref_right(:,6)];

leftm    = nanmean(prefs_left);
rightm   = nanmean(prefs_right);
%TODO
leftsem  = nanstd(prefs_left) /sqrt(nsub); 
rightsem = nanstd(prefs_right)/sqrt(nsub); 


x = [1:2];
y = [leftm rightm];
b = bar(x,y);
set(b, 'FaceColor', [0 .5 0]);
set(b, 'LineWidth',1.5);


hold on
errorbar(x,y, [leftsem rightsem], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);

grid;
xlim([0 3]);
% ylim([0 1]);
ylabel('rating');
title('Choice');

set(gca, 'XTickLabel', '')
xlabetxt = uniNames4;
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text(x+.3,repmat(ypos,2,1), ...
     xlabetxt','horizontalalignment','right','FontSize',10);

%--------------------------------------------------------------------------
subplot(1,2,2);

% confs_left  = [conf_left(:,1);  conf_left(:,2);    conf_left(:,3);  conf_left(:,4);  conf_left(:,5);  conf_left(:,6)];
% confs_right = [conf_right(:,1); conf_right(:,2);   conf_right(:,3); conf_right(:,4); conf_right(:,5); conf_right(:,6)];

confs_left  = [conf_left(:,2);    conf_left(:,3);  conf_left(:,4);  conf_left(:,5);  conf_left(:,6)];
confs_right = [conf_right(:,2);   conf_right(:,3); conf_right(:,4); conf_right(:,5); conf_right(:,6)];

leftm    = nanmean(confs_left);
rightm   = nanmean(confs_right);

leftsem  = nanstd(confs_left) /sqrt(nsub); 
rightsem = nanstd(confs_right)/sqrt(nsub); 

x = [1:2];
y = [leftm, rightm];
b = bar(x,y);
set(b, 'FaceColor', [0 1 0]);
set(b, 'LineWidth',1.5);

grid;
xlim([0 3]);
ylim([0 1]);
ylabel('conf');
title('Confidence');
 
hold on
errorbar(x,y, [leftsem rightsem], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);
%----------------
set(gca, 'XTickLabel', '')
xlabetxt = uniNames4;
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1:2]+.3,repmat(ypos,2,1), ...
     xlabetxt','horizontalalignment','right','FontSize',10);
%----------------
tit = strcat(ftype,'-',config_main.ttype);
supertitle(tit);
%--------------------------------------------------------------------------
nameRate = strcat('Figures', filesep, 'pop_transfer4_',ftype,'_',name,'.png');
saveas(gcf,nameRate);
close(f);

