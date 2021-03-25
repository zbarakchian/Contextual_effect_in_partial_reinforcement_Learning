function test_transfer_effect_between(addr,config)

do_draw = 0;

%-load data
%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_', 'Partial', '_Learning.mat']);
load([addr.bhv, filesep, 'data_', 'Partial', '_Transfer.mat']);
load([addr.bhv, filesep, 'data_', 'Partial', '_Estimation.mat']);

partial.info_learning    = info_learning;
partial.info_transfer    = info_transfer;
partial.info_estimation  = info_estimation;

load([addr.bhv, filesep, 'data_', 'Complete', '_Learning.mat']);
load([addr.bhv, filesep, 'data_', 'Complete', '_Transfer.mat']);
load([addr.bhv, filesep, 'data_', 'Complete', '_Estimation.mat']);

complete.info_learning   = info_learning;
complete.info_transfer   = info_transfer;
complete.info_estimation = info_estimation;

clearvars info_learning info_transfer info_estimation;

%--------------------------------------------------------------------------

sbjs_partial  = config.subjects{1}.indx;
sbjs_complete = config.subjects{2}.indx;

n_prtl  = length(sbjs_partial);
n_cmplt = length(sbjs_complete);
%--------------------------------------------------------------------------

partial.pref_rate_left   = partial.info_transfer.pref.rate_left (sbjs_partial,:);
partial.pref_rate_right  = partial.info_transfer.pref.rate_right (sbjs_partial,:);
partial.pref_bin_left    = partial.info_transfer.pref.bin_left (sbjs_partial,:);
partial.pref_bin_right   = partial.info_transfer.pref.bin_right (sbjs_partial,:);
partial.pref_first_left  = partial.info_transfer.pref.first_left (sbjs_partial,:);
partial.pref_first_right = partial.info_transfer.pref.first_right (sbjs_partial,:);
partial.conf_mean_left   = partial.info_transfer.conf.mean_left (sbjs_partial,:);
partial.conf_mean_right  = partial.info_transfer.conf.mean_right (sbjs_partial,:);
partial.conf_first_left  = partial.info_transfer.conf.first_left (sbjs_partial,:);
partial.conf_first_right = partial.info_transfer.conf.first_right (sbjs_partial,:);

complete.pref_rate_left   = complete.info_transfer.pref.rate_left (sbjs_complete,:);
complete.pref_rate_right  = complete.info_transfer.pref.rate_right (sbjs_complete,:);
complete.pref_bin_left    = complete.info_transfer.pref.bin_left (sbjs_complete,:);
complete.pref_bin_right   = complete.info_transfer.pref.bin_right (sbjs_complete,:);
complete.pref_first_left  = complete.info_transfer.pref.first_left (sbjs_complete,:);
complete.pref_first_right = complete.info_transfer.pref.first_right (sbjs_complete,:);
complete.conf_mean_left   = complete.info_transfer.conf.mean_left (sbjs_complete,:);
complete.conf_mean_right  = complete.info_transfer.conf.mean_right (sbjs_complete,:);
complete.conf_first_left  = complete.info_transfer.conf.first_left (sbjs_complete,:);
complete.conf_first_right = complete.info_transfer.conf.first_right (sbjs_complete,:);

%--------------------------------------------------------------------------


%% 
switch config.ttype
    
    case 'rate'
        partial.pref_right  = partial.pref_rate_right;
        partial.pref_left   = partial.pref_rate_left;
        complete.pref_right = complete.pref_rate_right;
        complete.pref_left  = complete.pref_rate_left;
        
        partial.conf_left   = partial.conf_mean_left;
        partial.conf_right  = partial.conf_mean_right;
        complete.conf_left  = complete.conf_mean_left;
        complete.conf_right = complete.conf_mean_right;
        
    case 'binary'
        partial.pref_right  = partial.pref_bin_right;
        partial.pref_left   = partial.pref_bin_left;
        complete.pref_right = complete.pref_bin_right;
        complete.pref_left  = complete.pref_bin_left;

        partial.conf_left   = partial.conf_mean_left;
        partial.conf_right  = partial.conf_mean_right;
        complete.conf_left  = complete.conf_mean_left;
        complete.conf_right = complete.conf_mean_right;
        
