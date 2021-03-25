function output = extract_info_transfer(ftype,sbjs,varargin)
% fill in the data structure named info

%-manage inputs
%--------------------------------------------------------------------------
switch nargin
case 2       
    %-put the data of all sbjs into one array
    for sub = sbjs.indx 
        load(['Data' filesep, 'S',int2str(sub), '_Test_', ftype, '.mat']);      
        data{sub} = data_Test;
        data{sub} = redesign_data_transfer(data{sub});
    end 

case 3
    data = varargin{1};
end
%--------------------------------------------------------------------------
info_transfer.data = data;

nsub = length(sbjs.indx);

%% Transfer Phase
cmb   = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4 ]; %1234 %combinations A1,A2,B,C
ncmb  = length(cmb);

%-Preferences
%--------------------------------------------------------------------------
for sub = sbjs.indx
    
    stim   = data{sub}(:,1:2);
    prefs  = data{sub}(:,3:4);
    confs  = data{sub}(:,5:6);


    %-rating 
    %----------------------------------------------------------------------
    pref_indx = ones(6,1);        
    for  i = 1:size(data{sub},1) %test trials
        for k = 1:ncmb   %combinations             
            if  ((stim(i,1) == cmb(k,1) && stim(i,2)== cmb(k,2))) || ...
                ((stim(i,1) == cmb(k,2) && stim(i,2)== cmb(k,1)))
            
                preference.left (pref_indx(k),k) = prefs(i,1);
                preference.right(pref_indx(k),k) = prefs(i,2);
                
                pref_indx(k) = pref_indx(k)  + 1;                
                break;                
            end
        end
    end  
    
    preferences{sub} = preference;
end
info_transfer.pref.all = preferences;

%-Confidences
%--------------------------------------------------------------------------
for sub = sbjs.indx
    
    stim   = data{sub}(:,1:2);
    confs  = data{sub}(:,5:6);

    %-rating 
    %----------------------------------------------------------------------
    pref_indx = ones(6,1);        
    for  i = 1:size(data{sub},1) %test trials
        for k = 1:ncmb   %combinations             
            if  ((stim(i,1) == cmb(k,1) && stim(i,2)== cmb(k,2))) || ...
                ((stim(i,1) == cmb(k,2) && stim(i,2)== cmb(k,1)))                 
            
                confidence.left (pref_indx(k),k) = confs(i,1);
                confidence.right(pref_indx(k),k) = confs(i,2);
                
                pref_indx(k) = pref_indx(k)  + 1;                
                break;                
            end
        end
    end  
    confidences{sub} = confidence;
end
info_transfer.conf.all = confidences;

 
%-left and right
%--------------------------------------------------------------------------
pref_rate_left      = zeros(nsub,ncmb);
pref_rate_right     = zeros(nsub,ncmb);

pref_first_left     = zeros(nsub, ncmb);
pref_first_right    = zeros(nsub, ncmb);
%--------------------------------------------------------------------------
for sub = sbjs.indx 
    for k = 1:ncmb

        %-first
        %------------------------------------------------------------------
        pref_first_left(sub,k)   = preferences{sub}.left(1,k);
        pref_first_right(sub,k)  = preferences{sub}.right(1,k);
        %------------------------------------------------------------------

        %-rate
        %------------------------------------------------------------------
        pref_rate_left(sub,k)  =  nanmean(preferences{sub}.left(:,k));
        pref_rate_right(sub,k) =  nanmean(preferences{sub}.right(:,k));  

    end
end

%-binary
%--------------------------------------------------------------------------
pref_bin_left  = zeros(nsub,ncmb);
pref_bin_right = zeros(nsub,ncmb);
for sub = sbjs.indx
    for c = 1:6
        if     pref_rate_left(sub,c) > 0.5
            pref_bin_left(sub,c) = 1;
            pref_bin_right(sub,c) = 0;
            
        elseif pref_rate_left(sub,c) < 0.5
            pref_bin_left(sub,c) = 0;
            pref_bin_right(sub,c) = 1;
            
        elseif pref_rate_left(sub,c) == 0.5
            pref_bin_left(sub,c) = 1;
            pref_bin_right(sub,c) = 1;    
        end
    end
end


info_transfer.pref.first_left  = pref_first_left;
info_transfer.pref.first_right = pref_first_right;

info_transfer.pref.rate_left   = pref_rate_left;
info_transfer.pref.rate_right  = pref_rate_right;

info_transfer.pref.bin_left    = pref_bin_left;
info_transfer.pref.bin_right   = pref_bin_right;




%-left and right
%--------------------------------------------------------------------------
conf_mean_left      = zeros(nsub,ncmb);
conf_mean_right     = zeros(nsub,ncmb);

conf_std_left       = zeros(nsub,ncmb);
conf_std_right      = zeros(nsub,ncmb);

conf_first_left     = zeros(nsub,ncmb);
conf_first_right    = zeros(nsub,ncmb);
%--------------------------------------------------------------------------
for sub = sbjs.indx 
    for k = 1:ncmb

        %-first
        %------------------------------------------------------------------
        conf_first_left(sub,k)   = confidences{sub}.left(1,k);
        conf_first_right(sub,k)  = confidences{sub}.right(1,k);
        %------------------------------------------------------------------

        %-rate
        %------------------------------------------------------------------
        conf_mean_left(sub,k)  =  nanmean(confidences{sub}.left(:,k));
        conf_mean_right(sub,k) =  nanmean(confidences{sub}.right(:,k));  

        conf_std_left(sub,k)  =  nanstd(confidences{sub}.left(:,k));
        conf_std_right(sub,k) =  nanstd(confidences{sub}.right(:,k));  

    end
end
info_transfer.conf.mean_left  = conf_mean_left;
info_transfer.conf.std_left   = conf_std_left;

info_transfer.conf.mean_right = conf_mean_right;
info_transfer.conf.std_right  = conf_std_right;

info_transfer.conf.first_left  = conf_first_left;
info_transfer.conf.first_right = conf_first_right;



%-reaction-time
%--------------------------------------------------------------------------   
for sub = sbjs.indx    
    rt{sub} = data{sub}(1:end,[1:2 3:4 7:8]); %stim1,stim2,left/right,choice,rt_choice,conf,rt_conf
end
info_transfer.rt = rt;



output = info_transfer;


