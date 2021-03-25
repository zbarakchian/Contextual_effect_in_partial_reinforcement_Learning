function plot_figure_reward_dists(mu,sd,colors)

lwidth = 4;

x = [-50:1:150];
norm1 = normpdf(x,mu(1),sd(1));
norm2 = normpdf(x,mu(2),sd(2));
norm3 = normpdf(x,mu(3),sd(3));
norm4 = normpdf(x,mu(4),sd(4));


text_size = 36;

%% Draw real
subp = [2,1];

f = figure;
subplot(subp(1),subp(2),1);

p1 = plot(x,norm1); 
set(p1,...
    'Color',colors.real.A1.face,...
    'linewidth', lwidth);

hold on

p3 = plot(x,norm3);
set(p3,...
    'Color',colors.real.B.face,...
    'linewidth', lwidth);

xlim([0 100]);
% xlabel('Normal Distribution');

xticks([0 54 64 100]);
xticklabels({'0' '54' '64' '100'});

legend('A_1','B','location','NorthWest');
legend boxoff;

h = gca;
set(h, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , h.Parent.Color, ...
  'LineWidth'   , 1         );

set(gca,'FontName','Times New Roman', 'FontSize',text_size);%'Helvetica' );

%--------------------------------------------------------------------------
subplot(subp(1),subp(2),2);
% f = figure;

p2 = plot(x,norm2); 
set(p2,...
    'Color',colors.real.A2.face,...
    'linewidth', lwidth);

hold on

p4 = plot(x,norm4);
set(p4,...
    'Color',colors.real.C.face,...
    'linewidth', lwidth);

xlim([0 100]);
% xlabel('Normal Distribution');

xticks([0 44 64 100]);
xticklabels({'0' '44' '64' '100'});


legend('A_2','C','location','NorthWest');
legend boxoff;

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , h.Parent.Color, ...
  'LineWidth'   , 1         );

name = strcat('Figures/fig_dists1.png');
saveas(gcf,name); 
% close(f);

set(gca,'FontName','Times New Roman', 'FontSize',text_size);%'Helvetica' );