case 'first'
        partial.pref_right  = partial.pref_first_right;
        partial.pref_left   = partial.pref_first_left;
        complete.pref_right = complete.pref_first_right;
        complete.pref_left  = complete.pref_first_left;

        partial.conf_left   = partial.conf_first_left;
        partial.conf_right  = partial.conf_first_right;
        complete.conf_left  = complete.conf_first_left;
        complete.conf_right = complete.conf_first_right;

end

%% Choice
PLeft  = [];
PRight = [];
for cmb = 1:6
    [h,p,stats] = ttest2(partial.pref_left(:,cmb),   complete.pref_left(:,cmb)); 
    PLeft = [PLeft,p];
end
for cmb = 1:6
    [h,p,stats] = ttest2(partial.pref_right(:,cmb),   complete.pref_right(:,cmb));
    PRight = [PRight,p];
end
% disp('-choice-');
% disp([PLeft;PRight]);

%% Confidence: 
%% X-Y vs X-Y (combination i in partial vs complete) 
PLeft  = [];
PRight = [];
for cmb = 1:6
    [h,p,stats] = ttest2(partial.conf_left( :,cmb), complete.conf_left( :,cmb)); 
    PLeft = [PLeft,p];
end
for cmb = 1:6
    [h,p,stats] = ttest2(partial.conf_right(:,cmb), complete.conf_right(:,cmb)); 
    PRight = [PRight,p];
end
% disp('-confidence-');
% disp([PLeft;PRight]);


%% accumulate pref left and right
partial.pref_left_all   = [];
partial.pref_right_all  = [];
complete.pref_left_all  = [];
complete.pref_right_all = [];

for cmb = 2:6
    partial.pref_left_all   = [partial.pref_left_all  ;partial.pref_left(  :,cmb)];
    partial.pref_right_all  = [partial.pref_right_all ;partial.pref_right( :,cmb)];
    complete.pref_left_all  = [complete.pref_left_all ;complete.pref_left( :,cmb)];
    complete.pref_right_all = [complete.pref_right_all;complete.pref_right(:,cmb)];
end

[h,p1,stats] = ttest2(partial.pref_left_all,  complete.pref_left_all ); 
[h,p2,stats] = ttest2(partial.pref_right_all, complete.pref_right_all); 
disp('-total left/right pref-');
disp([p1 p2]);

%% accumulate conf left and right
partial.conf_left_all   = [];
partial.conf_right_all  = [];
complete.conf_left_all  = [];
complete.conf_right_all = [];

for cmb = 2:6
    partial.conf_left_all   = [partial.conf_left_all  ;partial.conf_left(  :,cmb)];
    partial.conf_right_all  = [partial.conf_right_all ;partial.conf_right( :,cmb)];
    complete.conf_left_all  = [complete.conf_left_all ;complete.conf_left( :,cmb)];
    complete.conf_right_all = [complete.conf_right_all;complete.conf_right(:,cmb)];
end

[h,p1,stats] = ttest2(partial.conf_left_all,  complete.conf_left_all ); 
[h,p2,stats] = ttest2(partial.conf_right_all, complete.conf_right_all); 
disp('-total left/right confidence-');
disp([p1 p2]);

%% accumulate pref stimulus by stimulus
pref_A1_tot_partial = ([partial.pref_left( :,1)   ; partial.pref_left( :,2)   ; partial.pref_left( :,3)]);
pref_A2_tot_partial = ([partial.pref_right(:,1)   ; partial.pref_left( :,4)   ; partial.pref_left( :,5)]);
pref_B_tot_partial  = ([partial.pref_right(:,2)   ; partial.pref_right(:,4)   ; partial.pref_left( :,6)]);
pref_C_tot_partial  = ([partial.pref_right(:,3)   ; partial.pref_right(:,5)   ; partial.pref_right(:,6)]);

pref_A1_tot_complete = ([complete.pref_left( :,1) ; complete.pref_left( :,2)  ; complete.pref_left( :,3)]);
pref_A2_tot_complete = ([complete.pref_right(:,1) ; complete.pref_left( :,4)  ; complete.pref_left( :,5)]);
pref_B_tot_complete  = ([complete.pref_right(:,2) ; complete.pref_right(:,4)  ; complete.pref_left( :,6)]);
pref_C_tot_complete  = ([complete.pref_right(:,3) ; complete.pref_right(:,5)  ; complete.pref_right(:,6)]);


