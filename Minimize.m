function optimal = Minimize(id,model,args)
disp('----------------------------Fitting----------------------------');

%-fill in the variables necessary for running the fmincon function
%----------------------------------------------------------------------
funcType    = args.funcType;
% tleave      = args.tleave;    
%----------------------------------------------------------------------
inits       = model.parameters.inits;
init_size   = length(inits);
lb          = model.parameters.lb;
ub          = model.parameters.ub;

if isfield(model.parameters,'A')
     A = model.parameters.A;
else A = []; end

if isfield(model.parameters,'b')
     b = model.parameters.b;
else b = []; end
    

%-set the options of fmincon
%----------------------------------------------------------------------
% n_iter      = 1000; %10000
% options     = optimset('Algorithm', 'interior-point', 'MaxIter', n_iter);%,'Display','iter');       
options     = optimset('Algorithm', 'interior-point','Display','on');%,'Display','iter');       

%- run the fmincon
%----------------------------------------------------------------------
min_nLL = 10000;      %nLL= negative log likelihood   
for i = 1:init_size
    disp('------------------------------------------------------------');
    disp(model.name);
    disp([id, i, init_size]);
    disp('------------------------------------------------------------');

    try 
    switch(funcType)
    %=======================================================================
    %-fitting in a normal way
    %=======================================================================
    case 'Standard'
        [parameters,nLL,exitflag,output,lambda,grad,hessian] = ...  
           fmincon(@(x) model.func(x,args),inits(i,:),A,b,[],[],lb,ub,[],options);

    %=======================================================================
    %-fitting in a cross-validation way
    %=======================================================================
    case 'Cross-Validation'
        [parameters,nLL,exitflag,output,lambda,grad,hessian] = ...
           fmincon(@(x) model.funcCrossV(x,args),inits(i,:),[],[],[],[],lb,ub,[],options);
    end

    %-find the minimum
    %------------------------------------------------------------------
    if nLL <= min_nLL
        min_nLL = nLL;

        optimal.params      = parameters; 
        optimal.negloglik   = nLL; 
        optimal.exitflag    = exitflag;
        optimal.output      = output;
        optimal.lambda      = lambda;
        optimal.grad        = grad;
        optimal.hessian     = hessian;
    end
    %------------------------------------------------------------------
    catch  end
end
if min_nLL == 10000
    optimal.params = NaN;
end
%----------------------------------------------------------------------
