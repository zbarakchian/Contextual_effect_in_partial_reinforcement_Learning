function plot_figure_simulation_performance(addr,ftype,model,colors)



plot_task                       = 1;
plot_beta                       = 0;
plot_alpha1                     = 0;
plot_alpha2                     = 0;
plot_beta_a2var                 = 0;
plot_colormap                   = 0; %imp
plot_noise_relative_perf        = 0; 
plot_noise_shaded_full          = 0; %for every alpha2
plot_noise_shaded_part          = 0; %for alpha2=0, and alpha2=alpha1
plot_noise_mean                 = 0;
plot_noise_std                  = 0;
plot_noise_both                 = 0;
plot_noise_frac_musd            = 0;




dosave                          = 0;
doclose                         = 0;


%% config
sd        = [1 1];
mu1       = [10 9; 10 8; 10 7; 10 6; 10 5; 10 4; 10 3; 10 2; 10 1; 10 0;];
alphas1   = [0.1:0.1:1];
betas     = [0:0.025:0.4 0.5:0.1:1]; 

indx = 0;
for a1 = alphas1 
    tmp = [0];
    a2 = 0;
    for i = 1:10
        d = a1*power((1/2),i);
        a2 = a2 + d;
        tmp = [tmp; a2];
    end
    tmp  = [tmp; a1];
    indx = indx + 1;
    alphas2{indx} = tmp;
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


ratioa2a1 = [];
for a1 = 1:length(alphas1)
    for a2 = 1:length(alphas2{a1})
        ratioa2a1(a1,a2) = alphas2{a1}(a2)/alphas1(a1);        
    end
end
% disp(ratioa2a1);        


%% Draw figures
load([addr.optimal filesep 'square_perf_' ftype '.mat']);
square_perf       = matrix;
square_perf_mean  = square_perf.mean ./ 1000; %ntrials = 1000
square_perf_std   = square_perf.std  ./ 1000; %ntrials = 1000


%% task
%--------------------------------------------------------------------------
if plot_task

beta = [1 2 5 10 15 18 20 23];   
for b = beta
    
fig = figure;

indx = 1; y = [];
for tsk = 1:size(mu1,1)    
    sqsize    = size(square_perf_mean);
    y(:,indx) = reshape(square_perf_mean(:,:,b,tsk),[sqsize(1)*sqsize(2),1]);
    indx      = indx + 1;
end
s  = shadedErrorBar([1:10],y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1,'Marker','o','Color',colors.puresim});

g{1} = gca;
set(g{1}, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'LineWidth'   , 1         );
%     'YTick'       , []        , ...


ylim([0.5 1]);
xlabel('condition');
ylabel('performance');
title(['beta = ' num2str(betas(b))],'FontSize',15);

if dosave
    name = ['Figures/' 'optimal_task_beta' num2str(betas(b)) '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end

end
end

%% beta
%--------------------------------------------------------------------------
if plot_beta
    
task = [1:10];
for tsk = task
    
fig = figure;

indx = 1; y = [];
for b = 1:length(betas)
    sqsize    = size(square_perf_mean);
    y(:,indx) = reshape(square_perf_mean(:,:,b,tsk),[sqsize(1)*sqsize(2),1]);
    indx      = indx + 1;
end
s  = shadedErrorBar(betas,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1,'Marker','o','Color',colors.puresim});


g{2} = gca;
set(g{2}, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'LineWidth'   , 1         );
    
ylim([0.5 1]);
xlabel('beta');
ylabel('performance');
title(['option1 = N(' num2str(mu1(tsk,1)) ',1) , option2 = N(' num2str(mu1(tsk,2)) ',1)']);

if dosave
    name = ['Figures/' 'optimal_beta_task_' num2str(tsk) '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end

end
end

%% beta for alpha2=0
%--------------------------------------------------------------------------
if plot_beta_a2var
    
task = 3;%[1:10];

for tsk = task
for a2  = 1:size(square_perf_mean,2)
   
fig = figure;

indx = 1; y = [];
for b = 1:length(betas)
    sqsize    = size(square_perf_mean);
    y(:,indx) = reshape(square_perf_mean(:,a2,b,tsk),[sqsize(1),1]);
    indx      = indx + 1;
end
s  = shadedErrorBar(betas,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1,'Marker','o','Color',colors.puresim});


