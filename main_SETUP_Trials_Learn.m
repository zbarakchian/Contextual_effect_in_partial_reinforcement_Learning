function MEGAMIX =  main_SETUP_Trials_Learn(repeat)
load tempWorkspace
%% Stim
A1=1; A2=2; B =3; C =4; 
%% Learning Phase
% Build the trial lists
AB_trials_L = repmat([ A1,B ], trials_perType_Learn, 1);
BA_trials_L = repmat([ B,A1 ], trials_perType_Learn, 1);
AC_trials_L = repmat([ A2,C ], trials_perType_Learn, 1);
CA_trials_L = repmat([ C,A2 ], trials_perType_Learn, 1);

MEGAMIX_Learn = [];
for b = 1:n_block_Learn
    AB_trialList_L(:,:,b) = [AB_trials_L;BA_trials_L];
    AC_trialList_L(:,:,b) = [AC_trials_L;CA_trials_L];
    %%Randomize into m semi-blocks of 2 sets each (mixed AB,AC)
    AB_rand  = AB_trialList_L(randperm(size(AB_trialList_L, 1)),:,b); 
%     tr= timer('TimerFcn',@mycallback, 'Period', .1); wait(tr);

    AC_rand  = AC_trialList_L(randperm(size(AC_trialList_L, 1)),:,b); 
%     tr= timer('TimerFcn',@mycallback, 'Period', .1); wait(tr);

    BIGMIX  = cat(3,AB_rand,AC_rand);                                   
    CONMIX  = [];
    k       = blockSize_Learn_Ceiling/2;   %2: AB and AC                                             
    for mixi=1:k
        sqz     = squeeze(BIGMIX(mixi,:,randperm(2)))';
        CONMIX = [CONMIX;sqz];
%         tr       = timer('TimerFcn',@mycallback, 'Period', .1); wait(tr);
    end
    %% rewards
    [RWA1, RWA2, RWB, RWC] = main_psudorand_rewards();
    
    MEGAMIX = zeros(size(CONMIX,1),5);
    MEGAMIX(:,2:3) = CONMIX(:,:);
    indx = ones(4,1);
    
    for i=1:size(CONMIX,1)
        if     CONMIX(i,1) ==1 & CONMIX(i,2) == 3 %condition 1: 1,3 
            MEGAMIX(i,1)   = 1;
            MEGAMIX(i,1+3) = RWA1(indx(1));   indx(1) = indx(1)+1;
            MEGAMIX(i,2+3) = RWB (indx(3));   indx(3) = indx(3)+1;
               
        elseif CONMIX(i,1)== 3 & CONMIX(i,2) == 1 %condition 1: 3,1
            MEGAMIX(i,1)   = 1;
            MEGAMIX(i,1+3) = RWB (indx(3));   indx(3) = indx(3)+1;
            MEGAMIX(i,2+3) = RWA1(indx(1));   indx(1) = indx(1)+1;

        elseif CONMIX(i,1)== 2 & CONMIX(i,2) == 4 %condition 2: 2,4
            MEGAMIX(i,1)   = 2;
            MEGAMIX(i,1+3) = RWA2(indx(2));   indx(2) = indx(2)+1;
            MEGAMIX(i,2+3) = RWC (indx(4));   indx(4) = indx(4)+1;

        elseif CONMIX(i,1)== 4 & CONMIX(i,2) == 2 %condition 2: 4,2
            MEGAMIX(i,1)   = 2;
            MEGAMIX(i,1+3) = RWC (indx(4));   indx(4) = indx(4)+1;
            MEGAMIX(i,2+3) = RWA2(indx(2));   indx(2) = indx(2)+1;

        end
    end
    
    MEGAMIX_Learn(:,:,b) = MEGAMIX;
end
% save(['Trials_Learning_',int2str(repeat),'.mat'],'MEGAMIX_Learn');
%% END
% save tempWorkspace
