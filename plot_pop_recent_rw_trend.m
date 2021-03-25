function plot_pop_recent_rw_trend(config_analysis,sbjs,Ltrial)
info_learning = config_analysis.info_learning;

stat_recent_rws = info_learning.statistics.backward;
%--------------------------------------------------------------------------

%-function
extract.mean = @(C,stim,trial) cellfun(@(c) c.mean(stim,trial), C) ;

%--------------------------
rwA1 = [];
rwA2 = [];
for trial = 1:Ltrial
    rwA1    = [rwA1; extract.mean(stat_recent_rws(sbjs.indx), 1,trial)];
    rwA2    = [rwA2; extract.mean(stat_recent_rws(sbjs.indx), 2,trial)];
end
%%
f = figure;
nt = 10; 
x  = 1:nt;

y = rwA1(1:nt,:)';
s  = shadedErrorBar(x,y,{@mean,@std}, 'lineprops', '-r');

hold on

y = rwA2(1:nt,:)';
s  = shadedErrorBar(x,y,{@mean,@std}, 'lineprops', '-m');
  
% name = strcat('Figures/pop_LB1_PrefTrend_13_24.png');
% saveas(gcf,name); 
% close(f);