g{2} = gca;
set(g{2}, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'LineWidth'   , 1         );
    
ylim([0.5 1]);
xlabel('beta');
ylabel('performance');
title(['option1 = N(' num2str(mu1(tsk,1)) ',1) , option2 = N(' num2str(mu1(tsk,2)) ',1)']);

if dosave
    name = ['Figures/' 'optimal_beta_task_' num2str(tsk) '_a2' num2str(a2) '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end

end
end
end


%% alpha1
%--------------------------------------------------------------------------
if plot_alpha1
    
task = 3;%[1:10];
beta = [1 2 5 10 15 18 20 23];% 5;

for tsk = task
for b   = beta
    
fig = figure;

indx = 1; y = [];
for a1 = 1:size(square_perf_mean,1)
    sqsize    = size(square_perf_mean);
    y(:,indx) = reshape(square_perf_mean(a1,:,b,tsk),[sqsize(2),1]);
    indx      = indx + 1;
end
s  = shadedErrorBar([],y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1,'Marker','o','Color',colors.puresim});


g{3} = gca;
set(g{3}, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'LineWidth'   , 1         );

ylim([0.5 1]);
xlabel('alpha1');
ylabel('performance');
title(['option1 = N(' num2str(mu1(tsk,1)) ',1) , option2 = N(' num2str(mu1(tsk,2)) ',1)' ' , beta = ' num2str(betas(b))]);

if dosave
    name = ['Figures/' 'optimal_alpha1_beta' num2str(betas(b)) '_task_' num2str(tsk) '.png'];
    saveas(gcf,name);
end
if doclose
    close(fig);
end

end
end
end


%% alpha2
%--------------------------------------------------------------------------
if plot_alpha2

task = 3;%[1:10];
beta = [1 2 5 10 15 18 20 23];% 5;

for tsk = task
for b   = beta

fig = figure;

indx = 1; y = [];
for a2 = 1:size(square_perf_mean,2)
    sqsize    = size(square_perf_mean);
    y(:,indx) = reshape(square_perf_mean(:,a2,b,tsk),[sqsize(1),1]);
    indx      = indx + 1;
end
s  = shadedErrorBar(alphas2{1}',y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1,'Marker','o','Color',colors.puresim});

g{4} = gca;
set(g{4}, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'LineWidth'   , 1         );

ylim([0.5 1]);
xlabel('alpha2');
ylabel('performance');
title(['option1 = N(' num2str(mu1(tsk,1)) ',1) , option2 = N(' num2str(mu1(tsk,2)) ',1)' ' , beta = ' num2str(betas(b))]);

if dosave 
    name = ['Figures/' 'optimal_alpha2_beta' num2str(betas(b)) '_task_' num2str(tsk) '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end

end
end
end

%% color map for alpha1 ande alpha2
%--------------------------------------------------------------------------
if plot_colormap
    
task                = 3;
beta                = 5;

for tsk = task
for b   = beta
    
disp([tsk,b]); 

fig = figure;
square_perf_mean(7,:,b,tsk) = square_perf_mean(6,:,b,tsk); %mean(square_perf_mean(6,:,b,tsk),square_perf_mean(8,:,b,tsk));

imagesc(square_perf_mean(:,:,b,tsk), 'CDataMapping', 'scaled');
cbar = colorbar;
set(cbar, 'ylim', [0 1]);

% cmap    = colormap(cool);
% cmap    = colormap(pink);
cmap    = colormap(jet);
cmap    = flipud(cmap);
colormap(cmap);


set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'LineWidth'   , 1         );


yticks([1:1:10]);
yticklabels({'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'});
xticks([1:1:12]);
xticklabels({ num2str(ratioa2a1(1,1)),num2str(ratioa2a1(1,2)),num2str(ratioa2a1(1,3)),'',num2str(ratioa2a1(1,5)),'',num2str(ratioa2a1(1,7)),'',num2str(ratioa2a1(1,9)),'',num2str(ratioa2a1(1,11)),num2str(ratioa2a1(1,12)) });

xlabel('\alpha_2/\alpha_1','FontSize',20);
ylabel('\alpha_1','FontSize',20);

set(gca,'FontName','Times New Roman','FontSize',14);%'Helvetica' );


