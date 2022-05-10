


%% HTL
clear

num = 1;
H_SPL = 25;
for num = 2:6
    
    [MatrixSound,fs] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\MatrixSentence\200_quiet\[0]Q"+string(100)+".wav");

    %%%
    % RMS
    rmsS = rms(MatrixSound);
    rmsRef = 2*10.^(-5);

    % Estimate Hoping RMS of sound source
    H_rms = 10^(H_SPL/20)*(rmsRef);

    % 위 구한 rms를 가진 att signal을 만들기위해
    M_MatrixSound = (MatrixSound./rmsS).*H_rms;

    % Check
    if H_SPL ~= round(20*log10(rms(M_MatrixSound)/rmsRef))
        error("nooo!!!!!!!TT")
    end
    %%%
    
    audiowrite("00"+string(num)+"_HTL_"+string(H_SPL)+".wav",M_MatrixSound,fs);
    %num = num+1;
    H_SPL = H_SPL+5 ;
    
end

%% MCL
clear

num = 8;
H_SPL = 35;
track = 101;
while H_SPL < 85

    [MatrixSound,fs] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\MatrixSentence\200_quiet\[0]Q"+string(track)+".wav");

    %%%
    % RMS
    rmsS = rms(MatrixSound);
    rmsRef = 2*10.^(-5);

    % Estimate Hoping RMS of sound source
    H_rms = 10^(H_SPL/20)*(rmsRef);

    % 위 구한 rms를 가진 att signal을 만들기위해
    M_MatrixSound = (MatrixSound./rmsS).*H_rms;

    % Check
    if H_SPL ~= round(20*log10(rms(M_MatrixSound)/rmsRef))
        error("nooo!!!!!!!TT")
    end
    %%%

    audiowrite("00"+string(num)+"_MCL_"+string(H_SPL)+".wav",M_MatrixSound,fs);
    num = num+1;
    track = track +1;

    H_SPL = H_SPL+5 ;

end

%% SRT_LEFT
clear

sub = '0429_hjy';
%load ('C:\Users\LeeJiWon\Desktop\hykist\AAD\MatrixSentence\hjy\SAVE\HTL_'+string(sub)+'.mat');  %HTL_SPL
%load ('C:\Users\LeeJiWon\Desktop\hykist\AAD\MatrixSentence\hjy\SAVE\MCL_'+string(sub)+'.mat');  %MCL_SPL

MCL_list = [35,40,45,50,55,60,65,70,75,80];
SRT_list = [0,10,20,30,32,34,36,38,40,42,44,46,48,50];

% LEFT
H_snr = 0;
rmsRef = 2*10.^(-5);
num = 1;

% 여러 MCL dB 경우 다 만들기위해.

MCL_SPL = 50;    % 50, 55, 60, 65

for track = 1:20
    
    %[SRTsource,fs] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\MatrixSentence\hjy\SRT\SRT_source\ms_"+string(track)+".wav");
    [SRTsource,fs] = audioread("C:\Users\Jae Ho\Desktop\hy-kist\Matrix_sound\test source_matixAADC\hjy\SRT_source\ms_"+string(track)+".wav");
    
    %======= MCL db SPL 로 통일
    % RMS
    rmsS = rms(SRTsource);

    % MCL의 dB로 만들기 위한 rms
    H_rms = 10^(double(MCL_SPL)/20)*(rmsRef);

    % 위 구한 rms를 가진 att signal을 만들기위해
    Mcl_SRTsource = (SRTsource./rmsS).*H_rms;

    % Check
    if double(MCL_SPL) ~= round(20*log10(rms(Mcl_SRTsource)/rmsRef))
        error("nooo!!!!!!!TT")
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Att_s = Mcl_SRTsource(:,1);     % left
    Utt_s = Mcl_SRTsource(:,2);     % right
    
    %==============================%
    %======== Modify SNR ==========%
    %==============================%
    for i = 1:length(SRT_list)
        
        H_snr = SRT_list(i);
        % RMS
        rms_att = rms(Att_s);   
        rms_utt = rms(Utt_s);
        H_rms = 10^(-H_snr/20)*(rms_att);

        % 위 구한 rms를 가진 att signal을 만들기위해
        Att_sM = (Att_s./rms_att).*H_rms;

        % SNR check
        check_snr = -round(snr(Att_sM,Utt_s));

        if H_snr ~= round(check_snr)
            error("nooo!!!!!!!TT")
        end

        % 합치기
        M_SRTsource = [Att_sM, Utt_s];

        % Save
        if num < 10
            audiowrite("00"+string(num)+"_SRT_L_"+string(track)+"_"+string(H_snr)+".wav",M_SRTsource,fs);
            num = num + 1;
        elseif 10 <= num & num < 100 
            audiowrite("0"+string(num)+"_SRT_L_"+string(track)+"_"+string(H_snr)+".wav",M_SRTsource,fs);
            num = num + 1;
        elseif num >= 100
            audiowrite(string(num)+"_SRT_L_"+string(track)+"_"+string(H_snr)+".wav",M_SRTsource,fs);
            num = num + 1;
        end
    end
