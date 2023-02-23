%% AAD with DIff Sound Volume 

%% Gathering data

load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA_optimal.mat') %OffDATA_2
used = [1,3,4,5,6,7,8,9,11,12,13,14,16,19,21,22];
condition = {'MCL', 'MCL20', 'SI90', 'SI50'};

for c = 1:length(condition)
    eval(['Indi_AttCorr_' condition{c} ' = [];']);
    eval(['Indi_UttCorr_' condition{c} ' = [];']);
end

for i = 1:length(used)
    
    Indi_Acc_MCL(i) = OffDATA_2(used(i)).acc_mcl;
    Indi_Acc_MCL20(i) = OffDATA_2(used(i)).acc_20;
    Indi_Acc_SI90(i) = OffDATA_2(used(i)).acc_90;
    Indi_Acc_SI50(i) = OffDATA_2(used(i)).acc_srt;
    
    Indi_AttCorr_MCL = [Indi_AttCorr_MCL; OffDATA_2(used(i)).corr_att_mcl];
    Indi_AttCorr_MCL20 = [Indi_AttCorr_MCL20; OffDATA_2(used(i)).corr_att_20];
    Indi_AttCorr_SI90 = [Indi_AttCorr_SI90; OffDATA_2(used(i)).corr_att_90];
    Indi_AttCorr_SI50 = [Indi_AttCorr_SI50; OffDATA_2(used(i)).corr_att_srt];

    Indi_UttCorr_MCL = [Indi_UttCorr_MCL; OffDATA_2(used(i)).corr_utt_mcl];
    Indi_UttCorr_MCL20 = [Indi_UttCorr_MCL20; OffDATA_2(used(i)).corr_utt_20];
    Indi_UttCorr_SI90 = [Indi_UttCorr_SI90; OffDATA_2(used(i)).corr_utt_90];
    Indi_UttCorr_SI50 = [Indi_UttCorr_SI50; OffDATA_2(used(i)).corr_utt_srt];
    
end

%% Corr_Att&Utt_ allcondition - Box

figure(32)
clf
x1 = 1-0.5:3:10-0.5;
x2 = 1+0.5:3:10+0.5;

boxplot([mean(Indi_AttCorr_MCL,2), mean(Indi_AttCorr_MCL20,2), mean(Indi_AttCorr_SI90,2), mean(Indi_AttCorr_SI50,2)],...
            x1, 'Positions', x1, 'color', 'r', 'boxstyle', 'filled'); hold on
boxplot([mean(Indi_UttCorr_MCL,2), mean(Indi_UttCorr_MCL20,2), mean(Indi_UttCorr_SI90,2), mean(Indi_UttCorr_SI50,2)],...
            x2, 'Positions', x2, 'color', [0.5,0.5,0.5], 'boxstyle', 'filled');
ylim([-0.1 0.2])
xlim([-1 12])
ylabel('Envelope Correlation')
xlabel('Conditoin')

%% Encoding

load ('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\Rawdata_SPL_all.mat');
used = [1,3,4,5,6,7,8,9,11,12,13,14,16,19,21,22];
RAWDATA_SPL = RAWDATA_SPL_all;
trials_mcl = [15,22,24,27,33,38,42];
trials_20 = [17,20,25,28,32,36,41];
trials_90 = [16,19,23,30,34,37,40];
trials_srt = [18,21,26,29,31,35,39];
condition = {'MCL', 'MCL20', 'SI90', 'SI50'};

fs = 64;
Dir    = 1;
tmin    = -100; 
tmax    = 500;
lambda = 10.^(-6:1:4);
% Time-lag (tau) params
tmin_index     = floor(tmin/1000*fs); % tmin2idx
tmax_index     = ceil(tmax/1000*fs);  % tmax2idx
time_lag_index = length(tmin_index:tmax_index); % time-lag points btw tmin and tmax
t              = linspace(tmin, tmax, time_lag_index)';

