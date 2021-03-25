function tbl_report =  report_gof_bys(addr,ftype,sbjs,models,bms_results, flag)

nmodel = length(models);
tmp     = bms_results;

% OUTPUTS:
%   alpha   - vector of model probabilities
%   exp_r   - expectation of the posterior p(r|y)
%   xp      - exceedance probabilities
%   pxp     - protected exceedance probabilities
%   bor     - Bayes Omnibus Risk (probability that model frequencies are equal)

if flag == 1
%--------------------------------------------------------------------------
%-create the table structure
%--------------------------------------------------------------------------
for m = 1:nmodel
    
    tbl.data(1,m)  = tmp.xp(m);
    tbl.data(2,m)  = tmp.pxp(m);
    
    mname = models{m}.name;
    tbl.columns{m}   = mname;
end

% tbl.rows{1,1} = 'learning';
tbl.rows{1,1} = 'xp';
tbl.rows{2,1} = 'pxp';

disp('finish!');

tbl_report = [];
tbl_report.xp       = tbl.data;
tbl_report.name_col = tbl.columns;
tbl_report.name_row = tbl.rows;

%% latex
tble_latex  = [];
for i = 1:size(tbl_report.xp,1)
    for m = 1:nmodel
        tble_latex{1,m+1}   =   tbl_report.name_col{1,m};
        tble_latex{i+1,1}   =   tbl_report.name_row{i,1};
        tble_latex{i+1,m+1} =   ['$' num2str(tbl_report.xp(i,m)) '$'];
    end
end

disp(tble_latex);
disp('');

  
end

if flag == 2
%--------------------------------------------------------------------------
%-create the table structure
%--------------------------------------------------------------------------
for m = 1:nmodel
    
    tbl.data(1,m)  = tmp(1).xp(m);
    tbl.data(2,m)  = tmp(2).xp(m);
    tbl.data(3,m)  = tmp(3).xp(m);
    tbl.data(4,m)  = tmp(4).xp(m);
    tbl.data(5,m)  = tmp(5).xp(m);
    
    mname = models{m}.name;
    tbl.columns{m}   = mname;
end

tbl.rows{1,1} = 'learning';
tbl.rows{2,1} = '21';
tbl.rows{3,1} = '27'; 
tbl.rows{4,1} = '31'; 
tbl.rows{5,1} = '37';

disp('finish!');

tbl_report = [];
tbl_report.xp       = tbl.data;
tbl_report.name_col = tbl.columns;
tbl_report.name_row = tbl.rows;

%% latex
tble_latex  = [];
for i = 1:size(tbl_report.xp,1)
    for m = 1:nmodel
        tble_latex{1,m+1}   =   tbl_report.name_col{1,m};
        tble_latex{i+1,1}   =   tbl_report.name_row{i,1};
        tble_latex{i+1,m+1} =   ['$' num2str(tbl_report.xp(i,m)) '$'];
    end
end

disp(tble_latex);
disp('');

end

