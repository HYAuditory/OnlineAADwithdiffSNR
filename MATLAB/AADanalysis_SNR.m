%%
% Data analysis
clear
clc
% load
subject = '0629_lji';
dir = 'L';
oir = 'R';

load('C:\Users\LeeJiWon\Desktop\hykist\AAD\Speech\2022\2022_Speech\Allsource_snr.mat');
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Accuracy_'+string(subject)+'.mat');  % total accuracy / Acc
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Accuracy_MCL_'+string(subject)+'.mat');  % MCL accuracy / Acc_MCL
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Accuracy_20_'+string(subject)+'.mat');
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Accuracy_90_'+string(subject)+'.mat');
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Accuracy_SRT_'+string(subject)+'.mat');
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Corr_att_'+string(subject)+'.mat');
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Corr_unatt_'+string(subject)+'.mat');
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Behavior1_'+string(subject)+'.mat');
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Behavior2_'+string(subject)+'.mat');
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Self-report_'+string(subject)+'.mat');
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Resptime_'+string(subject)+'.mat');
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\RAW_'+string(subject)+'.mat');
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\AUX_'+string(subject)+'.mat');
% 해당 trial 넘버의 condition
trials_mcl = [15,22,24,27,33,35,39,44];
trials_20 = [17,20,25,28,32,38,42];
trials_90 = [16,19,23,30,34,37,40];
trials_srt = [18,21,26,29,31,36,41,43];
condition = {'mcl', '20', '90', 'srt'};
%% Decoder Accuracy

% Bar plot
% for each condition
X = categorical({'All','MCL','MCL-20', 'SI90', 'SRT'});
X = reordercats(X,{'All','MCL','MCL-20', 'SI90', 'SRT'});
Y = [mean(Acc),mean(Acc_MCL), mean(Acc_20), mean(Acc_90), mean(Acc_SRT)];

figure(1)
b = bar(X, Y, 'FaceColor', 'flat');  hold on
b.CData(2,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.9290 0.6940 0.1250];
b.CData(5,:) = [0.4940 0.1840 0.5560];
b.CData(1,:) = [0.4660 0.6740 0.1880];
plot(X, Y, '--ok');
grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
% refline([0, chance]);
title('Accuracy - Conditions')


% Left & Right

Acc_R = [];
Acc_L = [];
for i = 1:4
    eval(['Acc_R_',condition{i},'=[];']);
    eval(['Acc_L_',condition{i},'=[];']);
end
    
for i = 1:length(Acc)
    
    j = i+14
    
    if Allsource_snr(i).dir2 == 1 % dir
        eval(['Acc_', dir,' = [Acc_',dir,', Acc(i)];']);
        
        if length(find(trials_mcl == j)) == 1;
            eval(['Acc_',dir,'_mcl = [Acc_',dir,'_mcl, Acc(i)];'])
        elseif length(find(trials_20 == j)) == 1;
            eval(['Acc_',dir,'_20 = [Acc_',dir,'_20, Acc(i)];'])
        elseif length(find(trials_90 == j)) == 1;
            eval(['Acc_',dir,'_90 = [Acc_',dir,'_90, Acc(i)];'])
        elseif length(find(trials_srt == j)) == 1;
            eval(['Acc_',dir,'_srt = [Acc_',dir,'_srt, Acc(i)];'])
        end
        
    else
        eval(['Acc_', oir, ' = [Acc_',oir,', Acc(i)];']);
        
        if length(find(trials_mcl == j)) == 1;
            eval(['Acc_',oir,'_mcl = [Acc_',oir,'_mcl, Acc(i)];'])
        elseif length(find(trials_20 == j)) == 1;
            eval(['Acc_',oir,'_20 = [Acc_',oir,'_20, Acc(i)];'])
        elseif length(find(trials_90 == j)) == 1;
            eval(['Acc_',oir,'_90 = [Acc_',oir,'_90, Acc(i)];'])
        elseif length(find(trials_srt == j)) == 1;
            eval(['Acc_',oir,'_srt = [Acc_',oir,'_srt, Acc(i)];'])
        end
    end
end

% Bar plot
% for each direction
X = categorical({'All','Left','Right'});
X = reordercats(X,{'All','Left','Right'});
YLR = [mean(Acc),mean(Acc_L), mean(Acc_R)];

figure(3)
b = bar(X, YLR, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410]
b.CData(3,:) = [0.8500 0.3250 0.0980]
b.CData(2,:) = [0.9290 0.6940 0.1250]
plot(X, YLR, '--ok');
grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
% refline([0, chance]);
title('Accuracy - Direction')

