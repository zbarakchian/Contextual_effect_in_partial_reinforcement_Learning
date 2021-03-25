function plot_iters_value(addr,ftype,sbjs)


%-load data
%--------------------------------------------------------------------------
load([addr.bhv filesep, 'data_', ftype, '_Learning.mat']);
load([addr.bhv filesep, 'data_', ftype, '_Transfer.mat']);
load([addr.bhv filesep, 'data_', ftype, '_Estimation.mat']);

pref_rate_left   = info_transfer.pref.rate_left;
pref_rate_right  = info_transfer.pref.rate_right;

pref_bin_left    = info_transfer.pref.bin_left;
pref_bin_right   = info_transfer.pref.bin_right;

pref_first_left  = info_transfer.pref.first_left;
pref_first_right = info_transfer.pref.first_right;

Values           = info_estimation.valuation.estimate;
Variations       = info_estimation.variation.estimate;

%% organize

all = info_transfer.pref.all;

left  = [];
right = [];
for sub = sbjs.indx
    left(:,:,sub)  = all{sub}.left;
    right(:,:,sub) = all{sub}.right;
end

sbjs_A1 = [];
sbjs_A2 = [];

for sub = sbjs.indx
    if     left(1,1,sub) == 0 && right(1,1,sub) == 1
        sbjs_A2 = [sbjs_A2, sub];
    elseif left(1,1,sub) == 1 && right(1,1,sub) == 0
        sbjs_A1 = [sbjs_A1, sub];

    end
end

sbjs_to_analyze = sbjs_A1;

%% Plot    
% colors = [255 102 102; ...
%           255 178 102; ...
%           255 255 102; ...
%           178 255 102; ...
%           102 255 255; ...
%           102 178 255]/255;

colors = [0   0   102; ...
          51  51  255; ...
          153 153 255; ...
          0   128 255; ...
          0   204 204; ...
          51  255 255]/255;


figure;
x  = 1:4;
itrs = 1:4;

stim = 1;
yp(:,:) = Values(stim,itrs,sbjs_to_analyze);
y  = yp';

s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',2,'Marker','o','Color', colors(stim,:)});
p1 = s.mainLine;

% p1 = plot(x,mean(y));
% set(p1,...
%     'Color', colors(stim,:),   ...
%     'LineWidth',    2,              ...
%     'Marker',       'o',            ...
%     'MarkerSize',   6               ...
%     );


hold on;

stim = 2;
yp(:,:) = Values(stim,itrs,sbjs_to_analyze);
y  = yp';

s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',2,'Marker','o','Color', colors(stim,:)});
p2 = s.mainLine;

% p2 = plot(x,mean(y));
% set(p2,...
%     'Color', colors(stim,:),   ...
%     'LineWidth',    2,              ...
%     'Marker',       'o',            ...
%     'MarkerSize',   6               ...
%     );

hold on;

stim = 3;
yp(:,:) = Values(stim,itrs,sbjs_to_analyze);
y  = yp';

s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',2,'Marker','o','Color', colors(stim,:)});
p3 = s.mainLine;

% p3 = plot(x,mean(y));
% set(p3,...
%     'Color', colors(stim,:),   ...
%     'LineWidth',    2,              ...
%     'Marker',       'o',            ...
%     'MarkerSize',   6               ...
%     );

hold on;

stim = 4;
yp(:,:) = Values(stim,itrs,sbjs_to_analyze);
y  = yp';

s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',2,'Marker','o','Color', colors(stim,:)});
p4 = s.mainLine;

% p4 = plot(x,mean(y));
% set(p4,...
%     'Color', colors(stim,:),   ...
%     'LineWidth',    2,              ...
%     'Marker',       'o',            ...
%     'MarkerSize',   6               ...
%     );



ylim([0,100]);

hLegend = legend( ...
  [p1 p2 p3 p4], ...
  ['A_1'],['A_2'],['B'],['C'],...
  'location', 'SouthEast' );

legend boxoff;



set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'on'      , ...
    'YGrid'       , 'on'      , ...
    'XTick'       , [1:4]        , ... %     'YTick'       , []        , ...
    'LineWidth'   , 1         );







