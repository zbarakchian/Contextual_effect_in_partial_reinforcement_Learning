function plot_figure_simulation_convergence(ftype,model,colors)

ntimes   = 50;
ntrials  = 1000;
mu       = [10 9]; 
sd       = [1 1];
Q0       = [0 0];
params   = [0.3 0.4 0.4];

%%
for p    = 1:size(params,1)
for rpt  = 1:ntimes 
    
    %-context1
    rw_stat.mu              = [mu(1),mu(2)];
    rw_stat.sigma           = [sd(1),sd(2)];
    result                  = model.simulate_pure(params(p,:),rw_stat,Q0,ntrials);   
    qvalues{p}(:,rpt,:)     = result.value;

end
end

plot_simQValues2(qvalues,mu,colors);

end


%%
function plot_simQValues2(qvalues,mu,colors)

sz      = size(qvalues{1});
ntrials = sz(1);
ntimes  = sz(2);
nagents = size(qvalues,1);

colors1 = [255 000 000; ...
           000 000 255]./255;

f = figure;
x = 1:ntrials;

for p = 1:nagents
    
    A = qvalues{p}(:,:,1);
    B = repmat(2*(mu(1)-mu(2)),ntrials,ntimes);
    y(:,:) = (A - B)';

    shadedErrorBar(x,y,{@nanmean,@nanstd}, ...
          'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colors1(1,:)}); %3-p*0.25
      
    hold on   
    
%     A = repmat(mu(2),ntrials,ntimes);
%     B = qvalues{p}(:,:,2);
%     y(:,:) = (A - B)';
% 
%     shadedErrorBar(x,y,{@nanmean,@nanstd}, ...
%           'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colors1(2,:)}); %3-p*0.25
%       
%     hold on   

end

plot(repmat([0],1,ntrials),'Color',[0 0 0], 'LineWidth',2 ,'LineStyle', '--');

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