% direction for conditoin
figure(4)
X = categorical({'MCL','MCL-20', 'SI90', 'SRT'});
X = reordercats(X,{'MCL','MCL-20', 'SI90', 'SRT'});
YL = [mean(Acc_L_mcl), mean(Acc_L_20), mean(Acc_L_90), mean(Acc_L_srt)];
YR = [mean(Acc_R_mcl), mean(Acc_R_20), mean(Acc_R_90), mean(Acc_R_srt)];
plot(X, YL, '-ob','LineWidth', 1); hold on
plot(X, YR, '-or','LineWidth', 1); 
legend('Left', 'Right')
set(gcf, 'color', 'white')
xlabel('Conditions');
ylabel('Decoder Accuracy (%)');
ylim([0 100])
grid on


% Temporal
figure(5)
%plot(Acc, '-ok'); hold on
plot(Acc_MCL, '-ob','LineWidth', 1); hold on
plot(Acc_20, '-or','LineWidth', 1);
plot(Acc_90, '-og','LineWidth', 1);
plot(Acc_SRT, '-oc','LineWidth', 1);
grid on
legend('MCL', 'MCL-20', 'SI90', 'SRT')
title(['Accuracy - Trials']);
xlabel('Trial number');
ylabel('Decoder Accuracy (%)');
ylim([0 100])
set(gcf, 'color', 'white')


%% Correlation analysis
y1 = -0.1;
y2 = 0.1;

for i = 1:4
    eval(['corr_att_',condition{i},'=[];']);
    eval(['corr_utt_',condition{i},'=[];']);
end  
    
% condition 별 correlation - attended/unattended
for i=1:30
    corrM_att(i) = mean(corr_att(i,:));
    corrM_unatt(i) = mean(corr_unatt(i,:));
    
    j = i+14;
    if length(find(trials_mcl == j)) == 1;
        corr_att_mcl = [corr_att_mcl, corrM_att(i)];
        corr_utt_mcl = [corr_utt_mcl, corrM_unatt(i)];
    elseif length(find(trials_20 == j)) == 1;
        corr_att_20 = [corr_att_20, corrM_att(i)];
        corr_utt_20 = [corr_utt_20, corrM_unatt(i)];
    elseif length(find(trials_90 == j)) == 1;
        corr_att_90 = [corr_att_90, corrM_att(i)];
        corr_utt_90 = [corr_utt_90, corrM_unatt(i)];
    elseif length(find(trials_srt == j)) == 1;
        corr_att_srt = [corr_att_srt, corrM_att(i)];
        corr_utt_srt = [corr_utt_srt, corrM_unatt(i)];
    end
end

figure(8)
X = categorical({'MCL','MCL-20', 'SI90', 'SRT'});
X = reordercats(X,{'MCL','MCL-20', 'SI90', 'SRT'});
Y = [mean(corr_att_mcl), mean(corr_att_20), mean(corr_att_90), mean(corr_att_srt)];
b = bar(X, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410]
b.CData(3,:) = [0.8500 0.3250 0.0980]
b.CData(4,:) = [0.4940 0.1840 0.5560];
b.CData(2,:) = [0.9290 0.6940 0.1250]; grid on
set(gcf, 'color', 'white')
ylim([y1 y2])
ylabel('Correlation coefficient')
xlabel('Conditions')
% refline([0, chance]);
title('Attended Correlation value - Conditions ')

figure(9)
X = categorical({'MCL','MCL-20', 'SI90', 'SRT'});
X = reordercats(X,{'MCL','MCL-20', 'SI90', 'SRT'});
Y = [mean(corr_utt_mcl), mean(corr_utt_20), mean(corr_utt_90), mean(corr_utt_srt)];
b = bar(X, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410]
b.CData(3,:) = [0.8500 0.3250 0.0980]
b.CData(4,:) = [0.4940 0.1840 0.5560];
b.CData(2,:) = [0.9290 0.6940 0.1250]; grid on
set(gcf, 'color', 'white')
ylim([y1 y2])
ylabel('Correlation coefficient')
xlabel('Conditions')
% refline([0, chance]);
title('Unattended Correlation value - Conditions ')


% attended corr 와 srt 만 unattened corr
figure(10)
X = categorical({'MCL','MCL-20', 'SI90', 'SRT'});
X = reordercats(X,{'MCL','MCL-20', 'SI90', 'SRT'});
Ya = [mean(corr_att_mcl), mean(corr_att_20), mean(corr_att_90), mean(corr_att_srt)];
Yu = [mean(corr_utt_mcl), mean(corr_utt_20), mean(corr_utt_90), mean(corr_utt_srt)];
ba = bar(X, Ya, 'FaceColor', 'flat');  hold on
bu = bar(X, Yu, 'FaceColor', 'flat','FaceAlpha',0.5);
ba.CData(1,:) = [0 0.4470 0.7410]
ba.CData(3,:) = [0.8500 0.3250 0.0980]
ba.CData(4,:) = [0.4940 0.1840 0.5560];
ba.CData(2,:) = [0.9290 0.6940 0.1250]; 
bu.CData(1,:) = [0 0.4470 0.7410]
bu.CData(3,:) = [0.8500 0.3250 0.0980]
bu.CData(4,:) = [0.4940 0.1840 0.5560];
bu.CData(2,:) = [0.9290 0.6940 0.1250]; 
grid on
set(gcf, 'color', 'white')
ylim([y1 y2])
ylabel('Correlation coefficient')
xlabel('Conditions')
% refline([0, chance]);
title('Both Correlation value - Conditions ')

