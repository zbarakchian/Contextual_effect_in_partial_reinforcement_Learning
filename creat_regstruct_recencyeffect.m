function output = creat_regstruct_recencyeffect(addr,ftype,sbjs,regressor,whichward,last_nTr)

%-load data
%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Transfer.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Estimation.mat']);

data        = info_learning.data;
recent_rws  = info_learning.statistics.(whichward);
trial       = last_nTr;

%-function
extract.mean = @(C,stim,trial) cellfun(@(c) c.mean(stim,trial), C) ;
extract.std  = @(C,stim,trial) cellfun(@(c) c.std (stim,trial), C) ;
extract.min  = @(C,stim,trial) cellfun(@(c) c.min (stim,trial), C) ;
extract.max  = @(C,stim,trial) cellfun(@(c) c.max (stim,trial), C) ;



%% Organize stats
%--------------------------------------------------------------------------
histog    = [];
for sub = sbjs.indx  
    chosens{sub}         = data{sub}(sbjs.nt(sub)-last_nTr : sbjs.nt(sub), 8);  %chosen option    
    [a,~]                = hist(chosens{sub}(:),[0 1 2 3 4 99]);    
    histog               = [histog; [a(2:5),a(6),a(1)]]; %1,2,3,4,99,0 : A1,A2,B,C,NORESPONSE,NOTRIALS   
end

%----------------------move from end to begin, 1=end, lastnTr=last n trials

means = [ ...
  extract.mean(recent_rws,1,trial)'- extract.mean(recent_rws,2,trial)', ...
  extract.mean(recent_rws,1,trial)'- extract.mean(recent_rws,3,trial)', ...
  extract.mean(recent_rws,1,trial)'- extract.mean(recent_rws,4,trial)', ...
  extract.mean(recent_rws,2,trial)'- extract.mean(recent_rws,3,trial)', ...
  extract.mean(recent_rws,2,trial)'- extract.mean(recent_rws,4,trial)', ...
  extract.mean(recent_rws,3,trial)'- extract.mean(recent_rws,4,trial)'];
  
%---------------------------------------------------------------------------------------
stds = [ ...  
  extract.std(recent_rws,1,trial)'- extract.std(recent_rws,2,trial)', ...
  extract.std(recent_rws,1,trial)'- extract.std(recent_rws,3,trial)', ...
  extract.std(recent_rws,1,trial)'- extract.std(recent_rws,4,trial)', ...
  extract.std(recent_rws,2,trial)'- extract.std(recent_rws,3,trial)', ...
  extract.std(recent_rws,2,trial)'- extract.std(recent_rws,4,trial)', ...
  extract.std(recent_rws,3,trial)'- extract.std(recent_rws,4,trial)'];
%---------------------------------------------------------------------------------------
mins = [ ...  
  extract.min(recent_rws,1,trial)'- extract.min(recent_rws,2,trial)', ...
  extract.min(recent_rws,1,trial)'- extract.min(recent_rws,3,trial)', ...
  extract.min(recent_rws,1,trial)'- extract.min(recent_rws,4,trial)', ...
  extract.min(recent_rws,2,trial)'- extract.min(recent_rws,3,trial)', ...
  extract.min(recent_rws,2,trial)'- extract.min(recent_rws,4,trial)', ...
  extract.min(recent_rws,3,trial)'- extract.min(recent_rws,4,trial)'];
%---------------------------------------------------------------------------------------
maxs = [ ...  
  extract.max(recent_rws,1,trial)'- extract.max(recent_rws,2,trial)', ...
  extract.max(recent_rws,1,trial)'- extract.max(recent_rws,3,trial)', ...
  extract.max(recent_rws,1,trial)'- extract.max(recent_rws,4,trial)', ...
  extract.max(recent_rws,2,trial)'- extract.max(recent_rws,3,trial)', ...
  extract.max(recent_rws,2,trial)'- extract.max(recent_rws,4,trial)', ...
  extract.max(recent_rws,3,trial)'- extract.max(recent_rws,4,trial)'];

%---------------------------------------------------------------------------------------
means  = means;
stds   = stds;
cvs    = stds./means;
cvinvs = 1./cvs;
maxs   = maxs;
mins   = mins;
ranges = maxs - mins;
rates  = histog (:,1) - histog(:,2);

%%
%--------------------------------------------------------------------------
switch regressor
    case 'mean' 
        output = means(sbjs.indx,:);
    case 'std'
        output = stds(sbjs.indx,:);
    case 'cv'
        output = cvs(sbjs.indx,:);
    case 'cvinv'
        output = cvinvs(sbjs.indx,:);
    case 'max'
        output = maxs(sbjs.indx,:);
    case 'min'
        output = mins(sbjs.indx,:);
    case 'range'
        output = means(sbjs.indx,:);
    case 'rate'
        output = ranges(sbjs.indx,:);
    otherwise
        output = [];
        warning('Unexpected type. No data created.')
end
