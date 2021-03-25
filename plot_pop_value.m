function plot_pop_value(addr,ftype,config,sbjs)
%-load data
%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Transfer.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Estimation.mat']);

FC              = info_learning.statistics.normal.FC;
FCCF            = info_learning.statistics.normal.FCCF;
hist            = info_learning.hist;
Values          = info_estimation.valuation.estimate;
Variations      = info_estimation.variation.estimate;
vtype           = config.vtype;
nsub            = size(sbjs.indx,2);

%--------------------------------------------------------------------------
uniNames = {'A1','A2','B','C'};

%--------------------------------------------------------------------------
mEstim          = mean(Values(:,vtype,sbjs.indx),3);
sEstim          = std( Values(:,vtype,sbjs.indx),0,3)/sqrt(nsub);
mExpr           = mean(FC.mean(sbjs.indx,:),1);
sExpr           = std( FC.mean(sbjs.indx,:),0,1)/sqrt(nsub);

mrate1          = nanmean(info_transfer.pref.rate_left( sbjs.indx,:),1);
mrate2          = nanmean(info_transfer.pref.rate_right(sbjs.indx,:),1);
semrate1        = nanstd( info_transfer.pref.rate_left( sbjs.indx,:),1)/sqrt(nsub);
semrate2        = nanstd( info_transfer.pref.rate_right(sbjs.indx,:),1)/sqrt(nsub);

%--------------------------------------------------------------------------
mvar            = mean(Variations(:,5,sbjs.indx),3);
svar            = std( Variations(:,5,sbjs.indx),0,3)/sqrt(nsub);


