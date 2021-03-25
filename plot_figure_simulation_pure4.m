function plot_figure_simulation_pure4(addr,ftype,model,colors)


%[5,6],[3,5]
task                = 4;%[1:10];
beta                = 5;%[1 2 5 10 15 18 20 23];

%% config
sd                  = [1 1];
mu                  = [10 9; 10 8; 10 7; 10 6; 10 5; 10 4; 10 3; 10 2; 10 1; 10 0;];
alphas1             = [0.1:0.1:1];
betas               = [0:0.025:0.4 0.5:0.1:1]; 

indx = 0;
for a1 = alphas1 
    basic = [0];
    a2 = 0;
    for i = 1:10
        d = a1*power((1/2),i);
        a2 = a2 + d;
        basic = [basic; a2];
    end
    basic  = [basic; a1];
    indx = indx + 1;
    alphas2{indx} = basic;
end

%-agents
agents = [];
for b = betas
    indx = 0;
    for a1 = alphas1 
        agents = [agents; [b a1 0]];
        indx = indx + 1;
        for a2 = alphas2{indx}' 
             agents = [agents; [b a1 a2]];
        end
        agents = [agents; [b a1 a1]];
    end
end



%%

% load([addr.optimal filesep 'square_qvalue_' ftype '.mat']);
% qmean = matrix.mean;
% qstd  = matrix.std;
% 
% ratioa2a1 = [];
% corrs = [];
% for a1 = 1:length(alphas1)
%     for a2 = 1:5 %length(alphas2{a1})
%         disp([a1 a2]);
%         
%         %-calculate -a2/a1;
%         ratioa2a1(a1,a2) = alphas2{a1}(a2)/alphas1(a1);
%         
%         %calculate qvalues1
%         %---------------------------
%         rw_stat.mu         = mu(task,:);
%         rw_stat.sigma      = sd;
%         ntrials = 10000;
%         Q0 = [0 0];
%         
%         q1s = []; q2s = [];
%         for b = 3%1:length(betas)
%             params    = [betas(b),alphas1(a1),alphas2{a1}(a2)];
%             result    = model.simulate_pure(params,rw_stat,Q0,ntrials);   
%             q1s(b,:)  = result.value(ntrials-1000:ntrials,1);
%             q2s(b,:)  = result.value(ntrials-1000:ntrials,2);
%         end
% 
%         %calculate qvalues2
%         %---------------------------
% %         q1s = squeeze(qmean(a1,a2,:,task,1));
% %         q2s = squeeze(qmean(a1,a2,:,task,2));
%         
%         
%         %---------------------------
%         [corrs(a1,a2),~] = corr(q1s(b,:)',q2s(b,:)');        
%     end
% end
% 
% save('corr_q1q2','corrs','ratioa2a1');
% disp(' ');

%% plot

load('corr_q1q2');

figure;
x = - ratioa2a1(1,:);

for i = 1:size(corrs,1)
    y = corrs(i,:);
    p = plot(x,y);
    
    set(p, ...
        'LineStyle','-', ...
        'LineWidth',1.5, ...
        'Color', colors.model.A2.face);
    
    
    hold on    
end

p = plot([-1:0.1:1],repmat([0],1,21));
set(p, ...
    'LineStyle','--', ...
    'LineWidth',1, ...
    'Color', [.5 .5 .5]);

p = plot(repmat([0],1,21),[-1:0.1:1]);
set(p, ...
    'LineStyle','--', ...
    'LineWidth',1, ...
    'Color', [.5 .5 .5]);

p = plot([-1:0.1:1],[-1:0.1:1]);
set(p, ...
    'LineStyle','--', ...
    'LineWidth',1, ...
    'Color', [.5 .5 .5]);


xlim([-1 .2]);
ylim([-1 .2]);

xlabel('- \alpha_2/\alpha_1');
ylabel('Correlation (Q_1,Q_2)');

set(gca, ...
  'Box'         , 'on'     , ...
  'TickDir'     , 'in'     , ...
  'TickLength'  , [.005 .005] , ...
  'XMinorTick'  , 'off'     , ...
  'YMinorTick'  , 'off'     , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'XTick'       , -1:0.2:1  , ...
  'YTick'       , -1:0.2:1   , ...
  'XGrid'       , 'off'      , ...
  'YGrid'       , 'off'      , ...
  'LineWidth'   , 1         );



set(gca,'FontName','Times New Roman', 'FontSize', 18);%'Helvetica' );

%%
