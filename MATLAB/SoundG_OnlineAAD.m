%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Sound generation for online AAD individually
%  based on MCL, SRT value(left and right) gained from psychopy
%  

%% load MCL and SRT value
% 여기서는 불러올것 : MCL, SRT, SI 90%

clear
subject = '0713_phj';
SNR = [0,-10,-20,-30,-32,-34,-36,-38,-40,-42,-44,-46,-48,-50,-52,-54,-56];
SNRlist = [];
calb = 3.5;

load ('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\MCL_' + string(subject) + '.mat');        % MCL
load ('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\SNRofSI50_' + string(subject) + '.mat');  % SRT
load ('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\SNRofSI90_' + string(subject) + '.mat');  % SI90
dB20 = MCL -20;

% callibration
MCL = double(MCL) - calb;
SI90 = double(SI90) - calb;
SRT = double(SRT) - calb;
dB20 = double(dB20) - calb;

%% 
% rms = 0.02 , fs = 44100
% beep 사운드 있고, rms 까지 다 맞춰진, stereo sound 를 불러와
% time by trials
% for i = 1:14    
%     [AAK_att(:,i),fs] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\2022_Journey\"+string(i)+"_Journey.wav");
%     [AAK_utt(:,i),fs] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\2022_Twenty\"+string(i)+"_Twenty.wav");
% end
% for i = 1:30
%     [SAT_att(:,i),fs] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\2022_SAT1-30\"+string(i)+"_SAT.wav");
%     [SAT_utt(:,i),fs] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\2022_SAT31-60\"+string(i+30)+"_SAT.wav");
% end

load('C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\2022_Speech\Allsource_snr.mat');
fs = 44100;
for i = 1:14    
    AAK_att(:,i) = Allsource_snr(i).journey;
    AAK_utt(:,i) = Allsource_snr(i).twenty;
end
for i = 1:28
    SAT_att(:,i) = Allsource_snr(i).sat1;
    SAT_utt(:,i) = Allsource_snr(i).sat2;
end

% beep sound                                    
secs = 0.5;
freq = 500;
t  = linspace(0, secs, fs*secs+1); 
w = 2*pi*freq;                                  % Radian Value To Create 1kHz Tone
s = sin(w*t);                                   % Create Tone

h_len = fs*3;
beep = [s, zeros([1,(fs*0.5)]),s,zeros([1,(fs*0.5)])];
beep = [beep, zeros([1,h_len-length(beep)])];

% 해당 trial 넘버의 condition
trials_mcl = [15,22,24,27,33,38,42];
trials_20 = [17,20,25,28,32,36,41];
trials_90 = [16,19,23,30,34,37,40];
trials_srt = [18,21,26,29,31,35,39];

%% Generate sound corresponding on conditoins
% condition : mcl, -20, 90, srt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%  CHECK THE DIRECTION!!  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dir = 'L';
rmsRef = 2*10.^(-5);
AAK = {};
SAT = {};

% beep rms
rms_b = rms(beep);
tormsMCL =10^(double(MCL+5)/20)*(rmsRef);
beep = (beep./rms_b).*tormsMCL;

