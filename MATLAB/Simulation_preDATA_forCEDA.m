%% CEDA data

%% Load
EMAcorr_att = readNPY('C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\save_data\Allcorr_att_EMA_ceda.npy');
EMAcorr_unatt = readNPY('C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\save_data\Allcorr_unatt_EMA_ceda.npy');

% no EMA correlation load
subject = [2,5,6,7,9,10,11,12,13];
count = 1;
for sub = subject
    
    Corr_att{count} = readNPY('C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\CEDA\'+string(sub)+'\All_correlation_att_'+string(sub)+'.npy')
    Corr_unatt{count} = readNPY('C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\CEDA\'+string(sub)+'\All_correlation_unatt_'+string(sub)+'.npy')
    
    % Behavior
    load('C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\CEDA\'+string(sub)+'\Behavior_'+string(sub)+'.mat')
    beh_at = Behavior(:,3:4);
    beh_un = Behavior(:,1:2);
    correct_at = find(beh_at=='T');
    correct_un = find(beh_un=='T');
    
    Indi_beh_at(count) = (length(correct_at)/60)*100;
    Indi_beh_un(count) = (length(correct_un)/60)*100;
    
    count = count + 1;
    
end

%% Behavior - switching trial 확인
[27,28,29,30]
[53,54 ; 55,56; 57,58; 59,60;]
a = sum([2,1,4,2,4,6,2])/22;

%
Beh_att_sem = std(Indi_beh_at)/sqrt(length(Indi_beh_at));
Beh_utt_sem = std(Indi_beh_un)/sqrt(length(Indi_beh_un));


%% plot - EMA 유무

sub = 6;
tr = 1;
c1 = Corr_att{sub};
c2 = Corr_unatt{sub};
e1 = squeeze(EMAcorr_att(sub,:,:));
e2 = squeeze(EMAcorr_unatt(sub,:,:));

% fixed 경우

figure(2)
clf
subplot(2,1,1)
plot([15:60], c1(tr,:), '--or', 'LineWidth', 1); hold on
plot([15:60], c2(tr,:), '--ob', 'LineWidth', 1); hold off
legend('Right', 'Left', 'AutoUpdate','off', 'Location', 'NorthWest')
ylim([-0.2 0.33])
xlim([0 60])
xlabel('time (s)')
ylabel('Correlation coefficient')
xline(15, ':')
title('No EMA')

subplot(2,1,2)
plot([15:60], e1(tr,:), '--or', 'LineWidth', 1); hold on
plot([15:60], e2(tr,:), '--ob', 'LineWidth', 1); hold off
legend('Right', 'Left', 'AutoUpdate','off', 'Location', 'NorthWest')
ylim([-0.2 0.33])
xlim([0 60])
xline(15, ':')
xlabel('time (s)')
ylabel('Correlation coefficient')
title('With EMA')

%% switching 경우
sub = 1;
tr = 15
c1 = Corr_att{sub};
c2 = Corr_unatt{sub};
e1 = squeeze(EMAcorr_att(sub,:,:));
e2 = squeeze(EMAcorr_unatt(sub,:,:));

figure(1)
clf
subplot(2,1,1)
plot([15:60],[c1(tr,[1:16]), c2(tr,[17:46])], '--or', 'LineWidth', 1); hold on
plot([15:60],[c2(tr,[1:16]), c1(tr, [17:46])], '--ob', 'LineWidth', 1); hold off
legend('Right', 'Left', 'AutoUpdate','off', 'Location', 'NorthWest')
ylim([-0.2 0.33])
xlim([0 60])
xlabel('time (s)')
ylabel('Correlation coefficient')
xline(15, ':')
xline(33, ':b')
title('No EMA')

subplot(2,1,2)
plot([15:60],[e1(tr,[1:18]), e2(tr,[19:46])], '--or', 'LineWidth', 1); hold on
plot([15:60],[e2(tr,[1:18]), e1(tr, [19:46])], '--ob', 'LineWidth', 1); hold off
legend('Right', 'Left', 'AutoUpdate','off', 'Location', 'NorthWest')
ylim([-0.2 0.33])
xlim([0 60])
xline(15, ':')
xline(33, ':b')
xlabel('time (s)')
ylabel('Correlation coefficient')
title('With EMA')

%% EMA no/with data 비교 분석
%% 이게 맞는 EMA 결과
for sub = 1:9
    for tr = 1:16
        for w = 1:46
            att(w) = EMAcorr_att(sub,tr,w);
            utt(w) = EMAcorr_unatt(sub,tr,w);
            
            if att(w) > utt(w)
                acc(w) = 1;
            else acc(w) = 0;             
            end
        end
        acc_tr(sub,tr) = mean(acc)*100;
    end
end

E_all = mean(acc_tr,2)';
E_fix = mean(acc_tr(:,1:12),2)';
E_switch = mean(acc_tr(:,13:end),2)';

%%
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\DATA(OpenBCI)_sub9.mat') % DATA

for i = 1:length(DATA)
    R_all(i) = DATA(i).RealTime_all;
    R_fix(i) = DATA(i).RealTime_fix;
    R_switch(i) = DATA(i).RealTime_switch;
    E_all(i) = DATA(i).EMA_all;
    E_fix(i) = DATA(i).EMA_fix;
    E_switch(i) = DATA(i).EMA_switch;
end
all = mean([R_all; E_all],2);
fix = mean([R_fix; E_fix],2);
swi = mean([R_switch; E_switch],2);
X = categorical({'All', 'Fix', 'Switch'});
X = reordercats(X,{'All', 'Fix', 'Switch'});

figure(2)
clf
bar(X,[all';fix';swi']); hold on
legend('without EMA', 'with EMA')
ylim([50,85])

%% EMA - sensitivity 확인 
% 전화점 앞뒤 5초 accuracy 
Ptrial = [30, 31, 33, 27];
tr = [27, 28, 29, 30];

width = 10;

Sensit_att_fr = {};  Sensit_utt_fr = {};
Sensit_att_bc = {};  Sensit_utt_bc = {};
Sacc_tr_fr = [];     Sacc_tr_bc = [];
acc_fr = [];     acc_bc = [];
Compar_bc = {};
for i = 1:length(Ptrial)
    point = Ptrial(i)-14;    
%     point = 1;
    Sensit_att_fr{i} = EMAcorr_att(:,tr(i)-14, 1:point-1);
    Sensit_utt_fr{i} = EMAcorr_unatt(:,tr(i)-14, 1:point-1);
    Sensit_att_bc{i} = EMAcorr_att(:,tr(i)-14, point:end);
    Sensit_utt_bc{i} = EMAcorr_unatt(:,tr(i)-14, point:end);
end
    
for sub = 1:size(EMAcorr_att,1)
    for t = 1:size(Sensit_att_fr,2)
        acc_fr =[]; acc_bc = [];
        for wf = 1:size(Sensit_att_fr{t},3)
            att_fr(wf) = Sensit_att_fr{t}(sub,1,wf);
            utt_fr(wf) = Sensit_utt_fr{t}(sub,1,wf);
                                  
            if att_fr(wf) > utt_fr(wf)
                acc_fr(wf) = 1;
            else acc_fr(wf) = 0;             
            end
            
        end
        for wb = 1:size(Sensit_att_bc{t},3)
            att_bc(wb) = Sensit_att_bc{t}(sub,1,wb);
            utt_bc(wb) = Sensit_utt_bc{t}(sub,1,wb);
            
            if att_bc(wb) > utt_bc(wb)
                acc_bc(wb) = 1;
            else acc_bc(wb) = 0;             
            end
        end          
        Indi_Acc_swi(sub,t) = mean([acc_fr, acc_bc])*100;
        Sacc_tr_fr(sub,t) = mean(acc_fr)*100;
        Sacc_tr_bc(sub,t) = mean(acc_bc)*100;
        Compar_bc{sub,t} = acc_bc;
    end
end

latency = [];
latc = [];
f_one = {};
f = [];
f_ix = [];
for s = 1:size(Compar_bc,1)
    for t = 1:size(Compar_bc,2)
        f_one{s,t} = find(Compar_bc{s,t} == 1);
        try f_one{s,t}(5)-f_one{s,t}(1) == 4 && length(f_one{s,t}) > 1
            latency(s,t) = f_one{s,t}(1);
        catch %length(f_one) < 1
            latency(s,t) = NaN(1);
            f = [f,1];
        end
    end
    idx = find(Sacc_tr_fr(s,:) > 55.99); 
%     idx = find(Indi_Acc_swi(s,:) > 55.99);
    f_ix = [f_ix, (4-length(idx))];
    latc(s) = nanmean(latency(s,idx));
    indi_latency{s} = latency(s,idx);
end

disp('-------------------------')
nanmean(latc)
sensitivi_sem = std(latc)/sqrt(length(latc))
mean(mean(Sacc_tr_fr))
mean(mean(Sacc_tr_bc))

%% Sensitivity box plot 

figure(3)
clf
bar(latc); hold on
for i = 1:length(indi_latency)
    scatter(linspace(i,i, length(indi_latency{i})), indi_latency{i},'filled') %, 'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)
end


%% AAF - EMA sensitivity
Corr_att = []; Corr_unatt = [];
for sub = 1:6
    if sub < 4
%         load(['C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\pL0', num2str(sub) ,'\result_w_clip_delta+theta.mat']);
%         co_att = result.rL;
%         co_unatt = result.rR;
        load(['C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\pL0', num2str(sub), '\test1_Result.mat']);
        load(['C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\pL0', num2str(sub), '\test2_Result.mat']);
        load(['C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\pL0', num2str(sub), '\test3_Result.mat']);
        co_att = [test1_Result.rs_L(1,:), test2_Result.rs_L(1,:), test3_Result.rs_L(1,:)];
        co_unatt = [test1_Result.rs_R(1,:), test2_Result.rs_R(1,:), test3_Result.rs_R(1,:)];
        acc_aaf(sub,:) = test3_Result.accs(1,:);


    else
%         load(['C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\pR0', num2str(sub-3), '\result_w_clip_delta+theta.mat']);  
%         co_att = result.rR;
%         co_unatt = result.rL;        
        load(['C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\pR0', num2str(sub-3), '\test1_Result.mat']);
        load(['C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\pR0', num2str(sub-3), '\test2_Result.mat']);
        load(['C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\pR0', num2str(sub-3), '\test3_Result.mat']);
        co_unatt = [test1_Result.rs_L(1,:), test2_Result.rs_L(1,:), test3_Result.rs_L(1,:)];
        co_att = [test1_Result.rs_R(1,:), test2_Result.rs_R(1,:), test3_Result.rs_R(1,:)];
        acc_aaf(sub,:) = test3_Result.accs(1,:);
    end
    
    for tr = 1:16
        Corr_att(sub,tr,:) = co_att(1, 1+((tr-1)*46):46+((tr-1)*46));
        Corr_unatt(sub,tr,:) = co_unatt(1, 1+((tr-1)*46):46+((tr-1)*46));
    end
    
end

EMAcorr_att = Corr_att;
EMAcorr_unatt = Corr_unatt;

%
Ptrial = [30, 31, 33, 27];
tr = [27, 28, 29, 30];

corr = [];
Compar_bc = {};
for sub = 1:6
    for t = 1:4
        corr(sub,t,:) = acc_aaf(sub, 1+(t-1)*46:46+(t-1)*46);
        
        point = Ptrial(t)-14;  
        Sacc_tr_fr(sub,t) = mean(corr(sub, t, 1:point-1))*100;
        Sacc_tr_bc(sub,t) = mean(corr(sub, t, point:end))*100;     
        Compar_bc{sub,t} = squeeze(corr(sub, t, point:end))';
        
    end
end

latency = [];
latc = [];
f_one = {};
f = [];
f_ix = [];
for s = 1:size(Compar_bc,1)
    for t = 1:size(Compar_bc,2)
        f_one{s,t} = find(Compar_bc{s,t} == 1);
        try f_one{s,t}(5)-f_one{s,t}(1) == 4 && length(f_one{s,t}) > 1
            latency(s,t) = f_one{s,t}(1);
        catch %length(f_one) < 1
            latency(s,t) = NaN(1);
            f = [f,1];
        end
    end
    idx = find(Sacc_tr_fr(s,:) > 54); 
    f_ix = [f_ix, (4-length(idx))];
    latc(s) = nanmean(latency(s,idx));
end

disp('-------------------------')
nanmean(latc)
mean(mean(Sacc_tr_fr))
mean(mean(Sacc_tr_bc))

%% Data 정리
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\DATA(3conditions)_rev210330.mat');

% condition 직접 조정
for sub = 1:10
    id = 'AADC';
    name = [id, num2str(sub), '.vhdr'];
    EEG = pop_loadbv('C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AADC\', name);
%     EEG = pop_select(EEG, 'nochannel', [60,64,65,66,67,68]);
    EEG = pop_chanedit(EEG, 'lookup','C:\Users\LeeJiWon\Desktop\hykist\AAD\OfflineAAD\standard-10-5-cap385_witheog.elp');
%     EEG = pop_select(EEG, 'nochannel', [33 43]);
    EEG = pop_epoch(EEG, {'99'}, [2 62]);
%     EEG = pop_resample(EEG,125);
    DATA_AADC.DATA(sub).Subject = [id, num2str(sub)];
    DATA_AADC.DATA(sub).Data = EEG.data;
%     DATA_SNU(con).SPEECH = DATA(con).SPEECH;    
end

% speech data-AAK
path_L = 'C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\ORIGINAL_SPEECH_AAK\L_Twenty\'
path_R = 'C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\ORIGINAL_SPEECH_AAK\R_Journey\'

for i = 1:30 
    names(i).number = ['L' num2str(i)];
    names(i+30).number = ['R' num2str(i)];
    names(i).filename = [path_L char(names(i).number) '.wav'];
    names(i+30).filename = [path_R char(names(i+30).number) '.wav'];
    [y(i,:),sr] = audioread(names(i).filename);
    [y(i+30,:),sr] = audioread(names(i+30).filename);
    
    h(i,:) = hilbert(y(i,:));
    abs_h(i,:) = abs(h(i,:));
    h(i+30,:) = hilbert(y(i+30,:));
    abs_h(i+30,:) = abs(h(i+30,:));
    
%     env(i,:) = resample(abs_h(i,:),125,sr);
%     env(i+30,:) = resample(abs_h(i+30,:),125,sr);
%     hil(i,:) = zscore(hil(i,:));
end

%% AADC
% AADC
con = 3;
load('C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AADC\ALLINDEX_AADC.mat')    % ALLINDEX
for sub = 1:length(DATA(con).EEG)
    
    id = DATA(con).EEG(sub).id;
    name = [id, '.vhdr'];
    EEG = pop_loadbv('C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AADC\', name);
    EEG = pop_select(EEG, 'nochannel', [60,64,65,66,67,68]);
    EEG = pop_chanedit(EEG, 'lookup','C:\Users\LeeJiWon\Desktop\hykist\AAD\OfflineAAD\standard-10-5-cap385_witheog.elp');
    EEG = pop_select(EEG, 'nochannel', [33 43]);
    EEG = pop_epoch(EEG, {'99'}, [2 62]);
    EEG = pop_resample(EEG,125);
    DATA_SNU(2).DATA(sub).Subject = id;
    DATA_SNU(2).DATA(sub).Data = EEG.data;
    DATA_SNU(2).DATA(sub).att = ALLINDEX(sub).a;
    DATA_SNU(2).DATA(sub).utt = ALLINDEX(sub).u;
%     DATA_SNU(con).SPEECH = DATA(con).SPEECH;
    
end

% speech - AADC
path = 'C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\original narration file_AADC\';
abs_h=[];
env=[];
 for i = 1:60 
    names(i).number = ['s' num2str(i)];
    names(i).filename = [path char(names(i).number) '.wav'];
    [y(i,:),sr] = audioread(names(i).filename);
    
    h(i,:) = hilbert(y(i,:));
    abs_h(i,:) = abs(h(i,:));
    
%     env(i,:) = resample(abs_h(i,:),125,sr);
%     hil(i,:) = zscore(hil(i,:));
 end

DATA_SNU(2).SPEECH = env;
DATA_SNU(2).EEGstruct = EEG;
DATA_SNU(2).chloc = EEG.chanlocs;
DATA_SNU(2).srate = EEG.srate;
DATA_SNU(2).Label = 'AADC'; 

%% online exp
path = 'C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\';

for sub = 1:6

    if sub < 4
        load([path 'pL0' num2str(sub) '\epoched_eeg_off.mat'])  % trial by all ch 68 by time (epoched_eeg)
        load([path 'pL0' num2str(sub) '\f_onTrials.mat'])       % flag
        % reject channel
        epoched_eeg_off(:,[33,43,60,64,65,66,67,68],:) = [];
        % reshape
        for ep = 1:30
            eeg(:,:,ep) = resample(squeeze(epoched_eeg_off(ep,:,:))', 125, 1000)';end
       
        DATA_AAF.DATA(sub).Subject = ['AAFL0' num2str(sub)];
        DATA_AAF.DATA(sub).Data = eeg;
        DATA_AAF.DATA(sub).flag = f_onTrials;
    else
        load([path 'pR0' num2str(sub-3) '\epoched_eeg_off.mat'])  % trial by all ch 68 by time (epoched_eeg)
        load([path 'pR0' num2str(sub-3) '\f_onTrials.mat']) 
        % reject channel
        epoched_eeg_off(:,[33,43,60,64,65,66,67,68],:) = [];
        % reshape
        for ep = 1:30
            eeg(:,:,ep) = resample(squeeze(epoched_eeg_off(ep,:,:))', 125, 1000)';end

        DATA_AAF.DATA(sub).Subject = ['AAFR0' num2str(sub)];
        DATA_AAF.DATA(sub).Data = eeg;
        DATA_AAF.DATA(sub).flag = f_onTrials;
    end
end

% speech
load(['C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\pL01\AAK_left.mat']);  % trial by 60s*64
load(['C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\pL01\AAK_right.mat']); 
    


%%
for tr =1:30
    SPEECH(tr,:) = resample(abs(hilbert(DATA_AAK.SPEECH(tr,:))), 125, 44100);
    SPEECH(tr+30,:) = resample(abs(hilbert(DATA_AAK.SPEECH(tr+30,:))), 125, 44100);

end

DATA_SNU.DATA = DATA_AAF.DATA;%resample(double(DATA_AAF.DATA(sub).Data(:,:,tr)'),125,1000);

%% online simulation - various srate

fs = [32, 64, 125];
Dir    = -1;
tmin    = 0;                       % min time-lag(ms)
tmax    = 250;                     % max time-lag(ms)
lambda = 10;

Mov = 1;
Width = 15;

% experiment condition
condition = {'AAK', 'AADC','AAF'};

% filter
design = designfilt('bandpassfir', 'FilterOrder',4999, ...       % 125 =624 / 1000 = 4999
    'CutoffFrequency1', 0.5, 'CutoffFrequency2', 8,...
    'SampleRate', 1000);
% fvtool(design);

% Simulation 
for c = 1%:length(condition)-1
%     eval(['load(''C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\DATA_',condition{c},'.mat'');']);
%     DATA_SNU = eval(['DATA_',condition{c},';']);
%     eval(['clear DATA_',condition{c},';']);

    srate = 125; % eval(['DATA_SNU(1).DATA(1).srate;']);
    eval(['tcount_',condition{c},' = {};'])

    for f = 2%1:length(fs)
        tminIdx = floor(tmin/1000*fs(f));     % tmin2idx
        tmaxIdx = ceil(tmax/1000*fs(f));      % tmax2idx
        timeLag = length(tminIdx:tmaxIdx); % time-lag points between tmin and tmax
        t       = sort( 1 * ( linspace(tmin, tmax, timeLag) ) );
        % speech data
        hill = [];
        hil=[];
        for tr = 1:size(DATA_SNU(c).SPEECH,1)           
            hil(tr,:) = DATA_SNU(c).SPEECH(tr,:);
            hill(tr,:) = resample(hil(tr,:), fs(f), 125);
            hill(tr,:) = zscore(hill(tr,:));
                                         
            if c ~= 2
                if tr < 31
                    att_stim_cell{tr} = hill(tr,:);     % 1 by trials cell - 1 by time
                else
                    unatt_stim_cell{tr-30} = hill(tr,:);   % 1 by trials cell - 1 by time
                end
            end
        end

        % for each subject
        for SubIdx = 1:length(DATA_SNU(c).DATA)
            % AADC 에 경우 피험자별 speech index 가 달라서 다르게 셋팅
            if c == 2
                Idxatt = DATA_SNU(c).DATA(SubIdx).att;
                Idxutt = DATA_SNU(c).DATA(SubIdx).utt;

                for tr = 1:30
                    att_stim_cell{tr} = hill(Idxatt(tr),:);
                    unatt_stim_cell{tr} = hill(Idxutt(tr),:);
                end
            end
            
            subject = eval(['DATA_SNU(c).DATA(SubIdx).Subject;']);

            % data
            data = eval(['DATA_SNU(c).DATA(SubIdx).Data;']);   % channels by time by trials           

            m = zeros(size(data,2),length(t));
            b = 0;
            % Train model
            for tr = 1:14
                eeg = double(squeeze(data(:,:,tr)));                % time by channel
                att_stim = double(att_stim_cell{tr});      % 1 by time
                unatt_stim = double(unatt_stim_cell{tr});  % 1 by time

                for w = 1:46
                    tic          
                    Mov_eeg = eeg( (1+(Mov*(w-1))*srate) : (Width+(Mov*(w-1)))*srate,:);
                    Mov_att_stim = att_stim(1, (1+(Mov*(w-1))*fs(f)) : (Width+(Mov*(w-1)))*fs(f))';

                    % rereference
                    for ch = 1:size(Mov_eeg,2)
                        re = mean(Mov_eeg(:,ch));
                        Mov_eeg(:,ch) = Mov_eeg(:,ch) - re;
                    end
                    % filter
%                         EEG(l) = pop_eegfiltnew(EEG(l),0.5,25);
                    Mov_eeg = filtfilt(design, Mov_eeg);
%                     Mov_eeg = filtfilt(filterweights, 1, Mov_eeg); % time_pnts by chans
                    % downsample
                    Mov_eeg = resample(Mov_eeg,fs(f),srate);
                    % zscore
                    Mov_eeg = zscore(Mov_eeg);            

                    model = mTRFtrain(Mov_att_stim, Mov_eeg, fs(f), Dir, tmin, tmax, lambda, 'verbose', 0);
                    wcount(w) = toc;
                    m = m + model.w;
                    b = b + model.b;
                end
                eval(['tcount_',condition{c},'28{f,SubIdx,tr} = {wcount};'])
            end      

            disp([condition{c} '_fs' num2str(fs(f)) '_Subject' num2str(SubIdx) ' Train end!']);
            %%%%%%%%%%%%%%%%%%%%%%%
            % Averaging Decoder model
            model.w = m/(46*14);
            model.b = b/(46*14);

            % Test model
            for tr = 15:size(data,3)        
                eeg = double(squeeze(data(:,:,tr)));                % time by channel
                att_stim = double(att_stim_cell{tr});      % 1 by time
                unatt_stim = double(unatt_stim_cell{tr});  % 1 by time        

                for w = 1:46
                    tic
                    Mov_eeg = eeg( (1+(Mov*(w-1))*srate) : (Width+(Mov*(w-1)))*srate,:);
                    Mov_att_stim = att_stim(1, (1+(Mov*(w-1))*fs(f)) : (Width+(Mov*(w-1)))*fs(f))';
                    Mov_unatt_stim = unatt_stim(1, (1+(Mov*(w-1))*fs(f)) : (Width+(Mov*(w-1)))*fs(f))';

                    % average reference
                    for ch = 1:size(Mov_eeg,2)
                        re = mean(Mov_eeg(:,ch));
                        Mov_eeg(:,ch) = Mov_eeg(:,ch) - re;
                    end
                    % filtering
                    Mov_eeg = filtfilt(design, Mov_eeg);
%                     Mov_eeg = filtfilt(filterweights, 1, Mov_eeg); % time_pnts by chans
                    % downsample
                    Mov_eeg = resample(Mov_eeg,fs(f),125);
                    % zscore
                    Mov_eeg = zscore(Mov_eeg); 

                    [predict_att, stats_att] = mTRFpredict(Mov_att_stim, Mov_eeg, model, 'verbose', 0);
                    [predict_unatt, stats_unatt] = mTRFpredict(Mov_unatt_stim, Mov_eeg, model, 'verbose', 0);

                    if stats_att.r > stats_unatt.r
                        acc(w) = 1;
                    else acc(w) = 0; end

                    wcount(w) = toc;
                end     % end 46 windows
                eval(['tcount_',condition{c},'{f,SubIdx,tr} = {wcount};'])
                AccTrial(tr-14) = mean(acc);
            end
            eval(['Indi_Acc_',condition{c},'{SubIdx} = AccTrial*100;'])
            eval(['Ave_Acc_',condition{c},'(SubIdx,f) = mean(AccTrial)*100;'])

            disp([condition{c} '_fs' num2str(fs(f)) '_Subject' num2str(SubIdx) ' finished!'])    
        end
    end
end

%% online simulation - various number of EEG channels

Dir    = -1;
tmin    = 0;                       % min time-lag(ms)
tmax    = 250;                     % max time-lag(ms)
lambda = 10;
fs = 64;
Mov = 1;
Width = 15;

% experiment condition
condition = {'AAK', 'AADC','AAF'};

% Select channels
% used channels - openbci : (Fq1, Fz, Cz, C3, C4, ...
%                              P7, P8, Pz, F7, F8, ...
%                              F3, F4, T7, T8, P3, and P4)
selec_chans = {};
% all
% selec_chans{1} = [1:60];   
% 16
selec_chans{1} = [1, 10, 28, 26, 30, ...
               42, 50, 46, 6, 14, ...
               8, 12, 24, 32, 44, 48];           
% 15
selec_chans{2} = [10, 28, 26, 30, ...
               42, 50, 46, 6, 14, ...
               8, 12, 24, 32, 44, 48];           
           
% filter
design = designfilt('bandpassfir', 'FilterOrder',601, ...
    'CutoffFrequency1', 0.5, 'CutoffFrequency2', 8,...
    'SampleRate', 125);
% fvtool(design);

% time-lag index
tminIdx = floor(tmin/1000*fs);     % tmin2idx
tmaxIdx = ceil(tmax/1000*fs);      % tmax2idx
timeLag = length(tminIdx:tmaxIdx); % time-lag points between tmin and tmax
t       = sort( 1 * ( linspace(tmin, tmax, timeLag) ) );


for c = 1:length(condition)-1
    % speech data
    hill = [];
    for tr = 1:size(DATA_SNU(c).SPEECH,1)           
        hil(tr,:) = DATA_SNU(c).SPEECH(tr,:);
        hill(tr,:) = resample(hil(tr,:), fs, 125);
        hill(tr,:) = zscore(hill(tr,:));

        if c ~= 2
            if tr < 31
                att_stim_cell{tr} = hill(tr,:);     % 1 by trials cell - 1 by time
            else
                unatt_stim_cell{tr-30} = hill(tr,:);   % 1 by trials cell - 1 by time
            end
        end
    end

    srate = 125; %eval(['DATA_SNU(1).DATA(1).srate;']);
    eval(['tcount_',condition{c},'_ChN = {};'])

    for ChN = 1:2
        chans = double(selec_chans{ChN});
        % for each subject
        for SubIdx = 1:length(DATA_SNU(c).DATA)
            % AADC 에 경우 피험자별 speech index 가 달라서 다르게 셋팅
            if c == 2
                Idxatt = DATA_SNU(c).DATA(SubIdx).att;
                Idxutt = DATA_SNU(c).DATA(SubIdx).utt;

                for tr = 1:30
                    att_stim_cell{tr} = hill(Idxatt(tr),:);
                    unatt_stim_cell{tr} = hill(Idxutt(tr),:);
                end
            end
            
            subject = eval(['DATA_SNU(c).DATA(SubIdx).Subject;']);

            % data
            data = eval(['DATA_SNU(c).DATA(SubIdx).Data;']);   % channels by time by trials           

            m = zeros(length(chans),length(t));
            b = 0;
            % Train model
            for tr = 1:14
                eeg = double(squeeze(data(chans,:,tr)))';                % time by channel
                att_stim = double(att_stim_cell{tr});      % 1 by time
                unatt_stim = double(unatt_stim_cell{tr});  % 1 by time

                for w = 1:46
                    tic          
                    Mov_eeg = eeg( (1+(Mov*(w-1))*srate) : (Width+(Mov*(w-1)))*srate,:);
                    Mov_att_stim = att_stim(1, (1+(Mov*(w-1))*fs) : (Width+(Mov*(w-1)))*fs)';

                    % rereference
                    for ch = 1:size(Mov_eeg,2)
                        re = mean(Mov_eeg(:,ch));
                        Mov_eeg(:,ch) = Mov_eeg(:,ch) - re;
                    end
                    % filter
%                         EEG(l) = pop_eegfiltnew(EEG(l),0.5,25);
                    Mov_eeg = filtfilt(design, Mov_eeg);
%                     Mov_eeg = filtfilt(filterweights, 1, Mov_eeg); % time_pnts by chans
                    % downsample
                    Mov_eeg = resample(Mov_eeg,fs,125);
                    % zscore
                    Mov_eeg = zscore(Mov_eeg);            

                    model = mTRFtrain(Mov_att_stim, Mov_eeg, fs, Dir, tmin, tmax, lambda, 'verbose', 0);
                    wcount(w) = toc;
                    m = m + model.w;
                    b = b + model.b;
                end
                eval(['tcount_',condition{c},'_ChN{ChN,SubIdx,tr} = {wcount};'])
            end      

            disp([condition{c} '_ChN',num2str(ChN),'_Subject' num2str(SubIdx) ' Train end!']);
            %%%%%%%%%%%%%%%%%%%%%%%
            % Averaging Decoder model
            model.w = m/(46*14);
            model.b = b/(46*14);

            % Test model
            for tr = 15:size(data,3)        
                eeg = double(squeeze(data(chans,:,tr)))';  % time by channel
                att_stim = double(att_stim_cell{tr});      % 1 by time
                unatt_stim = double(unatt_stim_cell{tr});  % 1 by time        

                for w = 1:46
                    tic
                    Mov_eeg = eeg( (1+(Mov*(w-1))*srate) : (Width+(Mov*(w-1)))*srate,:);
                    Mov_att_stim = att_stim(1, (1+(Mov*(w-1))*fs) : (Width+(Mov*(w-1)))*fs)';
                    Mov_unatt_stim = unatt_stim(1, (1+(Mov*(w-1))*fs) : (Width+(Mov*(w-1)))*fs)';

                    % average reference
                    for ch = 1:size(Mov_eeg,2)
                        re = mean(Mov_eeg(:,ch));
                        Mov_eeg(:,ch) = Mov_eeg(:,ch) - re;
                    end
                    % filtering
                    Mov_eeg = filtfilt(design, Mov_eeg);
%                     Mov_eeg = filtfilt(filterweights, 1, Mov_eeg); % time_pnts by chans
                    % downsample
                    Mov_eeg = resample(Mov_eeg,fs,125);
                    % zscore
                    Mov_eeg = zscore(Mov_eeg); 

                    [predict_att, stats_att] = mTRFpredict(Mov_att_stim, Mov_eeg, model, 'verbose', 0);
                    [predict_unatt, stats_unatt] = mTRFpredict(Mov_unatt_stim, Mov_eeg, model, 'verbose', 0);

                    if stats_att.r > stats_unatt.r
                        acc(w) = 1;
                    else acc(w) = 0; end

                    wcount(w) = toc;
                end     % end 46 windows
                eval(['tcount_',condition{c},'_ChN{ChN,SubIdx,tr} = {wcount};'])
                AccTrial(tr-14) = mean(acc);
            end

            eval(['Ave_Acc_',condition{c},'_ChN(SubIdx,ChN) = mean(AccTrial)*100;'])

            disp([condition{c} '_ChN' num2str(ChN) '_Subject' num2str(SubIdx) ' finished!'])    
        end
    end
end

%% online simulation - only AAF

fs = [32, 64, 125];
Dir    = -1;
tmin    = 0;                       % min time-lag(ms)
tmax    = 250;                     % max time-lag(ms)
lambda = 10;

Mov = 1;
Width = 15;

% experiment condition
condition = {'AAF'};

% filter
design = designfilt('bandpassfir', 'FilterOrder',624, ...       % 125 =624 / 1000 = 4999
    'CutoffFrequency1', 0.5, 'CutoffFrequency2', 8,...
    'SampleRate', 125);
% fvtool(design);

% load speech
% load(['C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\pL01\AAK_left.mat']);  % trial by 60s*64
% load(['C:\Users\LeeJiWon\Desktop\hykist\AAD\OnlineAAD\Recording data\AAF\pL01\AAK_right.mat']);
% SPEECH = [AAK_left; AAK_right];

srate = 125; % eval(['DATA_SNU(1).DATA(1).srate;']);
tcount_AAF = [];

for f = 1:length(fs)
    tminIdx = floor(tmin/1000*fs(f));     % tmin2idx
    tmaxIdx = ceil(tmax/1000*fs(f));      % tmax2idx
    timeLag = length(tminIdx:tmaxIdx); % time-lag points between tmin and tmax
    t       = sort( 1 * ( linspace(tmin, tmax, timeLag) ) );
    % speech data
    hill = [];
    hil=[];
    for tr = 1:length(SPEECH)           
        hil(tr,:) = SPEECH(tr,:);
        hill(tr,:) = resample(hil(tr,:), fs(f), 125);
        hill(tr,:) = zscore(hill(tr,:));
        if tr < 31
            att_stim_cell{tr} = hill(tr,:);     % 1 by trials cell - 1 by time
        else
            unatt_stim_cell{tr-30} = hill(tr,:);   % 1 by trials cell - 1 by time
        end       
    end

    % for each subject
    for SubIdx = 1:length(DATA_SNU(c).DATA)

        subject = eval(['DATA_SNU(c).DATA(SubIdx).Subject;']);

        % data
        data = eval(['DATA_SNU(c).DATA(SubIdx).Data;']);   % channels by time by trials           

        m = zeros(size(data,2),length(t));
        b = 0;
        % Train model
        for tr = 1:14
            eeg = double(squeeze(data(:,:,tr)));                % time by channel
            att_stim = double(att_stim_cell{tr});      % 1 by time
            unatt_stim = double(unatt_stim_cell{tr});  % 1 by time

            for w = 1:46
                tic          
                Mov_eeg = eeg( (1+(Mov*(w-1))*srate) : (Width+(Mov*(w-1)))*srate,:);
                Mov_att_stim = att_stim(1, (1+(Mov*(w-1))*fs(f)) : (Width+(Mov*(w-1)))*fs(f))';

                % rereference
                for ch = 1:size(Mov_eeg,2)
                    re = mean(Mov_eeg(:,ch));
                    Mov_eeg(:,ch) = Mov_eeg(:,ch) - re;
                end
                % filter
%                         EEG(l) = pop_eegfiltnew(EEG(l),0.5,25);
                Mov_eeg = filtfilt(design, Mov_eeg);
%                     Mov_eeg = filtfilt(filterweights, 1, Mov_eeg); % time_pnts by chans
                % downsample
                Mov_eeg = resample(Mov_eeg,fs(f),srate);
                % zscore
                Mov_eeg = zscore(Mov_eeg);            

                model = mTRFtrain(Mov_att_stim, Mov_eeg, fs(f), Dir, tmin, tmax, lambda, 'verbose', 0);
                wcount(w) = toc;
                m = m + model.w;
                b = b + model.b;
            end
            eval(['tcount_',condition{c},'28{f,SubIdx,tr} = {wcount};'])
        end      

        disp([condition{c} '_fs' num2str(fs(f)) '_Subject' num2str(SubIdx) ' Train end!']);
        %%%%%%%%%%%%%%%%%%%%%%%
        % Averaging Decoder model
        model.w = m/(46*14);
        model.b = b/(46*14);

        % Test model
        for tr = 15:size(data,3)        
            eeg = double(squeeze(data(:,:,tr)));                % time by channel
            att_stim = double(att_stim_cell{tr});      % 1 by time
            unatt_stim = double(unatt_stim_cell{tr});  % 1 by time        

            for w = 1:46
                tic
                Mov_eeg = eeg( (1+(Mov*(w-1))*srate) : (Width+(Mov*(w-1)))*srate,:);
                Mov_att_stim = att_stim(1, (1+(Mov*(w-1))*fs(f)) : (Width+(Mov*(w-1)))*fs(f))';
                Mov_unatt_stim = unatt_stim(1, (1+(Mov*(w-1))*fs(f)) : (Width+(Mov*(w-1)))*fs(f))';

                % average reference
                for ch = 1:size(Mov_eeg,2)
                    re = mean(Mov_eeg(:,ch));
                    Mov_eeg(:,ch) = Mov_eeg(:,ch) - re;
                end
                % filtering
                Mov_eeg = filtfilt(design, Mov_eeg);
%                     Mov_eeg = filtfilt(filterweights, 1, Mov_eeg); % time_pnts by chans
                % downsample
                Mov_eeg = resample(Mov_eeg,fs(f),125);
                % zscore
                Mov_eeg = zscore(Mov_eeg); 

                [predict_att, stats_att] = mTRFpredict(Mov_att_stim, Mov_eeg, model, 'verbose', 0);
                [predict_unatt, stats_unatt] = mTRFpredict(Mov_unatt_stim, Mov_eeg, model, 'verbose', 0);

                if stats_att.r > stats_unatt.r
                    acc(w) = 1;
                else acc(w) = 0; end

                wcount(w) = toc;
            end     % end 46 windows
            eval(['tcount_',condition{c},'{f,SubIdx,tr} = {wcount};'])
            AccTrial(tr-14) = mean(acc);
        end
        eval(['Indi_Acc_',condition{c},'{SubIdx} = AccTrial*100;'])
        eval(['Ave_Acc_',condition{c},'(SubIdx,f) = mean(AccTrial)*100;'])

        disp([condition{c} '_fs' num2str(fs(f)) '_Subject' num2str(SubIdx) ' finished!'])    
    end
end


%% Gathering data - sampling rate
% sampling rate
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\AveAcc_3fs_AAK.mat')
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\AveAcc_3fs_AADC.mat')
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\AveAcc_3fs_AAF.mat')
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\time_count_3fs_AAK.mat')
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\time_count_3fs_AADC.mat')
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\timecount_AAF_32,64,125fs.mat')

%------------------ sr
% time count set
for sub = 1:10
    for tr = 1:30
        for fs = 1:3
            temp = tcount_AADC{fs,sub,tr};
            w_aadc(fs,sub,tr) = mean(temp{1});
            temp2 = tcount_AAK{fs,sub,tr};
            w_aak(fs,sub,tr) = mean(temp2{1}); 
        end
    end
end
for sub = 1:6
    for fs = 1:3
        w_aaf = time_count{sub,fs};
        Tic_AAF(fs,sub) = mean(mean(w_aaf));
    end
end

Tic_AAK = squeeze(mean(w_aak,3));
Tic_AADC = squeeze(mean(w_aadc,3));

% plotting
Ave_Acc = [Ave_Acc_AAK; Ave_Acc_AADC; Ave_Acc_AAF*100];   % Subject by 32/64/125 Hz
Ave_Acc_std= std(Ave_Acc);
Tic = [Tic_AAK, Tic_AADC, Tic_AAF]';
Tic_std = std(Tic);

figure(1)
clf
plot(Tic(:,1), Ave_Acc(:,1), 'or', 'MarkerFaceColor', 'r'); hold on
plot(Tic(:,2), Ave_Acc(:,2), 'ob', 'MarkerFaceColor', 'b'); 
plot(Tic(:,3), Ave_Acc(:,3), 'og', 'MarkerFaceColor', 'g'); 
legend('fs 32', 'fs 64', 'fs 125', 'AutoUpdate','off','location','southeast')
plot(mean(Tic(:,1)), mean(Ave_Acc(:,1)), 'pr', 'LineWidth', 3)
plot(mean(Tic(:,2)), mean(Ave_Acc(:,2)), 'pb', 'LineWidth', 3)
plot(mean(Tic(:,3)), mean(Ave_Acc(:,3)), 'pg', 'LineWidth', 3);
xlabel('Time (sec)')
ylabel('Decoder accuracy (%)')

%% Gathering data - channels
% channel - AAF 아직 없구나
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\AveAcc_ChN_AAK.mat')
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\AveAcc_ChN_AADC.mat')
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\accuracy_60,16,15ChN.mat')
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\time_count_ChN_AAK.mat')
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\time_count_ChN_AADC.mat')
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\timecount_60,16,15ChN.mat')

for sub = 1:6
    for ch = 1:3
        temp = accuracy(sub,ch);
        Ave_Acc_AAF_ChN(sub,ch) = temp{1};
    end
end

Ave_Acc_AAK_ChN = [Ave_Acc_AAK(:,2), Ave_Acc_AAK_ChN];
Ave_Acc_AADC_ChN = [Ave_Acc_AADC(:,2), Ave_Acc_AADC_ChN];

% time count set
for sub = 1:10
    for tr = 1:30
        for fs = 1:2
            temp = tcount_AADC_ChN{fs,sub,tr};
            w_aadc_chn(fs,sub,tr) = mean(temp{1});
            temp2 = tcount_AAK_ChN{fs,sub,tr};
            w_aak_chn(fs,sub,tr) = mean(temp2{1}); 
        end
    end
end
for sub = 1:6
    for fs = 1:3
        w_aaf = time_count{sub,fs};
        Tic_AAF_ChN(fs,sub) = mean(mean(w_aaf));
    end
end

Tic_AAK_ChN = [squeeze(mean(w_aak_chn,3)); Tic_AAK(2,:)];
Tic_AADC_ChN = [squeeze(mean(w_aadc_chn,3)); Tic_AADC(2,:)];

%------------- chn
Ave_Acc_ChN = [Ave_Acc_AAK_ChN; Ave_Acc_AADC_ChN; Ave_Acc_AAF_ChN*100];   % Subject by 32/64/125 Hz
Ave_Acc_std= std(Ave_Acc_ChN);
Tic = [Tic_AAK_ChN, Tic_AADC_ChN, Tic_AAF_ChN]';
Tic_std = std(Tic);

figure(2)
clf
plot(Tic(:,1), Ave_Acc_ChN(:,1), 'or', 'MarkerFaceColor', 'r'); hold on
plot(Tic(:,2), Ave_Acc_ChN(:,2), 'ob', 'MarkerFaceColor', 'b'); 
plot(Tic(:,3), Ave_Acc_ChN(:,3), 'og', 'MarkerFaceColor', 'g'); 
legend('ChN 60', 'ChN 16', 'ChN 15', 'AutoUpdate','off','location','southeast')
plot(mean(Tic(:,1)), mean(Ave_Acc_ChN(:,1)), 'pr', 'LineWidth', 3)
plot(mean(Tic(:,2)), mean(Ave_Acc_ChN(:,2)), 'pb', 'LineWidth', 3)
plot(mean(Tic(:,3)), mean(Ave_Acc_ChN(:,3)), 'pg', 'LineWidth', 3);
xlabel('Time (sec)')
ylabel('Decoder accuracy (%)')
%% Wilcoxson

% x = Ave_Acc_ChN(:,1);
% y = Ave_Acc_ChN(:,2);
% x = tcount_chn(:,2);
% y = tcount_chn(:,3);
x = R_switch;
y = E_switch;

[p,h] = signrank(x,y)

%% trial 별 - 0.5-8 / 64Hz

for sub = 1:10
    for tr = 1:16
        Indi_Acc(sub,tr) = Indi_Acc_AAK{sub}(tr);
        Indi_Acc(sub+10,tr) = Indi_Acc_AADC{sub}(tr);
    end
end

first = Indi_Acc(:,1:12);
last = Indi_Acc(:,13:16);
X = categorical({'First 12 tr', 'Last 4 tr'});
X = reordercats(X,{'First 12 tr', 'Last 4 tr'});
figure(3)
clf
bar(X,[mean(mean(first,2)), mean(mean(last,2))])
ylim([50 85])

%% AAK + AADC + AAF 결과값
Ave_Acc_All = [Ave_Acc_AAK; Ave_Acc_AADC; Ave_Acc_AAF*100];
Ave_Acc = mean(Ave_Acc_All);

[p,h] = ttest2(Ave_Acc_All(:,2),Ave_Acc_All(:,3), 'Vartype', 'unequal')

for i = 1:6
    for j = 1:3
        Ave_Acc_AAF_ChN(i,j) = accuracy{i,j}*100;
    end
end









