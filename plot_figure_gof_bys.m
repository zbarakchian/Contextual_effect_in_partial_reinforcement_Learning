function  plot_figure_gof_bys(addr,ftype,config_fit,sbjs,models,colors)



bms_results = do_gof_bysn(addr,ftype,config_fit,sbjs,models,1);

%% plot bar charts

nmodel = length(models);
data_xp   = bms_results.xp;
data_pxp  = bms_results.pxp;
 
for m = 1:nmodel
    uniNames{m} = models{m}.name;   
end

% uniNames = {'SQL','QL_{21}','QL_{22}','FQL','RPA_1','RPA_2','RPM_1','RPM_2','SAC','EWA','Dif','Hyb','OL_1','OL_2'};
% uniNames = {'SQL','QL21','QL22','FQL','RPA1','RPA2','RPM1','RPM2','SAC','EWA','Dif','Hyb','OL1','OL2'};
% uniNames = {'SQL','FQL','RPD','RPA','RPM','SAC','EWA','Hyb','OL1','OL2'};

% uniNames = {'SQL','RP','Dif','Hyb','OL1','OL2'};
% uniNames = {'SQL','RP','Hyb','OL1','OL2'};

%----------------
figure;
subplot(2,1,1);

x = [1:nmodel];
y = data_xp;

b = bar(x, y);      
set(b, ...
    'FaceColor', colors.real.A1.face, ...
    'EdgeColor', colors.real.A1.face, ...
    'LineWidth', 1);

ylim([0 1]);
xlim([0 nmodel + 1]);
ylabel('xp');
% title('');


ylabetxt = uniNames;
xpos     = - 0.1; %min(ylim) - (max(ylim)-min(ylim))/30;
text([1:nmodel]+0.15, repmat(xpos,nmodel,1), ...
     ylabetxt','horizontalalignment','right','FontSize',10);

grid on;

set(gca, ...
'Box'         , 'off'     , ...
'TickDir'     , 'out'     , ...
'TickLength'  , [.01 .01] , ...
'XMinorTick'  , 'off'     , ...
'YMinorTick'  , 'off'     , ...
'XColor'      , [.3 .3 .3], ...
'YColor'      , [.3 .3 .3], ...
'XTick'       , 0:1:nmodel     , ...
'YTick'       , 0:0.2:1   , ...
'XGrid'       , 'off'      , ...
'YGrid'       , 'on'      , ...
'LineWidth'   , 1         );

set(gca, 'XTickLabel', '');

%----------------
subplot(2,1,2);

x = [1:nmodel];
y = data_pxp;

b = bar(x, y);      
% b.FaceColor = 'c';

set(b, ...
    'FaceColor', colors.real.A1.face, ...
    'EdgeColor', colors.real.A1.face, ...
    'LineWidth', 1);

ylim([0 1]);
xlim([0 nmodel + 1]);
ylabel('pxp');
% title('');


ylabetxt = uniNames;
xpos     = - 0.1; %min(ylim) - (max(ylim)-min(ylim))/30;
text([1:nmodel]+0.15, repmat(xpos,nmodel,1), ...
     ylabetxt','horizontalalignment','right','FontSize',10);

grid on;

set(gca, ...
'Box'         , 'off'     , ...
'TickDir'     , 'out'     , ...
'TickLength'  , [.01 .01] , ...
'XMinorTick'  , 'off'     , ...
'YMinorTick'  , 'off'     , ...
'XColor'      , [.3 .3 .3], ...
'YColor'      , [.3 .3 .3], ...
'XTick'       , 0:1:nmodel     , ...
'YTick'       , 0:0.2:1   , ...
'XGrid'       , 'off'      , ...
'YGrid'       , 'on'      , ...
'LineWidth'   , 1         );

set(gca, 'XTickLabel', '');





