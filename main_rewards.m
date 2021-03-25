function data = main_rewards()
%% GENERAL
Pairs_Learn             = 2;
Types_Learn             = Pairs_Learn * 2;                                          %AB, BA, AC, CA, A ex:15; %AB = 15, BA = 15 -> (A,B)=2*15=30
Pairs_Test              = 6;                                                       %(tarkib 2 from 6)
Types_Test              = Pairs_Test * 2; 
numberOfStimuli         = Pairs_Learn * 2;
%% Trial number
trials_perType_Practice = 5;
trials_perType_Learn    = 5400;%75; 
trials_perType_Test     = 2;
blockSize_Learn_Ceiling = Types_Learn * trials_perType_Learn;
blockSize_Test          = Types_Test  * trials_perType_Test;
n_block_Learn           = 1;
%% Define the ptobabilistic stim reward contingencies
mu_Learn                = [64,64,54,44]; %[A,A,B,C,D]
sd_Learn                = repmat([15],1,4);
save tempWorkspace
%%
data =  main_SETUP_Trials_Learn(1);  
%         main_SETUP_Trials_Test; 
