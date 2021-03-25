function output = simulate(model,params,args)
%--------------------------------------------------------------------------
if ~isempty(params)
    go = 1;
    while(go)
        %-simulate 
        %----------------------------------------------------------------------
        sim = model.simulate(params,args);
        
        %-Check expected rewards, 8 ,11 to be valid! whether they can converge or not?
        %----------------------------------------------------------------------
        stim = sim.data(:,8);
        rwds = sim.data(:,11);
        
        rwds_mean = [];
        for i = 1:4
            I = find(stim == i);
            rwds_mean(i) = mean(rwds(I));
        end
        if (abs(rwds_mean(1)-rwds_mean(2)) <= 5) & sum(isnan(rwds_mean)) == 0
            n_tr = size(sim.value,1);
            disp('YESSSSSSSSSSSSSSSSSSS')
            go = 0;
            break;
        else 
            go = go + 1;
            if go == 10000
                disp("Sorry! no valid converged simulation found for this Parameter :(");
                sim = [];
                return;
            end
        end
    end
    %-specify the output    
    output = sim;

end