W_attno = zeros(15,length(t))';
W_uttno = zeros(15,length(t))';
for c = 1:4
    eval(['W_' condition{c} '= zeros(15,length(t))'';']);
    eval(['W_' condition{c} '_utt= zeros(15,length(t))'';']);
end
        
for SubIdx = 1:length(used)
    
    att_env = RAWDATA_SPL(used(SubIdx)).att_stim;
    utt_env = RAWDATA_SPL(used(SubIdx)).utt_stim;
    EEG = RAWDATA_SPL(used(SubIdx)).data;
    model = {};
    acc = [];
    
    % Searching optimal lambda   
%     cv = mTRFcrossval(att_env(1:14), EEG(1:14), fs, Dir, tmin, tmax, lambda, 'verbose', 0);
%     [rmax,idx] = max(mean(cv.r));
%     optmal_Lmb = lambda(idx);
    optmal_Lmb = 1024;

    % decoder train
    model_attno = mTRFtrain(att_env(1:14), EEG(1:14), fs, Dir, tmin, tmax, optmal_Lmb, 'verbose', 0);
    model_uttno = mTRFtrain(utt_env(1:14), EEG(1:14), fs, Dir, tmin, tmax, optmal_Lmb, 'verbose', 0);
    
    % attended 
    model_MCL = mTRFtrain(att_env(trials_mcl), EEG(trials_mcl), fs, Dir, tmin, tmax, optmal_Lmb, 'verbose', 0);
    model_MCL20 = mTRFtrain(att_env(trials_20), EEG(trials_20), fs, Dir, tmin, tmax, optmal_Lmb, 'verbose', 0);
    model_SI90 = mTRFtrain(att_env(trials_90), EEG(trials_90), fs, Dir, tmin, tmax, optmal_Lmb, 'verbose', 0);
    model_SI50 = mTRFtrain(att_env(trials_srt), EEG(trials_srt), fs, Dir, tmin, tmax, optmal_Lmb, 'verbose', 0);
    
    % unattended
    model_MCL_utt = mTRFtrain(utt_env(trials_mcl), EEG(trials_mcl), fs, Dir, tmin, tmax, optmal_Lmb, 'verbose', 0);
    model_MCL20_utt = mTRFtrain(utt_env(trials_20), EEG(trials_20), fs, Dir, tmin, tmax, optmal_Lmb, 'verbose', 0);
    model_SI90_utt = mTRFtrain(utt_env(trials_90), EEG(trials_90), fs, Dir, tmin, tmax, optmal_Lmb, 'verbose', 0);
    model_SI50_utt = mTRFtrain(utt_env(trials_srt), EEG(trials_srt), fs, Dir, tmin, tmax, optmal_Lmb, 'verbose', 0);    
    
    W_attno = W_attno + squeeze(model_attno.w);
    W_uttno = W_uttno + squeeze(model_uttno.w);
    for c = 1:4
        eval(['W_' condition{c} '= W_' condition{c} '+ squeeze(model_' condition{c} '.w);']);
        eval(['W_' condition{c} '_utt= W_' condition{c} '_utt+ squeeze(model_' condition{c} '_utt.w);']);
    end    
      
end

W_attno = W_attno/SubIdx;
W_uttno = W_uttno/SubIdx;
for c = 1:4
    eval(['W_' condition{c} '= W_' condition{c} '/SubIdx;']);
    eval(['W_' condition{c} '_utt = W_' condition{c} '_utt/SubIdx;']);
end 

%% Encoding Plotting
ch = {'Fz', 'Cz', 'C3', 'C4', 'P7', 'P8', 'Pz', 'F7', 'F8', 'F3', 'F4', 'T7', 'T8', 'P3','P4'};
% front = [12,13];
selec = [1:15];

% for c = 1:4
% for chan = [5,6,7,14,15]
% %     W_no(:,chan) = -W_no(:,chan);
%     eval(['W_' condition{c} '(:,chan) = -W_' condition{c} '(:,chan);'])
% end
% end


