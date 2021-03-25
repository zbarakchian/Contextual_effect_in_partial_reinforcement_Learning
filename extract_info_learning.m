function  output = extract_info_learning(ftype,sbjs,varargin)
% fill in the data structure named info_learning

%-manage inputs
%--------------------------------------------------------------------------
switch nargin
case 2
    %-put the data of all sbjs into one array
    for sub = sbjs.indx 
        disp(sub);
        load(['Data', filesep, 'S',int2str(sub), '_Learn_', ftype, '.mat']);      
        data{sub} = data_Learning; 
        data{sub} = redesign_data_learning(data{sub});
    end

case 3
    data = varargin{1};
    for sub = sbjs.indx 
        data{sub} = redesign_data_learning(data{sub});
    end
end

%--------------------------------------------------------------------------
info_learning.data = data;
nsub = length(sbjs.indx);

%-what is the structure of the new variable
%--------------------------------------------------------------------------
for sub = sbjs.indx
    % new structure = [cond, stims, chosen, prefs, rews, rews_FCCF, rsp,acc, rt];
    cond{sub}     = data{sub}(1:sbjs.nt(sub), 1);    % condition    
    stims{sub}    = data{sub}(1:sbjs.nt(sub), 2:3);  
    chosen{sub}   = data{sub}(1:sbjs.nt(sub), 4);    % chosen option    
    prefs{sub}    = data{sub}(1:sbjs.nt(sub), 5:6);             
    rws{sub}      = data{sub}(1:sbjs.nt(sub), 7:8);     
    rw_FC{sub}    = data{sub}(1:sbjs.nt(sub), 9);    % factual rewards
    rw_CF{sub}    = data{sub}(1:sbjs.nt(sub), 10);   % counter-factual rewards
    rsp{sub}      = data{sub}(1:sbjs.nt(sub), 11);   % counter-factual rewards
    acc{sub}      = data{sub}(1:sbjs.nt(sub), 12);   % accuracy 
    rt{sub}       = data{sub}(1:sbjs.nt(sub), 13);   % rt 
end

%-conditions data
%--------------------------------------------------------------------------
ntmax = max(sbjs.nt);
datac1 = zeros(ntmax,3,nsub);

for sub = sbjs.indx
    tmp  = [cond{sub} prefs{sub}];
    nt   = size(tmp,1);
    datac1(1:nt,:,sub) = tmp(1:nt,:);
end
info_learning.datac1 = datac1;


tmp = [];
for sub = sbjs.indx  
for c = 1:2   
    indx_cond  = find(cond{sub} == c);
    tmp{sub,c} = prefs{sub}(indx_cond,:); 
    
    l = length(tmp{sub,c});
    n = size(data{sub},1)/2 - l;
    if n > 0
        for i = l+1 : l+n
            tmp{sub,c}(i,:) = [nan,nan];
        end
    end
end   
end
%--------------------------------------------------------------------------
for c = 1:2
    for sub = sbjs.indx
        datac2{c}(:,:,sub) = tmp{sub,c};
    end
end
info_learning.datac2 = datac2;
%--------------------------------------------------------------------------

%-Histogram
%--------------------------------------------------------------------------
histg = [];
for sub = sbjs.indx      
    [counts,~]    = hist(chosen{sub}(:),[0 1 2 3 4 99]);    
    histg(sub,:)  = [counts(2:5),counts(6),counts(1)];   %1,2,3,4,99,0 : A1,A2,B,C,NORESPONSE,NOTRIALS
end
info_learning.hist = histg;

%-performance
%--------------------------------------------------------------------------
performance = [];
for sub = sbjs.indx       
    Indx             = find(acc{sub} == 1);
    performance(sub) = sum(acc{sub}(Indx)/sbjs.nt(sub));
end
info_learning.performance = performance;

%-performances across trials
%--------------------------------------------------------------------------
part_n    = 30;
len       = size(data{1},1);
part_size = len/part_n;
performances = zeros(nsub,part_n);

for sub = sbjs.indx  
    
    part  = [];
    perf  = [];  
    part_s = floor(sbjs.nt(sub)/part_size); %ceil
    
    for i = 1:part_s
        indxBegin  = (i-1)*part_size + 1;
        indxEnd    = i*part_size;
        part       = acc{sub}(indxBegin:indxEnd);
        [H,~]      = hist(part,[0 1 99]);
        perf       = [perf, H(2)/part_size];        
    end 
    
    for i = part_s+1:part_n
        perf = [perf, nan];
    end
    
    performances(sub,:) = perf; 
end
info_learning.performances = performances;


%-choice across trials
%--------------------------------------------------------------------------
part_n     = 30;
part_size  = 150/part_n;
% ratio_cond = zeros(nsub,part_n,4);
stim_cond  = [1 3;2 4]; %A1B, A2C

