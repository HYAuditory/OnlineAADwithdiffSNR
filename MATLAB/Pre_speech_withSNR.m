clear all

%% Speech data_SAT
% Hilbert transform & Resampleing & Zscoring
%Allspeech_SAT = [];
names = struct;
y = [];
h = [];
hil = [];

% speech data
for i = 31:60 
    names(i).number = ['C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\2022_SAT31-60\' num2str(i)];
    names(i).filename = [char(names(i).number) '_SAT.wav'];
    [y(i,:),fs] = audioread(names(i).filename);
    
    h(i,:) = hilbert(y(i,:));
    abs_h(i,:) = abs(h(i,:));
    
    hil(i,:) = resample(abs_h(i,:),64,fs);
    hil(i,:) = zscore(hil(i,:));
    Allspeech_SAT(i,:) = hil(i,:);
end

%save('Allspeech','Allspeech');

%% Speech data_AAK
% Hilbert transform & Resampleing & Zscoring
%Allspeech_AAK = [];
names = struct;
y = [];
h = [];
hil = [];

% speech data
for i = 1:60 
    
    if i < 31
        names(i).number = ['C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\2022_Journey\' num2str(i)];
        names(i).filename = [char(names(i).number) '_Journey.wav'];
        [y(i,:),fs] = audioread(names(i).filename);
    else
        names(i).number = ['C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\2022_Twenty\' num2str(i-30)];
        names(i).filename = [char(names(i).number) '_Twenty.wav'];
        [y(i,:),fs] = audioread(names(i).filename);
    end
    
    h(i,:) = hilbert(y(i,:));
    abs_h(i,:) = abs(h(i,:));
    
    hil(i,:) = resample(abs_h(i,:),64,fs);
    hil(i,:) = zscore(hil(i,:));
    Allspeech_AAK(i,:) = hil(i,:);
end

%save('Allspeech','Allspeech');

%% customizing
load 'C:\Users\user\Desktop\temp\ALLINDEX'

Speech = struct;
for i = 1:10
Speech(i).subject = ['AADC' num2str(i+1)];
end

% attended speech of customizing each subject
a = [];
for i = 1:10              % subject
    sub = ALLINDEX(i).a';
    for j = 1:30          % trial
        a(j,:) =  Allspeech_AADC(sub(j),:);
    end
    Speech(i).att_data = a;
end

% unattended speech of customizing each subject
u = []; 
for i =1:10
    sub = ALLINDEX(i).u';
    for j = 1:30
        u(j,:) = Allspeech_AADC(sub(j),:);
    end
    Speech(i).unat_data = u;
    Speech(i).left = ALLINDEX(i).left_is_1;
end

save('Speech', 'Speech');












