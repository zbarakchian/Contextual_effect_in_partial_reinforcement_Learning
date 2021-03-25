function [RWA1, RWA2, RWB, RWC] = main_psudorand_rewards()
load tempWorkspace

%% Begin
n = 2*trials_perType_Learn;
while true
    %% Create Default Rewards
    RWs = zeros(n,4);
    for i = 1:4
        %stimuli
        mu    = mu_Learn(i);
        sigma = sd_Learn(i);
        %left-right, right-left
        y = [];  indx = 0;
        while indx ~= n
            rw = round(normrnd(mu, sigma));
            if (rw >= mu - 3*sigma) & (rw <= mu + 3*sigma) & (rw > 0) & (rw <= 100)
                m2 = mod(rw,2); if  (m2 == 0) rw = rw; elseif (m2 == 1) rw = rw + 1;  end
                y = [y; rw];
                indx = indx + 1;
            end
        end
        RWs(:,i) = y;
    end
    %% make ready for conditioning
    maximum = zeros(4,1);    
    minimum = zeros(4,1);
    maximum(1) = max(RWs(:,1));  maximum(2) = max(RWs(:,2)); maximum(3) = max(RWs(:,3));  maximum(4) = max(RWs(:,4)); 
    minimum(1) = min(RWs(:,1));  minimum(2) = min(RWs(:,2)); minimum(3) = min(RWs(:,3));  minimum(4) = min(RWs(:,4)); 

    %find index of max and min
    Imax1 = find(RWs(:,1)== maximum(1));
    Imax2 = find(RWs(:,2)== maximum(2));
    Imax3 = find(RWs(:,3)== maximum(3));
    Imax4 = find(RWs(:,4)== maximum(4));
    
    Imin1 = find(RWs(:,1)== minimum(1));
    Imin2 = find(RWs(:,2)== minimum(2));
    Imin3 = find(RWs(:,3)== minimum(3));
    Imin4 = find(RWs(:,4)== minimum(4));

    %% condition!!   
    if (abs(mean(RWs(:,1)) - mean(RWs(:,2)))  <=  1) 
%         & (maximum(1) == maximum(2)) & (maximum(2) > maximum(3)) & (maximum(3) > maximum(4)) ...
%         & (minimum(1) == minimum(2)) & (minimum(2) > minimum(3)) & (minimum(3) > minimum(4)) 
%         if (max([Imax1(1),Imax2(1),Imax3(1),Imax4(1)]) <= 100) & ...
%            (max([Imin1(1),Imin2(1),Imin3(1),Imin4(1)]) <= 100) %previous: frac_Floor*n
            disp('*')
            break;
%         end
    end
end

RWA1 = zeros(n,2);
RWA2 = zeros(n,2);
RWB  = zeros(n,2);
RWC  = zeros(n,2);

RWA1 =  RWs(:,1);
RWA2 =  RWs(:,2);
RWB  =  RWs(:,3);
RWC  =  RWs(:,4);

% disp([mean(RWA1(:,1)),mean(RWA2(:,1)),mean(RWB(:,1)),mean(RWC(:,1))]);

save tempWorkspace;