% Train set sound
for i = 1:14
    % dB adjust to MCL dB
    rms_att = rms(AAK_att(:,i));
    rms_utt = rms(AAK_utt(:,i));  
    AAK_att(:,i) = (AAK_att(:,i)./rms_att).*tormsMCL;
    AAK_utt(:,i) = (AAK_utt(:,i)./rms_utt).*tormsMCL;
    
    sound_att = [beep'; AAK_att(:,i)];
    sound_utt = [zeros([length(beep),1]); AAK_utt(:,i)];
    if dir == 'R'
        if i < 8
            AAK{i} = [sound_utt, sound_att];
        else AAK{i} = [sound_att, sound_utt]; end
    else
        if i < 8
            AAK{i} = [sound_att, sound_utt];
        else AAK{i} = [sound_utt, sound_att]; end
    end
    
    if i < 10
        audiowrite('C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\exp_sound\00'+string(i)+'_AAK.wav',AAK{i},fs);
    else
        audiowrite('C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\exp_sound\0'+string(i)+'_AAK.wav',AAK{i},fs); end
end

% Test set sound
for i = 1:28
    % dB adjust to MCL dB
    rms_att = rms(SAT_att(:,i));
    rms_utt = rms(SAT_utt(:,i));  
    SAT_att(:,i) = (SAT_att(:,i)./rms_att).*tormsMCL;
    SAT_utt(:,i) = (SAT_utt(:,i)./rms_utt).*tormsMCL;
    
    % MCL - 20dB condition
    if Allsource_snr(i).condition == string(20)
        rms_att = rms(SAT_att(:,i));
        torms = 10^(double(dB20)/20)*(rmsRef); 
        SAT_att(:,i) = (SAT_att(:,i)./rms_att).*torms;
        
    elseif Allsource_snr(i).condition == string(90)
        rms_att = rms(SAT_att(:,i));
        rms_utt = rms(SAT_utt(:,i));
        torms = 10^(double(SI90)/20)*(rms_utt); 
        SAT_att(:,i) = (SAT_att(:,i)./rms_att).*torms;
    
    elseif Allsource_snr(i).condition == 'srt'
        rms_att = rms(SAT_att(:,i));
        rms_utt = rms(SAT_utt(:,i));
        torms = 10^(double(SRT)/20)*(rms_utt); 
        SAT_att(:,i) = (SAT_att(:,i)./rms_att).*torms;
    end
  
    sound_att = [beep'; SAT_att(:,i)];
    sound_utt = [zeros([length(beep),1]); SAT_utt(:,i)];
    
    if dir == 'R'
        if Allsource_snr(i).dir2 == 1
            SAT{i} = [sound_utt, sound_att];
        else
            SAT{i} = [sound_att, sound_utt]; end
    else
        if Allsource_snr(i).dir2 == 1
            SAT{i} = [sound_att, sound_utt];
        else
            SAT{i} = [sound_utt, sound_att]; end
    end
    
    audiowrite('C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\exp_sound\0'+string(i+14)+'_SAT.wav',SAT{i},fs);
    
end

% dummy
prac = {};
%part 1
for i = 1:2
    [t,fs2] = audioread('C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\2022_Speech\AAK\Prac'+string(i)+'_t.wav');
    [j,fs2] = audioread('C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\2022_Speech\AAK\Prac'+string(i)+'_j.wav');
    
    t = resample(t,fs,fs2);
    j = resample(j,fs,fs2);

    rms_att = rms(t(1:fs*15,1));
    rms_utt = rms(j(1:fs*15,1));  
    t = (t(1:fs*15,1)./rms_att).*tormsMCL;
    j = (j(1:fs*15,1)./rms_utt).*tormsMCL;
    
    if i == 1
        prac{1} = [[beep';t], [zeros([length(beep),1]);j]];
    else    
        prac{2} = [[zeros([length(beep),1]);j], [beep';t]];
    end
end

audiowrite('C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\exp_sound\0'+string(43)+'_Prac.wav',prac{1},fs);
audiowrite('C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\exp_sound\0'+string(44)+'_Prac.wav',prac{2},fs);

% part2
u = [16, 26, 6, 25];
a = [45, 55, 36, 58];
snr = [MCL, dB20, SI90, SRT];
for i =1:4
    pracs_u = Allsource_snr(u(i)).sat1(1:fs*15,1);
    pracs_a = Allsource_snr(a(i)-30).sat2(1:fs*15,1);
    
    rms_att = rms(pracs_a);
    rms_utt = rms(pracs_u);
    
    pracs_u = (pracs_u./rms_utt).*tormsMCL;
    if i < 3
        torms = 10^(double(snr(i))/20)*(rmsRef); 
        pracs_a = (pracs_a./rms_att).*torms;
        
        pracs = [[beep';pracs_a], [zeros([length(beep),1]);pracs_u]];
    else
        torms = 10^(double(snr(i))/20)*(rms_utt);
        pracs_a = (pracs_a./rms_att).*torms;
        
        pracs = [[zeros([length(beep),1]);pracs_u], [beep';pracs_a]];
    end

    audiowrite('C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\exp_sound\0'+string(i+44)+'_Prac.wav',pracs,fs);
    
end
    
%% data set
for i = 1:14
    Allsource_snr(i).journey = AAK_att(:,i);
    Allsource_snr(i).twenty = AAK_utt(:,i);
    
    if i < 8 
      Allsource_snr(i).dir = 1;
    else Allsource_snr(i).dir = 2;end
end

for i = 1:30
    Allsource_snr(i).sat1 = SAT_att(:,1);
    Allsource_snr(i).sat2 = SAT_utt(:,1);
    
    if (15 <= (i+14))&&((i+14)<= 18) || (27 <= (i+14))&&((i+14) <= 30) || (35 <= (i+14))&&((i+14) <= 41)
        Allsource_snr(i).dir2 = 1;
    else Allsource_snr(i).dir2 = 2;end
    
    
    if length(find(trials_20 == i+14)) == 1
        Allsource_snr(i).condition = '20';
        
    elseif length(find(trials_90 == i+14)) == 1
        Allsource_snr(i).condition = '90';
    
    elseif length(find(trials_srt == i+14)) == 1
        Allsource_snr(i).condition = 'srt';
        
    elseif length(find(trials_mcl == i+14)) == 1
        Allsource_snr(i).condition = 'mcl';
    end
end
        

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


