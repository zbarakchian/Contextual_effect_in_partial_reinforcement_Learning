function MEGAMIX_Learn = design_rewards2(stats,n)

mu_Learn = stats(:,1);
sd_Learn = stats(:,2);

trials_perType_Learn    = n/4;
blockSize_Learn_Ceiling = 4 * trials_perType_Learn;

%% Stim
A1=1; A2=2; B =3; C =4; 

%% Learning Phase
% Build the trial lists
AB_trials_L = repmat([ A1,B ], trials_perType_Learn, 1);
BA_trials_L = repmat([ B,A1 ], trials_perType_Learn, 1);
AC_trials_L = repmat([ A2,C ], trials_perType_Learn, 1);
CA_trials_L = repmat([ C,A2 ], trials_perType_Learn, 1);

AB_trialList_L(:,:) = [AB_trials_L;BA_trials_L];
AC_trialList_L(:,:) = [AC_trials_L;CA_trials_L];

%%Randomize into m semi-blocks of 2 sets each (mixed AB,AC)
AB_rand  = AB_trialList_L(randperm(size(AB_trialList_L, 1)),:); 
AC_rand  = AC_trialList_L(randperm(size(AC_trialList_L, 1)),:);

BIGMIX  = cat(3,AB_rand,AC_rand);                                   
CONMIX  = [];
k = blockSize_Learn_Ceiling/2;   %2: AB and AC                                             
for mixi=1:k
    sqz     = squeeze(BIGMIX(mixi,:,randperm(2)))';
    CONMIX = [CONMIX;sqz];
end

%% rewards
n = 2*trials_perType_Learn;

%% Create Default Rewards
RWs = zeros(n,4);
for i = 1:4
    
    %stimuli
    mu    = mu_Learn(i);
    sigma = sd_Learn(i);
    
    %left-right, right-left
    y = [];  indx = 0;
    while indx ~= n
        rw = round(normrnd(mu, sigma));
        y = [y; rw];
        indx = indx + 1;
    end
    RWs(:,i) = y;
end

%%   
RWA1 = zeros(n,2);
RWA2 = zeros(n,2);
RWB  = zeros(n,2);
RWC  = zeros(n,2);

RWA1 =  RWs(:,1);
RWA2 =  RWs(:,2);
RWB  =  RWs(:,3);
RWC  =  RWs(:,4);

% disp([mean(RWA1(:,1)),mean(RWA2(:,1)),mean(RWB(:,1)),mean(RWC(:,1))]);

%%
MEGAMIX = zeros(size(CONMIX,1),4);
MEGAMIX(:,1:2) = CONMIX(:,:);
conditions = [];
indx = ones(4,1);

for i=1:size(CONMIX,1)
    if     CONMIX(i,1) ==1 & CONMIX(i,2) == 3 %condition 1: 1,3 
        MEGAMIX(i,1+2) = RWA1(indx(1));   indx(1) = indx(1)+1;
        MEGAMIX(i,2+2) = RWB (indx(3));   indx(3) = indx(3)+1;
        conditions(i)  = 1;

    elseif CONMIX(i,1)== 3 & CONMIX(i,2) == 1 %condition 1: 3,1
        MEGAMIX(i,1+2) = RWB (indx(3));   indx(3) = indx(3)+1;
        MEGAMIX(i,2+2) = RWA1(indx(1));   indx(1) = indx(1)+1;
        conditions(i)  = 1;

    elseif CONMIX(i,1)== 2 & CONMIX(i,2) == 4 %condition 1: 3,1
        MEGAMIX(i,1+2) = RWA2(indx(2));   indx(2) = indx(2)+1;
        MEGAMIX(i,2+2) = RWC (indx(4));   indx(4) = indx(4)+1;
        conditions(i)  = 2;

    elseif CONMIX(i,1)== 4 & CONMIX(i,2) == 2 %condition 1: 3,1
        MEGAMIX(i,1+2) = RWC (indx(4));   indx(4) = indx(4)+1;
        MEGAMIX(i,2+2) = RWA2(indx(2));   indx(2) = indx(2)+1;
        conditions(i)  = 2;

    end
end

MEGAMIX_Learn = [conditions', MEGAMIX];


