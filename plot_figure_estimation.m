function plot_figure_estimation(addr,ftype,config,sbjs,colors)


load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Transfer.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Estimation.mat']);

%--------------------------------------------------------------------------
FC              = info_learning.statistics.normal.FC;
FCCF            = info_learning.statistics.normal.FCCF;
Values          = info_estimation.valuation.estimate;
Variations      = info_estimation.variation.estimate;
vtype           = config.vtype;
nsub            = size(sbjs.indx,2);

%--------------------------------------------------------------------------
uniNames = {'A_1','A_2','B','C'};

text_size = 18;

%-scatter
scat_size               = 20;
scat_jitter             = 0.2;

%% Valuation
%--------------------------------------------------------------------------
mEstim          = mean(Values(:,vtype,sbjs.indx),3);
sEstim          = std( Values(:,vtype,sbjs.indx),0,3)/sqrt(nsub);

mExprFC         = mean(FC.mean(sbjs.indx,:),1);
sExprFC         = std( FC.mean(sbjs.indx,:),0,1)/sqrt(nsub);

mExprFCCF       = mean(FCCF.mean(sbjs.indx,:),1);
sExprFCCF       = std(FCCF.mean(sbjs.indx,:),0,1)/sqrt(nsub); 

%-four stimlui in Partial Version
%--------------------------------------------------------------------------
if isequal(ftype,'Partial')
    mExpr  = mExprFC; 
elseif isequal(ftype,'Complete')
    mExpr  = mExprFCCF;
end

%--------------------------------------------------------------------------
f  = figure;
x  = [1:4];

plot(x,[repmat(0,1,4)]);

hold on

% ys = mExpr;
% s  = scatter(x,ys,125);
% set(s, ...
%     'MarkerFaceColor', [0 0 0],...
%     'MarkerEdgeColor', [0 0 0] );

%-bar chart
%--------------------------------------------------------------------------
yb = mEstim;
bar(1, yb(1), 'facecolor', colors.real.A1.face);    
hold on  
bar(2, yb(2), 'facecolor', colors.real.A2.face);    
hold on     
bar(3, yb(3), 'facecolor', colors.real.B.face);    
hold on  
bar(4, yb(4), 'facecolor', colors.real.C.face);    
hold on


%-scatter
%--------------------------------------------------------------------------
hold on

dataY(:,:) = Values(:,vtype,sbjs.indx);
dataY = dataY';
dataX = repmat(1:4,length(dataY),1);
scat  = scatter(dataX(:) ,dataY(:) ,scat_size,'jitter','on','jitterAmount',scat_jitter);%,'filled'

set(scat                                     , ...
  'LineWidth'        , 1                     , ...
  'Marker'           , 'o'                   , ...
  'MarkerEdgeColor'  , colors.scatter        , ...
  'MarkerFaceColor'  , colors.scatter        );



%-error bar
%--------------------------------------------------------------------------
ye = mEstim;
se = sEstim;
errorbar(x, [ye],[se],'Color',colors.error,'LineStyle','none','LineWidth',3);


%--------------------------------------------------------------------------
c = [0 0.1 0];
w = 4;

z = [0.5 1.475];
plot(z,repmat(64,1,size(z,2)),'Color',colors.real.A1.face-c,'LineStyle','-','LineWidth',w);
hold on

z = [1.525 2.5];
plot(z,repmat(64,1,size(z,2)),'Color',colors.real.A2.face-c,'LineStyle','-','LineWidth',w);
hold on
  
z = [2.5 3.5];
plot(z,repmat(54,1,size(z,2)),'Color',colors.real.B.face-c,'LineStyle','-','LineWidth',w);
hold on

z = [3.5 4.5];
plot(z,repmat(44,1,size(z,2)),'Color',colors.real.C.face-c,'LineStyle','-','LineWidth',w);
hold on


ylim([0 100]);
ylabel('Estimated Value');

set(gca, 'XTickLabel', '')
xlabetxt = uniNames;
ypos     = min(ylim)-5;
text(x+0.1,repmat(ypos,4,1),xlabetxt',...
        'horizontalalignment','right',...
        'FontSize',18,...
        'FontName','Times New Roman');

set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.0005 .0005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'on'      , ...
    'YTick'       , [0 44 54 64 100],    ...
    'LineWidth'   , 1         ,...
    'FontName','Times New Roman',...
    'FontSize',text_size);


% nameRate = strcat('Figures/pop_Values_',ftype,'.png');
% saveas(gcf,nameRate);
% close();


%%

%-Two stimlui in Partial Version
%--------------------------------------------------------------------------
if isequal(ftype,'Partial')
    mExpr  = mExprFC; 
elseif isequal(ftype,'Complete')
    mExpr  = mExprFCCF;
end

%--------------------------------------------------------------------------
f  = figure;
x  = [1:2];

plot(x,[repmat(0,1,2)]);

hold on

% ys = mExpr;
% s  = scatter(x,ys,125);
% set(s, ...
%     'MarkerFaceColor', [0 0 0],...
%     'MarkerEdgeColor', [0 0 0] );

%-bar chart
%--------------------------------------------------------------------------
yb = mEstim;
bar(1, yb(1), 'facecolor', colors.real.A1.face);    
hold on  
bar(2, yb(2), 'facecolor', colors.real.A2.face);    
hold on     


%-scatter
%--------------------------------------------------------------------------
hold on

dataY = [];
dataY(:,:) = Values(1:2,vtype,sbjs.indx);
dataY = dataY';
dataX = repmat(1:2,length(dataY),1);
scat  = scatter(dataX(:) ,dataY(:) ,scat_size,'jitter','on','jitterAmount',scat_jitter);%,'filled'

set(scat                                     , ...
  'LineWidth'        , 1                     , ...
  'Marker'           , 'o'                   , ...
  'MarkerEdgeColor'  , colors.scatter        , ...
  'MarkerFaceColor'  , colors.scatter        );



%-error bar
%--------------------------------------------------------------------------
ye = mEstim(1:2);
se = sEstim(1:2);
errorbar(x, [ye],[se],'Color',colors.error,'LineStyle','none','LineWidth',3);


%--------------------------------------------------------------------------
c = [0 0.1 0];
w = 4;

z = [0.5 1.475];
plot(z,repmat(64,1,size(z,2)),'Color',colors.real.A1.face-c,'LineStyle','-','LineWidth',w);
hold on

z = [1.525 2.5];
plot(z,repmat(64,1,size(z,2)),'Color',colors.real.A2.face-c,'LineStyle','-','LineWidth',w);
hold on

ylim([0 100]);
ylabel('Estimated Value');

set(gca, 'XTickLabel', '')
xlabetxt = uniNames(1:2);
ypos     = min(ylim)-5;
text(x+0.1,repmat(ypos,2,1),xlabetxt',...
        'horizontalalignment','right',...
        'FontSize',18,...
        'FontName','Times New Roman');

set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'in'     , ...
    'TickLength'  , [.0005 .0005] , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'XGrid'       , 'off'      , ...
    'YGrid'       , 'on'      , ...
    'YTick'       , [0 44 54 64 100],    ...
    'LineWidth'   , 1         ,...
    'FontName','Times New Roman',...
    'FontSize',text_size);


% nameRate = strcat('Figures/pop_Values_',ftype,'.png');
% saveas(gcf,nameRate);
% close();