if dosave
    name = ['Figures/' 'optimal_colormap' '_task_' num2str(tsk) 'beta' num2str(betas(b)) '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end

end
end
end


%% relative performance (LI2 - SQL) as a function of condition: different plots for different beta
%--------------------------------------------------------------------------
if plot_noise_relative_perf
 
beta = [1 2 5 10 15 18 20 23];% 5;

for a2 = 1:size(square_perf_mean,2)
    dif(:,a2,:,:) = square_perf_mean(:,a2,:,:) - square_perf_mean(:,1,:,:);
end    

indx = 1;
for b = beta   
    sqsize    = size(square_perf_mean);
    y(:,indx) = reshape(dif(:,:,b,:),[sqsize(1)*sqsize(2)*sqsize(4),1]);
    indx = indx + 1;
end

fig = figure;

x = betas(beta);
s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1,'Marker','o','Color',colors.puresim});

hold on

p = plot(x,repmat(0,1,length(x)));
set(p,...
    'Color', [96 96 96]/255,   ...
    'LineWidth',    2,         ...
    'LineStyle',    '--' ...
    );

g{1} = gca;
set(g{1}, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'LineWidth'   , 1         );


ylim([-0.3 0.3]);
xlabel('beta');
ylabel('performance');

if dosave
    name = ['Figures/' 'optimal_noise'  '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end

end

%% one plot: performance as a function of noise (beta) for different 0<=alpha2<=alpha1
%--------------------------------------------------------------------------
if plot_noise_shaded_full
    
colorss1 = [ ...           
            255 000 000; ...
            255 128 000; ...
            255 204 153; ...
            255 255 000; ...   
            204 255 153; ...   
            128 255 000; ...   
            000 255 000; ...   
            000 255 128; ...   
            000 255 255; ...   
            153 204 255; ...   
            000 128 255; ...   
            000 000 255; ...   
          ]./255;
   
n = size(colorss1,1);      
for i = 1:n
    colorss2(n-i+1,:) = colorss1(i,:);
end

colorss = colorss2;
%--------------------------------------------------------------------------
fig = figure;

beta = [1 2 5 10 15 18 20 23];% 5;
x = betas(beta);
m = size(square_perf_mean,2);

y_mean = [];
for a2 = 1:m
    
    absolute(:,:,:) = square_perf_mean(:,a2,:,:);
    absize = size(absolute);

    y = [];
    indx = 1;
    for b = beta   
        y(:,indx) = reshape(absolute(:,b,:),[absize(1)*absize(3),1]);
        indx = indx + 1;
    end
    y_mean(:,a2) = mean(y,1);
end


%--------------------------------------------------------------------------
for a2 = m
    
%     absolute(:,:,:) = square_perf_mean(:,a2,:,:);
    absolute(:,:,:) = square_perf_mean(:,m-a2+1,:,:);
    absize = size(absolute);

    y    = [];
    indx = 1;
    for b = beta   
        y(:,indx) = reshape(absolute(:,b,:),[absize(1)*absize(3),1]);
        indx = indx + 1;
    end


    s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colorss(a2,:)});
    component{a2} = s.mainLine;
    
    hold on
end

%--------------------------------------------------------------------------
for a2 = 2:m-1
% %     component{a2} = plot(x,y_mean(:,a2));
%     component{a2} = plot(x,y_mean(:,m-a2+1));
%     set(component{a2},...
%         'Color',        colorss(a2,:),   ...
%         'LineWidth',    2,         ...
%         'LineStyle',    '-' ...
%         );
    


