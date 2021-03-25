function plot_figure_simulation_pure2(ftype,model,colors)

ntimes   = 30;
ntrials  = 500;
mu1      = [7 5]; 
mu2      = [7 3];
sd       = [1 1];
Q0       = [0 0];
params   = [0.1,0.2,0.18];

%%
for rpt  = 1:ntimes 
    
    %-context1
    rw_stat.mu          = [mu1(1),mu1(2)];
    rw_stat.sigma       = [sd(1),sd(2)];
    result1             = model.simulate_pure(params,rw_stat,Q0,ntrials);   
    qvalues{1}(:,rpt,:) = result1.value;
    
    %-context2
    rw_stat.mu          = [mu2(1),mu2(2)];
    rw_stat.sigma       = [sd(1),sd(2)];
    result2             = model.simulate_pure(params,rw_stat,Q0,ntrials);   
    qvalues{2}(:,rpt,:) = result2.value;

end

plot_simDeltaQValues2(qvalues,colors,mu1,mu2);
% plot_simQValues2(qvalues,colors,mu1,mu2);

end


%%
function plot_simDeltaQValues2(qvalues,colors,mu1,mu2)
ntrials = size(qvalues{1},1);

f = figure;

x = 1:ntrials;
y1(:,:) = qvalues{1}(:,:,1)';
y2(:,:) = qvalues{1}(:,:,2)';

s  = shadedErrorBar_origin(x,y1-y2,{@nanmean,@nanstd}, ...
      'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colors.model.A1.face});
component{1} = s.mainLine;
  
hold on

x = 1:ntrials;
y1(:,:) = qvalues{2}(:,:,1)';
y2(:,:) = qvalues{2}(:,:,2)';

s  = shadedErrorBar_origin(x,y1-y2,{@nanmean,@nanstd}, ...
      'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colors.model.A2.face});
component{3} = s.mainLine;



% xlim([1 ntrials]);
ylim([-5 15]);

% yticks([0:2:10]);
% yticklabels({'0','2','0.4','0.6','0.8','1'});


xlabel(['trial']);
ylabel('\Delta Qvalue');

% hLegend = legend( ...
%   [component{1}, component{2} component{3} component{4}], ...
%   ['A_1 =  N(' num2str(mu1(1)) ',1)'] , ...
%   ['B   =  N(' num2str(mu1(2)) ',1)'] , ...
%   ['A_2 =  N(' num2str(mu2(1)) ',1)'] , ...
%   ['C   =  N(' num2str(mu2(2)) ',1)'] , ...
%   'location', 'SouthEast','NumColumns',2 );
% legend boxoff;  


set(gca, ...
  'Box'         , 'on'     , ...
  'TickDir'     , 'in'     , ...
  'TickLength'  , [.005 .005] , ...
  'XMinorTick'  , 'off'     , ...
  'YMinorTick'  , 'off'     , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'XTick'       , 0:ntrials/10:ntrials , ...
  'YTick'       , -10:1:10   , ...
  'XGrid'       , 'off'      , ...
  'YGrid'       , 'off'      , ...
  'LineWidth'   , 1         );

set(gca,'FontName','Times New Roman');%'Helvetica' );

end

%%
function plot_simQValues2(qvalues,colors,mu1,mu2)
ntrials = size(qvalues{1},1);

f = figure;

x = 1:ntrials;
y1(:,:) = qvalues{1}(:,:,1)';
y2(:,:) = qvalues{1}(:,:,2)';

s  = shadedErrorBar_origin(x,y1,{@nanmean,@nanstd}, ...
      'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colors.model.A1.face});
component{1} = s.mainLine;
  
hold on;

s  = shadedErrorBar_origin(x,y2,{@nanmean,@nanstd}, ...
      'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colors.model.B.face});
component{2} = s.mainLine;


hold on 

x = 1:ntrials;
y1(:,:) = qvalues{2}(:,:,1)';
y2(:,:) = qvalues{2}(:,:,2)';

s  = shadedErrorBar_origin(x,y1,{@nanmean,@nanstd}, ...
      'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colors.model.A2.face});
component{3} = s.mainLine;
  
hold on;

s  = shadedErrorBar_origin(x,y2,{@nanmean,@nanstd}, ...
      'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colors.model.C.face});
component{4} = s.mainLine;


% xlim([1 ntrials]);
ylim([-5 15]);

% yticks([0:2:10]);
% yticklabels({'0','2','0.4','0.6','0.8','1'});


xlabel(['trial']);
ylabel('Qvalue');

hLegend = legend( ...
  [component{1}, component{2} component{3} component{4}], ...
  ['A_1 =  N(' num2str(mu1(1)) ',1)'] , ...
  ['B   =  N(' num2str(mu1(2)) ',1)'] , ...
  ['A_2 =  N(' num2str(mu2(1)) ',1)'] , ...
  ['C   =  N(' num2str(mu2(2)) ',1)'] , ...
  'location', 'SouthEast','NumColumns',2 );

legend boxoff;  


set(gca, ...
  'Box'         , 'on'     , ...
  'TickDir'     , 'in'     , ...
  'TickLength'  , [.005 .005] , ...
  'XMinorTick'  , 'off'     , ...
  'YMinorTick'  , 'off'     , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'XTick'       , 0:ntrials/10:ntrials , ...
  'YTick'       , -10:1:10   , ...
  'XGrid'       , 'off'      , ...
  'YGrid'       , 'off'      , ...
  'LineWidth'   , 1         );

set(gca,'FontName','Times New Roman');%'Helvetica' );

end











