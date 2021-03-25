function [h,pout,ratio] = binomial_test(X1,X2)

sz1 = size(X1);
sz2 = size(X2);

if sz1(1) == 1 
    X1 = X1';
end

if sz2(1) == 1
    X2 = X2';
end

I1   = find(X1==1 & X2==0);
I2   = find(X1==0 & X2==1);
Ieq  = find(X1==1 & X2==1);
n1   = size(I1,1);
n2   = size(I2,1);
neq  = size(Ieq,1);
N12  = n1 + n2;
Nsub = N12 + neq;
%--------------------------------------------------------------------------
%% Bionomial
p_binom1 = binocdf(n1,N12,0.5,'upper');
p_binom2 = binocdf(n2,N12,0.5,'upper');

if p_binom2 < 0.5 
    p_binom2 = p_binom2;
    ratio = n2/N12;
elseif p_binom2 >= 0.5 
    p_binom2 = 1 - p_binom2;
    ratio = n1/N12;
end
%%
pout  = 2*p_binom2;
h     = 1;
if pout > .05
    h     = 0;
end

%%% 
%----------------------------------------------------------------------
% %% Confidence Interval for proportion
% %z = (p - pHAT)/sd);
% % pr(c1<z<c2) = 0.95 ->  pHAT + sd*z1 < p < pHAT + sd*z2 
% p_CI = 0.95; 
% p1 = (1 - p_CI)/2; 
% p2 = 1 - p1;
% pHAT = nA2/NA1A2;
% sd   = sqrt(pHAT*(1-pHAT)/NA1A2);
% z1   = norminv(p1,0,1);
% z2   = norminv(p2,0,1);
% c1   = pHAT + sd*z1;
% c2   = pHAT + sd*z2;
% parray = [nAeq,nA1,nA2,NA1A2];
% CI = [c1 c2];
% disp(parray);
% disp(['proportion = ',num2str(pHAT)]);
% disp(['Confidence Interval = [',num2str(CI(1)),',',num2str(CI(2)),']']);
