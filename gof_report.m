function tbl_report =  gof_report(ftype,sbjs,models)
%-create a structure to report

%--------------------------------------------------------------------------
% The Structure
%--------------------------------------------------------------------------
% columns: 
% model names or numbers
% 
% rows: 
% negloglik:        learning
% BIC:              learning 
% negloglik:        transfer(A1A2), 
% BIC:              BIC(learning + transfer(A1A2)) 
% negloglik:        transfer(1+..+6) 
% BIC:              BIC(learning + transfer(1+..+6)) 
% ratio_prediction: transfer(A1A2)
% ratio_prediction: transfer(1+...+6)
%--------------------------------------------------------------------------

nsub   = length(sbjs);
nmodel = length(models);

% extract the necessary data and put it into tmp variable
%--------------------------------------------------------------------------
%-load the learning one (type1) 
load(strcat( 'data_gof/',...
             'data_gof_',       ftype,...
             '_type',           num2str(1),...
             '_transfer','_itr',num2str(0),...
             '_cmb',            num2str(0)),...
      'output');

tmp.model_names     = output.model_names;
tmp.learning        = output.lik;
tmp.transfer.greedy = output.greedy;

%--------------------------------------------------------------------------
%-load the transfer one (type 2) 
load(strcat( 'data_gof/',...
             'data_gof_',       ftype,...
             '_type',           num2str(2),...
             '_transfer','_itr',num2str(1),...
             '_cmb',            num2str(1)),...
      'output');
 
tmp.transfer.lik21    = output.lik;

%--------------------------------------------------------------------------
%-load the transfer one (type 2) 
load(strcat( 'data_gof/',...
             'data_gof_',       ftype,...
             '_type',           num2str(2),...
             '_transfer','_itr',num2str(1),...
             '_cmb',            num2str(7)),...
      'output');
  
tmp.transfer.lik27    = output.lik;

%--------------------------------------------------------------------------
%-load the transfer one (type 3) 
load(strcat( 'data_gof/',...
             'data_gof_',       ftype,...
             '_type',           num2str(3),...
             '_transfer','_itr',num2str(1),...
             '_cmb',            num2str(1)),...
      'output');
 
tmp.transfer.lik31    = output.lik;

%--------------------------------------------------------------------------
%-load the transfer one (type 3) 
load(strcat( 'data_gof/',...
             'data_gof_',       ftype,...
             '_type',           num2str(3),...
             '_transfer','_itr',num2str(1),...
             '_cmb',            num2str(7)),...
      'output');
  
tmp.transfer.lik37    = output.lik;

%--------------------------------------------------------------------------
%-create the table structure
%--------------------------------------------------------------------------
for m = 1:nmodel
    mname = models{m}.name;     disp(mname);   
    mindxs = find(contains(tmp.model_names,mname));
    
    mindx = 0;
    if length(mindxs) > 1
        for i = 1:length(mindxs)
            if isequal(mname, tmp.model_names{mindxs(i)})
                mindx = mindxs(i);
                break;
            end
        end
    else mindx = mindxs; end
    
    tbl.data(1,m,:)  = tmp.learning.avrg.negloglik(mindx,:);
    tbl.data(2,m,:)  = tmp.learning.avrg.BIC(mindx,:);
    tbl.data(3,m,:)  = tmp.transfer.lik21.avrg.negloglik(mindx,:);
    tbl.data(4,m,:)  = tmp.transfer.lik31.avrg.BIC(mindx,:);
    tbl.data(5,m,:)  = tmp.transfer.lik27.avrg.negloglik(mindx,:);
    tbl.data(6,m,:)  = tmp.transfer.lik37.avrg.BIC(mindx,:);
    tbl.data(7,m,1)  = tmp.transfer.greedy.ratio(mindx).itr1(1);
    tbl.data(8,m,1)  = mean(tmp.transfer.greedy.ratio(mindx).itr1(:));
    
    tbl.columns{m}     = mname;
end

tbl.rows{1,1} = 'negloglik(learning)';
tbl.rows{2,1} = 'BIC(learning)';
tbl.rows{3,1} = 'negloglik(transfer(A1A2))'; 
tbl.rows{4,1} = 'BIC(learning + transfer(A1A2)))'; 
tbl.rows{5,1} = 'negloglik(transfer(all 6 combinations))' ;
tbl.rows{6,1} = 'BIC(learning + transfer(all 6 combinations)))';
tbl.rows{7,1} = 'ratio_prediction(transfer(A1A2))';
tbl.rows{8,1} = 'ratio_prediction(transfer(all 6 combinations))';

disp('finish!');

tbl_report = [];
tbl_report.mean     = round(tbl.data(:,:,1),2);
tbl_report.sem      = round(tbl.data(:,:,2),2);
tbl_report.name_col = tbl.columns;
tbl_report.name_row = tbl.rows;


 

 
 
 