% attended corr 와 unattened corr 동시
% figure(11)
% X = categorical({'MCL','MCL-20', 'SI90', 'SRT'});
% X = reordercats(X,{'MCL','MCL-20', 'SI90', 'SRT'});
% Y = [mean(corr_att_mcl), mean(corr_att_20), mean(corr_att_90), mean(corr_utt_srt)];
% b = bar(X, Y, 'FaceColor', 'flat');  hold on
% b.CData(1,:) = [0 0.4470 0.7410]
% b.CData(3,:) = [0.8500 0.3250 0.0980]
% b.CData(4,:) = [0.4940 0.1840 0.5560];
% b.CData(2,:) = [0.9290 0.6940 0.1250]; grid on
% set(gcf, 'color', 'white')
% ylim([-0.1 0.1])
% ylabel('Correlation coefficient')
% xlabel('Conditions')
% % refline([0, chance]);
% title('Mix Correlation value - Conditions ')

% % 
% corr_att_srt_tr =[];
% corr_utt_srt_tr =[];
% corr_att_20_tr =[];
% corr_utt_20_tr =[];
% for i=1:7
%     j = trials_srt(i);
%     q = trials_20(i);
%     corr_att_srt_tr = [corr_att_srt_tr;corr_att(j-14,:)];
%     corr_utt_srt_tr = [corr_utt_srt_tr;corr_unatt(j-14,:)];
%     corr_att_20_tr = [corr_att_20_tr;corr_att(q-14,:)];
%     corr_utt_20_tr = [corr_utt_20_tr;corr_unatt(q-14,:)];
% end
% srt_crrat = mean(corr_att_srt_tr,1);
% srt_crrut = mean(corr_utt_srt_tr,1);
% e0_crrat = mean(corr_att_20_tr,1);
% e0_crrut = mean(corr_utt_20_tr,1);
% figure(12)
% subplot(4,1,1)
% plot(corr_att(9,:), '-ob','LineWidth',2,'MarkerSize',5); hold on
% plot(corr_unatt(9,:), '-or', 'LineWidth',2,'MarkerSize',5); grid on
% subplot(4,1,2)
% plot(corr_att(10,:), '-ob','LineWidth',2,'MarkerSize',5); hold on
% plot(corr_unatt(10,:), '-or', 'LineWidth',2,'MarkerSize',5); grid on
% subplot(4,1,3)
% plot(corr_att(11,:), '-ob','LineWidth',2,'MarkerSize',5); hold on
% plot(corr_unatt(11,:), '-or', 'LineWidth',2,'MarkerSize',5); grid on
% subplot(4,1,4)
% plot(corr_att(12,:), '-ob','LineWidth',2,'MarkerSize',5); hold on
% plot(corr_unatt(12,:), '-or', 'LineWidth',2,'MarkerSize',5); grid on
% % plot(srt_crrat, '-ob','LineWidth',2,'MarkerSize',5); hold on
% % plot(srt_crrut, '-or','LineWidth',2,'MarkerSize',5); grid on
% set(gcf, 'color', 'white')
% ylabel('Correlation coefficient')
% xlabel('Time (s)')
% ylim([y1 y2])
% legend({'attended', 'unattended'})
% title('SRT')


% Attended Correlation boxplots
figure(17)
boxplot([corr_att_mcl(1:end-1)', corr_att_20', corr_att_90', corr_att_srt(1:end-1)'],{'MCL','MCL-20', 'SI90', 'SRT'}); grid on
ylabel(['Mean Correlation'])
xlabel(['Conditions'])
ylim([-0.2 0.2])
title(['Attended Correlation-Condition'])

% Unattended Correlation boxplots
figure(18)
boxplot([corr_utt_mcl(1:end-1)', corr_utt_20', corr_utt_90', corr_utt_srt(1:end-1)'],{'MCL','MCL-20', 'SI90', 'SRT'}); grid on
ylabel(['Mean Correlation'])
xlabel(['Conditions'])
ylim([-0.2 0.2])
title(['Unttended Correlation-Condition'])

%% Self-Report
for i = 1:length(condition)
    eval(['self_',condition{i},' = [];']);
end

% condition 별 report
for i = 1:30
    
    j = i+14;
    if length(find(trials_mcl == j)) == 1;
        self_mcl = [self_mcl,str2num(Self_answer(i))];
    elseif length(find(trials_20 == j)) == 1;
        self_20 = [self_20, str2num(Self_answer(i))];
    elseif length(find(trials_90 == j)) == 1;
        self_90 = [self_90, str2num(Self_answer(i))];
    elseif length(find(trials_srt == j)) == 1;
        self_srt = [self_srt, str2num(Self_answer(i))];
    end
