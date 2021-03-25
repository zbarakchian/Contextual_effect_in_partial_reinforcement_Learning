function plot_pop_pref_trend_learning2(config_analysis,ftype,sbjs)

nametosave  = config_analysis.nametosave;

%% in Which trial subjects learned (pref trend)
%% total preference

pref_all  = config_analysis.info_learning.performances;
part_n    = size(pref_all,2);

f = figure;
x  = 1:1:part_n;
%%
y  = pref_all(sbjs.indx,1:part_n);
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops', '-g');

% xlim([0 1]);
% ylim([0 1.5]);

xlabel('Trials');
ylabel('performance');

grid on
title(strcat('Performance Trend-',ftype));


name = strcat('Figures/pop_trend2_', ftype, '_', nametosave, '.png');
saveas(gcf,name); 
% close(f);

%% Which trial subjects learned
%% separately for each pair

ratio_all = config_analysis.info_learning.conds_ratio;
part_n    = size(ratio_all{1},1);

%%
f = figure;
x  = 1:1:part_n;

yp(:,:)  = ratio_all{1}(1:part_n,1,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops', '-k');


yp(:,:)  = ratio_all{2}(1:part_n,1,sbjs.indx);
y  = yp';
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops', '-y');

% ylim([0 1]);

xlabel('Time');
ylabel('Pcorrect');


grid on
supertitle('Trend of the Preferences during Learning');

name = strcat('Figures/pop_trend3_', ftype, '_', nametosave, '.png');
saveas(gcf,name); 
% close(f);

%%
% part_n      = 5;
% part_size   = 100/part_n;
% prf_all     = zeros(nsub,part_n,2);
% 
% for sub = sbjs.indx   
%     correct    = info_learning.data{sub}(:,14); 
%     conditions = info_learning.data{sub}(:,4);
%     %----------------------------------------------------------------------
%     part_Data1    = [];
%     part_Data2    = [];
%     performance1  = [];  
%     performance2  = [];  
%     for i = 1:part_n
%         indxBegin           = (i-1)*part_size + 1;
%         indxEnd             = i*part_size;
%         I1                  = find(conditions(indxBegin:indxEnd)==1);
%         I2                  = find(conditions(indxBegin:indxEnd)==2);
%         part_Data1          = correct(I1);
%         part_Data2          = correct(I2);
%         [H1,stim1]          = hist(part_Data1(:),[0 1 99]);
%         [H2,stim2]          = hist(part_Data2(:),[0 1 99]);
%         performance1        = [performance1, H1(2)/(H1(1)+H1(2))];        
%         performance2        = [performance2, H2(2)/(H2(1)+H2(2))];        
%     end 
%     prf_all(sub,:,1) = performance1; 
%     prf_all(sub,:,2) = performance2; 
% end