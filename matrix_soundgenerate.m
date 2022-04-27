


%% Adjust Length and RMS
clear sound
matrix = 40;
track = randi([1,5]);
aadc = randi([1,10]);

[Att_s,fs_a] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\MatrixSentence\200_quiet\[0]Q"+string(matrix)+".wav");
[Utt_s,fs_u] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\MatrixSentence\hjy\AADC_segment\S"+ string(track) +"_"+ string(aadc) +".wav");
Att_s = Att_s(:,1);

% adjust onset point
onset = find(abs(Att_s)>0.001);
Utt_s = cat(1, zeros(onset(1),1),Utt_s);

% adjust offset point
off = find(abs(Att_s(onset:end,1))<0.1e-05);
i=1;
while 1
    try
        if off(i+fs_a*0.3)-off(i) < fs_a*0.31
            break
        end
    catch
        break
    end
    
    i = i+ 1;
end

i = onset(1) +off(i);

Utt_s = Utt_s(1:i,1);
Att_s = Att_s(1:i,1);

% RMS
rms_att = rms(Att_s);
rms_utt = rms(Utt_s);

% att 고정 Utt_rms 가 일정하지 않아서 att rms에 고정
snr_aim = 0;

torms_forutt = 10^(snr_aim/20)*(rms_att);

% 위 구한 rms를 가진 att signal을 만들기위해
Utt_sm=(Utt_s./rms(Utt_s)).*torms_forutt;
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


