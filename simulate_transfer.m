function output = simulate_transfer(Qend,beta)

%--------------------------------------------------------------------------
cmb      = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];
ncmb     = length(cmb);

%-greedy
%--------------------------------------------------------------------------
data_transfer = [];
for c = 1:ncmb
    Q           = Qend(cmb(c,:));  
    result      = Q2choice(Q,beta); % it returns both softmax, and greedy versions of choice
    prefs       = result.greedy; 
    confs       = [0 0];
    rts         = [0 0];
    data_transfer = [data_transfer; [cmb(c,:), prefs, confs, rts]];
end
output.greedy = data_transfer;

%-softmax
%--------------------------------------------------------------------------
data_transfer = [];
for c = 1:ncmb
    Q           = Qend(cmb(c,:));  
    result      = Q2choice(Q,beta); % it returns both softmax, and greedy versions of choice
    prefs       = result.softmax.p;
    confs       = [0 0];
    rts         = [0 0];
    data_transfer = [data_transfer; [cmb(c,:), prefs, confs, rts]];
end
output.softmax = data_transfer;
