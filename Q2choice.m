function output = Q2choice(Q,beta)

%-stochastic(soft-max)
%--------------------------------------------------------------------------
p_left  = 1/(1 + exp(beta * (Q(2) - Q(1))));            
p_right = 1 - p_left;                                                         
output.softmax.p = [p_left,p_right];

% p = rand;
% if p <= p_left 
%     action = 1;
% else
%     action = 2;
% end
% 
% output.softmax.choice = [0 0];
% output.softmax.choice(action) = 1;

%-deterministic(greedy)
%--------------------------------------------------------------------------        
if      Q(1) > Q(2)                 
    output.greedy = [1 0];

elseif  Q(1) < Q(2)                    
    output.greedy = [0 1];
 
elseif  Q(1) == Q(2)             
    action  = randi(2);
    output.greedy = [0 0];
    output.greedy(action) = 1;
end


