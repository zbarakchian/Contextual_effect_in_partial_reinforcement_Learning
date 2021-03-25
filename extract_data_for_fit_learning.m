function output = extract_data_for_fit_learning(varargin)

if      nargin == 1  
    data_Learning = varargin{1};
    data_Learning = redesign_data_learning(data_Learning);
    
elseif  nargin == 4   
    addr          = varargin{1};
    ftype         = varargin{2};
    config_main   = varargin{3};
    sub           = varargin{4};
    
    load([addr.bhv, filesep, 'data_', ftype, '_Learning.mat']);
    data_Learning = info_learning.data{sub};
end

%% remove the non-responded trials
% Indx = find(data_Learning(:,13) == 1);
% data = data_Learning(Indx,:);

if (isempty(data_Learning))
    disp('Sorry! No data found!');
else
    con  = data_Learning(:,1);
    out  = data_Learning(:,9);                                                % "out": outcome (50c, 0c or -50c of euros) 
    cou  = data_Learning(:,10);                                                % "cou": counterfactual outcome (50c, 0c or -50c of euros, not shown when con = 1 or 3)                

    % "cho": choice; 2 for correct option (most rewarding or less punishing), 1 for incorrect (less rewarding, most punishing)
    for i = 1:size(data_Learning(:,4),1) %[1,2,3,4]=[A1,A2,B,C] -> S1=[A1,B],S2=[A2,B]
        if     (data_Learning(i,4) == 1)||(data_Learning(i,4) == 2)       cho(i,1)  = 1; 
        elseif (data_Learning(i,4) == 3)||(data_Learning(i,4) == 4)       cho(i,1)  = 2; 
        else                                                              cho(i,1)  = 0; 
        end   
    end
    resp = data_Learning(:,11);
    output = [con,cho,out,cou,resp];
end
%%    

%-remove the non-responded trials from fitting analysis
%----------------------------------------------------------------------
Indx     = find(output(:,5) == 1);
output   = output(Indx,:); 



