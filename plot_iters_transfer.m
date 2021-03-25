function plot_iters_transfer(addr,ftype,sbjs)


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
Variations = info_estimation.variation.estimate;

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

subplot(2,3,1)

cmb = 1;
yp(:,:) = left(:,cmb,sbjs_to_analyze);
% yp(:,:) = right(:,cmb,sbjs_to_analyze);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1,'Marker','o','Color', colors(cmb,:)});
p1 = s.mainLine;

% p1 = plot(x,mean(y));
% set(p1,...
%     'Color', colors(cmb,:),   ...
%     'LineWidth',    2,              ...
%     'Marker',       'o',            ...
%     'MarkerSize',   18               ...
%     );

hold on

p = plot(x,repmat(0.0,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');
p = plot(x,repmat(0.5,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');
p = plot(x,repmat(1.0,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');


title('A_1A_2');
ylim([-0.1,1.4]);


% hold on;
subplot(2,3,2)

cmb = 2;
yp(:,:) = left(:,cmb,sbjs_to_analyze);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1,'Marker','o','Color', colors(cmb,:)});
p2 = s.mainLine;

% p2 = plot(x,mean(y));
% set(p2,...
%     'Color', colors(cmb,:),   ...
%     'LineWidth',    2,              ...
%     'Marker',       'o',            ...
%     'MarkerSize',   16               ...
%     );

hold on

p = plot(x,repmat(0.0,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');
p = plot(x,repmat(0.5,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');
p = plot(x,repmat(1.0,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');

title('A_1B');
ylim([-0.1,1.4]);

% hold on;
subplot(2,3,3)

cmb = 3;
yp(:,:) = left(:,cmb,sbjs_to_analyze);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1,'Marker','o','Color', colors(cmb,:)});
p3 = s.mainLine;

% p3 = plot(x,mean(y));
% set(p3,...
%     'Color', colors(cmb,:),   ...
%     'LineWidth',    2,              ...
%     'Marker',       'o',            ...
%     'MarkerSize',   14               ...
%     );

hold on

p = plot(x,repmat(0.0,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');
p = plot(x,repmat(0.5,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');
p = plot(x,repmat(1.0,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');

title('A_1C');
ylim([-0.1,1.4]);


% hold on;
subplot(2,3,4)

cmb = 4;
yp(:,:) = left(:,cmb,sbjs_to_analyze);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1,'Marker','o','Color', colors(cmb,:)});
p4 = s.mainLine;

% p4 = plot(x,mean(y));
% set(p4,...
%     'Color', colors(cmb,:),   ...
%     'LineWidth',    2,              ...
%     'Marker',       'o',            ...
%     'MarkerSize',   10               ...
%     );

hold on

p = plot(x,repmat(0.0,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');
p = plot(x,repmat(0.5,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');
p = plot(x,repmat(1.0,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');

title('A_2B');
ylim([-0.1,1.4]);

% hold on;
subplot(2,3,5)

cmb = 5;
yp(:,:) = left(:,cmb,sbjs_to_analyze);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1,'Marker','o','Color', colors(cmb,:)});
p5 = s.mainLine;

% p5 = plot(x,mean(y));
% set(p5,...
%     'Color', colors(cmb,:),   ...
%     'LineWidth',    2,              ...
%     'Marker',       'o',            ...
%     'MarkerSize',   8               ...
%     );

hold on

p = plot(x,repmat(0.0,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');
p = plot(x,repmat(0.5,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');
p = plot(x,repmat(1.0,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');

title('A_2C');
ylim([-0.1,1.4]);

% hold on;
subplot(2,3,6)

cmb = 6;
yp(:,:) = left(:,cmb,sbjs_to_analyze);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1,'Marker','o','Color', colors(cmb,:)});
p6 = s.mainLine;

% p6 = plot(x,mean(y));
% set(p6,...
%     'Color', colors(cmb,:),   ...
%     'LineWidth',    2,              ...
%     'Marker',       'o',            ...
%     'MarkerSize',   6               ...
%     );

hold on

p = plot(x,repmat(0.0,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');
p = plot(x,repmat(0.5,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');
p = plot(x,repmat(1.0,1,length(x)),'Color',[.5 .5 .5],'LineStyle','--');

title('BC');
ylim([-0.1,1.4]);

% ylabel('Proportion of Left');
% xlabel('iteration');

% supertitle('A2 choosers');

% hLegend = legend( ...
%   [p1 p2 p3 p4 p5 p6], ...
%   ['A_{1}A_{2}'],['A_{1}B'],['A_1C'],['A_2B'],['A_2C'],['BC'] ,...
%   'location', 'SouthEast' );
% 
% legend boxoff;



set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'XTick'       , [1:4]        , ... %     'YTick'       , []        , ...
    'LineWidth'   , 1         );







