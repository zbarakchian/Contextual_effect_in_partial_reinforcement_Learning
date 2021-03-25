function models = choose_models(ftype,models_all,to_run)

if isempty(to_run) %all models
    
    switch ftype
    case 'Partial'
        models = models_all.models_partial([1:12]);
        models = add_index(models);
    case 'Complete'
        models = models_all.models_complete([1:16]);
        models = add_index(models);
    end  

else %subset of models   

    switch ftype
    case 'Partial'
        models = models_all.models_partial(to_run);
        models = add_index(models);
    case 'Complete'
        models = models_all.models_complete(to_run);
        models = add_index(models);
    end
    
end


