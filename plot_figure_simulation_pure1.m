function plot_figure_simulation_pure1(ftype,model,colors)

ntimes   = 10;
ntrials  = 500;
mu       = [7 5]; 
sd       = [1 1];
Q0       = [0 0];
agents   = [0.1,0.2,0.2];

%%
tasks    = mu;
ntasks   = size(tasks,1);
nagents  = size(agents,1);
nparams  = size(agents,2);

for tsk  = 1:ntasks 
    for sub  = 1:nagents   qvalues = [];
        for rpt  = 1:ntimes 
            disp([tsk sub rpt]);
            params          = agents(sub,:);    
            rw_stat.mu      = [mu(tsk,1),mu(tsk,2)];
            rw_stat.sigma   = [sd(1),sd(2)];
            result1{rpt}    = model.simulate_pure(params,rw_stat,Q0,ntrials);   
            qvalues(:,rpt,:)   = result1{rpt}.value;
        end
        plot_simQValues(qvalues,colors);
        result2{sub} = result1;
    end
    result3{tsk} = result2;
end
result = result3;

end



function plot_simQValues(qvalues,colors)
ntrials = size(qvalues,1);

f = figure;

x = 1:ntrials;
y1(:,:) = qvalues(:,:,1)';
y2(:,:) = qvalues(:,:,2)';

s1  = shadedErrorBar(x,y1,{@nanmean,@nanstd}, ...
      'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colors.model.A1.face});
  
hold on;

s2  = shadedErrorBar(x,y2,{@nanmean,@nanstd}, ...
      'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colors.model.B.face});


% xlabel('Trials');
% ylabel('QValues');
% xlim([]);
% ylim([-11 11]);

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

set(gca,'FontName','Times New Roman', 'FontSize', 16);%'Helvetica' );

end














