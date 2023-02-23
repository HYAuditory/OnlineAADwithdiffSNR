%% condition 별 - offline - optimal lambda
% clear
% clc
%load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\DATA_withSNR.mat');
% load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA.mat')
% load ('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\Rawdata_SPL.mat');
load ('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\Rawdata_SPL_all.mat');
RAWDATA_SPL = RAWDATA_SPL_all;
trials_mcl = [15,22,24,27,33,38,42];
trials_20 = [17,20,25,28,32,36,41];
trials_90 = [16,19,23,30,34,37,40];
trials_srt = [18,21,26,29,31,35,39];
condition = {'mcl', '20', '90', 'srt'};
list = {'MCL', '20', '90', 'SRT'};

fs = 64;
Dir    = -1;
tmin    = 0; 
tmax    = 500;
% lambda = 10;

% design = designfilt('bandpassfir', 'FilterOrder',601, ...
%     'CutoffFrequency1', 0.5, 'CutoffFrequency2', 4,...
%     'SampleRate', 125);

for SubIdx = 1:length(RAWDATA_SPL)
    
    att_env = RAWDATA_SPL(SubIdx).att_stim;
    utt_env = RAWDATA_SPL(SubIdx).utt_stim;
    EEG = RAWDATA_SPL(SubIdx).data;
    model = {};
    acc = [];
    
    % freq band 변경
%     for t = 1:length(EEG)
%         eeg = EEG{t};
%         EEG{t} = filtfilt(design, eeg);
%     end

    lambda_range = 10.^(-6:1:4);            

    % Search optimal lambda
    cv = mTRFcrossval(att_env, EEG, fs, Dir, tmin, tmax, lambda_range, 'verbose', 0);
    [rmax,idx] = max(mean(cv.r));
    lambda(SubIdx) = lambda_range(idx);

    % decoder train
    
    model = mTRFtrain(att_env(1:14), EEG(1:14), fs, Dir, tmin, tmax, lambda(SubIdx), 'verbose', 0);
    acc_mcl = [];
    acc_20 = [];
    acc_90 = [];
    acc_srt = [];
    for i = 1:length(list)
        eval(['Offcorr_att_',list{i},'=[];'])
        eval(['Offcorr_utt_',list{i},'=[];']); end

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

% save('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA.mat', 'OffDATA');
% save('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA_optimal_500.mat', 'OffDATA_2');

% save('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA_delta.mat', 'OffDATA_delta');