end




%% SRT_RIGHT
clear

sub = '0429_hjy';
%load ('C:\Users\LeeJiWon\Desktop\hykist\AAD\MatrixSentence\hjy\SAVE\HTL_'+string(sub)+'.mat');  %HTL_SPL
%load ('C:\Users\LeeJiWon\Desktop\hykist\AAD\MatrixSentence\hjy\SAVE\MCL_'+string(sub)+'.mat');  %MCL_SPL

MCL_list = [35,40,45,50,55,60,65,70,75,80];
SRT_list = [0,10,20,30,32,34,36,38,40,42,44,46,48,50];

% LEFT
H_snr = 0;
rmsRef = 2*10.^(-5);
num = 1;

%
MCL_SPL = 70;

for track = 21:40
    
    %[SRTsource,fs] = audioread("C:\Users\LeeJiWon\Desktop\hykist\AAD\MatrixSentence\hjy\SRT\SRT_source\ms_"+string(track)+".wav");
    [SRTsource,fs] = audioread("C:\Users\Jae Ho\Desktop\hy-kist\Matrix_sound\test source_matixAADC\hjy\SRT_source\ms_"+string(track)+".wav");
    
    %======= MCL db SPL 로 통일
    % RMS
    rmsS = rms(SRTsource);

    % MCL의 dB로 만들기 위한 rms
    H_rms = 10^(double(MCL_SPL)/20)*(rmsRef);

    % 위 구한 rms를 가진 att signal을 만들기위해
    Mcl_SRTsource = (SRTsource./rmsS).*H_rms;

    % Check
    if double(MCL_SPL) ~= round(20*log10(rms(Mcl_SRTsource)/rmsRef))
        error("nooo!!!!!!!TT")
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Utt_s = Mcl_SRTsource(:,1);     % left
    Att_s = Mcl_SRTsource(:,2);     % right
    
    %==============================%
    %======== Modify SNR ==========%
    %==============================%
    for i = 1:length(SRT_list)
        
        H_snr = SRT_list(i);
        % RMS
        rms_att = rms(Att_s);   
        rms_utt = rms(Utt_s);
        H_rms = 10^(-H_snr/20)*(rms_att);

        % 위 구한 rms를 가진 att signal을 만들기위해
        Att_sM = (Att_s./rms_att).*H_rms;

        % SNR check
        check_snr = -round(snr(Att_sM,Utt_s));

        if H_snr ~= round(check_snr)
            error("nooo!!!!!!!TT")
        end

        % 합치기
        M_SRTsource = [Utt_s, Att_sM];

        % Save
        if num < 10
            audiowrite("00"+string(num)+"_SRT_R_"+string(track)+"_"+string(H_snr)+".wav",M_SRTsource,fs);
            num = num + 1;
        elseif 10 <= num & num < 100 
            audiowrite("0"+string(num)+"_SRT_R_"+string(track)+"_"+string(H_snr)+".wav",M_SRTsource,fs);
            num = num + 1;
        elseif num >= 100
            audiowrite(string(num)+"_SRT_R_"+string(track)+"_"+string(H_snr)+".wav",M_SRTsource,fs);
            num = num + 1;
        end
    end
end




