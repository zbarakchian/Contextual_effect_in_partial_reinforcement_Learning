function plot_figure_learning_performance1(addr,ftype,sbjs,model,colors)

%% Datra
filename = [addr.bhv, filesep, 'data_', ftype, '_Learning'];
load(filename);  %info_learning
real = info_learning;

%% model
filename = [addr.simf, filesep, 'sim_fitted_level2', '_', ftype];

load(filename);
learning = level2.(model.name).learning;

%-convert the level2 structure to level1 structure: remove stds
fields = fieldnames(learning);
for i = 1:length(fields)
    info_learning.(fields{i}) = learning.(fields{i}).mean;
end
fake = info_learning;
clearvars info_learning;

%%
ratio_all.real  = real.conds_ratio;
ratio_all.fake  = fake.conds_ratio;

part_n = size(ratio_all.real{1},1);

%% sizes

text_size = 18;

realwidth = 2.5;
fakewidth = 2.5;

%%
rows=1;
cols=2;

% clf
f  = figure;
x  = 1:1:part_n;
%%
subplot(rows,cols,1)
%----------------
yp(:,:) = ratio_all.real{1}(1:part_n,1,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',realwidth,'Color',colors.real.A1.face});
% s  = shadedErrorBar(x,y,{@nanmean,@nanstd},'lineprops',{'-o','Color','k','markerfacecolor',[0.2,0.2,0.2]});
component{1} = s.mainLine;


hold on


yp(:,:) = ratio_all.real{1}(1:part_n,2,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',realwidth,'Color',colors.real.B.face});
% s  = shadedErrorBar(x,y,{@nanmean,@nanstd},'lineprops',{'-om','markerfacecolor',[0.2,0.2,0.2]});
component{2} = s.mainLine;

hold on
%----------------
yp(:,:) = ratio_all.fake{1}(1:part_n,1,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','--','LineWidth',fakewidth,'Color',colors.fake.A1.face});
% s  = shadedErrorBar(x,y,{@nanmean,@nanstd},'lineprops',{'-or','markerfacecolor',[0.8,0.8,0.8]});
component{3} = s.mainLine;


hold on


yp(:,:) = ratio_all.fake{1}(1:part_n,2,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','--','LineWidth',fakewidth,'Color',colors.fake.B.face});
% s  = shadedErrorBar(x,y,{@nanmean,@nanstd},'lineprops',{'-om','markerfacecolor',[0.8,0.8,0.8]});
component{4} = s.mainLine;

%----------------
xlim([0 part_n]);
ylim([-0.1 1.1]);

yticks([0:0.2:1]);
yticklabels({'0','0.2','0.4','0.6','0.8','1'});


ylabel('choice rate');

hLegend = legend( ...
  [component{1}, component{2} component{3} component{4}], ...
  ['A_1, data'] , ...
  ['B, data'] , ...
  ['A_1, model'] , ...
  ['B, model'] , ...
  'location', 'Northoutside','NumColumns',2 );

legend boxoff;  


hold off
grid on

set(gca,'FontName','Times New Roman', 'FontSize',text_size);%'Helvetica' );

xlabel(['time (each bin is 10 trials)'], 'FontSize',16);

%%
subplot(rows,cols,2)

yp(:,:) = ratio_all.real{2}(1:part_n,1,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',realwidth,'Color',colors.real.A2.face});
component{1} = s.mainLine;

hold on

yp(:,:) = ratio_all.real{2}(1:part_n,2,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',realwidth,'Color',colors.real.C.face});
component{2} = s.mainLine;

hold on
%----------------
yp(:,:) = ratio_all.fake{2}(1:part_n,1,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','--','LineWidth',fakewidth,'Color',colors.fake.A2.face});
component{3} = s.mainLine;

hold on


yp(:,:) = ratio_all.fake{2}(1:part_n,2,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','--','LineWidth',fakewidth,'Color',colors.fake.C.face});
component{4} = s.mainLine;

%----------------

xlim([0 part_n]);
ylim([-0.1 1.1]);

yticks([0:0.2:1]);
yticklabels({'0','0.2','0.4','0.6','0.8','1'});

hLegend = legend( ...
  [component{1}, component{2} component{3} component{4}], ...
  ['A_2, data'] , ...
  ['C, data'] , ...
  ['A_2, model'] , ...
  ['C, model'] , ...
  'location', 'Northoutside','NumColumns',2 );

legend boxoff;  


hold off
grid on

set(gca,'FontName','Times New Roman', 'FontSize',text_size);%'Helvetica' );

xlabel(['time (each bin is 10 trials)'], 'FontSize',16);

