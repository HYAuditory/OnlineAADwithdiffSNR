%% sigmoid fuction for SRT with each speech intelligibility

%% snr 별로 값 불러오기


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

 
%% SRT fitting

cutsnr = -30;
cut = find(snr_list == cutsnr);

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
si_snr = [fx.x;fx.y];

% 원하는 speech intelligibility 에 해당하는 snr 값
for si = 0.6:0.2:0.8

    snr = si_snr(1, find(si_snr(2,:) == si));
    
    if isempty(snr)
        resi = si - 0.01;

        msnr = si_snr(1, find(si_snr(2,:)==resi));
        psnr = si_snr(1, find(si_snr(2,:)==resi)+1);

        snr = (msnr+psnr)/2;
    end

    eval(['si_',num2str(si*100),'_snr = snr']);

end

   
%% AAD sounds based on MCL, SRT 


[Speech, fs] = audioread('');

% AAK track 1~14 > mcl로
% AADC track 1~8 > mcl
% AADC track 9~15 > snr of 80 si
% AADC track 16~22 > snr of 60 si
% AADC track 23~30 > snr of srt