end

% condtion-self report bar
figure(6)
X = categorical({'MCL','MCL-20', 'SI90', 'SRT'});
X = reordercats(X,{'MCL','MCL-20', 'SI90', 'SRT'});
Y = [mean(self_mcl), mean(self_20), mean(self_90), mean(self_srt)];
b = bar(X, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410]
b.CData(3,:) = [0.8500 0.3250 0.0980]
b.CData(4,:) = [0.4940 0.1840 0.5560];
b.CData(2,:) = [0.9290 0.6940 0.1250]; grid on
set(gcf, 'color', 'white')
ylim([0 5])
ylabel('Self-Report')
xlabel('Conditions')
% refline([0, chance]);
title('Self-Report - Conditions')

% self report 별 accuracy
for i = 1:5
    eval(['Acc_',num2str(i),'=[];']);
end
    
for i = 1:length(Acc)
    
    if str2num(Self_answer(i)) == 1
        Acc_1 = [Acc_1, Acc(i)];
    elseif str2num(Self_answer(i)) == 2
        Acc_2 = [Acc_2, Acc(i)];
    elseif str2num(Self_answer(i)) == 3
        Acc_3 = [Acc_3, Acc(i)];
    elseif str2num(Self_answer(i)) == 4
        Acc_4 = [Acc_4, Acc(i)];
    elseif str2num(Self_answer(i)) == 5
        Acc_5 = [Acc_5, Acc(i)];
    end
end

figure(7)
X = categorical({'1','2', '3', '4', '5'});
X = reordercats(X,{'1','2', '3', '4', '5'});
Y = [mean(Acc_1), mean(Acc_2), mean(Acc_3), mean(Acc_4), mean(Acc_5)];
b = bar(X, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410]
b.CData(3,:) = [0.8500 0.3250 0.0980]
b.CData(4,:) = [0.4940 0.1840 0.5560];
b.CData(2,:) = [0.9290 0.6940 0.1250]; grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
xlabel('Self-Report')
% refline([0, chance]);
title('Accuracy - Self-Report')

%% Behavior test
% Part 1
beh_at = Behavior_1(:,3:4);
beh_un = Behavior_1(:,1:2);

correct_at = find(beh_at=='T');
correct_un = find(beh_un=='T');

accb_at = (length(correct_at)/(length(beh_at)*2))*100;
accb_un = (length(correct_un)/(length(beh_at)*2))*100;  

X = categorical({'Attended','Unattended'});
Y = [accb_at, accb_un];

figure(13)
b = bar(X, Y);
grid on
ylim([0 100])
ylabel('Accuracy(%)')
set(gcf, 'color', 'white')
title('Behavior Result\_1')

% Part 2
beh_at2 = Behavior_2(:,1:2);
beh_un2 = Behavior_2(:,3:4);
correct_at2 = find(beh_at2=='T');
correct_un2 = find(beh_un2=='T');

accb_at2 = (length(correct_at2)/(length(beh_at2)*2))*100;
accb_un2 = (length(correct_un2)/(length(beh_at2)*2))*100;  

X = categorical({'Attended','Unattended'});
Y = [accb_at2, accb_un2];

figure(14)
b = bar(X, Y);
grid on
ylim([0 100])
ylabel('Accuracy(%)')
set(gcf, 'color', 'white')
title('Behavior Result\_2')

% condition 별 part 2 값
for i = 1:length(condition)
    eval(['correct_at_',condition{i},'=[];']);
    eval(['correct_ut_',condition{i},'=[];']);
end
for i = 1:30
    
    j = i+14;
    if length(find(trials_mcl == j)) == 1;
        correct_at_mcl = [correct_at_mcl,find(beh_at2(i,1)=='T')];
        correct_at_mcl = [correct_at_mcl,find(beh_at2(i,2)=='T')];
        correct_ut_mcl = [correct_ut_mcl,find(beh_un2(i,1)=='T')];
        correct_ut_mcl = [correct_ut_mcl,find(beh_un2(i,2)=='T')];
    elseif length(find(trials_20 == j)) == 1;
        correct_at_20 = [correct_at_20,find(beh_at2(i,1)=='T')];
        correct_ut_20 = [correct_ut_20,find(beh_un2(i,1)=='T')];
        correct_at_20 = [correct_at_20,find(beh_at2(i,2)=='T')];
        correct_ut_20 = [correct_ut_20,find(beh_un2(i,2)=='T')];
    elseif length(find(trials_90 == j)) == 1;
        correct_at_90 = [correct_at_90,find(beh_at2(i,1)=='T')];
        correct_ut_90 = [correct_ut_90,find(beh_un2(i,1)=='T')];
        correct_at_90 = [correct_at_90,find(beh_at2(i,2)=='T')];
        correct_ut_90 = [correct_ut_90,find(beh_un2(i,2)=='T')];
    elseif length(find(trials_srt == j)) == 1;
        correct_at_srt = [correct_at_srt,find(beh_at2(i,1)=='T')];
        correct_ut_srt = [correct_ut_srt,find(beh_un2(i,1)=='T')];
        correct_at_srt = [correct_at_srt,find(beh_at2(i,2)=='T')];
        correct_ut_srt = [correct_ut_srt,find(beh_un2(i,2)=='T')];
    end
