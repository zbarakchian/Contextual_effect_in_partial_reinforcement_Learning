function test_transfer_effect_estimation(config,config_analysis,sbjs)

Values = config_analysis.info_estimation.valuation.estimate;

%--------------------------------------------------------------------------
%% organize
itrs = 1:4;

A1(:,:) = Values(1,itrs,:);
A2(:,:) = Values(2,itrs,:);
B(:,:)  = Values(3,itrs,:);
C(:,:)  = Values(4,itrs,:);

A1 = A1';
A2 = A2';
B  = B';
C  = C';

pref_left  = [];
pref_right = [];
for sub = sbjs.indx
    for iter = 1:4
        if A1(sub,iter) > A2(sub,iter)
            pref_left(sub,iter)  = 1;
            pref_right(sub,iter) = 0;
            
        elseif A2(sub,iter) > A1(sub,iter)
            pref_left(sub,iter)  = 0;
            pref_right(sub,iter) = 1;
            
        elseif A2(sub,iter) == A1(sub,iter)
            rnd = 2-randi(2);
            pref_left(sub,iter)  = rnd;
            pref_right(sub,iter) = 1-rnd;
        end
    end
end

%% Choice
%-Binomial Test
%-H0: P(choosing between A1 and A2) = 0.5

disp('aret they fully absolute?');

for iter = 1:4
    [h,p_binom,ratio] = binomial_test(pref_left(sbjs.indx,iter),pref_right(sbjs.indx,iter));

    disp(' ');
    disp(['iteration ', num2str(iter)]);
    disp(strcat('ratio = ',num2str(ratio)));   
    disp(strcat('P Value = ',num2str(p_binom)));
end


%% mean value
disp('------------------');

A1 = [];
A2 = [];
A1(:,:) = Values(1,5,:);
A2(:,:) = Values(2,5,:);

pref_left  = [];
pref_right = [];
for sub = sbjs.indx
    if A1(sub) > A2(sub)
        pref_left(sub)  = 1;
        pref_right(sub) = 0;

    elseif A2(sub) > A1(sub)
        pref_left(sub)  = 0;
        pref_right(sub) = 1;

    elseif A2(sub) == A1(sub)
        disp('WOW');
        rnd = 2-randi(2);
        pref_left(sub)  = rnd;
        pref_right(sub) = 1-rnd;
    end
end

[h,p_binom,ratio] = binomial_test(pref_left(sbjs.indx),pref_right(sbjs.indx));

disp(' ');
disp(strcat('ratio = ',num2str(ratio)));   
disp(strcat('P Value = ',num2str(p_binom)));

