function steepness_choice_curve(addr,config_main)

%-load data
%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_behavioral.mat']);
%--------------------------------------------------------------------------
task{1}  = data.Partial.learning;
task{2}  = data.Complete.learning;
subjects = config_main.subjects;

feedbacks = {'Partial', 'Complete'};
type = 'pleft';
ftype = '';
%--------------------------------------------------------------------------
switch ftype 
case 'Partial'
    versions = [1];
case 'Complete'
    versions = [2];
case ''
    versions = [1,2];
end


%--------------------------------------------------------------------------
indx = 0;
for v = versions
feedback = feedbacks{v};
    
%--------------------------------------------------------------------------
for sub = subjects{v}.indx
info = task{v}(sub);
    
%--------------------------------------------------------------------------
responded   = find(info.rsp == 1)';
for t = responded
    
    %-condition
    %---------------------------------------------------------------------- 
    cond = info.cond(t); 
    
    %-choice
    %---------------------------------------------------------------------- 
    switch type         
        case 'pleft'            
            option1   = info.stim_l(t);
            option2   = info.stim_r(t);
            action    = 2 - info.action(t); %left =1, right = 0
            
    end
    
    
    %-value difference
    %---------------------------------------------------------------------- 
    v1      = get_value_of_option(feedback,t,option1,info);
    v2      = get_value_of_option(feedback,t,option2,info);
    
    value_dif    = v1 - v2;
        
    %-fill-in the regression struct
    %---------------------------------------------------------------------- 
    indx = indx + 1;
    
    reg.task(indx,1)           = v;
    reg.subject(indx,1)        = sub + v*100;
    reg.condition(indx,1)      = cond;
    reg.action(indx,1)         = action; %action = choice or switch
    reg.rt(indx,1)             = info.rt(t); %left =1, right = 0 %action = choice or switch
    reg.value_dif(indx,1)      = value_dif;
    
end
end
end

reg.type = type;

if      sum(versions) == 1 
    reg.name = '_Partial';
elseif  sum(versions) == 2
    reg.name = '_Complete';
elseif  sum(versions) == 3
    reg.name = '';
end

%-nominal-ization :)
%--------------------------------------------------------------------------
task        = nominal(reg.task);
sbj         = nominal(reg.subject);
cond        = nominal(reg.condition);

%-normal-ization: z-score
%--------------------------------------------------------------------------
vdif        = zscore(reg.value_dif);

%-nothing to do 
%--------------------------------------------------------------------------
action      = reg.action;
rt          = reg.rt;


%-General Linear Mixed model (Fixed effect + Random effect): fitlme
%--------------------------------------------------------------------------
tbl  = table(rt,  action,   vdif,  cond,  sbj,  task, 'VariableNames',...
           {'rt','action', 'vdif','cond','sbj','task'});

% modelspec = 'action ~ vdif * cond * task + (vdif * cond * task|sbj)';
modelspec = 'action ~ 1 + vdif*task + (1 + vdif*task | sbj)';
glme = fitglme(tbl,modelspec,'Distribution','binomial','Verbose',2);

disp(glme);

