%     absolute(:,:,:) = square_perf_mean(:,a2,:,:);
    absolute(:,:,:) = square_perf_mean(:,m-a2+1,:,:);
    absize = size(absolute);

    y    = [];
    indx = 1;
    for b = beta   
        y(:,indx) = reshape(absolute(:,b,:),[absize(1)*absize(3),1]);
        indx = indx + 1;
    end

        s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colorss(a2,:)});
        component{a2} = s.mainLine;

    
    hold on;
end


%--------------------------------------------------------------------------
for a2 = 1   
%     absolute(:,:,:) = square_perf_mean(:,a2,:,:);
    absolute(:,:,:) = square_perf_mean(:,m-a2+1,:,:);
    absize = size(absolute);

    y    = [];
    indx = 1;
    for b = beta   
        y(:,indx) = reshape(absolute(:,b,:),[absize(1)*absize(3),1]);
        indx = indx + 1;
    end


    s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colorss(a2,:)});
    component{a2} = s.mainLine;
    
    hold on
end

%--------------------------------------------------------------------------
hold on

p1 = plot(x,repmat(0.5,1,length(x)));
set(p1,...
    'Color', [0.8 0.8 0.8],   ...
    'LineWidth',    2,         ...
    'LineStyle',    '--' ...
    );

p2 = plot(x,repmat(1,1,length(x)));
set(p2,...
    'Color', [0.8 0.8 0.8],   ...
    'LineWidth',    2,         ...
    'LineStyle',    '--' ...
    );


%--------------------------------------------------------------------------
hLegend = legend( ...
  [component{1}, component{2} component{4} component{6} component{7} component{8} component{9} component{11} component{12}], ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,12))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,11))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,9))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,8))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,7))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,6))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,4))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,2))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,1))] , ...
  'location', 'SouthEast' );

legend boxoff;

set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'YTick'       , 0:0.5:1,    ...
    'LineWidth'   , 1         );


ylim([0.4 1.1]);
xlabel('\beta');
ylabel('performance');

% alpha(0.55);
set(gca,'FontName','Times New Roman');%'Helvetica' );


if dosave
    name = ['Figures/' 'optimal_noise'  '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end

end


%%
%--------------------------------------------------------------------------
if plot_noise_shaded_part
        
colorss1 = [ ...           
            255 000 000; ...
            255 128 000; ...
            255 204 153; ...
            255 255 000; ...   
            204 255 153; ...   
            128 255 000; ...   
            000 255 000; ...   
            000 255 128; ...   
            000 255 255; ...   
            153 204 255; ...   
            000 128 255; ...   
            000 000 255; ...   
          ]./255;
   
n = size(colorss1,1);      
for i = 1:n
    colorss2(n-i+1,:) = colorss1(i,:);
end
colorss = colorss2;

%--------------------------------------------------------------------------
fig = figure;
beta = [1 2 5 10 15 18 20 23];% 5;
x = betas(beta);
m = size(square_perf_mean,2);

y_mean = [];
for a2 = 1:m
    
    absolute(:,:,:) = square_perf_mean(:,a2,:,:);
    absize = size(absolute);

    y = [];
    indx = 1;
    for b = beta   
        y(:,indx) = reshape(absolute(:,b,:),[absize(1)*absize(3),1]);
        indx = indx + 1;
    end
    y_mean(:,a2) = mean(y,1);
end


%--------------------------------------------------------------------------
for a2 = m
    
    %absolute(:,:,:) = square_perf(:,a2,:,:);
    absolute(:,:,:) = square_perf_mean(:,m-a2+1,:,:);
    absize = size(absolute);

    y    = [];
    indx = 1;
    for b = beta   
        y(:,indx) = reshape(absolute(:,b,:),[absize(1)*absize(3),1]);
        indx = indx + 1;
    end
    
    s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colorss(a2,:)});
    component{a2} = s.mainLine;
    
    hold on
end

