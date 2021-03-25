function output = goodnessOFfit(addr,ftype,config_main,config_fit,config_gof,sbjs,models)
% compare two models with selecting the model with LL > other LLs 

%-load Data
%--------------------------------------------------------------------------
load([addr.bhv filesep 'data_', ftype, '_Learning.mat']); 
load([addr.bhv filesep 'data_', ftype, '_Transfer.mat']); 
load([addr.bhv filesep 'data_', ftype, '_Estimation.mat']);

requested = load([addr.fit filesep 'data_fit_',ftype,'_Learning1_Transfer',num2str(config_fit.fit_transfer),'_Prior',num2str(config_fit.use_prior),'.mat']);
new       = load([addr.fit filesep 'data_fit_BIC_' ftype]);
%--------------------------------------------------------------------------
nsub   = length(sbjs.indx);
nmodel = length(models);

%==========================================================================
%-Learning Phase
%==========================================================================
for m = 1:nmodel
    for sub = sbjs.indx      
        %------------------------------------------------------------------
        nfpm  = models{m}.parameters.num;
        nt    = sbjs.nt(sub);
        %------------------------------------------------------------------
%         gof(m).learning.negloglik(sub)  = requested.data_fit.(models{m}.name)(sub).negloglik;     
        gof(m).learning.negloglik(sub)  = new.info_criterion.(models{m}.name)(sub,1);  %1:nll, 2:BIC    
        gof(m).learning.AIC(sub)        = 2*gof(m).learning.negloglik(sub) + nfpm*2;     
        gof(m).learning.BIC(sub)        = 2*gof(m).learning.negloglik(sub) + nfpm*log(nt); 
        gof(m).learning.ABIC(sub)       = 2*gof(m).learning.negloglik(sub) + nfpm*log((nt+2)/24); 
        %------------------------------------------------------------------     
    end
end

%==========================================================================
%-Transfer Phase
%==========================================================================
pref_left  = [];
pref_right = [];
switch config_main.ttype
    case 'rate'
        pref_left  = info_transfer.pref.rate_left;
        pref_right = info_transfer.pref.rate_right;
    case 'binary'
        pref_left  = info_transfer.pref.bin_left;
        pref_right = info_transfer.pref.bin_right;
    case 'first'
        pref_left  = info_transfer.pref.first_left;
        pref_right = info_transfer.pref.first_right;
end

%-preference_all
%--------------------------------------------------------------------------
cmb      = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];
cmbN     = 6;

%--------------------------------------------------------------------------                           
%-calculating the transfer phase probabilistically based on the fitted
%betas
%--------------------------------------------------------------------------                           
field_names = {'Lik1','negLoglik1','AIC1','BIC1','ABIC1',...
               'Lik4','negLoglik4','AIC4','BIC4','ABIC4'};

for m = 1:nmodel
    disp(m);
    nfpm  = models{m}.parameters.num;
    
    %-make the arrays empty
    %----------------------------------------------------------------------                           
    for i = 1:length(field_names)
        eval([field_names{i} ' = [];']);
    end
    
    %-fill in the goodness-of-fit variables
    %----------------------------------------------------------------------                           
    for sub = sbjs.indx

        %-fit on the subjecs' decisions
        %------------------------------------------------------------------                           
        params         = requested.data_fit.(models{m}.name)(sub).params;
        beta           = params(1);
        args.arg_learn = extract_data_for_sim2(addr,ftype,sub);
        args.Q0        = [0 0;0 0];
        out            = models{m}.simulate_sbj(params,args); 
        Q_row          = [out.Qend(1,1),out.Qend(2,1),out.Qend(1,2),out.Qend(2,2)];

        %-calculate Likelihood of the first iteration of each combination
        %------------------------------------------------------------------                           
        lik1        = [];        
        negloglik1  = [];        
        AIC1        = [];        
        BIC1        = [];      
        ABIC1       = [];        
        for c = 1:cmbN
            if      pref_left(sub,c) == 1 && pref_right(sub,c) == 0                
                chosen        = cmb(c,1);                
                unchosen      = cmb(c,2);               
           elseif  pref_left(sub,c) == 0 && pref_right(sub,c) == 1               
                chosen        = cmb(c,2);                
                unchosen      = cmb(c,1);
           elseif  pref_left(sub,c) ==  pref_right(sub,c) %% TODO               
                chosen        = cmb(c,1);                
                unchosen      = cmb(c,1);
            end            
            p      = 1/(1 + exp(beta * (Q_row(unchosen) - Q_row(chosen))));            
            negll = -log(p);
            aic   = 2*negll + nfpm*2;
            bic   = 2*negll + nfpm*log(1); 
            abic  = 2*negll + nfpm*log((1+2)/24); 
            
            lik1        = [lik1, p];
            negloglik1  = [negloglik1, -log(p)];
            AIC1        = [AIC1, aic];
            BIC1        = [BIC1, bic];
            ABIC1       = [ABIC1,abic];
        end
        %------------------------------------------------------------------                        
        %-for all 6 combinations       
        %------------------------------------------------------------------                                
        lik_all     = geomean(lik1(1:6));
        negll_all   = sum(negloglik1(1:6)); 
        aic_all     = 2*negll_all + nfpm*2;
        bic_all     = 2*negll_all + nfpm*log(6);         
        abic_all    = 2*negll_all + nfpm*log((2+6)/24);  
        
        %-add it to the end of the array
        %------------------------------------------------------------------                        
        lik1        = [lik1,lik_all]; %prod(Lik1)
        negloglik1  = [negloglik1, negll_all]; %sum
        AIC1        = [AIC1,aic_all];          
        BIC1        = [BIC1,bic_all];
        ABIC1       = [ABIC1,abic_all];
        %------------------------------------------------------------------                        
        %-each row for each sbj
        %------------------------------------------------------------------                        
        Lik1s(:,sub)        = lik1;        
        negloglik1s(:,sub)  = negloglik1;
        AIC1s(:,sub)        = AIC1;        
        BIC1s(:,sub)        = BIC1;
        ABIC1s(:,sub)       = ABIC1;
        %==================================================================
        %-calculate Likelihood of all four iterations of each combination
        %==================================================================
        Lik4        = [];        
        negLoglik4  = [];        
        AIC4        = [];        
        BIC4        = [];        
        ABIC4       = [];        
        for c = 1:cmbN          Lik_per_iter = [];
            for i = 1:4