%% accumulate pref stimulus by stimulus
conf_A1_tot_partial = ([partial.conf_left(:,1)    ; partial.conf_left( :,2)   ; partial.conf_left( :,3)]);
conf_A2_tot_partial = ([partial.conf_right(:,1)   ; partial.conf_left( :,4)   ; partial.conf_left( :,5)]);
conf_B_tot_partial  = ([partial.conf_right(:,2)   ; partial.conf_right(:,4)   ; partial.conf_left( :,6)]);
conf_C_tot_partial  = ([partial.conf_right(:,3)   ; partial.conf_right(:,5)   ; partial.conf_right(:,6)]);

conf_A1_tot_complete = ([complete.conf_left( :,1) ; complete.conf_left( :,2)  ; complete.conf_left( :,3)]);
conf_A2_tot_complete = ([complete.conf_right(:,1) ; complete.conf_left( :,4)  ; complete.conf_left( :,5)]);
conf_B_tot_complete  = ([complete.conf_right(:,2) ; complete.conf_right(:,4)  ; complete.conf_left( :,6)]);
conf_C_tot_complete  = ([complete.conf_right(:,3) ; complete.conf_right(:,5)  ; complete.conf_right(:,6)]);



%% Draw
if do_draw
    
%-Stimuli
%--------------------------------------------------------------------------
pref_mean = [];
conf_mean = [];
pref_sem  = [];
conf_sem  = [];

uniNames = {'A1','A2','B','C'};
figure;

subplot(1,2,1);
pref_mean(:,1) = [nanmean(pref_A1_tot_partial,1); nanmean(pref_A2_tot_partial,1); nanmean(pref_B_tot_partial,1); nanmean(pref_C_tot_partial,1)];
pref_mean(:,2) = [nanmean(pref_A1_tot_complete,1);nanmean(pref_A2_tot_complete,1);nanmean(pref_B_tot_complete,1);nanmean(pref_C_tot_complete,1)];

pref_sem(:,1) = [nanstd(pref_A1_tot_partial,1) /sqrt(n_prtl);  nanstd(pref_A2_tot_partial,1) /sqrt(n_prtl);  nanstd(pref_B_tot_partial,1) /sqrt(n_prtl);  nanstd(pref_C_tot_partial,1) /sqrt(n_prtl)];
pref_sem(:,2) = [nanstd(pref_A1_tot_complete,1)/sqrt(n_cmplt); nanstd(pref_A2_tot_complete,1)/sqrt(n_cmplt); nanstd(pref_B_tot_complete,1)/sqrt(n_cmplt); nanstd(pref_C_tot_complete,1)/sqrt(n_cmplt)];

b = bar(pref_mean);
hold on
x = b.XData;
errorbar(x-.15,  [pref_mean(:,1)], [pref_sem(:,1)], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);
errorbar(x+.15,  [pref_mean(:,2)], [pref_sem(:,2)], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);

set(gca, 'XTickLabel', '')
xlabetxt = uniNames([1:4]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1:4],repmat(ypos,4,1),xlabetxt','horizontalalignment','right','FontSize',10);

title('Preference');
 
subplot(1,2,2);
conf_mean(:,1) = [nanmean(conf_A1_tot_partial,1); nanmean(conf_A2_tot_partial,1); nanmean(conf_B_tot_partial,1); nanmean(conf_C_tot_partial,1)];
conf_mean(:,2) = [nanmean(conf_A1_tot_complete,1);nanmean(conf_A2_tot_complete,1);nanmean(conf_B_tot_complete,1);nanmean(conf_C_tot_complete,1)];

conf_sem(:,1) = [nanstd(conf_A1_tot_partial,1) /sqrt(n_prtl);  nanstd(conf_A2_tot_partial,1) /sqrt(n_prtl);  nanstd(conf_B_tot_partial,1) /sqrt(n_prtl);  nanstd(conf_C_tot_partial,1) /sqrt(n_prtl)];
conf_sem(:,2) = [nanstd(conf_A1_tot_complete,1)/sqrt(n_cmplt); nanstd(conf_A2_tot_complete,1)/sqrt(n_cmplt); nanstd(conf_B_tot_complete,1)/sqrt(n_cmplt); nanstd(conf_C_tot_complete,1)/sqrt(n_cmplt)];

b = bar(conf_mean);

hold on

x = b.XData;
errorbar(x-.15,  [conf_mean(:,1)], [conf_sem(:,1)], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);
errorbar(x+.15,  [conf_mean(:,2)], [conf_sem(:,2)], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);

