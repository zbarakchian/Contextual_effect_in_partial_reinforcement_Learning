function tble = report_params(addr,ftype,models)

load([addr.params filesep 'data_parameters_', ftype]);

nmodel = length(models);

npmax = 0;
for m = 1:nmodel
    model = models{m};
    n     = info_params.(model.name).num;
    if n > npmax
        npmax = n;
    end
end


    
n = [];

tmp1 = zeros(npmax,nmodel);
tmp2 = zeros(npmax,nmodel);
for m = 1:nmodel
    model   = models{m};
    n(m)    = info_params.(model.name).num;
    params  = info_params.(model.name).stats;
    
    for j = 1:n(m)
        tmp1(j,m) = params(1,j);
        tmp2(j,m) = params(2,j);
    end
    
    tble.columns{1,m} = [model.name];    
end

tble.mean  = round(tmp1,2);
tble.std   = round(tmp2,2);


tble_latex = [];
for m = 1:nmodel
    tble_latex{1,m} = tble.columns{1,m};
    for j = 1:n(m)
        tble_latex{j+1,m} = ['$' num2str(tble.mean(j,m)) ' \pm ' num2str(tble.std(j,m)) '$'];
    end
end

disp('');







