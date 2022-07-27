%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sigmoid fuction for SRT with each speech intelligibility %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load MCL and SRT
clear
subject = '0727_lsc' ;
%path = 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\';
path = 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\';
SNR = [0,-10,-20,-30,-32,-34,-36,-38,-40,-42,-44,-46,-48,-50,-52,-54,-56];  % 제시될수있는 모든 SNR 범위
SNRlist_L = [];
SNRlist_R = [];

% Load response data
for i = 1:length(SNR)
    try
        load(string(path)+'RespL_SNR'+string(-SNR(i))+'_'+string(subject)+'.mat');
        SNRlist_L = [SNRlist_L, SNR(i)];    % 피험자별/방향별 제시된 SNR 범위가 매번 다르기 때문에 SNR 범위 list 재생성
    catch      
    end
    
    try
        load(string(path)+'RespR_SNR'+string(-SNR(i))+'_'+string(subject)+'.mat');
        SNRlist_R = [SNRlist_R, SNR(i)];
    catch      
    end
end

% Averaging
respL = [];
respR = [];
for i = SNRlist_L
    eval(['meanL_SNR', num2str(-i),'=[];']);
    x = eval(['RespL_SNR',num2str(-i)]);
    eval(['meanL_SNR', num2str(-i),'= mean(x);']);
    respL = [respL, eval(['meanL_SNR', num2str(-i)]);];
end

for i = SNRlist_R
    eval(['meanR_SNR', num2str(-i),'=[];']);
    x = eval(['RespR_SNR',num2str(-i)]);
    eval(['meanR_SNR', num2str(-i),'= mean(x);'])
    respR = [respR, eval(['meanR_SNR', num2str(-i)]);];
end

% -50 dB 까지 안내려갔다면 0 으로 채워주기
exist RespR_SNR50;
if ans == 0 
    RespR_SNR50 = [0];
    respR = [respR,0];
    SNRlist_R = [SNRlist_R, -50];
end
exist RespL_SNR50;
if ans == 0 
    RespL_SNR50 = [0];
    respL = [respL,0];
    SNRlist_L = [SNRlist_L, -50];
end

% SNR range 와 정답률 합치기
SNR_Si_L = [SNRlist_L; respL];
SNR_Si_R = [SNRlist_R; respR];

% Sigmoid fitting
% 0 ~ 20 은 무조건 100% 이기때문에 앞부분은 날림. 그러지 않으면 fitting 이 이상하게 나옴.
cut = 3;  % 4 = 30 미만 / 3 = 20 미만

figure(1)
for i = length(SNR_Si_L):-1:cut
    y = eval(['RespL_SNR', num2str(-SNRlist_L(i))]);
    plot(SNR_Si_L(1,i), y, 'bo'); hold on
    %ylim([-0.5, 1.5])
    title(['Left']);
    xlabel('SNR (dB)');
    ylabel('Speech Intelligibility');
end

% save individual vale 
[paramL,statL,fxL] = sigm_fit_hjy(SNR_Si_L(1,cut:end),SNR_Si_L(2,cut:end),[0,1,nan,nan]);
fxL.y = fix(fxL.y*10^2) / 10^2;   % si 소수점 두자리 이하 버리기
valueL = [fxL.x;fxL.y]; 

figure(2)
for i = length(SNR_Si_R):-1:cut
    y = eval(['RespR_SNR', num2str(-SNRlist_R(i))]);
    plot(SNR_Si_R(1,i), y, 'bo'); hold on
    %ylim([-0.5, 1.5])
    title(['Right']);
    xlabel('SNR (dB)');
    ylabel('Speech Intelligibility');
end

% save individual vale 
[paramR,statR,fxR] = sigm_fit_hjy(SNR_Si_R(1,cut:end),SNR_Si_R(2,cut:end),[0,1,nan,nan]);
fxR.y = fix(fxR.y*10^2) / 10^2;   % si 소수점 두자리 이하 버리기
valueR = [fxR.x;fxR.y];

%% Find a specific speech intelligibility 
% 찾고싶은 si  ( SRT 90 % )
si = 0.9000;

% Find SPL at hoping si
F_SNR_L = valueL(1,(find(valueL(2,:) == si)));
F_SNR_R = valueR(1,(find(valueR(2,:) == si)));

% 정확한 값 없을시
if length(F_SNR_L) == 0 | length(F_SNR_R) == 0
    error('noooo!!')
end

% 수작업 시 이 변수에 직접 타이핑
% F_SNR_L = -38.85;
% F_SNR_R = -34.25;

% 사용할 변수 만들기
eval(['SNRofSI50.L = paramL(3)']);
eval(['SNRofSI50.R = paramR(3)']);
eval(['SNRofSI50.M = mean([paramL(3),paramR(3)])']);
eval(['SRT= SNRofSI50.M']);
eval(['SNRofSI',num2str(si*100),'.L = F_SNR_L']);
eval(['SNRofSI',num2str(si*100),'.R = F_SNR_R']);
eval(['SNRofSI',num2str(si*100),'.M = mean([F_SNR_R,F_SNR_L])']);
eval(['SI',num2str(si*100),'= SNRofSI',num2str(si*100),'.M']);

% save
% eval(['save('''+string(path)+'SNRofSI'+num2str(si*100)+'_'+string(subject)+'_All.mat'',''SNRofSI'+num2str(si*100)+''');'])
% eval(['save('''+string(path)+'SNRofSI'+num2str(si*100)+'_'+string(subject)+'.mat'',''SI'+num2str(si*100)+''');'])
save(string(path)+'SNRofSI'+string(si*100)+'_'+string(subject)+'.mat', 'SI90');
save(string(path)+'SNRofSI'+string(si*100)+'_all_'+string(subject)+'.mat', 'SNRofSI90');
save(string(path)+'SNRofSI'+'50_'+string(subject)+'.mat', 'SRT');
save(string(path)+'SNRofSI'+'50_'+string(subject)+'_all.mat', 'SNRofSI50');
