function plot_pop_choice_hist(config_analysis,sbjs)

info_learning = config_analysis.info_learning;

%% set variables
% hist_learn; %title of columns: 1,2,3,4,99,0 : A1,A2,B,C,NORESPONSE,NOTRIALS
nsub = length(sbjs.indx);
uniNames = {'A1','A2','B','C'};

%%
rate_mean = mean(info_learning.hist(sbjs.indx,1:4),1);
rate_sem  = std( info_learning.hist(sbjs.indx,1:4),0,1)/sqrt(nsub);
disp(info_learning.hist(sbjs.indx,1:4));

%%
f = figure;  
y = [rate_mean(1),rate_mean(2),rate_mean(3),rate_mean(4)];
h = bar(y);
hold on 
errorbar([1:4],rate_mean,rate_sem,'Color',[0 0 0],'LineStyle','none','LineWidth',2);

xlim([0 5]);
ylim([0 120]);
ylabel('Choice Rate');

titMean = strcat('Learning Plase');
title(titMean);


set(gca, 'XTickLabel', '')
xlabetxt = uniNames;
limy = ylim;
ypos     = limy(1)- (limy(2)-limy(1))/20;
text([1:4]+.1,repmat(ypos,4,1), ...
     xlabetxt','horizontalalignment','right','FontSize',10);
 
 
 
