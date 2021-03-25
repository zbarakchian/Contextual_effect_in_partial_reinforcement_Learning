function check_validity_rewards(addr,ftype,sbjs)
%-load data
%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
%--------------------------------------------------------------------------
MeanRws_Stim = info_learning.statistics.normal.FC.mean;

sbjs_BadMeanRewards  = [];
for sub = sbjs.indx
    if (MeanRws_Stim(sub,1) > MeanRws_Stim(sub,3) & MeanRws_Stim(sub,3) > MeanRws_Stim(sub,4)) & ...
       (MeanRws_Stim(sub,2) > MeanRws_Stim(sub,3) & MeanRws_Stim(sub,3) > MeanRws_Stim(sub,4))
        %-Nothing
    else
        sbjs_BadMeanRewards = [sbjs_BadMeanRewards, sub];
    end
end
disp(sbjs_BadMeanRewards);