%--------------------------------------------------------------------------
for a2 = 2:m-1
%     component{a2} = plot(x,y_mean(:,a2));
    component{a2} = plot(x,y_mean(:,m-a2+1));
    set(component{a2},...
        'Color',        colorss(a2,:),   ...
        'LineWidth',    2,         ...
        'LineStyle',    '-' ...
        );
    


% %     absolute(:,:,:) = square_perf_mean(:,a2,:,:);
%     absolute(:,:,:) = square_perf_mean(:,m-a2+1,:,:);
%     absize = size(absolute);
% 
%     y    = [];
%     indx = 1;
%     for b = beta   
%         y(:,indx) = reshape(absolute(:,b,:),[absize(1)*absize(3),1]);
%         indx = indx + 1;
%     end
% 
%         s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colorss(a2,:)});
%         component{a2} = s.mainLine;

    
    hold on;
end


%--------------------------------------------------------------------------
for a2 = 1   
%     absolute(:,:,:) = square_perf_mean(:,a2,:,:);
    absolute(:,:,:) = square_perf_mean(:,m-a2+1,:,:);
    absize = size(absolute);

    y    = [];
    indx = 1;
    for b = beta   
        y(:,indx) = reshape(absolute(:,b,:),[absize(1)*absize(3),1]);
        indx = indx + 1;
    end


    s  = shadedErrorBar(x,y,{@nanmean,@nanstd}, 'lineprops',{'LineStyle','-','LineWidth',1.5,'Color',colorss(a2,:)});
    component{a2} = s.mainLine;
    
    hold on
end

%--------------------------------------------------------------------------
hold on

p1 = plot(x,repmat(0.5,1,length(x)));
set(p1,...
    'Color', [0.8 0.8 0.8],   ...
    'LineWidth',    2,         ...
    'LineStyle',    '--' ...
    );

p2 = plot(x,repmat(1,1,length(x)));
set(p2,...
    'Color', [0.8 0.8 0.8],   ...
    'LineWidth',    2,         ...
    'LineStyle',    '--' ...
    );


%--------------------------------------------------------------------------
hLegend = legend( ...
  [component{1}, component{2} component{4} component{6} component{7} component{8} component{9} component{11} component{12}], ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,12))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,11))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,9))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,8))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,7))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,6))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,4))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,2))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,1))] , ...
  'location', 'SouthEast' );

legend boxoff;

set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'YTick'       , 0:0.5:1,    ...
    'LineWidth'   , 1         );


ylim([0.4 1.1]);
xlabel('\beta');
ylabel('performance');

% alpha(0.55);
set(gca,'FontName','Times New Roman');%'Helvetica' );


if dosave
    name = ['Figures/' 'optimal_noise'  '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end

end

%%
%--------------------------------------------------------------------------
if plot_noise_mean
colorss1 = [ ...           
            255 000 000; ...
            255 128 000; ...
            255 204 153; ...
            255 255 000; ...   
            204 255 153; ...   
            128 255 000; ...   
            000 255 000; ...   
            000 255 128; ...   
            000 255 255; ...   
            153 204 255; ...   
            000 128 255; ...   
            000 000 255; ...   
          ]./255;
   
n = size(colorss1,1);      
for i = 1:n
    colorss2(n-i+1,:) = colorss1(i,:);
end
colorss = colorss2;

%--------------------------------------------------------------------------
fig = figure;
beta = [1 2 5 10 15 18 20 23];% 5;
x = betas(beta);
m = size(square_perf_mean,2);

y_mean = [];
for a2 = 1:m
    
    absolute(:,:,:) = square_perf_mean(:,a2,:,:);
    absize = size(absolute);

    y = [];
    indx = 1;
    for b = beta   
        y(:,indx) = reshape(absolute(:,b,:),[absize(1)*absize(3),1]);
        indx = indx + 1;
    end
    y_mean(:,a2) = mean(y,1);
end




%--------------------------------------------------------------------------
for a2 = 1:m
    %component{a2} = plot(x,y_mean(:,a2));
    component{a2} = plot(x,y_mean(:,m-a2+1));
    set(component{a2},...
        'Color',        colorss(a2,:),   ...
        'LineWidth',    2,         ...
        'LineStyle',    '-' ...
        );
        
    hold on;
end

%--------------------------------------------------------------------------
hold on

p1 = plot(x,repmat(0.5,1,length(x)));
set(p1,...
    'Color', [0.8 0.8 0.8],   ...
    'LineWidth',    2,         ...
    'LineStyle',    '--' ...
    );

p2 = plot(x,repmat(1,1,length(x)));
set(p2,...
    'Color', [0.8 0.8 0.8],   ...
    'LineWidth',    2,         ...
    'LineStyle',    '--' ...
    );


%--------------------------------------------------------------------------
hLegend = legend( ...
  [component{1}, component{2} component{4} component{6} component{7} component{8} component{9} component{11} component{12}], ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,12))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,11))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,9))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,8))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,7))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,6))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,4))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,2))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,1))] , ...
  'location', 'SouthEast' );

