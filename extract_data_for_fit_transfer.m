function output = extract_data_for_fit_transfer(addr,ftype,config_main,sub)
load([addr.bhv, filesep, 'data_', ftype, '_Transfer.mat']);

pref  = [];
switch config_main.ttype
    case 'rate' %% TODO
%         pref  = preference_all;
    case 'binary'
%         pref  = preference_all;
    case 'first'
        pref  = [ info_transfer.pref.first_left(sub,:); ...
                  info_transfer.pref.first_right(sub,:)];
end
output = pref;


