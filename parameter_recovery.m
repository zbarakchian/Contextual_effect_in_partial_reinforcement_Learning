function params2 = parameter_recovery(model,params1,ntrial)
    
%-simulate
%----------------------------------------------------------------------
args.arg_learn      = design_rewards([[64,13]; [64, 13]; [54, 13]; [44, 13]],ntrial);
args.Q0             = [0 0;0 0];
args.sub            = nan;
args.model          = nan;

sim                 = model.simulate(params1,args);   
data                = sim.data;

%-fitting
%----------------------------------------------------------------------
args.arg_learn      = extract_data_for_fit_learning(data);  %arguments: [con,cho,out,cou,resp];    
args.arg_transfer   = nan;
args.t1             = 1;
args.t2             = ntrial;
args.Q0             = [0,0; 0,0];
args.funcType       = 'Standard';
args.use_prior      = 1;
args.fit_transfer   = 0;

optimal             = Minimize(0,model,args);
params2             = optimal.params;