end

for i = 1:length(condition)
    eval(['beh_att_', condition{i},' = length(correct_at_',condition{i},')/(length(trials_',condition{i},')*2)*100;'])
    eval(['beh_utt_', condition{i},' = length(correct_ut_',condition{i},')/(length(trials_',condition{i},')*2)*100;'])
end

figure(15)
X = categorical({'All','MCL','MCL-20', 'SI90', 'SRT'});
X = reordercats(X,{'All', 'MCL','MCL-20', 'SI90', 'SRT'});
Y = [accb_at2, beh_att_mcl, beh_att_20, beh_att_90, beh_att_srt];
b = bar(X, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.4940 0.1840 0.5560];
b.CData(2,:) = [0.9290 0.6940 0.1250]; grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Accuracy (%)')
xlabel('Conditions')
% refline([0, chance]);
title('Behavior 2 Att - Conditions')

% condition 별 utt beh acc
figure(18)
X = categorical({'All','MCL','MCL-20', 'SI90', 'SRT'});
X = reordercats(X,{'All','MCL','MCL-20', 'SI90', 'SRT'});
Y = [accb_un2, beh_utt_mcl, beh_utt_20, beh_utt_90, beh_utt_srt];
b = bar(X, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.4940 0.1840 0.5560];
b.CData(2,:) = [0.9290 0.6940 0.1250]; grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Accuracy (%)')
xlabel('Conditions')
% refline([0, chance]);
title('Behavior 2 Utt - Conditions')

%% Response time
% condition 별 response time
for i = 1:length(condition)
    eval(['respt_att_',condition{i},'=[];']);
    eval(['respt_utt_',condition{i},'=[];']);
end
for i = 1:30
    
    j = i+14;
    if length(find(trials_mcl == j)) == 1;
        respt_att_mcl = squeeze([respt_att_mcl,[Resp_time(i,1,1),Resp_time(i,1,2)]]);
        respt_utt_mcl = squeeze([respt_utt_mcl,[Resp_time(i,1,3),Resp_time(i,1,4)]]);
    elseif length(find(trials_20 == j)) == 1;
        respt_att_20 = squeeze([respt_att_20,[Resp_time(i,1,1),Resp_time(i,1,2)]]);
        respt_utt_20 = squeeze([respt_utt_20,[Resp_time(i,1,3),Resp_time(i,1,4)]]);
    elseif length(find(trials_90 == j)) == 1;
        respt_att_90 = squeeze([respt_att_90,[Resp_time(i,1,1),Resp_time(i,1,2)]]);
        respt_utt_90 = squeeze([respt_utt_90,[Resp_time(i,1,3),Resp_time(i,1,4)]]);
    elseif length(find(trials_srt == j)) == 1;
        respt_att_srt = squeeze([respt_att_srt,[Resp_time(i,1,1),Resp_time(i,1,2)]]);
        respt_utt_srt = squeeze([respt_utt_srt,[Resp_time(i,1,3),Resp_time(i,1,4)]]);
    end
end

for i = 1:length(condition)
    eval(['Mrespt_att_',condition{i},'= mean(mean(respt_att_',condition{i},'));']);
    eval(['Mrespt_utt_',condition{i},'= mean(mean(respt_utt_',condition{i},'));']);
end

% condition 별 response time
% figure(18)
% X = categorical({'MCL','MCL-20', 'SI90', 'SRT'});
% X = reordercats(X,{'MCL','MCL-20', 'SI90', 'SRT'});
% Y = [Mrespt_att, beh_utt_20, beh_utt_90, beh_utt_srt];
% b = bar(X, Y, 'FaceColor', 'flat');  hold on
% b.CData(1,:) = [0 0.4470 0.7410];
% b.CData(3,:) = [0.8500 0.3250 0.0980];
% b.CData(4,:) = [0.4940 0.1840 0.5560];
% b.CData(2,:) = [0.9290 0.6940 0.1250]; grid on
% set(gcf, 'color', 'white')
% ylim([0 100])
% ylabel('Accuracy (%)')
% xlabel('Conditions')
% % refline([0, chance]);
% title('Behavior 2 Utt - Conditions')

figure(19)
boxplot([respt_att_mcl(1:end-2)', respt_att_20', respt_att_90', respt_att_srt(1:end-2)'],...
        {'MCL','MCL-20', 'SI90', 'SRT'}); grid on
