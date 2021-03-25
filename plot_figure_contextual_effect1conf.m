function plot_figure_contextual_effect1conf(addr,config_main,ftype,sbjs,model,colors,transfer_greedy)
nsub = length(sbjs.indx);


%% real

%-load data
%--------------------------------------------------------------------------
load([addr.bhv filesep 'data_' ftype '_Transfer.mat']);
real = info_transfer;

clearvars info_transfer

%-set up variables
%--------------------------------------------------------------------------
switch config_main.ttype
    case 'rate'
        %-Rate
        real.pref_left         = real.pref.rate_left(sbjs.indx,:);
        real.pref_right        = real.pref.rate_right(sbjs.indx,:);
        %-Conf
        real.conf_left         = real.conf.mean_left(sbjs.indx,:);
        real.conf_right        = real.conf.mean_right(sbjs.indx,:);
        
    case 'binary'
        %-Rate
        real.pref_left         = real.pref.bin_left(sbjs.indx,:);
        real.pref_right        = real.pref.bin_right(sbjs.indx,:);
        %-Conf
        real.conf_left         = real.conf.mean_left(sbjs.indx,:);
        real.conf_right        = real.conf.mean_right(sbjs.indx,:);
        
    case 'first'
        %-Rate
        real.pref_left         = real.pref.first_left(sbjs.indx,:);
        real.pref_right        = real.pref.first_right(sbjs.indx,:);
        %-Conf
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
load([addr.simf, filesep, 'sim_fitted_level2_',ftype,'.mat']);

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
        %-Conf
        fake.conf_left         = fake.conf.mean_left(sbjs.indx,:);
        fake.conf_right        = fake.conf.mean_right(sbjs.indx,:);
        
    case 'binary'
        %-Rate
        fake.pref_left         = fake.pref.bin_left(sbjs.indx,:);
        fake.pref_right        = fake.pref.bin_right(sbjs.indx,:);
        %-Conf
        fake.conf_left         = fake.conf.mean_left(sbjs.indx,:);
        fake.conf_right        = fake.conf.mean_right(sbjs.indx,:);
        
    case 'first'
        %-Rate
        fake.pref_left         = fake.pref.first_left(sbjs.indx,:);
        fake.pref_right        = fake.pref.first_right(sbjs.indx,:);
        %-Conf
        fake.conf_left         = fake.conf.first_left(sbjs.indx,:);
        fake.conf_right        = fake.conf.first_right(sbjs.indx,:);
end


fake.pref_left_mean         = nanmean(fake.pref_left,1);
fake.pref_right_mean        = nanmean(fake.pref_right,1);

fake.pref_left_std          = nanstd(fake.pref_left,1);
fake.pref_right_std         = nanstd(fake.pref_right,1);
fake.pref_left_sem          = nanstd(fake.pref_left,1)/sqrt(nsub);
fake.pref_right_sem         = nanstd(fake.pref_right,1)/sqrt(nsub);

fake.conf_left_mean         = nanmean(fake.conf_left,1);
fake.conf_right_mean        = nanmean(fake.conf_right,1);

fake.conf_left_std          = nanstd(fake.conf_left,1);
fake.conf_right_std         = nanstd(fake.conf_right,1);
fake.conf_left_sem          = nanstd(fake.conf_left,1)/sqrt(nsub);
fake.conf_right_sem         = nanstd(fake.conf_right,1)/sqrt(nsub);


%% start
%--------------------------------------------------------------------------
uniNames1 = {'A1','A2'};
uniNames2 = {'A1-A2','A1-B','A1-C','A2-B','A2-C','B-C'};
uniNames3 = {'A1','A2','B','C'};
uniNames4 = {'Correct','Wrong'};

%% sizes

%-real data
bar_width          = 0.4;
bar_lwidth         = 1.5;
error_lwidth       = 2.5;

%-fake data
fake_mark_size          = 11;
fake_error_lwidth       = 2;

%-scatter
scat_size               = 50;
scat_jitter             = 0.15;

%% A1A2 pair
f = figure;  
%--------------------------------------------------------------------------
subplot(1,2,1);

%-real data
%--------------------------------------------------------------------------
x = [1];
y = [real.pref_left_mean(1), real.pref_right_mean(1)];

b1 = bar(1,y(1));
hold on
b2 = bar(2,y(2));

e1 = errorbar(x,  [real.pref_left_mean(1)], [real.pref_left_sem(1)]);
e2 = errorbar(x+1,[real.pref_right_mean(1)],[real.pref_right_sem(1)]);

set(b1, ...
    'FaceColor', colors.real.A1.face, ...
    'EdgeColor', colors.real.A1.face, ...
    'LineWidth', bar_lwidth);

set(b2, ...
    'FaceColor', colors.real.A2.face, ...
    'EdgeColor', colors.real.A2.face, ...
    'LineWidth', bar_lwidth);