%                 chosen  = pref_all{sub}(i,c);
%                 if     chosen == cmb(i,1)     unchosen  = cmb(i,2);               
%                 elseif chosen == cmb(i,2)     unchosen  = cmb(i,1);   end
                                
                left_chosen  = info_transfer.pref.all{sub}.left(i,c);
                if  left_chosen     
                    chosen    = cmb(c,1);
                    unchosen  = cmb(c,2);               
                else
                    chosen    = cmb(c,2);     
                    unchosen  = cmb(c,1);   
                end
                
                p  = 1/(1 + exp(beta * (Q_row(unchosen) - Q_row(chosen))));
                Lik_per_iter = [Lik_per_iter, p];
            end
            Lik_geomean   = geomean(Lik_per_iter); %prod(Lik_per_iter)
            negLoglik_sum = sum(-log(Lik_per_iter));

            negll = negLoglik_sum;
            aic   = 2*negll + nfpm*2;
            bic   = 2*negll + nfpm*log(4); 
            abic  = 2*negll + nfpm*log((2+4)/24); 
            
            Lik4        = [Lik4, Lik_geomean];
            negLoglik4  = [negLoglik4, negLoglik_sum];
            AIC4        = [AIC4,aic];
            BIC4        = [BIC4,bic];
            ABIC4       = [ABIC4,abic];
        end
        %------------------------------------------------------------------                        
        %-for all 6 combinations       
        %------------------------------------------------------------------                                
        lik_all     = geomean(Lik4(1:6));
        negll_all   = sum(negLoglik4(1:6)); %LL4(7)
        aic_all     = 2*negll_all + nfpm*2;
        bic_all     = 2*negll_all + nfpm*log(24);         
        abic_all    = 2*negll_all + nfpm*log((2+24)/24); 
        
        %-add it to the end of the array
        %------------------------------------------------------------------                        
        Lik4        = [Lik4,lik_all]; %prod(Lik4)
        negLoglik4  = [negLoglik4, negll_all];
        AIC4        = [AIC4,aic_all];          
        BIC4        = [BIC4,bic_all];
        ABIC4       = [ABIC4,abic_all];
        %------------------------------------------------------------------                        
        %-each row for each sbj
        %------------------------------------------------------------------                        
        Lik4s(:,sub)        = Lik4;        
        negloglik4s(:,sub)  = negLoglik4;
        AIC4s(:,sub)        = AIC4;        
        BIC4s(:,sub)        = BIC4;
        ABIC4s(:,sub)       = ABIC4;
        %------------------------------------------------------------------        
    end
    
    %-put goodness of fit into the transfer_prob part of the gof variable
    %----------------------------------------------------------------------
    gof(m).transfer_prob.Lik1        = Lik1s;    
    gof(m).transfer_prob.negloglik1  = negloglik1s;     
    gof(m).transfer_prob.AIC1        = AIC1s; 
    gof(m).transfer_prob.BIC1        = BIC1s;    
    gof(m).transfer_prob.ABIC1       = ABIC1s;   
    
    gof(m).transfer_prob.Lik4        = Lik4s;
    gof(m).transfer_prob.negloglik4  = negloglik4s;
    gof(m).transfer_prob.AIC4        = AIC4s;    
    gof(m).transfer_prob.BIC4        = BIC4s;
    gof(m).transfer_prob.ABIC4       = ABIC4s;
