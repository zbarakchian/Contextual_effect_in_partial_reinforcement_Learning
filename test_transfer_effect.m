function test_transfer_effect(config,config_analysis,sbjs)

info_transfer    = config_analysis.info_transfer;


pref_rate_left   = info_transfer.pref.rate_left;
pref_rate_right  = info_transfer.pref.rate_right;

pref_bin_left    = info_transfer.pref.bin_left;
pref_bin_right   = info_transfer.pref.bin_right;

pref_first_left  = info_transfer.pref.first_left;
pref_first_right = info_transfer.pref.first_right;


%--------------------------------------------------------------------------

%% Choice
disp('CHOICE:');
disp(' ');

%%
pref_left  = [];
pref_right = [];
switch config.ttype
    case 'rate'
        pref_left  = pref_rate_left;
        pref_right = pref_rate_right;
    case 'binary'
        pref_left  = pref_bin_left;
        pref_right = pref_bin_right;
    case 'first'
        pref_left  = pref_first_left;
        pref_right = pref_first_right;
end

%%
switch config.ttype
    case 'rate'
        %% the median of A2-A1 difference is different form zero? Wilcoxon
        PH_wilcoxon = [];
        [p,h,stats] = signrank(pref_left(sbjs.indx,1),pref_right(sbjs.indx,1),'tail','right'); 
        PH_wilcoxon = [PH_wilcoxon; p];
        [p,h,stats] = signrank(pref_left(sbjs.indx,1),pref_right(sbjs.indx,1)); 
        p1 = p;
        
    
        %% Paired t-test 
        PH_pttest = [];
        [h,p,stats] = ttest(pref_right(sbjs.indx,1),pref_left(sbjs.indx,1),'tail','right'); 
        PH_pttest = [PH_pttest; p];
        [h,p,stats] = ttest(pref_right(sbjs.indx,1),pref_left(sbjs.indx,1)); 
        p2 = p;
        for i=2:6
            [h,p,stats] = ttest(pref_left(sbjs.indx,i),pref_right(sbjs.indx,i)); 
            PH_pttest = [PH_pttest; p];
        end
        %------------------------------------------------------------------
        disp(strcat('P Value = ',num2str(2*p1)));
    
    case {'binary','first'}

        %% Binomial Test
        %-H0: P(choosing between A1 and A2) = 0.5
        %-Bionomial
        [h,p_binom,ratio] = binomial_test(pref_left(sbjs.indx,1),pref_right(sbjs.indx,1));
        disp(strcat('ratio = ',num2str(ratio)));   

        disp('------------------');
        disp('aret they fully absolute?');
        disp(strcat('P Value = ',num2str(p_binom)));
        %----------------------------------------
        [h,p,ci,stats] = ttest(pref_left(sbjs.indx,1),.1); %35
 
        disp('------------------');
        disp('are they fully relative');
        disp(strcat('P Value = ',num2str(p)));
        %--------------------------------------------------------------------------
end

