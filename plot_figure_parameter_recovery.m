function plot_figure_parameter_recovery(addr,ftype,model,colors)

dosave  = 0;
doclose = 0;

plot_heatmap = 0;
plot_scatter = 1;


fontsize_legend = 22;
fontsize_gca    = 18;
fontsize_txt    = 26;
%%

load([addr.precovery filesep 'parameter_recovery_',ftype]);

%%
% beta  = [RHO1 0 0];
% alpha = [0 RHO2 0];
% w     = [0 0 RHO3];
% tbl   = table(beta,alpha,w);
% h     = heatmap(tbl,'initial','recovered');

%%
%--------------------------------------------------------------------------
if plot_heatmap
    
fig = figure;

matrix.fr = correlation.fr.(model.name); %fitted vs recovered
matrix.ff = correlation.ff.(model.name); %fitted vs fitted
matrix.rr = correlation.rr.(model.name); %recovered vs recovered

matrix_mixed = [];
for i = 1:size(matrix.fr,1)
for j = 1:size(matrix.fr,2)
    if i == j
        matrix_mixed(i,j) = matrix.fr(i,j);
    else
        matrix_mixed(i,j) = matrix.ff(i,j);
    end
end
end

switch model.name
    case 'LI1'
        xvalues = {'\beta','\alpha'};
    case 'LI2'
        xvalues = {'\beta','\alpha_1','\alpha_2'};
    case 'HL1'
        xvalues = {'\beta','\alpha','w'};
    case 'HL2'
        xvalues = {'\beta','\alpha_1','\alpha_2','w'};
end
yvalues = xvalues;

h = heatmap(xvalues,yvalues,matrix_mixed(:,:,1),'FontSize', fontsize_txt);
caxis(h,[-1 1]); 

cmap = polarmap(cool,1);
colormap(cmap);

% h.Title  = 'Parameters Correlations';
% h.YLabel = 'fitted';
% h.XLabel = 'recovered';



set(gca,'FontName','Times New Roman','FontSize',fontsize_gca);%'Helvetica' );

if dosave
    name = ['Figures/' 'precovery_' ftype '_' model.name '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end
end

%%
%--------------------------------------------------------------------------
if plot_scatter
cor_matrix = correlation.fr.(model.name); %fitted vs recovered
    
color.Partial  = [ 000 102 051; 
                   000 204 102;
                   102 204 000;
                   051 255 051; %254 255 229
                 ]./255;

color.Complete = [ 102 051 000; 
                   255 128 000;
                   255 178 102;
                   255 229 204;
                  ]./255;

old = parameters.(model.name).old; 
new = parameters.(model.name).new; 

fig = figure;

for p = 1:size(old,2)
    
    x = old(:,p);
    y = new(:,p);
    
    s{p} = scatter(x,y); 
    set(s{p}                                 , ...
      'LineWidth'        , 2                 , ...
      'Marker'           , 'o'               , ...
      'MarkerEdgeColor'  , color.(ftype)(p,:), ...  
      'MarkerFaceColor'  , color.(ftype)(p,:));

    hold on    
end

l = lsline;


for p = 1:size(old,2)
    set(l(p) ,...
       'Color',color.(ftype)(p,:),...
       'LineWidth',1,...
       'LineStyle','-'); 

    m = (l(p).YData(2)-l(p).YData(1))/(l(p).XData(2)-l(p).XData(1));
%     x_txt = 0.4 + rand*3/10;
    x_txt = 0.5 + (p-1)/20;
    y_txt = l(p).XData(1) + m * x_txt;

    txt = num2str(cor_matrix(p,p));
    t = text(x_txt,y_txt,txt);
    
    l(p).XData(2) = 1;
    l(p).YData(2) = l(p).XData(1) + m * l(p).XData(2);
    
    set(t, ...
        'FontSize', fontsize_txt, ...
        'Color',color.(ftype)(p,:),...
        'FontName','Times New Roman',...
        'FontWeight','bold');
    
end

xlim([0 1]);
ylim([0 1]);
xlabel('Fitted');
ylabel('Recovered');   

   
switch model.parameters.num
    
    case 2
        hLegend = legend( ...
          [s{1}, s{2}], ...
          ['\beta'], ['\alpha'], ...
          'FontSize', 14, ...
          'FontName','Times New Roman',...
          'location', 'NorthWest' );
      
    case 3
        if strcmp(ftype,'Partial')

        hLegend = legend( ...
          [s{1}, s{2}, s{3}], ...
          ['\beta'], ['\alpha_1'], ['\alpha_2'], ...
          'FontSize', fontsize_legend, ...
          'location', 'NorthWest' );
          'FontName','Times New Roman',...
      
        elseif strcmp(ftype,'Complete')
            
        hLegend = legend( ...
          [s{1}, s{2}, s{3}], ...
          ['\beta'], ['\alpha'], ['w'], ...
          'FontSize', fontsize_legend, ...
          'FontName','Times New Roman',...
          'location', 'NorthWest' );
        end
        
    case 4
        hLegend = legend( ...
          [s{1}, s{2}, s{3}, s{4}], ...
          ['\beta'], ['\alpha_1'], ['\alpha_2'], ['w'], ...
          'FontSize', fontsize_legend, ...
          'FontName','Times New Roman',...
          'location', 'NorthWest' );
end
legend boxoff;

set(gca, ...
    'Box'         , 'on'        , ...
    'TickDir'     , 'in'        , ...
    'TickLength'  , [.005 .005] , ...
    'XMinorTick'  , 'off'       , ...
    'YMinorTick'  , 'off'       , ...
    'XColor'      , [.3 .3 .3]  , ...
    'YColor'      , [.3 .3 .3]  , ...
    'XGrid'       , 'off'       , ...
    'YGrid'       , 'off'       , ...
    'LineWidth'   , 1           , ...
    'FontName','Times New Roman', ...  %'Helvetica' );
    'FontSize', fontsize_gca);


if dosave
    name = ['Figures/' 'precovery_' ftype '_' model.name '.png'];
    saveas(gcf,name);
end

if doclose
    close(fig);
end
end