set(e1, ...
    'Color', 	 colors.error, ...
    'LineStyle', 'none', ...
    'LineWidth', error_lwidth);

set(e2, ...
    'Color',     colors.error, ...
    'LineStyle', 'none', ...
    'LineWidth', error_lwidth);

%-scatter
%--------------------------------------------------------------------------
hold on

dataY = [real.pref_left(:,1), real.pref_left(:,2)];
dataX = repmat(1:2,length(dataY),1);
scat  = scatter(dataX(:) ,dataY(:) ,scat_size,'jitter','on','jitterAmount',scat_jitter);%,'filled'

set(scat                                     , ...
  'LineWidth'        , 1                     , ...
  'Marker'           , 'o'                   , ...
  'MarkerEdgeColor'  , colors.scatter    , ...
  'MarkerFaceColor'  , colors.scatter    );

%-Fake data
%--------------------------------------------------------------------------
hold on
x = [1:2]-.15;
y = [fake.pref_left_mean(1), fake.pref_right_mean(1)];
s = [fake.pref_left_sem(1),  fake.pref_right_sem(1) ];

p1 = plot(x(1),y(1));
hold on
e1 = errorbar(x(1),[y(1)],[s(1)]);

hold on

p2 = plot(x(2),y(2));
hold on
e2 = errorbar(x(2),[y(2)],[s(2)]);


set(p1, ...
    'Marker', 'o', ...
    'MarkerSize',     fake_mark_size,...
    'MarkerEdgeColor',colors.fake.A1.face,...
    'MarkerFaceColor',colors.fake.A1.face);

set(e1, ...
    'Color',colors.error,...
    'LineStyle','none',...
    'LineWidth',fake_error_lwidth);


set(p2, ...
    'Marker', 'o', ...
    'MarkerSize',fake_mark_size,...
    'MarkerEdgeColor',colors.fake.A2.face,...
    'MarkerFaceColor',colors.fake.A2.face);

set(e2, ...
    'Color',    colors.error,...
    'LineStyle','none',...
    'LineWidth',fake_error_lwidth);

%-continue
%--------------------------------------------------------------------------
xlim([0 3]);
ylim([0 1]);

ylabel('rating freq');

set(gca, 'XTickLabel', '');

xlabetxt = uniNames1([1 2]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1 2],repmat(ypos,2,1), ...
     xlabetxt','horizontalalignment','right','FontSize',10);

 grid on;

 set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'off'     , ...
  'YMinorTick'  , 'off'     , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'XTick'       , 0:1:3     , ...
  'YTick'       , 0:0.1:1   , ...
  'XGrid'       , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'LineWidth'   , 1         );

%--------------------------------------------------------------------------
subplot(1,2,2);

%-real confidence data
%--------------------------------------------------------------------------
x = [1];
y = [real.conf_left_mean(1), real.conf_right_mean(1)];

b1 = bar(1,y(1));
hold on
b2 = bar(2,y(2));

hold on

e1 = errorbar(x,  [real.conf_left_mean(1)], [real.conf_left_sem(1)]);
e2 = errorbar(x+1,[real.conf_right_mean(1)],[real.conf_right_sem(1)]);

set(b1, ...
    'FaceColor', colors.real.A1.face, ...
    'EdgeColor', colors.real.A1.face, ...
    'LineWidth', bar_lwidth);

set(b2, ...
    'FaceColor', colors.real.A2.face, ...
    'EdgeColor', colors.real.A2.face, ...
    'LineWidth', bar_lwidth);

set(e1, ...
    'Color',colors.error, ...
    'LineStyle','none', ...
    'LineWidth',error_lwidth); 

set(e2, ...
    'Color',colors.error, ...
    'LineStyle','none', ...
    'LineWidth',error_lwidth);

%-scatter jitter
%--------------------------------------------------------------------------

hold on

dataY = [real.conf_left(:,1), real.conf_left(:,2)];
dataX = repmat(1:2,length(dataY),1);
scat  = scatter(dataX(:) ,dataY(:) ,scat_size,'jitter','on','jitterAmount',scat_jitter);%,'filled'


set(scat                                             , ...
  'LineWidth'        , 1                             , ...
  'Marker'           , 'o'                           , ...
  'MarkerEdgeColor'  , colors.scatter    , ...
  'MarkerFaceColor'  , colors.scatter    );

%-continue
%--------------------------------------------------------------------------

xlim([0 3]);
ylim([0 1]);

ylabel('conf freq');

set(gca, 'XTickLabel', '')
xlabetxt = uniNames1([1 2]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1 2],repmat(ypos,2,1), ...
     xlabetxt','horizontalalignment','right','FontSize',10);
 
% grid on; 
 
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'off'     , ...
  'YMinorTick'  , 'off'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'XTick'       , 0:1:3     , ...
  'YTick'       , 0:0.1:1   , ...
  'XGrid'       , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'LineWidth'   , 1         );

