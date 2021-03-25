function plot_figure_learning_performance2(addr,ftype,sbjs,model,unknown,colors)

%% Data
filename = [addr.bhv, filesep, 'data_', ftype, '_Learning'];
load(filename);  %info_learning
real = info_learning;

%% model
filename    = [addr.simf, filesep,'sim_fitted_level2', '_', ftype];
load(filename);
learning    = level2.(model.name).learning;
%-convert the level2 structure to level1 structure: remove stds
fields = fieldnames(learning);
for i = 1:length(fields)
    info_learning.(fields{i}) = learning.(fields{i}).mean;
end
fake = info_learning;
clearvars info_learning;

%%
realwidth = 2.5;
fakewidth = 2.5;


pref_all.real  = real.performances;
pref_all.fake  = fake.performances;

part_n = size(pref_all.real,2);

f = figure;
x  = 1:1:part_n;

y  = pref_all.real(sbjs.indx,1:part_n);
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops', {'LineStyle','-','LineWidth',realwidth,'Color',colors.real.A1.face});


xlabel('time (each bin is 10 trials)');
ylabel('performance');

grid on

set(gca,'FontName','Times New Roman', 'FontSize',14);%'Helvetica' );
