function plot_figure_reward_dists()


mu1 = 10;
sd1 = 2;
mu2 = 0;
sd2 = 2;
mu3 = 0;
sd3 = 1;


x = [-50:.1:50];


colors.A = [.5 .5 .5];
colors.B = [1 1 1];


lwidth = 4;

limx = [-10 20];
limy = [0 .45];

tickx = [ 0 10];
tlabelx = { '0' '\mu'};

%% Draw real
subp = [3,1];
f = figure;

%--------------------------------------------------------------------------
subplot(subp(1),subp(2),1);
norm1 = normpdf(x,mu1,sd1);

p1 = plot(x,norm1); 
set(p1,...
    'Color',colors.A,...
    'linewidth', lwidth);


xlim(limx);
ylim(limy);
% xlabel('Normal Distribution');

xticks(tickx);
xticklabels(tlabelx);


h = gca;
set(h, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , h.Parent.Color, ...
  'LineWidth'   , 1         );

%--------------------------------------------------------------------------
subplot(subp(1),subp(2),2);

norm2 = normpdf(x,mu2,sd2);

p2 = plot(x,norm2); 
set(p2,...
    'Color',colors.A,...
    'linewidth', lwidth);


xlim(limx);
ylim(limy);

xticks(tickx);
xticklabels(tlabelx);


set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , h.Parent.Color, ...
  'LineWidth'   , 1         );



set(gca,'FontName','Times New Roman');%'Helvetica' );


%--------------------------------------------------------------------------
subplot(subp(1),subp(2),3);

x3 = [-10:0.1:10];
norm3 = normpdf(x,mu3,sd3);

p3 = plot(x,norm3); 
set(p3,...
    'Color',colors.A,...
    'linewidth', lwidth);


xlim(limx);
ylim(limy);
xlabel('Normal Distribution');

xticks(tickx);
xticklabels(tlabelx);


set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , h.Parent.Color, ...
  'LineWidth'   , 1         );



set(gca,'FontName','Times New Roman');%'Helvetica' );

%--------------------------------------------------------------------------

%%

f = figure;
norm3 = normpdf(x,mu3,sd3);

p1 = plot(x,norm3); 
set(p1,...
    'Color','b',...
    'linewidth', lwidth);


xlim([-5 5]);
ylim([0 .5]);

xticks([0]);
xticklabels({''});


h = gca;
set(h, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , h.Parent.Color, ...
  'LineWidth'   , 1         );


%%
mu = [64 64 54 44];
sd = [13 13 13 13];
colors.C = 'r';


x = [-50:1:150];
norm1 = normpdf(x,mu(1),sd(1));


f = figure;
p1 = plot(x,norm1); 
set(p1,...
    'Color',colors.C,...
    'linewidth', lwidth);


xlim([0 130]);
% xlabel('Normal Distribution');

xticks([64]);
xticklabels({''});



h = gca;
set(h, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , h.Parent.Color, ...
  'LineWidth'   , 1         );


