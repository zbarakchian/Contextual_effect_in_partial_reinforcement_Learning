function models = add_index(models)

nmodel = length(models);

for m = 1:nmodel
    models{m}.index = m;
end