function test_transfer_effect_iterations(config,config_analysis,sbjs)
info_transfer    = config_analysis.info_transfer;


pref_rate_left   = info_transfer.pref.rate_left;
pref_rate_right  = info_transfer.pref.rate_right;

pref_bin_left    = info_transfer.pref.bin_left;
pref_bin_right   = info_transfer.pref.bin_right;

pref_first_left  = info_transfer.pref.first_left;
pref_first_right = info_transfer.pref.first_right;


%--------------------------------------------------------------------------
%% organize

all = info_transfer.pref.all;

left  = [];
right = [];
for sub = sbjs.indx
    left(:,:,sub)  = all{sub}.left;
    right(:,:,sub) = all{sub}.right;
end

pref_left(:,:)  = left(:,1,:);
pref_right(:,:) = right(:,1,:);

pref_left  = pref_left';
pref_right = pref_right';


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
