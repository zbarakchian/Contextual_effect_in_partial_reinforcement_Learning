function sbj_converged = check_convergency(addr,ftype,sbjs,dif)
%-load data
%--------------------------------------------------------------------------
load([addr.bhv filesep 'data_' ftype '_Learning.mat'  ]);
load([addr.bhv filesep 'data_' ftype '_Transfer.mat'  ]);
load([addr.bhv filesep 'data_' ftype '_Estimation.mat']);

%% Determine The sbjs whose A1 and A2 have not converged 

%-in Partial Verion
%--------------------------------------------------------------------------
switch ftype
case 'Partial'
    FC_mean =  info_learning.statistics.normal.FC.mean;
    
    sbj_converged = [];
    for sub = sbjs
        distance = abs(FC_mean(sub,1) - FC_mean(sub,2));
        if abs(FC_mean(sub,1) - FC_mean(sub,2)) <= dif 
            sbj_converged = [sbj_converged,sub];  
        end
    end

case 'Complete'
    FCCF_mean =  info_learning.statistics.normal.FCCF.mean;
    FC_mean   =  info_learning.statistics.normal.FC.mean;
    
    sbj_converged = [];
    for sub = sbjs
%         if abs(FCCF_mean(sub,1) - FCCF_mean(sub,2)) <= dif 
        if abs(FC_mean(sub,1) - FC_mean(sub,2)) <= dif 
            sbj_converged = [sbj_converged,sub];  
        end
    end
end

%% Determine The sbjs whose A1 and A2 havent converged and affects on decisions in a bad way
% sbjs_A1 = [];
% sbjs_A2 = [];
% for sub = sbjs
%     if      ((FCMeans(sub,1)-FCMeans(sub,2) > dif)  & (rate_left(sub,1)  > rate_right(sub,1)))
%         sbjs_A1 = [sbjs_A1,sub];          
%     elseif  ((FCMeans(sub,2)-FCMeans(sub,1) > dif)  & (rate_right(sub,1) > rate_left( sub,1)))     
%         sbjs_A2 = [sbjs_A2,sub];  
%     end
% end
% disp(sbjs_A1);
% disp(sbjs_A2);

%% Determine The sbjs whose mean(Ai) >  mean(Aj) in learning phase and Ai>Aj in test phase
% sbjs_A1 = [];
% sbjs_A2 = [];
% for sub = sbjs
%     if      ((FCMeans(sub,1) > FCMeans(sub,2))  & (rate_left(sub,1)  > rate_right(sub,1)))
%         sbjs_A1 = [sbjs_A1,sub];          
%     elseif  ((FCMeans(sub,2) < FCMeans(sub,1))  & (rate_right(sub,1) < rate_left( sub,1)))     
%         sbjs_A2 = [sbjs_A2,sub];  
%     end
% end
% disp(sbjs_A1);
% disp('--------');
% disp(sbjs_A2);

%% Determine The sbjs whose A1 and A2 havent converged and affects on decisions in a good way
% sbjs_A1 = [];
% sbjs_A2 = [];
% for sub = sbjs
%     if      ((FCMeans(sub,1)-FCMeans(sub,2) > dif)  & (rate_left(sub,1)  < rate_right(sub,1)))
%         sbjs_A2 = [sbjs_A2,sub];          
%     elseif  ((FCMeans(sub,2)-FCMeans(sub,1) > dif)  & (rate_right(sub,1) < rate_left( sub,1)))     
%         sbjs_A1 = [sbjs_A1,sub];  
%     end
% end
% disp(sbjs_A1);
% disp(sbjs_A2);

%% Is there any subjects who dosnt choose at least one stimulus at all?
% sbjs_notChoose = [];
% for sub = sbjs
%     for i=1:4
%         if hist_learn(sub,i)== 0 
%             sbjs_notChoose = [sbjs_notChoose,sub];  
%             break;
%         end
%     end
% end
% disp(sbjs_notChoose);