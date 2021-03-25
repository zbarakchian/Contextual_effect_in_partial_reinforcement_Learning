function test_motor_perseveration_effect(addr,ftype,config,sbjs)
%-load data
%--------------------------------------------------------------------------
load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
load([addr.bhv, filesep, 'data_', ftype, '_Transfer.mat']);
load([addr.bhv, filesep, 'data_behavioral.mat']);
%--------------------------------------------------------------------------

pref_rate_left  = info_transfer.pref.rate_left;
pref_rate_right = info_transfer.pref.rate_right;

pref_bin_left    = info_transfer.pref.bin_left;
pref_bin_right   = info_transfer.pref.bin_right;

pref_first_left  = info_transfer.pref.first_left;
pref_first_right = info_transfer.pref.first_right;

%% Whether the Last Choice affects the Decision between A1-A2 in test phase?
%--------------------------------------------------------------------------
switch config.ttype
    case {'rate','binary'}
        pref_left  = pref_bin_left(:,1);
        pref_right = pref_bin_right(:,1);
    case 'first'
        pref_left  = pref_first_left(:,1);
        pref_right = pref_first_right(:,1);
end

%% Categorical Chi2 Test
%--------------------------------------------------------------------------
X     = [];
for  sub = sbjs.indx
    chosen      = data.(ftype).learning(sub).chosen;
    LastChoice  = chosen(sbjs.nt(sub));
    if     LastChoice == 1 %(A1)
        X  = [X; 1];
    elseif LastChoice == 2 %(A2)
        X  = [X; 2];
    else %(B or C)
        X  = [X; 3];        
    end
end
%--------------------------------------------------------------------------
Y  = [];
for  sub = sbjs.indx
    if     pref_left(sub) == 1 & pref_right(sub) == 0 %A1
        Y = [Y; 1];
    elseif pref_left(sub) == 0 & pref_right(sub) == 1 %A2
        Y = [Y; 2];
    end
end

%--------------------------------------------------------------------------

[tbl,chi2,p,labels] = crosstab(X,Y);
disp([chi2,p]);



%% Whether the Left and Right Choice affects the Decision between A1-A2 in test phase?
%--------------------------------------------------------------------------
X = [];
Y = [];
for sub = sbjs.indx  
    LRaction_Learn  = data.(ftype).learning(sub).action(sbjs.nt(sub));
    
    condition       = (info_transfer.data{sub}(:,3)+1)*10 + (info_transfer.data{sub}(:,4)+1);
    I               = find(condition(:) == 21 | condition(:) == 12);
    LRaction_Test   = info_transfer.data{sub}(I(1),5);

    X = [X; LRaction_Learn];  
    Y = [Y; LRaction_Test];
end

[tbl,chi2,p,labels] = crosstab(X,Y);
disp([chi2,p]);


