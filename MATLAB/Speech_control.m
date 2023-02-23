%% Sound Volume control

%% LOAD file - original - journey
ori = {}

for i = 1:30
    file = strcat('C:\Users\user\Desktop\hy-kist\OpenBCI\Psychopy_seungcheol\Psychopy\stim_new\Original Narration file\L_Twenty\L', num2str(i),'.wav');
    ori_L{i} = audioread(file);
    file = strcat('C:\Users\user\Desktop\hy-kist\OpenBCI\Psychopy_seungcheol\Psychopy\stim_new\Original Narration file\R_Journey\R', num2str(i),'.wav');
    ori_R{i} = audioread(file);
end

%% LOAD file - Journey - R
y = {};
for i = 1:26
    
    if (i < 8) || (i >= 15 && i <= 17) || i == 22 || i == 23 || i == 26
        file = strcat('Journey_R' , num2str(i) , '.wav');
        y{i} = audioread(file);
    else
        file = strcat('Journey_L' , num2str(i) , '.wav');
        y{i} = audioread(file);
    end
end

y{27} = audioread('Journey_RL27_30.6122.wav');
y{28} = audioread('Journey_LR28_31.8594.wav');
y{29} = audioread('Journey_LR29_33.22.wav');
y{30} = audioread('Journey_RL30_27.6644.wav');

%% up - R

fs = 44100;

for i = 1:26
    
    up{i} = [y{i}(1:fs*3-1,:) ; y{i}(fs*3:end,:)*(2)];
    
    if (i < 8) || (i >= 15 && i <= 17) || i == 22 || i == 23 || i == 26 %r
        up{i}(fs*3:end,1) = up{i}(fs*3:end,1)/1.03;
    else
        up{i}(fs*3:end,2) = up{i}(fs*3:end,2)/1.03;
    end
end

for i = 27:30
    up{i} = [y{i}(1:fs*3-1,:) ; y{i}(fs*3:end,:)*(2)];
end
 
%% save - R

for i = 1:26
    if i < 9
     
        if (i < 8)
            file = strcat('00',num2str(i+1) ,'_Journey_R' , num2str(i) , '.wav');
            audiowrite(file, up{i},fs)
        else
            file = strcat('00',num2str(i+1) ,'_Journey_L' , num2str(i) , '.wav');
            audiowrite(file, up{i},fs)
        end
        
    else
        if (i >= 15 && i <= 17) || i == 22 || i == 23 || i == 26
            file = strcat('0',num2str(i+1) ,'_Journey_R' , num2str(i) , '.wav');
            audiowrite(file, up{i},fs)
        else
            file = strcat('0',num2str(i+1) ,'_Journey_L' , num2str(i) , '.wav');
            audiowrite(file, up{i},fs)
        end
    end
end
    
file = '028_Journey_RL27_30.6122.wav';
audiowrite(file, up{27},fs)
file = '029_Journey_LR28_31.8594.wav';
audiowrite(file, up{28},fs)
file = '030_Journey_LR29_33.22.wav';
audiowrite(file, up{29},fs)
file = '031_Journey_RL30_27.6644.wav';
audiowrite(file, up{30},fs)
    
%% LOAD file - Journey - L
y = {};
for i = 1:26
    
    if (i < 8) || (i >= 15 && i <= 17) || i == 22 || i == 23 || i == 26
        file = strcat('Journey_L' , num2str(i) , '.wav');
        y{i} = audioread(file);
    else
        file = strcat('Journey_R' , num2str(i) , '.wav');
        y{i} = audioread(file);
    end
end

y{27} = audioread('Journey_LR27_30.6122.wav');
y{28} = audioread('Journey_RL28_31.8594.wav');
y{29} = audioread('Journey_RL29_33.22.wav');
y{30} = audioread('Journey_LR30_27.6644.wav');

%% up - L

fs = 44100;

for i = 1:26
    
    up{i} = [y{i}(1:fs*3-1,:) ; y{i}(fs*3:end,:)*(2)];
    
    if (i < 8) || (i >= 15 && i <= 17) || i == 22 || i == 23 || i == 26 %r
        up{i}(fs*3:end,2) = up{i}(fs*3:end,2)/1.03;
    else
        up{i}(fs*3:end,1) = up{i}(fs*3:end,1)/1.03;
    end
end

for i = 27:30
    up{i} = [y{i}(1:fs*3-1,:) ; y{i}(fs*3:end,:)*(2)];
end

%% save - L

for i = 1:26
    if i < 9
     
        if (i < 8)
            file = strcat('00',num2str(i+1) ,'_Journey_L' , num2str(i) , '.wav');
            audiowrite(file, up{i},fs)
        else
            file = strcat('00',num2str(i+1) ,'_Journey_R' , num2str(i) , '.wav');
            audiowrite(file, up{i},fs)
        end
        
    else
        if (i >= 15 && i <= 17) || i == 22 || i == 23 || i == 26
            file = strcat('0',num2str(i+1) ,'_Journey_L' , num2str(i) , '.wav');
            audiowrite(file, up{i},fs)
        else
            file = strcat('0',num2str(i+1) ,'_Journey_R' , num2str(i) , '.wav');
            audiowrite(file, up{i},fs)
        end
    end
end
    
file = '028_Journey_LR27_30.6122.wav';
audiowrite(file, up{27},fs)
file = '029_Journey_RL28_31.8594.wav';
audiowrite(file, up{28},fs)
file = '030_Journey_RL29_33.22.wav';
audiowrite(file, up{29},fs)
file = '031_Journey_LR30_27.6644.wav';
audiowrite(file, up{30},fs)


%% practice
[y, fs] = audioread('027_Journey_L26.wav');
[y1, fs] = audioread('032_prac_tweentyL_1.wav');
[y2, fs] = audioread('033_prac_tweentyR_2.wav');

yrms = rms(up{1});

y1_1 = [y1(1:fs*3-1,:) ; y1(fs*3:end,:)*1];
rms(y1_1)
y1_1(fs*3:end,2) = y1_1(fs*3:end,2)/1.1;
rms(y1_1)

y2_1 = [y2(1:fs*3-1,:) ; y2(fs*3:end,:)*1.05];
rms(y2_1)
y2_1(fs*3:end,1) = y2_1(fs*3:end,1)/1.1;
rms(y2_1)

audiowrite('033_prac_tweentyR_1.wav', y2_1,fs)


%%

subplot(311)
plot(ori_L{1})
subplot(312)
plot(y{1}(fs*3:end,1))
subplot(313)
plot(up{1}(fs*3:end,1))

