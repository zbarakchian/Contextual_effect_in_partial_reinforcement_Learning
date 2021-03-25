function organize_behavioral_data(addr)

task = {'Partial','Complete'}; 

for version = 1:2
    ftype = task{version};
    
    sbjs_all.indx = get_all_sbjs(ftype);
    sbjs_all.nt   = find_end_trial(ftype,sbjs_all);

    info_learning = extract_info_learning(ftype,sbjs_all); 
    save([addr.bhv filesep 'data_' ftype '_Learning'], 'info_learning');

    info_transfer = extract_info_transfer(ftype,sbjs_all);
    save([addr.bhv filesep 'data_' ftype '_Transfer'], 'info_transfer');


    info_estimation = extract_info_estimation(ftype,sbjs_all);
    save([addr.bhv, filesep, 'data_',ftype,'_Estimation'], 'info_estimation');

end