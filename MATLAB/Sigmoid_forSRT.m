%% sigmoid fuction for SRT with each speech intelligibility

%%
all_mean = [];
snr_list = [0:-10:-40, -42:-2:-50]; 

snr_0 = [5/5];
snr_10 = [5/5];
snr_20 = [5/5];
snr_30 = [4/5];
snr_40 = [4/5, 5/5];
snr_42 = [4/5, 4/5, 4/5];
snr_44 = [3/5, 3/5, 2/5];
snr_46 = [2/5, 2/5, 3/5, 1/5, 2/5];
snr_48 = [2/5, 1/5];
snr_50 = [0/5];

for i = 0:10:40
    snr = ['snr_',num2str(i)];
    eval(['mean_', num2str(i),'= mean(eval(snr));'])
    all_mean = [all_mean, eval(['mean_',num2str(i)])];
end
for i = 42:2:50
    snr = ['snr_',num2str(i)];
    eval(['mean_', num2str(i),'= mean(eval(snr));']);
    all_mean = [all_mean, eval(['mean_',num2str(i)])];
end

 
%%
cut=4;
figure
for i = length(snr_list)-1:-1:cut
    x = eval(['snr_', num2str(-snr_list(i))]);
    plot(snr_list(i), x, 'bo'); hold on
    %ylim([-0.5, 1.5])
end
%plot(snr_list(cut:end), all_mean(cut:end))

%figure(2)
[param,stat,fx] = sigm_fit_hjy(snr_list(cut:end),all_mean(cut:end),[0,1,nan,nan]);

% si 소수점 두자리 이하 버리기
fx.y = fix(fx.y*10^2) / 10^2;

si70_idx = find(fx.y==0.6); % 없음8ㄴ 
si70_snr = fx.x(si70_idx);

