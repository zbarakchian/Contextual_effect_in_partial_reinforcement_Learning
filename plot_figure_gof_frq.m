function  plot_figure_gof_frq(addr,ftype,sbjs,models,colors)

data =  report_gof_frq(addr,ftype,sbjs,models);
nmodel = length(models);

% data rows
% tbl.rows{1,1}  = 'negloglik(learning)';
% tbl.rows{2,1}  = 'BIC(learning)';
% tbl.rows{3,1}  = 'negloglik(transfer(A1A2))'; 
% tbl.rows{4,1}  = 'BIC(learning + transfer(A1A2)))'; 
% tbl.rows{5,1}  = 'negloglik(transfer(all 6 combinations))' ;
% tbl.rows{6,1}  = 'BIC(learning + transfer(all 6 combinations)))';
% tbl.rows{7,1}  = 'ratio_prediction(transfer(A1A2))';
% tbl.rows{8,1}  = 'ratio_prediction(transfer(all 6 combinations))';
% tbl.rows{9,1}  = 'likelihood A1A2)';
% tbl.rows{10,1} = 'likelihood transfer';


%% heatmap fitting
figure;

rows = [1,2,4,6];
matrix  = data.mean(rows,:);
xvalues = data.name_col;
yvalues = data.name_row(rows);


% xvalues = {'SQL','QL_{21}','QL_{22}','FQL','RPA_1','RPA_2','RPM_1','RPM_2','SAC','EWA','Dif','Hyb','OL_1','OL_2'};
% xvalues = {'SQL','QL21','QL22','FQL','RPA1','RPA2','RPM1','RPM2','SAC','EWA','Dif','Hyb','OL1','OL2'};
% xvalues = {'SQL','FQL','RPD','RPA','RPM','SAC','EWA','Hyb','OL1','OL2'};
% xvalues = {'SQL','RP','Dif','Hyb','OL1','OL2'};
% xvalues = {'SQL', 'QL21', 'RP','Hyb','OL1','OL2'};

yvalues = {'nll','BIC','A1A2','all'};

h = heatmap(xvalues, yvalues, matrix,'FontSize', 20);
% h.ColorScaling = 'scaledcolumns';
h.ColorScaling = 'scaledrows';

% caxis(h,[-1 1]); 

% cmap = polarmap(cool,1);
% colormap(cmap);

% h.Title  = 'Parameters Correlations';
% h.YLabel = 'fitted';
% h.XLabel = 'recovered';



set(gca,'FontName','Times New Roman');%'Helvetica' );

%% heatmap prediction
figure;

rows = [3,5]; %[9,10]
matrix  = data.mean(rows,:);
xvalues = data.name_col;
yvalues = data.name_row(rows);


% xvalues = {'SQL','QL_{21}','QL_{22}','FQL','RPA_1','RPA_2','RPM_1','RPM_2','SAC','EWA','Dif','Hyb','OL_1','OL_2'};
% xvalues = {'SQL','QL21','QL22','FQL','RPA1','RPA2','RPM1','RPM2','SAC','EWA','Dif','Hyb','OL1','OL2'};
% xvalues = {'SQL','FQL','RPD','RPA','RPM','SAC','EWA','Hyb','OL1','OL2'};
% xvalues = {'SQL','RP','Dif','Hyb','OL1','OL2'};
% xvalues = {'SQL', 'QL21', 'RP','Hyb','OL1','OL2'};

yvalues = {'A1A2','all'};

h = heatmap(xvalues, yvalues, matrix,'FontSize', 20);
% h.ColorScaling = 'scaledcolumns';
h.ColorScaling = 'scaledrows';

% caxis(h,[-1 1]); 

% cmap = polarmap(cool,1);
% colormap(cmap);

% h.Title  = 'Parameters Correlations';
% h.YLabel = 'fitted';
% h.XLabel = 'recovered';



set(gca,'FontName','Times New Roman');%'Helvetica' );