legend boxoff;

set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'YTick'       , 0:0.5:1,    ...
    'LineWidth'   , 1         );


ylim([-0.1 1.1]);
xlabel('\beta');
ylabel('performance(\mu)');

% alpha(0.55);
set(gca,'FontName','Times New Roman');%'Helvetica' );


if dosave
    name = ['Figures/' 'optimal_noise'  '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end
end


%%
%--------------------------------------------------------------------------
if plot_noise_std
colorss1 = [ ...           
            255 000 000; ...
            255 128 000; ...
            255 204 153; ...
            255 255 000; ...   
            204 255 153; ...   
            128 255 000; ...   
            000 255 000; ...   
            000 255 128; ...   
            000 255 255; ...   
            153 204 255; ...   
            000 128 255; ...   
            000 000 255; ...   
          ]./255;
   
n = size(colorss1,1);      
for i = 1:n
    colorss2(n-i+1,:) = colorss1(i,:);
end
colorss = colorss2;

%--------------------------------------------------------------------------
fig = figure;
beta = [1 2 5 10 15 18 20 23];% 5;
x = betas(beta);
m = size(square_perf_std,2);

y_mean = [];
for a2 = 1:m
    
    absolute(:,:,:) = square_perf_std(:,a2,:,:);
    absize = size(absolute);

    y = [];
    indx = 1;
    for b = beta   
        y(:,indx) = reshape(absolute(:,b,:),[absize(1)*absize(3),1]);
        indx = indx + 1;
    end
    y_mean(:,a2) = mean(y,1);
end




%--------------------------------------------------------------------------
for a2 = 1:m
    %component{a2} = plot(x,y_mean(:,a2));
    component{a2} = plot(x,y_mean(:,m-a2+1));
    set(component{a2},...
        'Color',        colorss(a2,:),   ...
        'LineWidth',    2,         ...
        'LineStyle',    '-' ...
        );
        
    hold on;
end

%--------------------------------------------------------------------------
hold on

p1 = plot(x,repmat(0.5,1,length(x)));
set(p1,...
    'Color', [0.8 0.8 0.8],   ...
    'LineWidth',    2,         ...
    'LineStyle',    '--' ...
    );

p2 = plot(x,repmat(0,1,length(x)));
set(p2,...
    'Color', [0.8 0.8 0.8],   ...
    'LineWidth',    2,         ...
    'LineStyle',    '--' ...
    );


%--------------------------------------------------------------------------
% hLegend = legend( ...
%   [component{1}, component{2} component{4} component{6} component{7} component{8} component{9} component{11} component{12}], ...
%   ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,12))] , ...
%   ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,11))] , ...
%   ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,9))] , ...
%   ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,8))] , ...
%   ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,7))] , ...
%   ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,6))] , ...
%   ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,4))] , ...
%   ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,2))] , ...
%   ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,1))] , ...
%   'location', 'SouthEast' );
% 
% legend boxoff;

set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'YTick'       , 0:0.5:1,    ...
    'LineWidth'   , 1         );