ylabel(['Response time (s)'])
ylim([0, 25])
title(['Response time - Att'])
set(gcf, 'color', 'white'); 

figure(20)
boxplot([respt_utt_mcl(1:end-2)', respt_utt_20', respt_utt_90', respt_utt_srt(1:end-2)'],...
        {'MCL','MCL-20', 'SI90', 'SRT'}); grid on
ylabel(['Response time (s)'])
ylim([0, 25])
title(['Response time - Utt'])
set(gcf, 'color', 'white'); 


%% Volume difference

H_L = [16,18,21,25,26,28,29,36,40,41,43];        %12  /16,18,21,25,26,28,29,34,36,40,41,43
L_H = [17,19,20,22,24,27,30,35,37,39,42,44];  %14  /17,19,20,22,24,27,30,32,33,35,37,39,42,44
high_low = [];
low_high = [];
for i = 1:30
    
    j = i+14;
    if length(find(H_L == j)) == 1;
        high_low = [high_low, Acc(i)];
    elseif length(find(L_H == j)) == 1;
        low_high = [low_high, Acc(i)];
    end
end
            
figure(16)
X = categorical({'All','high-low','low-high'});
X = reordercats(X,{'All','high-low','low-high'});
Y = [mean(Acc), mean(high_low), mean(low_high)];
b = bar(X, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410];
b.CData(2,:) = [0.9290 0.6940 0.1250]; grid 
b.CData(3,:) = [0.8500 0.3250 0.0980];
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Accuracy (%)')
xlabel('Volume difference')
% refline([0, chance]);
title('Volume difference')

%% Individual time lags
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\data\SAT_envelope.mat');  % sound env
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\data\AAK_envelope.mat'); 
srate = 125;
fs = 64;
Dir = -1;
dur    = 60;
lambda = 10;

% Time-lag (tau) params
tmin    = 0;                       % min time-lag(ms)
tminIdx = floor(tmin/1000*fs);     % tmin2idx
tmax    = 250;                     % max time-lag(ms)
tmaxIdx = ceil(tmax/1000*fs);      % tmax2idx
timeLag = length(tminIdx:tmaxIdx); % time-lag points between tmin and tmax
t       = sort( 1 * ( linspace(tmin, tmax, timeLag) ) );

% searching onset 
temp = diff(AUX(2,:));
start = find(temp > 0)+1;
start = [1, start];
try
    for i = length(start):-1:1

        if abs(start(i)-start(i-1)) == 1

            start(i)=[];
        end
    end
end