for sub = sbjs.indx  
for c = 1:2   
    indx_cond  = find(cond{sub} == c);
    chosen_incond = chosen{sub}(indx_cond);
    
    part   = [];
    ratio  = []; 
    part_s = floor(length(indx_cond)/part_size); %ceil
    
    for i = 1:part_s
        indxBegin = (i-1)*part_size + 1;
        indxEnd   = i*part_size;
        part      = chosen_incond(indxBegin:indxEnd);
        [H,~]     = hist(part,stim_cond(c,:));
        ratio     = [ratio; H/(part_size)];
    end 
    
    for i = part_s+1:part_n
        ratio = [ratio; [nan nan]];
    end
    
    ratio_cond{c}(:,:,sub) = ratio; 
end   
end
info_learning.conds_ratio = ratio_cond;

%-statistics (mean/std,max,min) of the observered (factual and counter-factual) rewards 
%--------------------------------------------------------------------------
for sub = sbjs.indx        
    Indx    = find(chosen{sub} == 1);
    rw_FC1  = rw_FC{sub}(Indx);
    rw_CF1  = rw_CF{sub}(Indx);
    
    Indx    = find(chosen{sub} == 2);
    rw_FC2  = rw_FC{sub}(Indx);
    rw_CF2  = rw_CF{sub}(Indx);
    
    Indx    = find(chosen{sub} == 3);
    rw_FC3  = rw_FC{sub}(Indx);
    rw_CF3  = rw_CF{sub}(Indx);
    
    Indx    = find(chosen{sub} == 4);
    rw_FC4  = rw_FC{sub}(Indx);
    rw_CF4  = rw_CF{sub}(Indx);
    
    %-Mean
    %----------------------------------------------------------------------
    
    FC_mean     = [nanmean(rw_FC1),nanmean(rw_FC2),nanmean(rw_FC3),nanmean(rw_FC4)];
    FC_std      = [nanstd(rw_FC1),  nanstd(rw_FC2), nanstd(rw_FC3), nanstd(rw_FC4)];
    
    CF_mean     = [nanmean(rw_CF1),nanmean(rw_CF2),nanmean(rw_CF3),nanmean(rw_CF4)];    
    CF_std      = [nanstd(rw_CF1),  nanstd(rw_CF2), nanstd(rw_CF3), nanstd(rw_CF4)];
    
    FC_max = zeros(1,4); FC_min = zeros(1,4);
    if (~isempty(rw_FC1) && ~isempty(rw_FC2) && ~isempty(rw_FC3) && ~isempty(rw_FC4))
        FC_min  = [nanmin(rw_FC1) ,nanmin(rw_FC2) ,nanmin(rw_FC3) ,nanmin(rw_FC4) ];
        FC_max  = [nanmax(rw_FC1) ,nanmax(rw_FC2) ,nanmax(rw_FC3) ,nanmax(rw_FC4) ];
    else
        if isempty(rw_FC1)                FC_min(1) = 0; FC_max(1) = 0;            end
        if isempty(rw_FC2)                FC_min(2) = 0; FC_max(2) = 0;            end
        if isempty(rw_FC3)                FC_min(3) = 0; FC_max(3) = 0;            end
        if isempty(rw_FC4)                FC_min(4) = 0; FC_max(4) = 0;            end
    end
    
    CF_max = zeros(1,4); CF_min = zeros(1,4);
    if (~isempty(rw_CF1) && ~isempty(rw_CF2) && ~isempty(rw_CF3) && ~isempty(rw_CF4))
        CF_min  = [nanmin(rw_CF1) ,nanmin(rw_CF2) ,nanmin(rw_CF3) ,nanmin(rw_CF4) ];
        CF_max  = [nanmax(rw_CF1) ,nanmax(rw_CF2) ,nanmax(rw_CF3) ,nanmax(rw_CF4) ];
    else           
        if isempty(rw_CF1)                CF_min(1) = 0; CF_max(1) = 0;            end
        if isempty(rw_CF2)                CF_min(2) = 0; CF_max(2) = 0;            end
        if isempty(rw_CF3)                CF_min(3) = 0; CF_max(3) = 0;            end
        if isempty(rw_CF4)                CF_min(4) = 0; CF_max(4) = 0;            end
    end

    %--------------------------------
    reward.FC.mean(sub,:) = FC_mean;
    reward.FC.std(sub,:)  = FC_std;
    reward.FC.max(sub,:)  = FC_max;
    reward.FC.min(sub,:)  = FC_min;
    
    reward.CF.mean(sub,:) = FC_mean;
    reward.CF.std(sub,:)  = FC_std;
    reward.CF.max(sub,:)  = FC_max;
    reward.CF.min(sub,:)  = FC_min;