set(gca, 'XTickLabel', '')
xlabetxt = uniNames([1:4]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1:4],repmat(ypos,4,1),xlabetxt','horizontalalignment','right','FontSize',10);

title('Confidence');
legend('Partial','Complete','Location','northeast');
supertitle(config.ttype);


%-Left/right
%--------------------------------------------------------------------------
pref_mean = [];
conf_mean = [];
pref_sem  = [];
conf_sem  = [];

uniNames = {'Left','Right'};
figure;

subplot(1,2,1);
pref_mean(:,1) = [nanmean(partial.pref_left_all,1); nanmean(partial.pref_right_all,1)];
pref_mean(:,2) = [nanmean(complete.pref_left_all,1);nanmean(complete.pref_right_all,1)];

pref_sem(:,1) = [nanstd(partial.pref_left_all,1) /sqrt(n_prtl);  nanstd(partial.pref_right_all,1) /sqrt(n_prtl)];
pref_sem(:,2) = [nanstd(complete.pref_left_all,1)/sqrt(n_cmplt); nanstd(complete.pref_right_all,1)/sqrt(n_cmplt)];

b = bar(pref_mean);
hold on
x = b.XData;
errorbar(x-.15,  [pref_mean(:,1)], [pref_sem(:,1)], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);
errorbar(x+.15,  [pref_mean(:,2)], [pref_sem(:,2)], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);

set(gca, 'XTickLabel', '')
xlabetxt = uniNames([1:2]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1:2],repmat(ypos,2,1),xlabetxt','horizontalalignment','right','FontSize',10);

title('Preference');
 
subplot(1,2,2);
conf_mean(:,1) = [nanmean(partial.conf_left_all,1); nanmean(partial.conf_right_all,1)];
conf_mean(:,2) = [nanmean(complete.conf_left_all,1);nanmean(complete.conf_right_all,1)];

conf_sem(:,1) = [nanstd(partial.conf_left_all,1) /sqrt(n_prtl);  nanstd(partial.conf_right_all,1) /sqrt(n_prtl)];
conf_sem(:,2) = [nanstd(complete.conf_left_all,1)/sqrt(n_cmplt); nanstd(complete.conf_right_all,1)/sqrt(n_cmplt)];

b = bar(conf_mean);

hold on

x = b.XData;
errorbar(x-.15,  [conf_mean(:,1)], [conf_sem(:,1)], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);
errorbar(x+.15,  [conf_mean(:,2)], [conf_sem(:,2)], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);

set(gca, 'XTickLabel', '')
xlabetxt = uniNames([1:2]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1:2],repmat(ypos,2,1),xlabetxt','horizontalalignment','right','FontSize',10);

title('Confidence');
legend('Partial','Complete','Location','northeast');
supertitle(config.ttype);


%-Total partial vs complete
%--------------------------------------------------------------------------
pref_mean = [];
conf_mean = [];
pref_sem  = [];
conf_sem  = [];

uniNames = {'Partial','Complete'};
figure;

subplot(1,2,1);
pref_mean = [nanmean(pref_partial_all,1);                nanmean(pref_complete_all,1)];
pref_sem  = [nanstd(pref_partial_all,1)/sqrt(n_prtl);  nanstd(pref_complete_all,1)/sqrt(n_cmplt)];

b = bar(pref_mean);
hold on
x = b.XData;
errorbar(x,  [pref_mean], [pref_sem], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);

set(gca, 'XTickLabel', '')
xlabetxt = uniNames([1:2]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1:2],repmat(ypos,2,1),xlabetxt','horizontalalignment','right','FontSize',10);

title('Preference');
 
subplot(1,2,2);
conf_mean  = [nanmean(conf_partial_all,1);              nanmean(conf_complete_all,1)];
conf_sem   = [nanstd(conf_partial_all,1)/sqrt(n_prtl);  nanstd(conf_complete_all,1)/sqrt(n_cmplt)];

b = bar(conf_mean);

hold on

x = b.XData;
errorbar(x,  [conf_mean], [conf_sem], 'Color',[0 0 0],'LineStyle','none','LineWidth',2);

set(gca, 'XTickLabel', '')
xlabetxt = uniNames([1:2]);
ypos     = min(ylim) - (max(ylim)-min(ylim))/30;
text([1:2],repmat(ypos,2,1),xlabetxt','horizontalalignment','right','FontSize',10);

title('Confidence');
% legend('Partial','Complete','Location','northeast');
supertitle(config.ttype);

end