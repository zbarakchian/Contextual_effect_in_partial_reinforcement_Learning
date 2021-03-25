function plot_figure_contextual_effect6modelconf(addr,config_main,ftype,sbjs,model,colors,transfer_greedy)
nsub = length(sbjs.indx);


%% real

%-load data
%--------------------------------------------------------------------------
load([addr.bhv  filesep  'data_'  ftype '_Transfer.mat']);
real = info_transfer;

clearvars info_transfer

%-set up variables
%--------------------------------------------------------------------------
switch config_main.ttype
    case 'rate'
        %-Rate
        real.pref_left         = real.pref.rate_left(sbjs.indx,:);
        real.pref_right        = real.pref.rate_right(sbjs.indx,:);
        
        real.conf_left         = real.conf.rate_left(sbjs.indx,:);
        real.conf_right        = real.conf.rate_right(sbjs.indx,:);
    case 'binary'
        %-Rate
        real.pref_left         = real.pref.bin_left(sbjs.indx,:);
        real.pref_right        = real.pref.bin_right(sbjs.indx,:);
        
        real.conf_left         = real.conf.rate_left(sbjs.indx,:);
        real.conf_right        = real.conf.rate_right(sbjs.indx,:);
   case 'first'
        %-Rate
        real.pref_left         = real.pref.first_left(sbjs.indx,:);
        real.pref_right        = real.pref.first_right(sbjs.indx,:);

        real.conf_left         = real.conf.first_left(sbjs.indx,:);
        real.conf_right        = real.conf.first_right(sbjs.indx,:);
end


real.pref_left_mean         = nanmean(real.pref_left,1);
real.pref_right_mean        = nanmean(real.pref_right,1);

real.pref_left_std          = nanstd(real.pref_left,1);
real.pref_right_std         = nanstd(real.pref_right,1);
real.pref_left_sem          = nanstd(real.pref_left,1)/sqrt(nsub);
real.pref_right_sem         = nanstd(real.pref_right,1)/sqrt(nsub);


real.conf_left_mean         = nanmean(real.conf_left,1);
real.conf_right_mean        = nanmean(real.conf_right,1);

real.conf_left_std          = nanstd(real.conf_left,1);
real.conf_right_std         = nanstd(real.conf_right,1);
real.conf_left_sem          = nanstd(real.conf_left,1)/sqrt(nsub);
real.conf_right_sem         = nanstd(real.conf_right,1)/sqrt(nsub);


%% fake

%-load data
%--------------------------------------------------------------------------
% load([addr.simf filesep 'sim_fitted_level2_' ftype '_' model.name]);
load([addr.simf filesep 'sim_fitted_level2_' ftype]);

switch transfer_greedy
    case 1
        fake = level2.(model.name).transfer.greedy;
    case 0
        fake = level2.(model.name).transfer.softmax;
end

%-convert the level2 structure to level1 structure: remove stds
fields = fieldnames(fake);
for i = 1:length(fields)
    fake.(fields{i}) = fake.(fields{i}).mean;
end

clearvars level2

%-set up variables
%--------------------------------------------------------------------------
switch config_main.ttype
    case 'rate'
        %-Rate
        fake.pref_left         = fake.pref.rate_left(sbjs.indx,:);
        fake.pref_right        = fake.pref.rate_right(sbjs.indx,:);
        
    case 'binary'
        %-Rate
        fake.pref_left         = fake.pref.bin_left(sbjs.indx,:);
        fake.pref_right        = fake.pref.bin_right(sbjs.indx,:);
        
    case 'first'
        %-Rate
        fake.pref_left         = fake.pref.first_left(sbjs.indx,:);
        fake.pref_right        = fake.pref.first_right(sbjs.indx,:);
end


fake.pref_left_mean         = nanmean(fake.pref_left,1);
fake.pref_right_mean        = nanmean(fake.pref_right,1);

fake.pref_left_std          = nanstd(fake.pref_left,1);
fake.pref_right_std         = nanstd(fake.pref_right,1);
fake.pref_left_sem          = nanstd(fake.pref_left,1)/sqrt(nsub);
fake.pref_right_sem         = nanstd(fake.pref_right,1)/sqrt(nsub);


