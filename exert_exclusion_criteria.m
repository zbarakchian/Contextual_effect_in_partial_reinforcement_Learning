function sbjs = exert_exclusion_criteria(addr,ftype,config)

sbjs = [];
switch ftype
    
case 'Partial'
sbjs_total           = [1:41];
sbjs_partl           = [1:41];
sbjs_NlearnedP       = [15 17];
sbj_ConvergedP       = check_convergency(addr,ftype,sbjs_total,config.cnvrg);
sbj_NconvergedP      = sbjs_total; sbj_NconvergedP(sbj_ConvergedP) = []; 
sbj_delP             = [sbjs_NlearnedP, sbj_NconvergedP];
sbjs_partl(sbj_delP) = [];
       
sbjs = sbjs_partl;

case 'Complete'
sbjs_total           = [1:47];
sbjs_cmplt           = [1:47];
sbjs_NlearnedC       = [22 37 38];         
sbj_ConvergedC       = check_convergency(addr,ftype,sbjs_total,config.cnvrg);
sbj_NconvergedC      = sbjs_total; sbj_NconvergedC(sbj_ConvergedC) = []; 
sbj_delC             = [sbjs_NlearnedC, sbj_NconvergedC];
sbjs_cmplt(sbj_delC) = [];

sbjs = sbjs_cmplt;
end