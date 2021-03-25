function reg = create_regression_structure(addr,config_main,type,ftype) %choice:left
%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_behavioral.mat']);
%--------------------------------------------------------------------------
task{1}  = data.Partial.learning;
task{2}  = data.Complete.learning;
subjects = config_main.subjects;

feedbacks = {'Partial', 'Complete'};

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
latest_from = [nan,nan];
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
            
        case 'switch'
            option1   = info.chosen(t);
            option2   = info.unchosen(t);

            if isnan(latest_from(cond))
                action = 0;
            elseif option1 == latest_from(cond)
                action = 0;
            else
                action = 1;
            end
            latest_from(cond) = option1;   
    end
    
    
    %-value difference
    %---------------------------------------------------------------------- 
    v1      = get_value_of_option(feedback,t,option1,info);
    v2      = get_value_of_option(feedback,t,option2,info);
    
    value_dif    = v1 - v2;
    
    
    %-rate difference
    %----------------------------------------------------------------------    
    rate1   = get_rates_of_option(feedback,t,option1,info);
    rate2   = get_rates_of_option(feedback,t,option2,info);
    
    rate_dif     = rate1 - rate2;  
    
    %regret, relief, and outcome difference
    %----------------------------------------------------------------------   
    outcome_dif  = get_outcomeDif_of_options(feedback,t,option1,option2,info); %left-right
    
    regret       = -outcome_dif * (outcome_dif <  0);
    relief       = +outcome_dif * (outcome_dif >= 0);
    
    %-fill-in the regression struct
    %---------------------------------------------------------------------- 
    indx = indx + 1;
    
    reg.task(indx,1)           = v;
    reg.subject(indx,1)        = sub + v*100;
    reg.condition(indx,1)      = cond;
    reg.action(indx,1)         = action; %action = choice or switch
    reg.rt(indx,1)             = info.rt(t); %left =1, right = 0 %action = choice or switch
    reg.value_dif(indx,1)      = value_dif;
    reg.rate_dif(indx,1)       = rate_dif;
    reg.outcome_dif(indx,1)    = outcome_dif;
    reg.regret(indx,1)         = regret;    
    reg.relief(indx,1)         = relief;
    
end
end
end


Data = reg;
save([addr.glme filesep 'data_reg_' type '_' ftype],'Data');

reg.type = type;

if      sum(versions) == 1 
    reg.name = '_Partial';
elseif  sum(versions) == 2
    reg.name = '_Complete';
elseif  sum(versions) == 3
    reg.name = '';
end

%% table
% reg_table = [reg.task, reg.subject, reg.condition, reg.action, reg.rt, reg.value_dif, reg.rate_dif, reg.outcome_dif, reg.regret, reg.relief];












