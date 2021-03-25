function plot_figure_simulation_pure3(ftype,model,colors)

ntimes   = 100;
ntrials  = 300;
mu1      = [10 8]; 
mu2      = [10 6];
sd       = [1 1];
Q0       = [0 0];
params   = [ ...
            0.125 0.2 0.0;    ...
            0.125 0.2 0.1;    ...
            0.125 0.2 0.15;    ...
            0.125 0.2 0.175;    ...
            0.125 0.2 0.19;    ...
            0.125 0.2 0.2;    ...
            ];

params  = [params(6,:);params(5,:);params(4,:);params(3,:);params(2,:);params(1,:);];

%%
for p    = 1:size(params,1)
for rpt  = 1:ntimes 
    
    %-context1
    rw_stat.mu              = [mu1(1),mu1(2)];
    rw_stat.sigma           = [sd(1),sd(2)];
    result1                 = model.simulate_pure(params(p,:),rw_stat,Q0,ntrials);   
    qvalues{1,p}(:,rpt,:)   = result1.value;
    
    %-context2
    rw_stat.mu              = [mu2(1),mu2(2)];
    rw_stat.sigma           = [sd(1),sd(2)];
    result2                 = model.simulate_pure(params(p,:),rw_stat,Q0,ntrials);   
    qvalues{2,p}(:,rpt,:)   = result2.value;

end
end

plot_simQValues2(qvalues,colors);

end


%%
function plot_simQValues2(qvalues,colors)

ntrials = size(qvalues{1,1},1);
nagents = size(qvalues,2);

colors3 = [ ...           
            255 000 000; ...
            255 128 000; ...
            255 255 000; ...   
            000 255 000; ...   
            000 255 255; ...   
            000 000 255; ...   
          ]./255;

colors3 = [colors3(6,:);colors3(5,:);colors3(4,:);colors3(3,:);colors3(2,:);colors3(1,:);];

f = figure;
x = 1:ntrials;

for p = 1:nagents
    
    y(:,:) = (qvalues{2,p}(:,:,1) - qvalues{1,p}(:,:,1))';

    shadedErrorBar(x,y,{@nanmean,@nanstd}, ...
          'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colors3(p,:)}); %3-p*0.25
      
    hold on   
end
hold off 


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

end











