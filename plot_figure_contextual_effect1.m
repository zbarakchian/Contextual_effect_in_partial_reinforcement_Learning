function plot_figure_contextual_effect1(addr,config_main,ftype,sbjs,model,colors,transfer_greedy)
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
        
    case 'binary'
        %-Rate
        real.pref_left         = real.pref.bin_left(sbjs.indx,:);
        real.pref_right        = real.pref.bin_right(sbjs.indx,:);
        
    case 'first'
        %-Rate
        real.pref_left         = real.pref.first_left(sbjs.indx,:);
        real.pref_right        = real.pref.first_right(sbjs.indx,:);
end


real.pref_left_mean         = nanmean(real.pref_left,1);
real.pref_right_mean        = nanmean(real.pref_right,1);

real.pref_left_std          = nanstd(real.pref_left,1);
real.pref_right_std         = nanstd(real.pref_right,1);
real.pref_left_sem          = nanstd(real.pref_left,1)/sqrt(nsub);
real.pref_right_sem         = nanstd(real.pref_right,1)/sqrt(nsub);


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

%-real data
bar_width               = 0.8;%0.4;
bar_lwidth              = 1.8;
error_lwidth            = 2.5;

%-fake data
fake_mark_size          = 11;
fake_error_lwidth       = 2;    

%-scatter
scat_size               = 60;
scat_jitter             = 0.25;

modelfacecolor = [1 1 1];
modeledgecolor = [0 0 0];

d = bar_width/2;
l = 1;

%% A1A2 pair
%--------------------------------------------------------------------------
f = figure;  

%-real data
%--------------------------------------------------------------------------
xr = [1];
yr = [real.pref_left_mean(1), real.pref_right_mean(1)];

b1 = bar(xr(1)-d,yr(1));
hold on
b2 = bar(xr(1)+d,yr(2));

e1 = errorbar(xr(1)-d, [real.pref_left_mean(1)], [real.pref_left_sem(1)]);
e2 = errorbar(xr(1)+d, [real.pref_right_mean(1)],[real.pref_right_sem(1)]);

set(b1, ...
    'FaceColor', colors.real.A1.face, ...
    'EdgeColor', colors.real.A1.face, ...
    'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);

set(b2, ...
    'FaceColor', colors.real.A2.face, ...
    'EdgeColor', colors.real.A2.face, ...
    'BarWidth',  bar_width, ...
    'LineStyle', '-', ...
    'LineWidth', bar_lwidth);

set(e1, ...
    'Color',     colors.error, ...
    'LineStyle', '-', ...
    'LineWidth', error_lwidth);

set(e2, ...
    'Color',     colors.error, ...
    'LineStyle', '-', ...
    'LineWidth', error_lwidth);

%-scatter
%--------------------------------------------------------------------------
hold on

dataY = [real.pref_left(:,1), real.pref_right(:,1)];
dataX = repmat([1-d,1+d],length(dataY),1);
scat  = scatter(dataX(:) ,dataY(:) ,scat_size,'jitter','on','jitterAmount',scat_jitter);%,'filled'

set(scat                                     , ...
  'LineWidth'        , 1                     , ...
  'Marker'           , 'o'                   , ...
  'MarkerEdgeColor'  , colors.scatter        , ...
  'MarkerFaceColor'  , colors.scatter        );

%-Fake as a bar
%--------------------------------------------------------------------------
% hold on
% 
% xf = [xr];%+0.3;
% yf = [fake.pref_left_mean(1), fake.pref_right_mean(1)];
% 
% b3 = bar(xf(1)-d,yf(1));
% hold on
% b4 = bar(xf(1)+d,yf(2));
% 
% e3 = errorbar(xf(1)-d, [fake.pref_left_mean(1)], [fake.pref_left_sem(1)]);
% e4 = errorbar(xf(1)+d, [fake.pref_right_mean(1)],[fake.pref_right_sem(1)]);
% 
% set(b3, ...
%     'FaceColor', colors.fake.A1.face, ...
%     'EdgeColor', colors.fake.A1.face, ...
%     'BarWidth',  bar_width/l, ...
%     'LineStyle', '--', ...
%     'LineWidth', bar_lwidth + 1);
% 
% set(b4, ...
%     'FaceColor', colors.fake.A2.face, ...
%     'EdgeColor', colors.fake.A2.face, ...
%     'BarWidth',  bar_width/l, ...
%     'LineStyle', '--', ...
%     'LineWidth', bar_lwidth + 1);
% 
% set(e3, ...
%     'Color',     colors.error, ...
%     'LineStyle', '--', ...
%     'LineWidth', error_lwidth);
% 
% set(e4, ...
%     'Color',     colors.error, ...
%     'LineStyle', '--', ...
%     'LineWidth', error_lwidth);
% 
% alpha(0.55);

%-fake as marker
%--------------------------------------------------------------------------
hold on

% x = [1];%+.15;
% y = [fake.pref_left_mean(1), fake.pref_right_mean(1)];
% s = [fake.pref_left_sem(1),  fake.pref_right_sem(1) ];
% 
% p1 = plot(x(1)-d,y(1));
% hold on
% e1 = errorbar(x(1)-d,[y(1)],[s(1)]);
% 
% hold on
% 
% p2 = plot(x(1)+d,y(2));
% hold on
% e2 = errorbar(x(1)+d,[y(2)],[s(2)]);
% 
% 
% set(p1, ...
%     'LineStyle', '--', ...
%     'Marker', 'o', ...
%     'MarkerSize',     fake_mark_size,...
%     'MarkerFaceColor',modelfacecolor,...
%     'MarkerEdgeColor',modeledgecolor);
% 
% set(e1, ...
%     'Color',    colors.error,...
%     'LineStyle','none',...
%     'LineWidth',fake_error_lwidth);
% 
% 
% set(p2, ...
%     'LineStyle', '--', ...
%     'Marker', 'o', ...
%     'MarkerSize',fake_mark_size,...
%     'MarkerFaceColor',modelfacecolor,...
%     'MarkerEdgeColor',modeledgecolor);
% 
% set(e2, ...
%     'Color',colors.error,...
%     'LineStyle','none',...
%     'LineWidth',fake_error_lwidth);

%-continue
%--------------------------------------------------------------------------
% xlim([0 3]);
% ylim([0 1]);

ylabel('choice rate');

%dump
% d1 = plot([1 2],[0 0],'Color',colors.real.A2.face,'LineStyle','-' ,'LineWidth',2.5);
% d2 = plot([1 2],[0 0],'Color',colors.fake.A2.face,'LineStyle','--','LineWidth',2.5);
% 
% hLegend = legend( ...
%   [d1,d2], ...
%   ['data'] , ...
%   ['model'] , ...
%   'location', 'NorthWest' );
% 
% set(hLegend,'FontSize',12);
% legend boxoff;


set(gca, 'XTickLabel', '');

xlabetxt = uniNames1([1 2]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/15;
text([1-d+0.075 1+d+0.075],repmat(ypos,2,1), ...
     xlabetxt','horizontalalignment','right','FontSize',20);

 grid on;

 set(gca, ...
  'Box'         , 'on'     , ...
  'TickDir'     , 'in'     , ...
  'TickLength'  , [.005 .005] , ...
  'XMinorTick'  , 'off'     , ...
  'YMinorTick'  , 'off'     , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'XTick'       , 0:1:3     , ...
  'YTick'       , 0:0.1:1   , ...
  'XGrid'       , 'off'      , ...
  'YGrid'       , 'off'      , ...
  'LineWidth'   , 1         );

set(gca,'FontName','Times New Roman', 'FontSize',14);%'Helvetica' );