%% start
%--------------------------------------------------------------------------
uniNames1 = {'A_1','A_2'};
uniNames2 = {'A_1-A_2','A_1-B','A_1-C','A_2-B','A_2-C','B-C'};
uniNames3 = {'A_1','A_2','B','C'};
uniNames4 = {'Correct','Wrong'};

%% sizes

text_size = 18;

%-real data
bar_width          = .35;
bar_lwidth         = 1.5;
error_lwidth       = 2.5;

%-fake data
fake_mark_size          = 11;
fake_error_lwidth       = 2;

%-scatter
scat_size               = 20;
scat_jitter             = 0.125;

modelcolor = [0 0 0];

%% SIX PAIRS
f = figure;  
%--------------------------------------------------------------------------
subplot(2,1,1);
%--------------------------------------------------------------------------
x = [1:6];
y{1}  = [real.pref_left_mean(1), real.pref_right_mean(1)]; %A1A2
y{2}  = [real.pref_left_mean(2), real.pref_right_mean(2)]; %A1B
y{3}  = [real.pref_left_mean(3), real.pref_right_mean(3)]; %A1C
y{4}  = [real.pref_left_mean(4), real.pref_right_mean(4)]; %A2B
y{5}  = [real.pref_left_mean(5), real.pref_right_mean(5)]; %A2C
y{6}  = [real.pref_left_mean(6), real.pref_right_mean(6)]; %BC

d = bar_width/2;
for i = 1:6
    b{2*(i-1)+1} = bar(x(i)-d,y{i}(:,1));
    hold on
    
    b{2*(i-1)+2} = bar(x(i)+d,y{i}(:,2));
    hold on
end

e1 = errorbar(x-d,[real.pref_left_mean(:)],[real.pref_left_sem(:)]);
% e1 = errorbar(x-d,[real.pref_left_mean(:)],[real.pref_left_std(:)]);
hold on
e2 = errorbar(x+d,[real.pref_right_mean(:)],[real.pref_right_sem(:)]);
% e2 = errorbar(x+d,[real.pref_right_mean(:)],[real.pref_right_std(:)]);