end

%==========================================================================
%-calculate Likelihood and so on depends on the requested configuration
%==========================================================================

%----------------------------------------------------------------------
if config_gof.type == 1 || config_gof.type == 3 %-if includes Learning phase calculate the learning variables
    for m = 1:nmodel
        learning.nll{m} = gof(m).learning.negloglik;        
    end
end

%----------------------------------------------------------------------
if config_gof.type == 2 || config_gof.type == 3 %-if includes Transfer phase calculate the transfer variables
    
    switch config_gof.transfer.iter    
        case 1 % only first iteration of each combination
        for m = 1:nmodel
            tmp.nll{m} = gof(m).transfer_prob.negloglik1;
            tmp.nt = 1;
        end 
        
        case 4 % all  four iterations of each combination
        for m = 1:nmodel
            tmp.nll{m} = gof(m).transfer_prob.negloglik4;
            tmp.nt = 4;
        end
    end

    for m = 1:nmodel
    switch config_gof.transfer.cmb
        case 1 %A1A2
            transfer.nll{m} = tmp.nll{m}(1,:);
            transfer.nt = 1*tmp.nt;
            
        case 2 %A1B
            transfer.nll{m} = tmp.nll{m}(2,:);
            transfer.nt = 1*tmp.nt;
            
        case 3 %A1C
            transfer.nll{m} = tmp.nll{m}(3,:);
            transfer.nt = 1*tmp.nt;

        case 4 %A2B
            transfer.nll{m} = tmp.nll{m}(4,:);
            transfer.nt = 1*tmp.nt;
            
        case 5 %A2C
            transfer.nt = 1*tmp.nt;
            transfer.nll{m} = tmp.nll{m}(5,:);
            
        case 6 %BC
            transfer.nll{m} = tmp.nll{m}(6,:);
            transfer.nt = 1*tmp.nt;
            
        case 7 %1+2+3+4+5+6
            transfer.nll{m} = sum(tmp.nll{m}([1:6],:),1);
            transfer.nt = 6*tmp.nt;
            
        case 8 %1+6
            transfer.nll{m} = sum(tmp.nll{m}([1,6],:),1);
             transfer.nt = 2*tmp.nt;
           
        case 9 %2+3+4+5
            transfer.nll{m} = sum(tmp.nll{m}([2:5],:),1);
            transfer.nt = 4*tmp.nt;            
    end
    end
end

