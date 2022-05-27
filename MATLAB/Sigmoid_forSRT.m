%% sigmoid fuction for SRT with each speech intelligibility


%% Load MCL and SRT
clear
subject = '0429_hjy';
path = 'C:\Users\LeeJiWon\Desktop\hykist\AAD\MatrixSentence\hjy\SAVE\hjy\';
SNR = [0,-10,-20,-30,-32,-34,-36,-38,-40,-42,-44,-46,-48,-50];
SNRlist_L = [];
SNRlist_R = [];
%load (string(path)+'MCL_' + string(subject) + '.mat');
MCL_0516 = 65;

for i = 1:length(SNR)
    try
        load(string(path)+'RespL_SNR'+string(-SNR(i))+'_'+string(subject)+'.mat');
        SNRlist_L = [SNRlist_L, SNR(i)];
    catch      
    end
    
    try
        load(string(path)+'RespR_SNR'+string(-SNR(i))+'_'+string(subject)+'.mat');
        SNRlist_R = [SNRlist_R, SNR(i)];
    catch      
    end
end

% Mean
respL=[];
respR=[];
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

SNR_Si_L = [SNRlist_L; respL];
SNR_Si_R = [SNRlist_R; respR];

% Sigmoid fitting
cut=1; % 4 : 30 미만 cut

figure(1)
for i = length(SNR_Si_L):-1:cut
    y = eval(['RespL_SNR', num2str(-SNRlist_L(i))]);
    plot(SNR_Si_L(1,i), y, 'bo'); hold on
    %ylim([-0.5, 1.5])
    title(['Left']);
    xlabel('SNR (dB)');
    ylabel('Speech Intelligibility');
end
%plot(snr_list(cut:end), all_mean(cut:end))

[paramL,statL,fxL] = sigm_fit_hjy(SNR_Si_L(1,cut:end),SNR_Si_L(2,cut:end),[0,1,nan,nan]);
fxL.y = fix(fxL.y*10^2) / 10^2;   % si 소수점 두자리 이하 버리기
valueL = [fxL.x;fxL.y]; 

% Left 50 /60/80 구하고 Right 50/60/80 구해서 평균값 output 보내기

figure(2)
for i = length(SNR_Si_R):-1:cut
    y = eval(['RespR_SNR', num2str(-SNRlist_R(i))]);
    plot(SNR_Si_R(1,i), y, 'bo'); hold on
    %ylim([-0.5, 1.5])
    title(['Right']);
    xlabel('SNR (dB)');
    ylabel('Speech Intelligibility');
end
%plot(snr_list(cut:end), all_mean(cut:end))

[paramR,statR,fxR] = sigm_fit_hjy(SNR_Si_R(1,cut:end),SNR_Si_R(2,cut:end),[0,1,nan,nan]);
fxR.y = fix(fxR.y*10^2) / 10^2;   % si 소수점 두자리 이하 버리기
valueR = [fxR.x;fxR.y];


%% find a specific speech intelligibility 
% 찾고싶은 si
si = 0.7000;

F_Si = si;
%=========  LEFT
% 딱 맞지않을 값을 대비하여 on-off 값 찾기.
while 1    
    ckon = find(valueL(2,:)==F_Si);

    if length(ckon) == 1
        F_Si = si;
        break
    end
    F_Si = F_Si - 0.01;
end
while 1
    ckoff = find(valueL(2,:)==F_Si);

    if length(ckoff) == 1
        F_Si = si;
        break
    end
    F_Si = F_Si + 0.01;
end    


if ckon == ckoff   % 딱 맞아 떨어지는 경우
    F_SNRL = valueL(1,ckon);
else    % 사이값일 경우
    ia = valueL(2,ckon)*100;
    ib = valueL(2,ckoff)*100;
    len = ib-ia +1;
    sa = valueL(1,ckon);
    sb = valueL(1,ckoff);
    
    F_valueL = round([linspace(sa,sb,len);linspace(ia,ib,len)]);
    F_SNRL = F_valueL(1, find(F_valueL(2,:) == F_Si*100)); 
end

%=========  Right    
while 1    
    ckon = find(valueR(2,:)==F_Si);

    if length(ckon) == 1
        F_Si = si;
        break
    end
    F_Si = F_Si - 0.01;
end
while 1
    ckoff = find(valueR(2,:)==F_Si);

    if length(ckoff) == 1
        F_Si = si;
        break
    end
    F_Si = F_Si + 0.01;
end    


if ckon == ckoff   % 딱 맞아 떨어지는 경우
    F_SNRR = valueR(1,ckon);
else    % 사이값일 경우
    ia = valueR(2,ckon)*100;
    ib = valueR(2,ckoff)*100;
    len = ib-ia +1;
    sa = valueR(1,ckon);
    sb = valueR(1,ckoff);
    
    F_valueR = round([linspace(sa,sb,len);linspace(ia,ib,len)]);
    F_SNRR = F_valueR(1, find(F_valueR(2,:) == F_Si*100)); 
end

%
eval(['SNRofSI',num2str(si*100),'.L = F_SNRL']);
eval(['SNRofSI',num2str(si*100),'.R = F_SNRR']);
eval(['SNRofSI',num2str(si*100),'.M = mean([F_SNRR,F_SNRL])']);

SNRofSI50.L = paramL(3);
SNRofSI50.R = paramR(3);
SNRofSI50.M = mean([paramL(3),paramR(3)]);

% save
save(string(path)+'SNRofSI'+string(si*100)+'_'+string(subject)+'.mat', ['SNRofSI',num2str(si*100)]);
save(string(path)+'SNRofSI'+'50_'+string(subject)+'.mat', ['SNRofSI',num2str(si*100)]);