% preprocessing
EEG = {};
for j = 1:length(start)
    eeg = RAW(:,(start(j)+(srate*3)):(start(j)+(srate*63))-1); 
    
    % rereference
    for ch = 1:16
        m = mean(eeg(ch,:));
        eeg(ch,:) = eeg(ch,:) - m;
    end

    % filter
    design = designfilt('bandpassfir', 'FilterOrder',601, ...
        'CutoffFrequency1', 0.5, 'CutoffFrequency2', 8,...
        'SampleRate', 125);

    eeg = filtfilt(design, eeg');

    % downsample
    eeg = resample(eeg,64,srate);

    % zscore
    eeg = zscore(eeg);

    EEG{j} = eeg;
 
end
att_env={};
utt_env={};
for i = 1:44
    if i < 15
        att_env{i} = Allspeech_JT(i,:);
        utt_env{i} = Allspeech_JT(i+30,:);
    else              
        att_env{i} = Allspeech_SAT(i-14,:);
        utt_env{i} = Allspeech_SAT(i+16,:);
    end 
end

% individual time-lags
SubIdx = 1;
for ti = 1:length(t)
    % Attention Decoding
    [stats,stats1,stats2,~] = mTRFattncrossval(att_env, utt_env, EEG, ...
        fs, Dir, t(ti), t(ti), lambda, 'verbose', 0);

    Accs(SubIdx,ti,1)   = stats.acc;
    Rs_AAD(SubIdx,ti,1) = mean(stats1.r);
    Rs_AAD(SubIdx,ti,2) = mean(stats2.r);
    Sub_AAD_w{SubIdx, ti} = mean(stats.d, 2);

    % Unattention Decoding
    [stats,stats1,stats2,~] = mTRFattncrossval(utt_env, att_env, EEG, ...
        fs, Dir, t(ti), t(ti), lambda, 'verbose', 0);

    Accs(SubIdx,ti,2)   = stats.acc;
    Rs_AUD(SubIdx,ti,1) = mean(stats1.r);
    Rs_AUD(SubIdx,ti,2) = mean(stats2.r);
    Sub_AUD_w{SubIdx, ti} = mean(stats.d, 2); 

end % end time-lag

Nchans  = 16; % Number of Channels
Ave_AAD_w = zeros( Nchans+1, ti);
Ave_AUD_w = zeros( Nchans+1, ti);

for i = 1:ti
    
    Ave_AAD_w(:,i) = mean(cat(2, Sub_AAD_w{:,i}), 2);
    Ave_AUD_w(:,i) = mean(cat(2, Sub_AUD_w{:,i}), 2);
    
end

%% Topography of the decoder weghts averaged over all subjects

chanlocs = readlocs('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Matlab\Standard-10-20-Cap19.locs');
chanlocs([1 2 18 19]) = [];
Chanloc_ob = [chanlocs(3), chanlocs(8), chanlocs(7), chanlocs(9), chanlocs(11), chanlocs(15), chanlocs(13), chanlocs(1), chanlocs(5), ...
                    chanlocs(2), chanlocs(4), chanlocs(6), chanlocs(10), chanlocs(12), chanlocs(14)];
           
for i = 1:ti
    figure(i)
    set(gcf, 'color', 'w')
    subplot(121)
    topoplot(Ave_AAD_w(3:end,i),  Chanloc_ob);
    subplot(122)
    topoplot(Ave_AUD_w(3:end,i),  Chanloc_ob);
    
    sgtitle(t(i));
end

%% All Subjects data
load('Pilot_result.mat');
%Pilot_result = struct();
i=4;

Pilot_result(i).Subject = string(subject);
Pilot_result(i).Dir = dir;
Pilot_result(i).All_Acc = mean(Acc);
Pilot_result(i).MCL_Acc = mean(Acc_MCL);
Pilot_result(i).MCL20_Acc = mean(Acc_20);
Pilot_result(i).SI90_Acc = mean(Acc_90);
Pilot_result(i).SRT_Acc = mean(Acc_SRT);
Pilot_result(i).Right_Acc = mean(Acc_R);
Pilot_result(i).Left_Acc = mean(Acc_L);
Pilot_result(i).Self_MCL = mean(self_mcl);
Pilot_result(i).Self_20 = mean(self_20);
Pilot_result(i).Self_90 = mean(self_90);
Pilot_result(i).Self_SRT = mean(self_srt);
Pilot_result(i).Self1_Acc = mean(Acc_1);
Pilot_result(i).Self2_Acc = mean(Acc_2);
Pilot_result(i).Self3_Acc = mean(Acc_3);
Pilot_result(i).Self4_Acc = mean(Acc_4);
Pilot_result(i).Self5_Acc = mean(Acc_5);
Pilot_result(i).Corratt = corr_att;
Pilot_result(i).Corratt_MCL = corr_att_mcl;
Pilot_result(i).Corratt_20 = corr_att_20;
Pilot_result(i).Corratt_90 = corr_att_90;
Pilot_result(i).Corratt_SRT = corr_att_srt;
Pilot_result(i).Corrutt = corr_unatt;
Pilot_result(i).Corrutt_MCL = corr_utt_mcl;
Pilot_result(i).Corrutt_20 = corr_utt_20;
Pilot_result(i).Corrutt_90 = corr_utt_90;
Pilot_result(i).Corrutt_SRT = corr_utt_srt;
Pilot_result(i).Behavior_att = accb_at;
Pilot_result(i).Behaviro_utt = accb_un;
Pilot_result(i).Behavior2_att = accb_at2;
Pilot_result(i).Behaviro2_utt = accb_un2;
Pilot_result(i).Behaviro2_att_MCL = beh_att_mcl;
Pilot_result(i).Behaviro2_att_20 = beh_att_20;
Pilot_result(i).Behaviro2_att_90 = beh_att_90;
Pilot_result(i).Behaviro2_att_SRT = beh_att_srt;
Pilot_result(i).Behaviro2_utt_MCL = beh_utt_mcl;
Pilot_result(i).Behaviro2_utt_20 = beh_utt_20;
Pilot_result(i).Behaviro2_utt_90 = beh_utt_90;
Pilot_result(i).Behaviro2_utt_SRT = beh_utt_srt;

%save('Pilot_result.mat', 'Pilot_result');

%% All Subject results

load('Pilot_result.mat');

Corr_att = [];
Corr_utt = [];
for i = 1:4
    
    Acc(i) = Pilot_result(i).All_Acc;
    Acc_MCL(i) = Pilot_result(i).MCL_Acc;
    Acc_20(i) = Pilot_result(i).MCL20_Acc;
    Acc_90(i) = Pilot_result(i).SI90_Acc;
    Acc_SRT(i) = Pilot_result(i).SRT_Acc;
    
    Acc_1(i) = Pilot_result(i).Self1_Acc;
    Acc_2(i) = Pilot_result(i).Self2_Acc;
    Acc_3(i) = Pilot_result(i).Self3_Acc;
    Acc_4(i) = Pilot_result(i).Self4_Acc;
    Acc_5(i) = Pilot_result(i).Self5_Acc;
   
%     Corr_att = [Corr_att; Pilot_result(i).Corratt];
%     Corr_utt = [Corr_utt; Pilot_result(i).Corrutt];
    if i > 1
        Beh_att(i-1) = Pilot_result(i).Behavior2_att;
        Beh_utt(i-1) = Pilot_result(i).Behaviro2_utt;
        beh_att_mcl(i-1) = Pilot_result(i).Behaviro2_att_MCL;
        beh_att_20(i-1) = Pilot_result(i).Behaviro2_att_20;
        beh_att_90(i-1) = Pilot_result(i).Behaviro2_att_90;
        beh_att_srt(i-1) = Pilot_result(i).Behaviro2_att_SRT;
        beh_utt_mcl(i-1) = Pilot_result(i).Behaviro2_utt_MCL;
        beh_utt_20(i-1) = Pilot_result(i).Behaviro2_utt_20;
        beh_utt_90(i-1) = Pilot_result(i).Behaviro2_utt_90;
        beh_utt_srt(i-1) = Pilot_result(i).Behaviro2_utt_SRT; end
end

All_Acc = mean(Acc);
All_Acc_20 = mean(Acc_20);
All_Acc_90 = mean(Acc_90);
All_Acc_SRT = mean(Acc_SRT);
All_Acc_MCL = mean(Acc_MCL);

All_Acc_1 = mean(Acc_1);
All_Acc_2 = mean(Acc_2);
All_Acc_3 = mean(Acc_3);
All_Acc_4 = mean(Acc_4);
All_Acc_5 = mean(Acc_5);

All_behatt = mean(Beh_att);
All_behatt_mcl = mean(beh_att_mcl);
All_behatt_20 = mean(beh_att_20);
All_behatt_90 = mean(beh_att_90);
All_behatt_srt = mean(beh_att_srt);
All_behutt = mean(Beh_utt);
All_behutt_mcl = mean(beh_utt_mcl);
All_behutt_20 = mean(beh_utt_20);
All_behutt_90 = mean(beh_utt_90);
All_behutt_srt = mean(beh_utt_srt);

% Bar plot
% for each direction
X = categorical({'All','MCL','MCL-20', 'SI90', 'SRT'});
X = reordercats(X,{'All','MCL','MCL-20', 'SI90', 'SRT'});
Y = [All_Acc, All_Acc_MCL, All_Acc_20, All_Acc_90, All_Acc_SRT];

figure(21)
b = bar(X, Y, 'FaceColor', 'flat');  hold on
b.CData(2,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.9290 0.6940 0.1250];
b.CData(5,:) = [0.4940 0.1840 0.5560];
b.CData(1,:) = [0.4660 0.6740 0.1880];
plot(X, Y, '--ok');
grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
% refline([0, chance]);
title('Accuracy - Condition for All subjects')


% Bar plot
% for each direction
X = categorical({'All','MCL','MCL-20', 'SI90', 'SRT'});
X = reordercats(X,{'All','MCL','MCL-20', 'SI90', 'SRT'});
Y = [All_behutt, All_behutt_mcl, All_behutt_20, All_behutt_90, All_behutt_srt];
figure(21)
b = bar(X, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410]
b.CData(3,:) = [0.8500 0.3250 0.0980]
b.CData(2,:) = [0.9290 0.6940 0.1250]
b.CData(4,:) = [0.4940 0.1840 0.5560];
plot(X, Y, '--ok');
grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
% refline([0, chance]);
title('Behavior2\_utt - Condition for All subjects')


% Bar plot
% for each direction
X = categorical({'1','2','3', '4', '5'});
X = reordercats(X,{'1','2','3', '4', '5'});
Y = [All_Acc_1, All_Acc_2, All_Acc_3, All_Acc_4, Acc_5(2)];

figure(22)
b = bar(X, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410]
b.CData(3,:) = [0.8500 0.3250 0.0980]
b.CData(2,:) = [0.9290 0.6940 0.1250]
b.CData(4,:) = [0.4940 0.1840 0.5560];
plot(X, Y, '--ok');
grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
% refline([0, chance]);
title('Accuracy - Self-Report for All subjects')

%
figure(23)
boxplot([Corr_att, Corr_utt],...
        {'MCL','MCL-20'}); grid on
ylabel(['Response time (s)'])
ylim([0, 25])
title(['Response time - Utt'])
set(gcf, 'color', 'white'); 

%
X = categorical({'All','MCL','MCL-20', 'SI90', 'SRT'});
X = reordercats(X,{'All','MCL','MCL-20', 'SI90', 'SRT'});
for i = 1:4
    Y = [Acc(i), Acc_MCL(i), Acc_20(i), Acc_90(i), Acc_SRT(i)];
    plot(X, Y, '--o', 'LineWidth', 2); hold on
end
grid on
legend('Sub1', 'Sub2', 'Sub3', 'Sub4')
title(['Accuracy - Trials']);
xlabel('Conditions');
ylabel('Decoder Accuracy (%)');
ylim([0 100])
set(gcf, 'color', 'white')
    
    
    
    