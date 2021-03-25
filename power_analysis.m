function power_analysis(ss) %ss = sample size

%% effectSize = 0.8 - 0.5; %Klein2017, Type2 transitions
p0 = 0.5;
p1 = 0.8;


n0 = ss*p0;
n2 = binoinv(.975, ss,.5);
n1 = n0 - (n2 - n0);
% CI = [n1 n2]
% beta = pr(X in CI)
beta = binocdf(n2,ss,p1) - binocdf(n1,ss,p1);
power = 1 - beta;
disp(power);