%----------------------------------------------------------------------
switch config_gof.type
    
    %----------------------------------------------------------------------
    case 1 %-Learning phase
    %----------------------------------------------------------------------
    for m = 1:nmodel
        for sub = sbjs.indx                      
            nfpm  = models{m}.parameters.num;
            nt    = sbjs.nt(sub);
            %--------------------------------------------------------------
            cases.negloglik(sub,m) = learning.nll{m}(sub);
            cases.AIC(sub,m)       = 2*cases.negloglik(sub,m) + nfpm*2;
            cases.BIC(sub,m)       = 2*cases.negloglik(sub,m) + nfpm*log(nt);         
            cases.ABIC(sub,m)      = 2*cases.negloglik(sub,m) + nfpm*log((2+nt)/24);         
        end
    end

    %-calculating the ratio of transfer phase greedily
    %----------------------------------------------------------------------                           
    for m = 1:nmodel

        %-fill in the goodness-of-fit variables
        %------------------------------------------------------------------                           
        for sub = sbjs.indx

            %-fit on the subjecs' decisions
            %---------------------------------------------------------------                           
            params         = requested.data_fit.(models{m}.name)(sub).params;
            beta           = params(1);
            args.arg_learn = extract_data_for_sim2(addr,ftype,sub);
            args.Q0        = [0 0;0 0];
            out            = models{m}.simulate_sbj(params,args); 
            Q_row          = [out.Qend(1,1), out.Qend(2,1), out.Qend(1,2), out.Qend(2,2)];

            %-calculate Likelihood of all four iterations of each combination
            %---------------------------------------------------------------                           
            for c = 1:cmbN          
                for i = 1:4

                    %-subject choice
                    %------------------------------------------------------           
                    left_chosen  = info_transfer.pref.all{sub}.left(i,c);
                    if  left_chosen     
                        chosen    = cmb(c,1);
                        unchosen  = cmb(c,2);               
                    else
                        chosen    = cmb(c,2);     
                        unchosen  = cmb(c,1);   
                    end

                    transfer_greedy{sub}.real(i,c) = chosen;

                    %-subject choice
                    %------------------------------------------------------           
                    if    Q_row(cmb(c,1)) > Q_row(cmb(c,2))            
                        chosen        = cmb(c,1);                
                        unchosen      = cmb(c,2);               
                    elseif Q_row(cmb(c,1)) < Q_row(cmb(c,2))               
                        chosen        = cmb(c,2);                
                        unchosen      = cmb(c,1);
                    elseif  Q_row(cmb(c,1)) == Q_row(cmb(c,2)) %% TODO               
                        chosen        = cmb(c,1);                
                        unchosen      = cmb(c,1);
                    end

                    transfer_greedy{sub}.synthetic(i,c) = chosen; 
                end
            end
        end

        %-calculate rate of prediction
        %------------------------------------------------------------------                           
        itr1 = [];
        itr4 = [];
        for sub = sbjs.indx           
            consistency{sub} = transfer_greedy{sub}.real == transfer_greedy{sub}.synthetic;
            itr1 = [itr1;consistency{sub}(1,:)]; 
            itr4 = [itr4;mean(consistency{sub},1)];
        end
        ratio(m).itr1 = mean(itr1,1); 
        ratio(m).itr4 = mean(itr4,1); 

        %-put goodness of fit into the transfer part of the gof variable
        %----------------------------------------------------------------------
        gof(m).transfer_greedy.data  = transfer_greedy;
        gof(m).transfer_greedy.cnsis = consistency;
    end 
    
    %----------------------------------------------------------------------
    case 2 %-Transfer phase
    %----------------------------------------------------------------------
    for m = 1:nmodel
        for sub = sbjs.indx                      
            nfpm  = models{m}.parameters.num;
            nt    = transfer.nt;
            %----------------------------------------------------------
            cases.negloglik(sub,m) = transfer.nll{m}(sub);
            cases.AIC(sub,m)       = 2*cases.negloglik(sub,m) + nfpm*2;
            cases.BIC(sub,m)       = 2*cases.negloglik(sub,m) + nfpm*log(nt);         
            cases.ABIC(sub,m)      = 2*cases.negloglik(sub,m) + nfpm*log((2+nt)/24);         
        end
    end
    
    %----------------------------------------------------------------------
    case 3  %-Both phases
    %----------------------------------------------------------------------
    for m = 1:nmodel
        for sub = sbjs.indx                      
            nfpm  = models{m}.parameters.num;
            nt    = sbjs.nt(sub) + transfer.nt; %6
            %----------------------------------------------------------
            cases.negloglik(sub,m) = learning.nll{m}(sub) + transfer.nll{m}(sub);
            cases.AIC(sub,m)       = 2*cases.negloglik(sub,m) + nfpm*2;
            cases.BIC(sub,m)       = 2*cases.negloglik(sub,m) + nfpm*log(nt);         
            cases.ABIC(sub,m)      = 2*cases.negloglik(sub,m) + nfpm*log((2+nt)/24);         
        end
    end
end

%==========================================================================
%-calculate statistics (mean/sem) of the gof and put them into geof_stat
%==========================================================================
field_names={'negloglik','AIC','BIC','ABIC'};
for m = 1:nmodel
    for i = 1:numel(field_names)
        overal.(field_names{i})(m,1) = nanmean(cases.(field_names{i})(sbjs.indx,m),1);      
        overal.(field_names{i})(m,2) = nanstd (cases.(field_names{i})(sbjs.indx,m),1)/sqrt(nsub);      
    end               
end


for m = 1:nmodel
    names{m} = models{m}.name;
end


% gof_stat(m).Lik_geomean1    = geomean(gof(m).Lik1,1);
% gof_stat(m).Lik_geomean4    = geomean(gof(m).Lik4,1);

output.lik.persbj   = cases;
output.lik.avrg     = overal;
output.model_names  = names;
output.data = gof;

if config_gof.type == 1
output.greedy.ratio = ratio;
end

%--------------------------------------------------------------------------
if config_gof.save
    disp('saving the goodness of fit ...');
    save([ addr.gof filesep ...
                 'data_gof_',ftype,...
                 '_type', num2str(config_gof.type),...
                 '_transfer','_itr',num2str(config_gof.transfer.iter),...
                 '_cmb',num2str(config_gof.transfer.cmb)],...
         'output');     
     disp('Saving finished.');
end