for i = [1 3 5]
set(b{i}, ...
    'FaceColor', colors.real.A1.face, ...
    'EdgeColor', colors.real.A1.face, ...
    'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);
end

for i = [2 7 9]
set(b{i}, ...
    'FaceColor', colors.real.A2.face, ...
    'EdgeColor', colors.real.A2.face, ...
    'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);
end

for i = [4 8 11]
set(b{i}, ...
    'FaceColor', colors.real.B.face, ...
    'EdgeColor', colors.real.B.face, ...
    'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);
end

for i = [6 10 12]
set(b{i}, ...
    'FaceColor', colors.real.C.face, ...
    'EdgeColor', colors.real.C.face, ...
    'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);
end


set(e1, ...
    'Color',     colors.error, ...
    'LineStyle', 'none', ...
    'LineWidth', error_lwidth);

set(e2, ...
    'Color',     colors.error, ...
    'LineStyle', 'none', ...
    'LineWidth', error_lwidth);



%-scatter
%--------------------------------------------------------------------------
hold on
d = 0.15;
dataY = [real.pref_left(:,1), real.pref_right(:,1),...
         real.pref_left(:,2), real.pref_right(:,2),...
         real.pref_left(:,3), real.pref_right(:,3),...
         real.pref_left(:,4), real.pref_right(:,4),...
         real.pref_left(:,5), real.pref_right(:,5),...
         real.pref_left(:,6), real.pref_right(:,6),...
    ];

dataX = repmat([1-d,1+d, 2-d,2+d, 3-d,3+d, 4-d,4+d, 5-d,5+d,  6-d,6+d],size(dataY,1),1);
scat  = scatter(dataX(:) ,dataY(:) ,scat_size,'jitter','on','jitterAmount',scat_jitter);%,'filled'



set(scat                                     , ...
  'LineWidth'        , 1                     , ...
  'Marker'           , 'o'                   , ...
  'MarkerEdgeColor'  , colors.scatter        , ...
  'MarkerFaceColor'  , colors.scatter        );



ylim([0 1]);
%--------------------------------------------------------------------------


%-fake as marker
%--------------------------------------------------------------------------
hold on

x = [1:6];
y = [fake.pref_left_mean(1), fake.pref_right_mean(1); ...
     fake.pref_left_mean(2), fake.pref_right_mean(2); ...
     fake.pref_left_mean(3), fake.pref_right_mean(3); ...
     fake.pref_left_mean(4), fake.pref_right_mean(4); ...
     fake.pref_left_mean(5), fake.pref_right_mean(5); ...
     fake.pref_left_mean(6), fake.pref_right_mean(6)];
     
% s = [fake.pref_left_std(1),  fake.pref_right_std(1); ... 
%      fake.pref_left_std(2),  fake.pref_right_std(2); ... 
%      fake.pref_left_std(3),  fake.pref_right_std(3); ... 
%      fake.pref_left_std(4),  fake.pref_right_std(4); ... 
%      fake.pref_left_std(5),  fake.pref_right_std(5); ... 
%      fake.pref_left_std(6),  fake.pref_right_std(6)];

s = [fake.pref_left_sem(1),  fake.pref_right_sem(1); ... 
     fake.pref_left_sem(2),  fake.pref_right_sem(2); ... 
     fake.pref_left_sem(3),  fake.pref_right_sem(3); ... 
     fake.pref_left_sem(4),  fake.pref_right_sem(4); ... 
     fake.pref_left_sem(5),  fake.pref_right_sem(5); ... 
     fake.pref_left_sem(6),  fake.pref_right_sem(6)];

  
for i = 1:6 
    p{i} = plot([x(i)-d,x(i)+d],y(i,:));
    hold on
    e{i} = errorbar([x(i)-d,x(i)+d],y(i,:),s(i,:));
    hold on
end

for i = 1:6
set(p{i}, ...
    'LineStyle',     'none', ...
    'Marker',        'o', ...
    'MarkerSize',     fake_mark_size,...
    'MarkerEdgeColor',modelcolor,...
    'MarkerFaceColor',modelcolor);
    
set(e{i}, ...
    'Color',    colors.error,...
    'LineStyle','none',...
    'LineWidth',fake_error_lwidth);

end

ylim([0 1]);
ylabel('rate');

xticks([1:1:6]);
xticklabels([]);
xticklabels(uniNames2);


%dump
% d1 = plot([1 2],[0 0],'Color',colors.real.A1.face,'LineStyle','-','LineWidth',2.5);
% d2 = plot([1 2],[0 0],'Color',colors.real.A2.face,'LineStyle','-','LineWidth',2.5);
% d3 = plot([1 2],[0 0],'Color',colors.real.B.face, 'LineStyle','-','LineWidth',2.5);
% d4 = plot([1 2],[0 0],'Color',colors.real.C.face, 'LineStyle','-','LineWidth',2.5);


% hLegend = legend( ...
%   [d1,d2,d3,d4], ...
%   ['A_1'] , ...
%   ['A_2'] , ...
%   ['B']  , ...
%   ['C']  , ...
%   'location', 'Northoutside','NumColumns',4);
%   'location', 'NorthWest' );
% legend boxoff;

set(gca,'FontName','Times New Roman','FontSize',text_size);%'Helvetica' );

%--------------------------------------------------------------------------
subplot(2,1,2);
%--------------------------------------------------------------------------
x = [1:6];
yconf{1}  = [real.conf_left_mean(1), real.conf_right_mean(1)]; %A1A2
yconf{2}  = [real.conf_left_mean(2), real.conf_right_mean(2)]; %A1B
yconf{3}  = [real.conf_left_mean(3), real.conf_right_mean(3)]; %A1C
yconf{4}  = [real.conf_left_mean(4), real.conf_right_mean(4)]; %A2B
yconf{5}  = [real.conf_left_mean(5), real.conf_right_mean(5)]; %A2C
yconf{6}  = [real.conf_left_mean(6), real.conf_right_mean(6)]; %BC

d = bar_width/2;
for i = 1:6
    b{2*(i-1)+1} = bar(x(i)-d,yconf{i}(:,1));
    hold on
    
    b{2*(i-1)+2} = bar(x(i)+d,yconf{i}(:,2));
    hold on
end

e1 = errorbar(x-d,[real.conf_left_mean(:)],[real.conf_left_sem(:)]);
% e1 = errorbar(x-d,[real.conf_left_mean(:)],[real.conf_left_std(:)]);
hold on
e2 = errorbar(x+d,[real.conf_right_mean(:)],[real.conf_right_sem(:)]);
% e2 = errorbar(x+d,[real.conf_right_mean(:)],[real.conf_right_std(:)]);

for i = [1 3 5]
set(b{i}, ...
    'FaceColor', colors.real.A1.face, ...
    'EdgeColor', colors.real.A1.face, ...
    'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);
end

for i = [2 7 9]
set(b{i}, ...
    'FaceColor', colors.real.A2.face, ...
    'EdgeColor', colors.real.A2.face, ...
    'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);
end

for i = [4 8 11]
set(b{i}, ...
    'FaceColor', colors.real.B.face, ...
    'EdgeColor', colors.real.B.face, ...
    'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);
end

for i = [6 10 12]
set(b{i}, ...
    'FaceColor', colors.real.C.face, ...
    'EdgeColor', colors.real.C.face, ...
    'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);
end


set(e1, ...
    'Color',     colors.error, ...
    'LineStyle', 'none', ...
    'LineWidth', error_lwidth);

set(e2, ...
    'Color',     colors.error, ...
    'LineStyle', 'none', ...
    'LineWidth', error_lwidth);


ylim([0 1]);
ylabel('confidence');

xticks([1:1:6]);
xticklabels(uniNames2);


%dump
d1 = plot([1 2],[0 0],'Color',colors.real.A1.face,'LineStyle','-','LineWidth',2.5);
d2 = plot([1 2],[0 0],'Color',colors.real.A2.face,'LineStyle','-','LineWidth',2.5);
d3 = plot([1 2],[0 0],'Color',colors.real.B.face, 'LineStyle','-','LineWidth',2.5);
d4 = plot([1 2],[0 0],'Color',colors.real.C.face, 'LineStyle','-','LineWidth',2.5);

hLegend = legend( ...
  [d1,d2,d3,d4], ...
  ['A_1'] , ...
  ['A_2'] , ...
  ['B']  , ...
  ['C']  , ...
  'location', 'Southoutside','NumColumns',4);

legend boxoff;

set(gca,'FontName','Times New Roman','FontSize',text_size);%'Helvetica' );



%% Overal Pairs

f = figure;  
%--------------------------------------------------------------------------
subplot(2,1,1);
%--------------------------------------------------------------------------
x = [1:4];

A1_mean = nanmean([real.pref_left_mean(1),  real.pref_left_mean(2),  real.pref_left_mean(3)]);
A2_mean = nanmean([real.pref_right_mean(1), real.pref_left_mean(4),  real.pref_left_mean(5)]);
B_mean  = nanmean([real.pref_right_mean(2), real.pref_right_mean(4), real.pref_left_mean(6)]);
C_mean  = nanmean([real.pref_right_mean(3), real.pref_right_mean(5), real.pref_right_mean(6)]);

%mean(vars) + var(means)
A1_var = nanmean([real.pref_left_std(1)^2  , real.pref_left_std(2)^2  , real.pref_left_std(3)^2]) ...
        + nanvar([real.pref_left_mean(1)   , real.pref_left_mean(2)   , real.pref_left_mean(3)] );
A2_var = nanmean([real.pref_right_std(1)^2 , real.pref_left_std(4)^2  , real.pref_left_std(5)^2]) ...
        + nanvar([real.pref_right_mean(1)  , real.pref_left_mean(4)   , real.pref_left_mean(5)] );
B_var  = nanmean([real.pref_right_std(2)^2 , real.pref_right_std(4)^2 , real.pref_left_std(6)^2]) ...
        + nanvar([real.pref_right_mean(2)  , real.pref_right_mean(4)  , real.pref_left_mean(6)] );
C_var  = nanmean([real.pref_right_std(3)^2 , real.pref_right_std(5)^2 , real.pref_right_std(6)^2]) ...
        + nanvar([real.pref_right_mean(3)  , real.pref_right_mean(5)  , real.pref_right_mean(6)] );
    
    
A1_sem = sqrt(A1_var)/sqrt(nsub); 
A2_sem = sqrt(A2_var)/sqrt(nsub); 
B_sem  = sqrt(B_var) /sqrt(nsub); 
C_sem  = sqrt(C_var) /sqrt(nsub); 

y = [A1_mean, A2_mean,B_mean,C_mean];

d = bar_width/2;
for i = 1:4
    b{i} = bar(x(i),y(i));
    hold on
end


hold on
e = errorbar(x, y, [A1_sem, A2_sem, B_sem, C_sem]);%, 'Color',[0 0 0],'LineStyle','none','LineWidth',2);

 
set(b{1}, ...
    'FaceColor', colors.real.A1.face, ...
    'EdgeColor', colors.real.A1.face, ...%'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);


set(b{2}, ...
    'FaceColor', colors.real.A2.face, ...
    'EdgeColor', colors.real.A2.face, ...%'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);

set(b{3}, ...
    'FaceColor', colors.real.B.face, ...
    'EdgeColor', colors.real.B.face, ...%'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);

set(b{4}, ...
    'FaceColor', colors.real.C.face, ...
    'EdgeColor', colors.real.C.face, ...%'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);


set(e, ...
    'Color',     colors.error, ...
    'LineStyle', 'none', ...
    'LineWidth', error_lwidth);


ylim([0 1]);
ylabel('rate');

xticks([1:1:4]);
xticklabels([]);
xticklabels(uniNames3);

set(gca,'FontName','Times New Roman', 'FontSize', 16);%'Helvetica' );




%-fake as marker
%--------------------------------------------------------------------------
hold on

x = [1:4];
% y = [fake.pref_left_mean(1), fake.pref_right_mean(1); ...
%      fake.pref_left_mean(2), fake.pref_right_mean(2); ...
%      fake.pref_left_mean(3), fake.pref_right_mean(3); ...
%      fake.pref_left_mean(4), fake.pref_right_mean(4); ...
%      fake.pref_left_mean(5), fake.pref_right_mean(5); ...
%      fake.pref_left_mean(6), fake.pref_right_mean(6)];
   
y = []; 
y = [mean([fake.pref_left_mean(1),   fake.pref_left_mean(2),  fake.pref_left_mean(3)]), ...
     mean([fake.pref_right_mean(1),  fake.pref_left_mean(4),  fake.pref_left_mean(5)]),...
     mean([fake.pref_right_mean(2),  fake.pref_right_mean(4), fake.pref_left_mean(6)]),...
     mean([fake.pref_right_mean(3),  fake.pref_right_mean(5), fake.pref_right_mean(:,6)])];
 

s = [sqrt(fake.pref_left_sem(1) ^2 +  fake.pref_left_sem(2) ^2 +  fake.pref_left_sem(3) ^2), ...
     sqrt(fake.pref_right_sem(1)^2 +  fake.pref_left_sem(4) ^2 +  fake.pref_left_sem(5) ^2),...
     sqrt(fake.pref_right_sem(2)^2 +  fake.pref_right_sem(4)^2 +  fake.pref_left_sem(6) ^2),...
     sqrt(fake.pref_right_sem(3)^2 +  fake.pref_right_sem(5)^2 +  fake.pref_right_sem(6)^2)];
 

  
p = plot(x,y);
hold on
e = errorbar(x,y,s);
hold on


set(p, ...
    'LineStyle',     'none', ...
    'Marker',        'o', ...
    'MarkerSize',     fake_mark_size,...
    'MarkerEdgeColor',modelcolor,...
    'MarkerFaceColor',modelcolor);

set(e, ...
    'Color',    colors.error,...
    'LineStyle','none',...
    'LineWidth',fake_error_lwidth);


ylim([0 1]);
ylabel('rate');

xticks([1:1:4]);
xticklabels([]);
xticklabels(uniNames3);


%dump
% d1 = plot([1 2],[0 0],'Color',colors.real.A1.face,'LineStyle','-','LineWidth',2.5);
% d2 = plot([1 2],[0 0],'Color',colors.real.A2.face,'LineStyle','-','LineWidth',2.5);
% d3 = plot([1 2],[0 0],'Color',colors.real.B.face, 'LineStyle','-','LineWidth',2.5);
% d4 = plot([1 2],[0 0],'Color',colors.real.C.face, 'LineStyle','-','LineWidth',2.5);


% hLegend = legend( ...
%   [d1,d2,d3,d4], ...
%   ['A_1'] , ...
%   ['A_2'] , ...
%   ['B']  , ...
%   ['C']  , ...
%   'location', 'Northoutside','NumColumns',4);
%   'location', 'NorthWest' );
% legend boxoff;

set(gca,'FontName','Times New Roman','FontSize',text_size);%'Helvetica' );




%-scatter
%--------------------------------------------------------------------------
hold on
d = 0.15;
    
dataY = [];    
dataY(:,1) = [real.pref_left(:,1);  real.pref_left(:,2);  real.pref_left(:,3)];
dataY(:,2) = [real.pref_right(:,1); real.pref_left(:,4);  real.pref_left(:,5)];
dataY(:,3) = [real.pref_right(:,2); real.pref_right(:,4); real.pref_left(:,6)];
dataY(:,4) = [real.pref_right(:,3); real.pref_right(:,5); real.pref_right(:,6)];
    
dataX = [];
dataX = repmat(1:4,size(dataY,1),1);
scat  = scatter(dataX(:) ,dataY(:) ,scat_size,'jitter','on','jitterAmount',scat_jitter);%,'filled'



set(scat                                     , ...
  'LineWidth'        , 1                     , ...
  'Marker'           , 'o'                   , ...
  'MarkerEdgeColor'  , colors.scatter        , ...
  'MarkerFaceColor'  , colors.scatter        );
ylim([0 1]);


%--------------------------------------------------------------------------
subplot(2,1,2);
%--------------------------------------------------------------------------
x = [1:4];

A1_mean = nanmean([real.conf_left_mean(1)  , real.conf_left_mean(2)  , real.conf_left_mean(3)]);
A2_mean = nanmean([real.conf_right_mean(1) , real.conf_left_mean(4)  , real.conf_left_mean(5)]);
B_mean  = nanmean([real.conf_right_mean(2) , real.conf_right_mean(4) , real.conf_left_mean(6)]);
C_mean  = nanmean([real.conf_right_mean(3) , real.conf_right_mean(5) , real.conf_right_mean(6)]);

%mean(vars) + var(means)
A1_var = nanmean([real.conf_left_std(1)^2  , real.conf_left_std(2)^2  , real.conf_left_std(3)^2]) ...
        + nanvar([real.conf_left_mean(1)   , real.conf_left_mean(2)   , real.conf_left_mean(3)] );
A2_var = nanmean([real.conf_right_std(1)^2 , real.conf_left_std(4)^2  , real.conf_left_std(5)^2]) ...
        + nanvar([real.conf_right_mean(1)  , real.conf_left_mean(4)   , real.conf_left_mean(5)] );
B_var  = nanmean([real.conf_right_std(2)^2 , real.conf_right_std(4)^2 , real.conf_left_std(6)^2]) ...
        + nanvar([real.conf_right_mean(2)  , real.conf_right_mean(4)  , real.conf_left_mean(6)] );
C_var  = nanmean([real.conf_right_std(3)^2 , real.conf_right_std(5)^2 , real.conf_right_std(6)^2]) ...
        + nanvar([real.conf_right_mean(3)  , real.conf_right_mean(5)  , real.conf_right_mean(6)] );
    
    
A1_sem = sqrt(A1_var)/sqrt(nsub); 
A2_sem = sqrt(A2_var)/sqrt(nsub); 
B_sem  = sqrt(B_var) /sqrt(nsub); 
C_sem  = sqrt(C_var) /sqrt(nsub);

y = [A1_mean, A2_mean, B_mean, C_mean];

for i = 1:4
    b{i} = bar(x(i),y(i));
    hold on
end
% 
e = errorbar(x,y,[A1_sem, A2_sem, B_sem, C_sem]);
hold on

set(b{1}, ...
    'FaceColor', colors.real.A1.face, ...
    'EdgeColor', colors.real.A1.face, ... %'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);

set(b{2}, ...
    'FaceColor', colors.real.A2.face, ...
    'EdgeColor', colors.real.A2.face, ...%'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);

set(b{3}, ...
    'FaceColor', colors.real.B.face, ...
    'EdgeColor', colors.real.B.face, ...%'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);

set(b{4}, ...
    'FaceColor', colors.real.C.face, ...
    'EdgeColor', colors.real.C.face, ...%'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);


set(e, ...
    'Color',     colors.error, ...
    'LineStyle', 'none', ...
    'LineWidth', error_lwidth);

ylim([0 1]);


ylim([0 1]);
ylabel('confidence');

xticks([1:1:4]);
xticklabels(uniNames3);

set(gca,'FontName','Times New Roman', 'FontSize', 16);%'Helvetica' );