figure(3)
clf
% plot(t, mean(W_no(:,front)'), 'color', [0.5,0.5,0.5], 'Linewidth', 1); hold on
plot(t, mean(W_MCL(:,selec)'), 'color', [0 0.4470 0.7410], 'Linewidth', 2);hold on
plot(t, mean(W_MCL20(:,selec)'), 'color', [0.8500 0.3250 0.0980], 'Linewidth', 2);
plot(t, mean(W_SI90(:,selec)'), 'color', [0.9290 0.6940 0.1250], 'Linewidth', 2);
plot(t, mean(W_SI50(:,selec)'), 'color', [0.4940 0.1840 0.5560], 'Linewidth', 2);
% ylim([-0.03 0.03])
legend('MCL', 'MCL20', 'SI90', 'SI50')

%% Encoding Plotting - unattended 랑
% front = [1:4,8,9,10,11];
selec = 1:15;
figure(2)
clf

% plot(t, mean(W_no(:,front)'), 'color', [0.5,0.5,0.5], 'Linewidth', 1); hold on
subplot(4,1,1)
plot(t, mean(W_MCL(:,selec)'), 'color', [0 0.4470 0.7410], 'Linewidth', 2);hold on
plot(t, mean(W_MCL_utt(:,selec)'),':', 'color', [0 0.4470 0.7410], 'Linewidth', 2);
subplot(4,1,2)
plot(t, mean(W_MCL20(:,selec)'), 'color', [0.8500 0.3250 0.0980], 'Linewidth', 2);hold on
plot(t, mean(W_MCL20_utt(:,selec)'),':', 'color', [0.8500 0.3250 0.0980], 'Linewidth', 2);
subplot(4,1,3)
plot(t, mean(W_SI90(:,selec)'), 'color', [0.9290 0.6940 0.1250], 'Linewidth', 2); hold on
plot(t, mean(W_SI90_utt(:,selec)'),':', 'color', [0.9290 0.6940 0.1250], 'Linewidth', 2);
subplot(4,1,4)
plot(t, mean(W_SI50(:,selec)'), 'color', [0.4940 0.1840 0.5560], 'Linewidth', 2); hold on
plot(t, mean(W_SI50_utt(:,selec)'),':', 'color', [0.4940 0.1840 0.5560], 'Linewidth', 2);

% 
% ylim([-0.03 0.03])
% 
% legend('MCL', 'MCL20', 'SI90', 'SI50')  


%% 그냥 보기
figure(4)
clf
ch = {'Fz', 'Cz', 'C3', 'C4', 'P7', 'P8', 'Pz', 'F7', 'F8', 'F3', 'F4', 'T7', 'T8', 'P3','P4'};
plot(t, mean(W_attno,2), 'Linewidth', 2); hold on
plot(t, mean(W_uttno,2), ':', 'Linewidth', 2); hold on 

% legend(ch)

%% Offline decoding
clear

load ('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\Rawdata_SPL_all.mat');
RAWDATA_SPL = RAWDATA_SPL_all;
trials_mcl = [15,22,24,27,33,38,42];
trials_20 = [17,20,25,28,32,36,41];
trials_90 = [16,19,23,30,34,37,40];
trials_srt = [18,21,26,29,31,35,39];
condition = {'mcl', '20', '90', 'srt'};
list = {'MCL', '20', '90', 'SRT'};
used = [1,3,4,5,6,7,8,9,11,12,13,14,16,19,21,22];
fs = 64;
Dir    = -1;
tmin    = 0; 
tmax    = 250;
lambda = 10.^(-6:1:4);

% filtering design
design = designfilt('bandpassfir', 'FilterOrder',401, ...
    'CutoffFrequency1', 0.5, 'CutoffFrequency2', 4,...
    'SampleRate', 64);

for i = 1:length(list)
    eval(['OffCorr_att_',list{i},'=[];'])
    eval(['OffCorr_utt_',list{i},'=[];']);     

end
    
for SubIdx = 1:length(used)
    
    att_env = RAWDATA_SPL(used(SubIdx)).att_stim;
    utt_env = RAWDATA_SPL(used(SubIdx)).utt_stim;
    EEG = RAWDATA_SPL(used(SubIdx)).data;
    model = {};
    acc = [];
    
    % freq band 변경
    for t = 1:length(EEG)
        eeg = EEG{t};
        EEG{t} = filtfilt(design, eeg);
    end
    
    % Searching optimal lambda   
    cv = mTRFcrossval(att_env(1:14), EEG(1:14), fs, Dir, tmin, tmax, lambda, 'verbose', 0);
    [rmax,idx] = max(mean(cv.r));
    optmal_Lmb = lambda(idx);
    
    % decoder train
    model = mTRFtrain(att_env(1:14), EEG(1:14), fs, Dir, tmin, tmax, optmal_Lmb, 'verbose', 0);
    acc_mcl = [];
    acc_20 = [];
    acc_90 = [];
    acc_srt = [];
    for i = 1:length(list)
        eval(['Offcorr_att_',list{i},'=[];'])
        eval(['Offcorr_utt_',list{i},'=[];']); 
   
    end

    for i = 15:length(EEG)

%         j = i+14;
        if length(find(trials_mcl == i)) == 1;
            [pred_att_mcl, stats_att_mcl] = mTRFpredict(att_env{i}, EEG{i}, model, 'verbose', 0);
            [pred_utt_mcl, stats_utt_mcl] = mTRFpredict(utt_env{i}, EEG{i}, model, 'verbose', 0);

            if stats_att_mcl.r > stats_utt_mcl.r
                acc_mcl = [acc_mcl,1];
            else acc_mcl = [acc_mcl,0]; end
            Offcorr_att_MCL = [Offcorr_att_MCL, stats_att_mcl.r];
            Offcorr_utt_MCL = [Offcorr_utt_MCL, stats_utt_mcl.r];

        elseif length(find(trials_20 == i)) == 1;
            [pred_att_20, stats_att_20] = mTRFpredict(att_env{i}, EEG{i}, model, 'verbose', 0);
            [pred_utt_20, stats_utt_20] = mTRFpredict(utt_env{i}, EEG{i}, model, 'verbose', 0);

            if stats_att_20.r > stats_utt_20.r
                acc_20 = [acc_20,1];
            else acc_20 = [acc_20,0]; end
            Offcorr_att_20 = [Offcorr_att_20, stats_att_20.r];
            Offcorr_utt_20 = [Offcorr_utt_20, stats_utt_20.r];

        elseif length(find(trials_90 == i)) == 1;
            [pred_att_90, stats_att_90] = mTRFpredict(att_env{i}, EEG{i}, model, 'verbose', 0);
            [pred_utt_90, stats_utt_90] = mTRFpredict(utt_env{i}, EEG{i}, model, 'verbose', 0);

            if stats_att_90.r > stats_utt_90.r
                acc_90 = [acc_90,1];
            else acc_90 = [acc_90,0]; end
            Offcorr_att_90 = [Offcorr_att_90, stats_att_90.r];
            Offcorr_utt_90 = [Offcorr_utt_90, stats_utt_90.r];

        elseif length(find(trials_srt == i)) == 1;
            [pred_att_srt, stats_att_srt] = mTRFpredict(att_env{i}, EEG{i}, model, 'verbose', 0);
            [pred_utt_srt, stats_utt_srt] = mTRFpredict(utt_env{i}, EEG{i}, model, 'verbose', 0);

            if stats_att_srt.r > stats_utt_srt.r
                acc_srt = [acc_srt,1];
            else acc_srt = [acc_srt,0]; end
            Offcorr_att_SRT = [Offcorr_att_SRT, stats_att_srt.r];
            Offcorr_utt_SRT = [Offcorr_utt_SRT, stats_utt_srt.r];

        end
    end
    %
    OffCorr_att_MCL = [OffCorr_att_MCL; Offcorr_att_MCL];
    OffCorr_att_20 = [OffCorr_att_20; Offcorr_att_20];
    OffCorr_att_90 = [OffCorr_att_90; Offcorr_att_90];
    OffCorr_att_SRT = [OffCorr_att_SRT; Offcorr_att_SRT];
    %
    OffCorr_utt_MCL = [OffCorr_utt_MCL; Offcorr_utt_MCL];
    OffCorr_utt_20 = [OffCorr_utt_20; Offcorr_utt_20];
    OffCorr_utt_90 = [OffCorr_utt_90; Offcorr_utt_90];
    OffCorr_utt_SRT = [OffCorr_utt_SRT; Offcorr_utt_SRT];
    
    
    OffAcc_mcl = mean(acc_mcl);
    OffAcc_20 = mean(acc_20);
    OffAcc_90 = mean(acc_90);
    OffAcc_srt = mean(acc_srt);

%     OffDATA(SubIdx).subject = RAWDATA_SPL(SubIdx).subject;
%     OffDATA(SubIdx).all_acc = mean([OffAcc_mcl,OffAcc_20, OffAcc_90,OffAcc_srt])*100;
    OffDATA_2(SubIdx).subject = RAWDATA_SPL(SubIdx).subject;
    OffDATA_2(SubIdx).all_acc = mean([OffAcc_mcl,OffAcc_20, OffAcc_90,OffAcc_srt])*100;

    for i = 1:length(condition)
        eval(['OffDATA_2(SubIdx).acc_',condition{i},' = OffAcc_',condition{i},'*100;']);
%         eval(['OffDATA(SubIdx).acc_',condition{i},' = OffAcc_',condition{i},'*100;']);
    end
    for i = 1:4
%         eval(['OffDATA(SubIdx).corr_att_',condition{i},'= Offcorr_att_',list{i},';']);
        eval(['OffDATA_2(SubIdx).corr_att_',condition{i},'= Offcorr_att_',list{i},';']);
    end
    for i = 1:4
%         eval(['OffDATA(SubIdx).corr_utt_',condition{i},'= Offcorr_utt_',list{i},';']);
        eval(['OffDATA_2(SubIdx).corr_utt_',condition{i},'= Offcorr_utt_',list{i},';']);
    end
    
    disp(['subject',num2str(SubIdx),' finished!'])
end

%% delta - Acc Wilcoxon & Corraltion plot
condition = {'MCL', 'MCL20', 'SI90', 'SI50'};
for SubIdx = 1:16
    
    Indi_Acc_MCL(SubIdx) = OffDATA_2(SubIdx).acc_mcl;
    Indi_Acc_MCL20(SubIdx) = OffDATA_2(SubIdx).acc_20;
    Indi_Acc_SI90(SubIdx) = OffDATA_2(SubIdx).acc_90;
    Indi_Acc_SI50(SubIdx) = OffDATA_2(SubIdx).acc_srt;
    
end

% Wilcoxon signed - Behavior & Self scale
for c = 1:4
    eval(['Ave_Acc(c) = mean(Indi_Acc_' condition{c} ');'])
    eval(['x = Indi_Acc_' condition{c} ';'])
    for cc = 1:4
        eval(['y = Indi_Acc_' condition{cc} ';'])
        if c==cc
%             Wilcox{c, cc} = [];
        else
            [p,h] = signrank(x,y);
            Wilcox_Acc_h(c, cc) = h;
            Wilcox_Acc_p(c, cc) = p;
                   
        end
    end
end


% correlation
figure(32)
clf
x1 = 1-0.5:3:10-0.5;
x2 = 1+0.5:3:10+0.5;

boxplot([mean(OffCorr_att_MCL,2), mean(OffCorr_att_20,2), mean(OffCorr_att_90,2), mean(OffCorr_att_SRT,2)],...
            x1, 'Positions', x1, 'color', 'r', 'boxstyle', 'filled'); hold on
boxplot([mean(OffCorr_utt_MCL,2), mean(OffCorr_utt_20,2), mean(OffCorr_utt_90,2), mean(OffCorr_utt_SRT,2)],...
            x2, 'Positions', x2, 'color', [0.5,0.5,0.5], 'boxstyle', 'filled');
ylim([-0.1 0.2])
xlim([-1 12])
ylabel('Envelope Correlation')
xlabel('Conditoin')


%% data
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\DATA_withSNR_used.mat');
DATA = DATA_withSNR_used;
clear DATA_withSNR_used
condition = {'MCL', 'MCL20', 'SI90', 'SI50'};

% behavior test & Self scale
for i = 1:length(DATA)    
    Beh_Att_MCL(i) = DATA(i).Behavior2_att_MCL;
    Beh_Att_MCL20(i) = DATA(i).Behavior2_att_20;
    Beh_Att_SI90(i) = DATA(i).Behavior2_att_90;
    Beh_Att_SI50(i) = DATA(i).Behavior2_att_SRT;
  
    Beh_Utt_MCL(i) = DATA(i).Behavior2_utt_MCL;
    Beh_Utt_MCL20(i) = DATA(i).Behavior2_utt_20;
    Beh_Utt_SI90(i) = DATA(i).Behavior2_utt_90;
    Beh_Utt_SI50(i) = DATA(i).Behavior2_utt_SRT;    
    
    Self_MCL(i) = DATA(i).Self_MCL;
    Self_MCL20(i) = DATA(i).Self_20;
    Self_SI90(i) = DATA(i).Self_90;
    Self_SI50(i) = DATA(i).Self_SRT; 
end

% Wilcoxon signed - Behavior & Self scale
for c = 1:4
    eval(['x = Beh_Att_' condition{c} ';'])
    eval(['xs = Self_' condition{c} ';'])
    for cc = 1:4
        eval(['y = Beh_Att_' condition{cc} ';'])
        eval(['ys = Self_' condition{cc} ';'])
        if c==cc
%             Wilcox{c, cc} = [];
        else
            [p,h] = signrank(x,y);
            Wilcox_Beh_h(c, cc) = h;
            Wilcox_Beh_p(c, cc) = p;
            
            [p,h] = signrank(xs,ys);
            Wilcox_Self_h(c, cc) = h;
            Wilcox_Self_p(c, cc) = p;            
        end
    end
end

x = Beh_Att_MCL;
y = Beh_Utt_MCL;
[p,h] = signrank(x,y)



% Wilcoxon signed - Corr
for c = 1:4
    eval(['xca = mean(Indi_AttCorr_' condition{c} ',2);'])
    eval(['xcu = mean(Indi_UttCorr_' condition{c} ',2);'])
    eval(['xacc = Indi_Acc_' condition{c} ';'])
    for cc = 1:4
        eval(['yca = mean(Indi_AttCorr_' condition{cc} ',2);'])
        eval(['ycu = mean(Indi_UttCorr_' condition{cc} ',2);'])
        eval(['yacc = Indi_Acc_' condition{cc} ';'])
        if c==cc
%             Wilcox{c, cc} = [];
        else
            [p,h] = signrank(xca,yca);
            Wilcox_CorrAtt_h(c, cc) = h;
            Wilcox_CorrAtt_p(c, cc) = p;
            
            [p,h] = signrank(xcu,ycu);
            Wilcox_CorrUtt_h(c, cc) = h;
            Wilcox_CorrUtt_p(c, cc) = p;            
            
            [p,h] = signrank(xacc,yacc);
            Wilcox_Acc_h(c, cc) = h;
            Wilcox_Acc_p(c, cc) = p;
        end
    end
end 

%% 모든 팩터 - condition 별 box plot






