%% four stimlui in Partial Version
if isequal(ftype,'Partial')

    fHand1 = figure;
    aHand1 = axes('parent', fHand1);
    hold(aHand1, 'on')

    y  = [mEstim(1),mExpr(1); mEstim(2),mExpr(2); mEstim(3),mExpr(3); mEstim(4),mExpr(4)];
    disp(y);
    x1 = [1,   4,   7,   10  ]; 
    x2 = [1.7, 4.7, 7.7, 10.7];
    
    bar(x1, y(:,1)', .2, 'parent', aHand1, 'facecolor', 'b');
    bar(x2, y(:,2)', .2, 'parent', aHand1, 'facecolor', 'y');
    
    hold on 
    errorbar(x1, [mEstim],[sEstim],'Color',[0 0 0],'LineStyle','none','LineWidth',2);
    errorbar(x2, [mExpr], [sExpr], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);
    
    ylim([0 100]);
    ylabel('Estimated Value');
    
    legend('Estimation','Experienced', 'Location','southoutside','Orientation','horizontal');
    titMean = strcat('The Estimated Value vs. Experienced Mean-',ftype);
    title(titMean);
    grid minor;
    %------------
    set(gca, 'XTickLabel', '')
    xlabetxt = uniNames;
    ypos     = min(ylim)-5;
    text(x2,repmat(ypos,4,1), ...
         xlabetxt','horizontalalignment','right','FontSize',10);
    %----------------------------------------------------------------------
    fHand1 = figure;
    aHand1 = axes('parent', fHand1);
    hold(aHand1, 'on')

    y  = [mEstim(1),mExpr(1); mEstim(3),mExpr(3); mEstim(2),mExpr(2); mEstim(4),mExpr(4)];
    x1 = [1,   4,   7,   10  ]; 
    x2 = [1.7, 4.7, 7.7, 10.7];
    
    bar(x1, y(:,1)', .2, 'parent', aHand1, 'facecolor', 'b');
    bar(x2, y(:,2)', .2, 'parent', aHand1, 'facecolor', 'y');
    
    hold on 
    errorbar(x1, [mEstim([1 3 2 4])],[sEstim([1 3 2 4])],'Color',[0 0 0],'LineStyle','none','LineWidth',2);
    errorbar(x2, [mExpr([1 3 2 4])], [sExpr([1 3 2 4])], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);
    
    ylim([0 100]);
    ylabel('Estimated Value');
    
    legend('Estimation','Experienced', 'Location','southoutside','Orientation','horizontal');
    titMean = strcat('The Estimated Value vs. Experienced Mean-',ftype);
    title(titMean);
    grid minor;
    %------------
    set(gca, 'XTickLabel', '')
    xlabetxt = uniNames;
    ypos     = min(ylim)-5;
    text(x2,repmat(ypos,4,1), ...
         xlabetxt','horizontalalignment','right','FontSize',10);
end


%% four stimlui in Complete Version
if isequal(ftype,'Complete')
    mComplete   = mean(FCCF.mean(sbjs.indx,:),1);
    sComplete   = std(FCCF.mean(sbjs.indx,:),0,1);%/sqrt(nsub); 
    
    fHand1 = figure;
    aHand1 = axes('parent', fHand1);
    hold(aHand1, 'on')

    y = [mEstim(1),mExpr(1),mComplete(1); ...
         mEstim(2),mExpr(2),mComplete(2); ...
         mEstim(3),mExpr(3),mComplete(3); ...
         mEstim(4),mExpr(4),mComplete(4)];

    disp(y);

    x1 = [1,6,10,14]; x2 = [2,7,11,15]; x3 = [3,8,12,16];
    bar(x1, y(:,1)', .2, 'parent', aHand1, 'facecolor', 'b');
    bar(x2, y(:,2)', .2, 'parent', aHand1, 'facecolor', 'y');
    bar(x3, y(:,3)', .2, 'parent', aHand1, 'facecolor', 'g');
    
    hold on 
    errorbar(x1,[mEstim],    [sEstim],    'Color',[0 0 0],'LineStyle','none','LineWidth',2);
    errorbar(x2,[mExpr],     [sExpr],     'Color',[0 0 0],'LineStyle','none','LineWidth',2);
    errorbar(x3,[mComplete], [sComplete], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);

    ylim([0 100]);
    ylabel('Estimated Value');

    legend('Estimation','FC','FC+CF', 'Location','southoutside','Orientation','horizontal');
    titMean = strcat('The Estimated Value vs. FC Mean vs. FC+CF Mean-',ftype);
    title(titMean);
    grid minor;
    %------------
    set(gca, 'XTickLabel', '')
    xlabetxt = uniNames;
    ypos     = min(ylim)-5;
    text(x2,repmat(ypos,4,1), ...
         xlabetxt','horizontalalignment','right','FontSize',10);
    %----------------------------------------------------------------------
    fHand1 = figure;
    aHand1 = axes('parent', fHand1);
    hold(aHand1, 'on')

    y = [mEstim(1),mExpr(1),mComplete(1); ...
         mEstim(3),mExpr(3),mComplete(3); ...
         mEstim(2),mExpr(2),mComplete(2); ...
         mEstim(4),mExpr(4),mComplete(4)];

    x1 = [1,6,10,14]; x2 = [2,7,11,15]; x3 = [3,8,12,16];
    bar(x1, y(:,1)', .2, 'parent', aHand1, 'facecolor', 'b');
    bar(x2, y(:,2)', .2, 'parent', aHand1, 'facecolor', 'y');
    bar(x3, y(:,3)', .2, 'parent', aHand1, 'facecolor', 'g');
    
    hold on 
    errorbar(x1,[mEstim([1 3 2 4])],    [sEstim([1 3 2 4])],    'Color',[0 0 0],'LineStyle','none','LineWidth',2);
    errorbar(x2,[mExpr([1 3 2 4])],     [sExpr([1 3 2 4])],     'Color',[0 0 0],'LineStyle','none','LineWidth',2);
    errorbar(x3,[mComplete([1 3 2 4])], [sComplete([1 3 2 4])], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);

    ylim([0 100]);
    ylabel('Estimated Value');

    legend('Estimation','FC','FC+CF', 'Location','southoutside','Orientation','horizontal');
    titMean = strcat('The Estimated Value vs. FC Mean vs. FC+CF Mean-',ftype);
    title(titMean);
    grid minor;
    %------------
    set(gca, 'XTickLabel', '')
    xlabetxt = uniNames;
    ypos     = min(ylim)-5;
    text(x2,repmat(ypos,4,1), ...
         xlabetxt','horizontalalignment','right','FontSize',10);

end

%% Only A1 and A2
figure;

subplot(1,2,1);
y = mEstim(1:2);
x = [1:2]; 
h = bar(x,y);
set(h(1), 'FaceColor', [0.75, 0.75, 0]);

hold on

% plot(x-0,mEstim(1:2),'ko','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','k');
errorbar(x,[mEstim(1:2)],[sEstim(1:2)],'Color',[0.25,0.25, 0.25],'LineStyle','none','LineWidth',1.5);


xlim([0 3]);
ylim([0 100]);
ylabel('Estimated Value');
grid minor;

titMean = strcat('The Estimated Value-',ftype);
title(titMean);
%------------
set(gca, 'XTickLabel', '')
xlabetxt = uniNames(1:2);
ypos     = min(ylim)-5;
text(x,repmat(ypos,2,1), ...
     xlabetxt','horizontalalignment','right','FontSize',10);
%---------------
subplot(1,2,2);
y = mvar(1:2);
x = [1:2];
h = bar(x,y);

set(h(1), 'FaceColor', [0.75, 0.75, 0]);

hold on 
% errorbar(x,[mrange(1:2)],[srange(1:2)],'Color',[0 0 0],'LineStyle','none','LineWidth',1);

hold on
% plot(x-0,mvar(1:2),'ko','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','k');
errorbar(x,[mvar(1:2)],[svar(1:2)],'Color',[0.25, 0.25, 0.25],'LineStyle','none','LineWidth',1.5);

xlim([0 3]);
ylim([0 100]);
ylabel('Estimated Variation');
grid minor;

titMean = strcat('The Estimated Variation-',ftype);
title(titMean);
%------------
set(gca, 'XTickLabel', '')
xlabetxt = uniNames(1:2);
ypos     = min(ylim)-5;
text(x,repmat(ypos,2,1), ...
     xlabetxt','horizontalalignment','right','FontSize',10); 
%--------------------------------------------------------------------------




