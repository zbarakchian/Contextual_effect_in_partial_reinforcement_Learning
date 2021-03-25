function test_transfer_effect_model(config,sbjs)

%% hypothesis testing
[h,p_binom,ratio] = binomial_test(pref_leftM(:,1),pref_rightM(:,1));
disp(strcat('P Value = ',num2str(p_binom)));
disp(strcat('ratio = ',num2str(ratio)));


%%
disp('------------------');
disp('pref left vs right');
prefs_left  = [pref_leftM(:,2);    pref_leftM(:,3);  pref_leftM(:,4);  pref_leftM(:,5);  pref_leftM(:,6)];
prefs_right = [pref_rightM(:,2);   pref_rightM(:,3); pref_rightM(:,4); pref_rightM(:,5); pref_rightM(:,6)];

[h,p_binom,ratio] = binomial_test(prefs_left(:,1),prefs_right(:,1));
disp(strcat('P Value = ',num2str(p_binom)));
disp(strcat('ratio = ',num2str(ratio)));