end

%-statistics of all rewards (A1,A2,B,C) not only Chosen options, 
%-it is useful in the Complete version
%--------------------------------------------------------------------------
FCCF_mean = [];
for sub = sbjs.indx   
    
    Indx1 = find(stims{sub}(:,1)  == 1);
    Indx2 = find(stims{sub}(:,2)  == 1);
    Rw1 = union(rws{sub}(Indx1,1),rws{sub}(Indx2,2));
    
    Indx1 = find(stims{sub}(:,1)  == 2);
    Indx2 = find(stims{sub}(:,2)  == 2);
    Rw2 = union(rws{sub}(Indx1,1),rws{sub}(Indx2,2));
    
    Indx1 = find(stims{sub}(:,1)  == 3);
    Indx2 = find(stims{sub}(:,2)  == 3);
    Rw3 = union(rws{sub}(Indx1,1),rws{sub}(Indx2,2));

    Indx1 = find(stims{sub}(:,1)  == 4);
    Indx2 = find(stims{sub}(:,2)  == 4);
    Rw4 = union(rws{sub}(Indx1,1),rws{sub}(Indx2,2));


%     Indx = find(stims{sub}(:)  == 1);
%     Rw1 = rws{sub}(Indx);
%     
%     Indx = find(stims{sub}(:)  == 2);
%     Rw2 = rws{sub}(Indx);
%     
%     Indx = find(stims{sub}(:)  == 3);
%     Rw3 = rws{sub}(Indx);
% 
%     Indx = find(stims{sub}(:)  == 4);
%     Rw4 = rws{sub}(Indx);

    %-Mean,MIN,MAX
    %----------------------------------------------------------------------              
    reward.FCCF.mean(sub,:) = [nanmean(Rw1),nanmean(Rw2),nanmean(Rw3),nanmean(Rw4)];
end
info_learning.statistics.normal = reward;

%-statistics of rewards (A1,A2,B,C) from end to begin: backward
%--------------------------------------------------------------------------
for sub = sbjs.indx
    
    t = 0;
    while t < sbjs.nt(sub)
        
        Indx = find(chosen{sub}(sbjs.nt(sub)-t:sbjs.nt(sub)) == 1);
        rw_FC1 = rw_FC{sub}(Indx);
        
        Indx = find(chosen{sub}(sbjs.nt(sub)-t:sbjs.nt(sub)) == 2);
        rw_FC2 = rw_FC{sub}(Indx);
        
        Indx = find(chosen{sub}(sbjs.nt(sub)-t:sbjs.nt(sub)) == 3);
        rw_FC3 = rw_FC{sub}(Indx);
        
        Indx = find(chosen{sub}(sbjs.nt(sub)-t:sbjs.nt(sub)) == 4);
        rw_FC4 = rw_FC{sub}(Indx);

        %-Mean,MIN,MAX
        %------------------------------------------------------------------
        FC_mean   = [nanmean(rw_FC1),nanmean(rw_FC2),nanmean(rw_FC3),nanmean(rw_FC4)];
        FC_std    = [nanstd(rw_FC1),  nanstd(rw_FC2), nanstd(rw_FC3), nanstd(rw_FC4)];
 
       if (~isempty(rw_FC1) && ~isempty(rw_FC2) && ~isempty(rw_FC3) && ~isempty(rw_FC4))
            FC_min  = [nanmin(rw_FC1) ,nanmin(rw_FC2) ,nanmin(rw_FC3) ,nanmin(rw_FC4) ];
            FC_max  = [nanmax(rw_FC1) ,nanmax(rw_FC2) ,nanmax(rw_FC3) ,nanmax(rw_FC4) ];
        else           
            if isempty(rw_FC1)                FC_min(1) = 0; FC_max(1) = 0;            end
            if isempty(rw_FC2)                FC_min(2) = 0; FC_max(2) = 0;            end
            if isempty(rw_FC3)                FC_min(3) = 0; FC_max(3) = 0;            end
            if isempty(rw_FC4)                FC_min(4) = 0; FC_max(4) = 0;            end
        end
        
%         FC_mean(isnan(FC_mean)) = 0;
%         FC_std( isnan(FC_std) ) = 0;
%         FC_min( isnan(FC_min) ) = 0;
%         FC_max( isnan(FC_max) ) = 0;
        %------------------------------------------------------------------
        t = t + 1;
        
        rw_stat.mean(:,t) = [FC_mean(1); FC_mean(2); FC_mean(3); FC_mean(4)];
        rw_stat.std(:,t)  = [FC_std(1);  FC_std(2);  FC_std(3);  FC_std(4)];
        rw_stat.min(:,t)  = [FC_min(1);  FC_min(2);  FC_min(3);  FC_min(4)];
        rw_stat.max(:,t)  = [FC_max(1);  FC_max(2);  FC_max(3);  FC_max(4)];
    end
    backward{sub} = rw_stat;
