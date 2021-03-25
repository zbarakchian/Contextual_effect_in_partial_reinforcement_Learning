function models = define_models(config_fit)


%-add the models folder to the path to be recognized by matlab 
addpath(genpath([pwd, filesep, 'models' ]));

partial.SQL        = model_partial_SQL('SQL','Standard-QLearning(Watkins-Dayan1992 & Sutton-Barto1998)',config_fit);
partial.FQL        = model_partial_FQL('FQL','Forgetting unchosen option(Doya2009)',config_fit);
partial.RPD        = model_partial_RPD('RPD','Reference-Point with direct FC outcome(Palminteri2015)',config_fit);
partial.RPA        = model_partial_RPA('RPA','Reference-Point with average of FC and CF outcomes(Palminteri2015)',config_fit);
partial.RPM        = model_partial_RPM('RPM','Reference-Point with max of FC and CF outcomes(Palminteri2015)',config_fit);
partial.SAC        = model_partial_SAC('SAC','Standard Actor-Critic(Sutton-Barto)',config_fit);
partial.EWA        = model_partial_EWA('EWA','Experience?weighted Attraction(Camerer1999)',config_fit);
partial.Hyb        = model_partial_Hyb('Hyb','Hybrid of Relative and Absolute rewards(Palminteri2017)',config_fit);
partial.OL1        = model_partial_OL1('OL1','Opposing Learning1(Zahra2020)',config_fit);
partial.OL2        = model_partial_OL2('OL2','Opposing Learning2(Zahra2020)',config_fit);
partial.Episod1    = model_partial_Episod1('Episod1','Episodic-memory sample based RL, 1 sample',config_fit); 
%-----------------------------------------------------------------------
complete.SQL       = model_complete_SQL ('SQL','Standard-QLearning(Watkins-Dayan1992 & Sutton-Barto1998)',config_fit);
complete.QL21      = model_complete_QL21('QL21','QLearning with 2 PEs for FC and CF outcomes with the same learning rate',config_fit);
complete.QL22      = model_complete_QL22('QL22','QLearning with 2 PEs for FC and CF outcomes with two different learning rates',config_fit);
complete.FQL       = model_complete_FQL ('FQL','Forgetting unchosen option(Doya2009)',config_fit);
complete.RPA1      = model_complete_RPA1('RPA1','Reference-Point with average of FC and CF outcomes with the same learning rate(Palminteri2015)',config_fit);
complete.RPA2      = model_complete_RPA2('RPA2','Reference-Point with average of FC and CF outcomes with two different learning rates(Palminteri2015)',config_fit);
complete.RPM1      = model_complete_RPM1('RPM1','Reference-Point with max of FC and CF outcomes with the same learning rate(Palminteri2015)',config_fit);
complete.RPM2      = model_complete_RPM2('RPM2','Reference-Point with max of FC and CF outcomes with two different learning rates(Palminteri2015)',config_fit);
complete.SAC       = model_complete_SAC ('SAC','Standard Actor-Critic(Sutton-Barto)',config_fit);
complete.EWA       = model_complete_EWA ('EWA','Experience?weighted Attraction(Camerer1999)',config_fit);
complete.Dif       = model_complete_Dif ('Dif','learning the difference of FC and CF outcomes(Klein2017)',config_fit);
complete.Hyb       = model_complete_Hyb ('Hyb','Hybrid of Relative and Absolute rewards(Palminteri2017)',config_fit);
complete.OL1       = model_complete_OL1 ('OL1','Hybrid OL1(Zahra2020)',config_fit);
complete.OL2       = model_complete_OL2 ('OL2','Hybrid OL2(Zahra2020)',config_fit);
complete.Episod1   = model_complete_Episod1('Episod1','Episodic-memory sample based RL, 1 sample',config_fit); 
%-----------------------------------------------------------------------
models_partial   = { partial.SQL,...     %1
                     partial.FQL,...     %2
                     partial.RPD,...     %3
                     partial.RPA,...     %4
                     partial.RPM,...     %5
                     partial.SAC,...     %6      
                     partial.EWA,...     %7
                     partial.Hyb,...     %8
                     partial.OL1,...     %9
                     partial.OL2,...     %10
                     partial.Episod1,....%11
                     };      
%-----------------------------------------------------------------------
models_complete  = { complete.SQL,...       %1
                     complete.QL21,...      %2
                     complete.QL22,...      %3
                     complete.FQL,...       %4
                     complete.RPA1,...      %5
                     complete.RPA2,...      %6      
                     complete.RPM1,...      %7
                     complete.RPM2,...      %8
                     complete.SAC,...       %9       
                     complete.EWA,...       %10
                     complete.Dif,...       %11
                     complete.Hyb,...       %12  
                     complete.OL1,...       %13
                     complete.OL2,...       %14 
                     complete.Episod1,....  %15
                     };   
                 
%-----------------------------------------------------------------------
models.models_partial  = models_partial;
models.models_complete = models_complete;


