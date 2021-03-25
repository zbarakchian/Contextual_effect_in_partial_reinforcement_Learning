function [a p] = choose_option(P,s,t)   

a = 1;
p = rand;
if p <= P(s,a,t) %actions = (state,action) = 11,12,21,22 (A1,B,A2,C)
    a = a;
else
    a = 3-a;
end