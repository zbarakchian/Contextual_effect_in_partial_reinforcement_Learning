function plot_pop_pref_trend_learning1(config_analysis,ftype,sbjs)
%-load data
%--------------------------------------------------------------------------
name      = config_analysis.type;
ratio_all = config_analysis.info_learning.conds_ratio;
part_n    = size(ratio_all{1},1);

%%
rows=1;
cols=2;

% clf
f  = figure;

subplot(rows,cols,1)

x  = 1:1:part_n;
yp(:,:) = ratio_all{1}(1:part_n,1,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops', '-r');

hold on


yp(:,:) = ratio_all{1}(1:part_n,2,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops', '-m');

xlim([0 part_n]);
% ylim([-1 3]);

xlabel('Trials/10');
ylabel('Choice Ratio');

hold off
grid on
%%
subplot(rows,cols,2)

x  = 1:1:part_n;
yp(:,:) = ratio_all{2}(1:part_n,1,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops', '-b');

hold on

yp(:,:) = ratio_all{2}(1:part_n,2,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops', '-c');

xlim([0 part_n]);
% ylim([-1 3]);

xlabel('Trials/10');
% ylabel('freq');

% tit = strcat('The Preferences of pop');
% title(tit);

hold off
grid on

supertitle(strcat('Choice Trend-',ftype));

% legend('A1','B');
% legend('A2','C');


% name = strcat('Figures/pop_trend1_', ftype, '_', name, '.png');
% saveas(gcf,name); 
% close(f);