ylim([-0.1 1.1]);
xlabel('\beta');
ylabel('performance(\sigma)');

% alpha(0.55);
set(gca,'FontName','Times New Roman');%'Helvetica' );


if dosave
    name = ['Figures/' 'optimal_noise'  '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end
end





%%
%--------------------------------------------------------------------------
if plot_noise_both
 
task                = 3;
beta                = [1 2 5 10 15 18 20 23];
    
text_size = 18;

colorss1 = [ ...           
            255 000 000; ...
            255 128 000; ...
            255 204 153; ...
            255 255 000; ...   
            204 255 153; ...   
            128 255 000; ...   
            000 255 000; ...   
            000 255 128; ...   
            000 255 255; ...   
            153 204 255; ...   
            000 128 255; ...   
            000 000 255; ...   
          ]./255;
   
n = size(colorss1,1);      
for i = 1:n
    colorss2(n-i+1,:) = colorss1(i,:);
end
colorss = colorss1;

%--------------------------------------------------------------------------
fig = figure;
x   = betas(beta);
m   = size(square_perf_mean,2);

y1_mean = [];
y2_mean = [];
for a2 = 1:m
    
    absolute_mean(:,:,:) = square_perf_mean(:,a2,:,:);
    absolute_std(:,:,:)  = square_perf_std (:,a2,:,:);
    absize = size(absolute_mean);

    y1 = []; y2 = [];
    indx = 1;
    for b = beta   
        y1(:,indx) = reshape(absolute_mean(:,b,:),[absize(1)*absize(3),1]);
        y2(:,indx) = reshape(absolute_std (:,b,:),[absize(1)*absize(3),1]);
        indx = indx + 1;
    end
    y1_mean(:,a2) = mean(y1,1);
    y2_mean(:,a2) = mean(y2,1);
end




%--------------------------------------------------------------------------
for a2 = 1:m
    component{a2} = plot(x,y1_mean(:,a2));
    %component{a2} = plot(x,y1_mean(:,m-a2+1));
    set(component{a2},...
        'Color',        colorss(a2,:),   ...
        'LineWidth',    2,         ...
        'LineStyle',    '-' ...
        );
        
    hold on;
end

%--------------------------------------------------------------------------
for a2 = 1:m
    component{a2} = plot(x,y2_mean(:,a2));
    %component{a2} = plot(x,y2_mean(:,m-a2+1));
    set(component{a2},...
        'Color',        colorss(a2,:),   ...
        'LineWidth',    2,         ...
        'LineStyle',    '-' ...
        );
        
    hold on;
end

%--------------------------------------------------------------------------
hold on

p0 = plot(x,repmat(0,1,length(x)));
set(p0,...
    'Color', [0.8 0.8 0.8],   ...
    'LineWidth',    2,         ...
    'LineStyle',    '--' ...
    );

p1 = plot(x,repmat(0.5,1,length(x)));
set(p1,...
    'Color', [0.8 0.8 0.8],   ...
    'LineWidth',    2,         ...
    'LineStyle',    '--' ...
    );

p2 = plot(x,repmat(1,1,length(x)));
set(p2,...
    'Color', [0.8 0.8 0.8],   ...
    'LineWidth',    2,         ...
    'LineStyle',    '--' ...
    );


%--------------------------------------------------------------------------
hLegend = legend( ...
  [component{1}, component{2} component{4} component{6} component{7} component{8} component{9} component{11} component{12}], ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,1))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,2))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,4))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,6))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,7))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,8))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,9))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,11))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,12))] , ...
  'location', 'northoutside','NumColumns',3 );

legend boxoff;

set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'YTick'       , 0:0.5:1,    ...
    'LineWidth'   , 1         );


ylim([-0.1 1.1]);
xlabel('\beta');
ylabel('performance');%(\mu,\sigma)');

% alpha(0.55);
set(gca,'FontName','Times New Roman','FontSize',text_size);%'Helvetica' );