end
info_learning.statistics.backward = backward;

%-statistics of rewards (A1,A2,B,C) from begin to end: forward
%--------------------------------------------------------------------------
for sub = sbjs.indx   

    t = 1;
    while t <= sbjs.nt(sub)
        
        Indx = find(chosen{sub}(1:t) == 1);
        rw_FC1 = rw_FC{sub}(Indx);
        
        Indx = find(chosen{sub}(1:t) == 2);
        rw_FC2 = rw_FC{sub}(Indx);
        
        Indx = find(chosen{sub}(1:t) == 3);
        rw_FC3 = rw_FC{sub}(Indx);
        
        Indx = find(chosen{sub}(1:t) == 4);
        rw_FC4 = rw_FC{sub}(Indx);

        %-Mean,MIN,MAX
        %------------------------------------------------------------------      
        FC_mean   = [nanmean(rw_FC1),nanmean(rw_FC2),nanmean(rw_FC3),nanmean(rw_FC4)];
        FC_std    = [nanstd(rw_FC1),  nanstd(rw_FC2), nanstd(rw_FC3), nanstd(rw_FC4)];

        if (~isempty(rw_FC1) && ~isempty(rw_FC2) && ~isempty(rw_FC3) && ~isempty(rw_FC4))
            FC_min  = [nanmin(rw_FC1) ,nanmin(rw_FC2) ,nanmin(rw_FC3) ,nanmin(rw_FC4) ];
            FC_max  = [nanmax(rw_FC1) ,nanmax(rw_FC2) ,nanmax(rw_FC3) ,nanmax(rw_FC4) ];
        else           
            if isempty(rw_FC1)                FC_min(1) = 0; FC_max(1) = 0;            end
            if isempty(rw_FC2)                FC_min(2) = 0; FC_max(2) = 0;            end
            if isempty(rw_FC3)                FC_min(3) = 0; FC_max(3) = 0;            end
            if isempty(rw_FC4)                FC_min(4) = 0; FC_max(4) = 0;            end
        end        

%         FC_mean(isnan(FC_mean))=0;
%         FC_std( isnan(FC_std) )=0;
%         FC_min( isnan(FC_min) )=0;
%         FC_max( isnan(FC_max) )=0;
        %------------------------------------------------------------------
        t = t + 1;
        
        rw_recent.mean(:,t) = [ FC_mean(1); FC_mean(2); FC_mean(3); FC_mean(4)];
        rw_recent.std(:,t)  = [ FC_std(1);  FC_std(2);  FC_std(3);  FC_std(4)];
        rw_recent.min(:,t)  = [ FC_min(1);  FC_min(2);  FC_min(3);  FC_min(4)];
        rw_recent.max(:,t)  = [ FC_max(1);  FC_max(2);  FC_max(3);  FC_max(4)];
    end
    forward{sub} = rw_recent;
end
info_learning.statistics.forward = forward;

%-reaction time
%--------------------------------------------------------------------------
tmp = [];
for sub = sbjs.indx   
    tmp{sub} = [cond{sub}, rt{sub}];
end
info_learning.rt = tmp;

%-Regret
%--------------------------------------------------------------------------
for sub = sbjs.indx   
    
    Indx = find(chosen{sub} == 1);
    rw_FC1 = rw_FC{sub}(Indx);
    rw_CF1 = rw_CF{sub}(Indx);
    REG1  = rw_CF1 - rw_FC1;
    
    Indx = find(chosen{sub} == 2);
    rw_FC2 = rw_FC{sub}(Indx);
    rw_CF2 = rw_CF{sub}(Indx);
    REG2  = rw_CF2 - rw_FC2;
    
    Indx = find(chosen{sub} == 3);
    rw_FC3 = rw_FC{sub}(Indx);
    rw_CF3 = rw_CF{sub}(Indx);
    REG3  = rw_CF3 - rw_FC3;
    
    Indx = find(chosen{sub} == 4);
    rw_FC4 = rw_FC{sub}(Indx);
    rw_CF4 = rw_CF{sub}(Indx);
    REG4  = rw_CF4 - rw_FC4;
    
    %-Mean
    regret_mean = [nanmean(REG1),nanmean(REG2),nanmean(REG3),nanmean(REG4)]; 
%     reg_mean(isnan(reg_mean)) = 0;
    %----------------------------------------------------------------------
    regret_means(sub,:) = regret_mean;
end
info_learning.regret = regret_means;

output = info_learning;


