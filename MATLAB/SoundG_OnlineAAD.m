%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Sound generation for online AAD individually
%  based on MCL, SRT value(left and right) gained from psychopy
%  



%% load MCL and SRT value
clear
subject = '0429_hjy';
SNR = [0,-10,-20,-30,-32,-34,-36,-38,-40,-42,-44,-46,-48,-50];
SNRlist = [];

load ('MCL_' + string(subject) + '.mat');
for i = 1:length(SNR)
    try
        %load(eval(['RsepL_SNR',string(-SNR(i)),string(subject),'.mat');
        load('RespSNR'+string(-SNR(i))+'_L'+string(subject)+'.mat');
        SNRlist = [SNRlist, SNR(i)];
    catch      
    end
end
    
%%  Estimate SRT 
% SNRlist = [0,-10,-20,-30,-32,-34,-36,-38,-40,-42,-44,-46,-48,-50];

for i = 1:length(SRTlist)
    
    SRTarr_L(i) = SRTresp_L(i)/SRTfreq_L(i);
    SRTarr_R(i) = SRTresp_R(i)/SRTfreq_R(i);
    
end

%y = rmmissing(SRTarr_L);   % delete NAN
%y2 = fillmissing(SRTarr_R, 'constant', 0);   % change NAN to 0

%% Adjust RMS of all sound equally

for t = 1:30
    % Load two original sound -  실제로는 30 trials 한번에 있는걸로 만들기
    % AAK
    [Att_aak,fs_a] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\ORIGINAL_SPEECH_AAK\L_Twenty\L"+string(t)+".wav");
    [Utt_aak,fs_u] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\ORIGINAL_SPEECH_AAK\R_Journey\R"+string(t)+".wav");
    % AADC
    [Att_aadc,fs_a] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\original narration file_AADC\s"+string(t)+".wav");
    [Utt_aadc,fs_u] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\original narration file_AADC\s"+string(t+30)+".wav");
    
    % RMS - 한 trial씩
    rms_aak_att = rms(Att_aak);
    rms_aak_utt = rms(Utt_aak);
    rms_aadc_att = rms(Att_aadc);
    rms_aadc_utt = rms(Utt_aadc);
    
    % Attended sound 를 Unattended sound RMS에 맞춤
%     Att_aak_sm = (Att_aak./rms_aak_att).*rms_aak_utt;
%     Att_aadc_sm = (Att_aadc./rms_aadc_att).*rms_aadc_utt;

    % 원하는 RMS에 모든 음원 맞춤
     H_rms = 0.05;
     Att_aak_sm(t,:) = (Att_aak./rms_aak_att).*H_rms;
     Utt_aak_sm(t,:) = (Utt_aak./rms_aak_utt).*H_rms;
     Att_aadc_sm(t,:) = (Att_aadc./rms_aadc_att).*H_rms;
     Utt_aadc_sm(t,:) = (Utt_aadc./rms_aadc_utt).*H_rms; 

end

%ALLSPEECH_NEWAAK = 

%% Practice sound
% 연습문제 위한 음원도 만들어야해!

% 1 > MCL의 왼집중, 오집중 하나씩 - unattended speech를 attended 가 되도록. 근데 15초


% 2 > 1(MCL-20dB) & 2(Speech Intelligibility 90%) & 3(SRT i.e., 50%) 가 되도록.
% 근데 15초
% 즉 3가지 음원. 

%% Generate sound for online AAD - 46 trials
%% ff
% RMS - 한 trial씩
rms_att = rms(Att_s);
rms_utt = rms(Utt_s);

% Attended sound 를 Unattended sound RMS에 맞춤
Att_sm = (Att_s./rms_att).*rms_utt;

% attention direction 
% if 
%     Sound_1 = [Att_s, Utt_sm];
% end
snr_aim = 0;
torms_foratt = 10^(snr_aim/20)*(rms_utt);  

% 위 구한 rms를 가진 att signal을 만들기위해
Att_sm = (Att_s./rms_att).*torms_foratt;
rms_utt2 = rms(Utt_sm);
% SNR check
check_snr = round(snr(Att_s,Utt_sm));

if snr_aim ~= round(check_snr)
    error("nooo!!!!!!!TT")
end

% save
Sound_1 = [Att_s, Utt_sm];   % left attention

sound(Sound_1,fs_a);

audiowrite("ms_"+string(matrix)+".wav",Sound_1,fs_a);

%% Adjust SNR two sound
clear
clear sound

ms = string(11);

[S,fs] = audioread("C:\Users\LeeJiWon\Desktop\Matrix sentence\hjy\testsource_matrixAADC\ms"+ms+".wav");
%%
clear sound
Att_s = S(:,1);
Utt_s = S(:,2);

rms_att = rms(Att_s);
rms_utt = rms(Utt_s);

% 원하는 snr 을 위한 att의 rms 구하는 / utt 고정
snr_aim = 5;
torms_foratt = 10^(snr_aim/20)*(rms_utt);

% 위 구한 rms를 가진 att signal을 만들기위해
Att_modif=(Att_s./rms(Att_s)).*torms_foratt;

% check
check_snr = snr(Att_modif,Utt_s);

if snr_aim ~= round(check_snr)
    error("nooo!!!!!!!TT")
end

% regenerate sound

Sound_modif = [Att_modif, Utt_s];
sound(Sound_modif,fs);

audiowrite("ms"+ms+"_snr("+string(snr_aim)+").wav",Sound_modif,fs);


%%
clf
ax1=nexttile;
plot(Att_s)

ax2=nexttile;
plot(Utt_s)
linkaxes([ax1, ax2],'xy')