if dosave
    name = ['Figures/' 'optimal_noise'  '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end
end



%%
%--------------------------------------------------------------------------
if plot_noise_frac_musd
 
task                = 3;
beta                = [1 2 5 10 15 18 20 23];
    
text_size = 18;

colorss1 = [ ...           
            255 000 000; ...
            255 128 000; ...
            255 204 153; ...
            255 255 000; ...   
            204 255 153; ...   
            128 255 000; ...   
            000 255 000; ...   
            000 255 128; ...   
            000 255 255; ...   
            153 204 255; ...   
            000 128 255; ...   
            000 000 255; ...   
          ]./255;
   
n = size(colorss1,1);      
for i = 1:n
    colorss2(n-i+1,:) = colorss1(i,:);
end
colorss = colorss1;

%--------------------------------------------------------------------------
fig = figure;
x   = betas(beta);
m   = size(square_perf_mean,2);

y1_mean = [];
y2_mean = [];
for a2 = 1:m
    
    absolute_mean(:,:,:) = square_perf_mean(:,a2,:,:);
    absolute_std(:,:,:)  = square_perf_std (:,a2,:,:);
    absize = size(absolute_mean);

    y1 = []; y2 = [];
    indx = 1;
    for b = beta   
        y1(:,indx) = reshape(absolute_mean(:,b,:),[absize(1)*absize(3),1]);
        y2(:,indx) = reshape(absolute_std (:,b,:),[absize(1)*absize(3),1]);
        indx = indx + 1;
    end
    y1_mean(:,a2) = mean(y1,1);
    y2_mean(:,a2) = mean(y2,1);
end




%--------------------------------------------------------------------------
y3_mean = y1_mean./y2_mean;
for a2 = 1:m
    component{a2} = plot(x,y3_mean(:,a2));
    %component{a2} = plot(x,y1_mean(:,m-a2+1));
    set(component{a2},...
        'Color',        colorss(a2,:),   ...
        'LineWidth',    2,         ...
        'LineStyle',    '-' ...
        );
        
    hold on;
end

%--------------------------------------------------------------------------
% for a2 = 1:m
%     component{a2} = plot(x,y2_mean(:,a2));
%     %component{a2} = plot(x,y2_mean(:,m-a2+1));
%     set(component{a2},...
%         'Color',        colorss(a2,:),   ...
%         'LineWidth',    2,         ...
%         'LineStyle',    '-' ...
%         );
%         
%     hold on;
% end

%--------------------------------------------------------------------------
% hold on
% 
% p0 = plot(x,repmat(0,1,length(x)));
% set(p0,...
%     'Color', [0.8 0.8 0.8],   ...
%     'LineWidth',    2,         ...
%     'LineStyle',    '--' ...
%     );
% 
% p1 = plot(x,repmat(0.5,1,length(x)));
% set(p1,...
%     'Color', [0.8 0.8 0.8],   ...
%     'LineWidth',    2,         ...
%     'LineStyle',    '--' ...
%     );
% 
% p2 = plot(x,repmat(1,1,length(x)));
% set(p2,...
%     'Color', [0.8 0.8 0.8],   ...
%     'LineWidth',    2,         ...
%     'LineStyle',    '--' ...
%     );


%--------------------------------------------------------------------------
hLegend = legend( ...
  [component{1}, component{2} component{4} component{6} component{7} component{8} component{9} component{11} component{12}], ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,1))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,2))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,4))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,6))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,7))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,8))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,9))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,11))] , ...
  ['\alpha_2 / \alpha_1 = ' num2str(ratioa2a1(1,12))] , ...
  'location', 'northoutside','NumColumns',3 );

legend boxoff;

set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'off'      , ... %    'YTick'       , 0:0.5:1,    ...
    'LineWidth'   , 1         );


% ylim([-0.1 1.1]);
xlabel('\beta');
ylabel('performance');%(\mu,\sigma)');

% alpha(0.55);
set(gca,'FontName','Times New Roman','FontSize',text_size);%'Helvetica' );


if dosave
    name = ['Figures/' 'optimal_noise'  '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end
end


end







