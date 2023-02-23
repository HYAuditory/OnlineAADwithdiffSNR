%%
% Data analysis
clear
clc
% load
subject = '0928_kms';
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
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\MCL_' + string(subject) + '.mat');        % MCL
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\SNRofSI50_' + string(subject) + '_all.mat');  % SRT
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\SNRofSI90_all_' + string(subject) + '.mat');  % SI90

dB20 = MCL-20;
SI90 = SNRofSI90.M;
SRT = SNRofSI50.M;

% 해당 trial 넘버의 condition
% trials_mcl = [15,22,24,27,33,35,39,44];
% trials_20 = [17,20,25,28,32,38,42];
% trials_90 = [16,19,23,30,34,37,40];
% trials_srt = [18,21,26,29,31,36,41,43];

trials_mcl = [15,22,24,27,33,38,42];
trials_20 = [17,20,25,28,32,36,41];
trials_90 = [16,19,23,30,34,37,40];
trials_srt = [18,21,26,29,31,35,39];
condition = {'mcl', '20', '90', 'srt'};
list = {'MCL', '20', '90', 'SRT'};
%% Decoder Accuracy
% Bar plot
% for each condition
Xa = categorical({'All','MCL','MCL-20', 'SI90', 'SRT'});
Xa = reordercats(Xa,{'All','MCL','MCL-20', 'SI90', 'SRT'});
Mean_Acc = mean(Acc);
for j = 1:length(list)
    eval(['Mean_Acc_',list{j},' = mean(Acc_',list{j},');']);
end
Y = [Mean_Acc, Mean_Acc_MCL, Mean_Acc_20, Mean_Acc_90, Mean_Acc_SRT];

figure(1)
clf
b = bar(Xa, Y, 'FaceColor', 'flat');  hold on
b.CData(2,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.9290 0.6940 0.1250];
b.CData(5,:) = [0.4940 0.1840 0.5560];
b.CData(1,:) = [0.4660 0.6740 0.1880];
plot(Xa, Y, '--ok');
grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
%refline([0, chance]);
title('Accuracy - Conditions')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Accuracy_Condtions.jpg')

% Left & Right

Acc_R = [];
Acc_L = [];
for i = 1:4
    eval(['Acc_R_',condition{i},'=[];']);
    eval(['Acc_L_',condition{i},'=[];']);
end
    
for i = 1:length(Acc)
    
    j = i+14;
    
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
Mean_Acc_L = mean(Acc_L);
Mean_Acc_R = mean(Acc_R);
YLR = [Mean_Acc, Mean_Acc_L, Mean_Acc_R];

figure(3)
clf
b = bar(X, YLR, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980]
b.CData(2,:) = [0.9290 0.6940 0.1250]
plot(X, YLR, '--ok');
grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
% refline([0, chance]);
title('Accuracy - Direction')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Accuracy_Direction.jpg')

% direction for conditoin
figure(4)
clf
Xc = categorical({'MCL','MCL-20', 'SI90', 'SRT'});
Xc = reordercats(Xc,{'MCL','MCL-20', 'SI90', 'SRT'});

for j = 1:length(list)
    eval(['Mean_Acc_L_',list{j},' = mean(Acc_L_',condition{j},');']);
    eval(['Mean_Acc_R_',list{j},' = mean(Acc_R_',condition{j},');']);
end

YL = [Mean_Acc_L_MCL, Mean_Acc_L_20, Mean_Acc_L_90, Mean_Acc_L_SRT];
YR = [Mean_Acc_R_MCL, Mean_Acc_R_20, Mean_Acc_R_90, Mean_Acc_R_SRT];
plot(Xc, YL, '-ob','LineWidth', 1); hold on
plot(Xc, YR, '-or','LineWidth', 1); 
legend('Left', 'Right')
set(gcf, 'color', 'white')
xlabel('Conditions');
ylabel('Decoder Accuracy (%)');
ylim([0 100])
grid on
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Accuracy_Direction_Condition.jpg')

% Temporal
figure(5)
clf
%plot(Acc, '-ok'); hold on
plot(Acc_MCL, '-ob','LineWidth', 1); hold on
plot(Acc_20, '-or','LineWidth', 1);
plot(Acc_90, '-og','LineWidth', 1);
plot(Acc_SRT, '-oc','LineWidth', 1);
grid on
legend('MCL', 'MCL-20', 'SI90', 'SRT','Location','southeast')
title(['Accuracy - Trials']);
xlabel('Trial number');
ylabel('Decoder Accuracy (%)');
ylim([0 100])
set(gcf, 'color', 'white')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Accuracy_Condtions_Trials.jpg')

%% Correlation analysis
y1 = -0.1;
y2 = 0.1;

for i = 1:4
    eval(['corr_att_',list{i},'=[];']);
    eval(['corr_utt_',list{i},'=[];']);
end  
    
% condition 별 correlation - attended/unattended
for i=1:length(Acc)
    corrM_att(i) = mean(corr_att(i,:));
    corrM_unatt(i) = mean(corr_unatt(i,:));
    
    j = i+14;
    if length(find(trials_mcl == j)) == 1;
        corr_att_MCL = [corr_att_MCL, corrM_att(i)];
        corr_utt_MCL = [corr_utt_MCL, corrM_unatt(i)];
    elseif length(find(trials_20 == j)) == 1;
        corr_att_20 = [corr_att_20, corrM_att(i)];
        corr_utt_20 = [corr_utt_20, corrM_unatt(i)];
    elseif length(find(trials_90 == j)) == 1;
        corr_att_90 = [corr_att_90, corrM_att(i)];
        corr_utt_90 = [corr_utt_90, corrM_unatt(i)];
    elseif length(find(trials_srt == j)) == 1;
        corr_att_SRT = [corr_att_SRT, corrM_att(i)];
        corr_utt_SRT = [corr_utt_SRT, corrM_unatt(i)];
    end
end

figure(8)
Xc = categorical({'MCL','MCL-20', 'SI90', 'SRT'});
Xc = reordercats(Xc,{'MCL','MCL-20', 'SI90', 'SRT'});
Y = [mean(corr_att_MCL), mean(corr_att_20), mean(corr_att_90), mean(corr_att_SRT)];
b = bar(Xc, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410]
b.CData(2,:) = [0.8500 0.3250 0.0980]
b.CData(4,:) = [0.4940 0.1840 0.5560];
b.CData(3,:) = [0.9290 0.6940 0.1250]; grid on
set(gcf, 'color', 'white')
ylim([y1 y2])
ylabel('Correlation coefficient')
xlabel('Conditions')
% refline([0, chance]);
title('Attended Correlation value - Conditions ')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Correlation_Att_Condition.jpg')

figure(9)
Y = [mean(corr_utt_MCL), mean(corr_utt_20), mean(corr_utt_90), mean(corr_utt_SRT)];
b = bar(Xc, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410]
b.CData(2,:) = [0.8500 0.3250 0.0980]
b.CData(4,:) = [0.4940 0.1840 0.5560];
b.CData(3,:) = [0.9290 0.6940 0.1250]; grid on
set(gcf, 'color', 'white')
ylim([y1 y2])
ylabel('Correlation coefficient')
xlabel('Conditions')
% refline([0, chance]);
title('Unattended Correlation value - Conditions ')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Correlation_Utt_Condition.jpg')

% % Attended Correlation boxplots
% figure(17)
% boxplot([corr_att_MCL', corr_att_20', corr_att_90', corr_att_SRT'],{'MCL','MCL-20', 'SI90', 'SRT'}); grid on
% ylabel(['Mean Correlation'])
% xlabel(['Conditions'])
% ylim([-0.2 0.2])
% title(['Attended Correlation-Condition'])
% saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Correlation_Att_Condition_box.jpg')
% 
% % Unattended Correlation boxplots
% figure(18)
% boxplot([corr_utt_MCL', corr_utt_20', corr_utt_90', corr_utt_SRT'],{'MCL','MCL-20', 'SI90', 'SRT'}); grid on
% ylabel(['Mean Correlation'])
% xlabel(['Conditions'])
% ylim([-0.2 0.2])
% title(['Unttended Correlation-Condition'])
% saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Correlation_Utt_Condition_box.jpg')

%% Self-Report
for i = 1:length(condition)
    eval(['self_',condition{i},' = [];']);
end
% condition 별 report
for i = 1:length(Acc);
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

% all factor

% condtion-self report bar
figure(6)
Xc = categorical({'MCL','MCL-20', 'SI90', 'SRT'});
Xc = reordercats(Xc,{'MCL','MCL-20', 'SI90', 'SRT'});
for j = 1:length(condition)
    eval(['Mean_self_',condition{j},' = mean(self_',condition{j},');']);
end
Y = [Mean_self_mcl, Mean_self_20, Mean_self_90, Mean_self_srt];
b = bar(Xc, Y, 'FaceColor', 'flat');  hold on
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
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Self_Condition.jpg')

% self report 별 accuracy
for i = 1:5
    eval(['Acc_',num2str(i),'=[];']);
end
    self_all = [];
for i = 1:length(Acc)
    
    if str2num(Self_answer(i)) == 1
        Acc_1 = [Acc_1, Acc(i)];
        self_all = [self_all, double(5)];
    elseif str2num(Self_answer(i)) == 2
        Acc_2 = [Acc_2, Acc(i)];
        self_all = [self_all, double(4)];
    elseif str2num(Self_answer(i)) == 3
        Acc_3 = [Acc_3, Acc(i)];
        self_all = [self_all, double(2)];
    elseif str2num(Self_answer(i)) == 4
        Acc_4 = [Acc_4, Acc(i)];
        self_all = [self_all, double(2)];
    elseif str2num(Self_answer(i)) == 5
        Acc_5 = [Acc_5, Acc(i)];
        self_all = [self_all, double(1)];
    end
end

figure(7)
Xn = categorical({'1','2', '3', '4', '5'});
Xn = reordercats(Xn,{'1','2', '3', '4', '5'});
for z = 1:5
    eval(['Mean_Acc_'+string(z)+' = mean(Acc_'+string(z)+');']);
end
Y = [Mean_Acc_1, Mean_Acc_2, Mean_Acc_3, Mean_Acc_4, Mean_Acc_5];
b = bar(Xn, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(2,:) = [0.9290 0.6940 0.1250];
b.CData(4,:) = [0.4940 0.1840 0.5560];
b.CData(5,:) = [0.4660 0.6740 0.1880]; grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
xlabel('Self-Report')
% refline([0, chance]);
title('Accuracy - Self-Report')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Self_Accuracy.jpg')
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
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Behavior1.jpg')

% Part 2
beh_at2 = Behavior_2(:,1:2);
beh_un2 = Behavior_2(:,3:4);
correct_at2 = find(beh_at2=='T');
correct_un2 = find(beh_un2=='T');

accb_at2 = (length(correct_at2)/(length(beh_at2)*2))*100;
accb_un2 = (length(correct_un2)/(length(beh_at2)*2))*100;  

% X = categorical({'Attended','Unattended'});
% Y = [accb_at2, accb_un2];
% figure(14)
% b = bar(X, Y);
% grid on
% ylim([0 100])
% ylabel('Accuracy(%)')
% set(gcf, 'color', 'white')
% title('Behavior Result\_2')
% saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Behavior2.jpg')

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
Xa = categorical({'All','MCL','MCL-20', 'SI90', 'SRT'});
Xa = reordercats(Xa,{'All', 'MCL','MCL-20', 'SI90', 'SRT'});
Y = [accb_at2, beh_att_mcl, beh_att_20, beh_att_90, beh_att_srt];
b = bar(Xa, Y, 'FaceColor', 'flat');  hold on
b.CData(2,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.9290 0.6940 0.1250];
b.CData(5,:) = [0.4940 0.1840 0.5560];
b.CData(1,:) = [0.4660 0.6740 0.1880]; grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Accuracy (%)')
xlabel('Conditions')
% refline([0, chance]);
title('Behavior 2 Att - Conditions')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Behavior2_Att_Condition.jpg')

% condition 별 utt beh acc
figure(18)
Y = [accb_un2, beh_utt_mcl, beh_utt_20, beh_utt_90, beh_utt_srt];
b = bar(Xa, Y, 'FaceColor', 'flat');  hold on
b.CData(2,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.9290 0.6940 0.1250];
b.CData(5,:) = [0.4940 0.1840 0.5560];
b.CData(1,:) = [0.4660 0.6740 0.1880]; grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Accuracy (%)')
xlabel('Conditions')
% refline([0, chance]);
title('Behavior 2 Utt - Conditions')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Behavior2_Utt_Condition.jpg')

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
boxplot([respt_att_mcl', respt_att_20', respt_att_90', respt_att_srt'],...
        {'MCL','MCL-20', 'SI90', 'SRT'}); grid on
ylabel(['Response time (s)'])
ylim([0, 25])
title(['Response time - Att'])
set(gcf, 'color', 'white'); 
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Resptime_Att.jpg')

figure(20)
boxplot([respt_utt_mcl', respt_utt_20', respt_utt_90', respt_utt_srt'],...
        {'MCL','MCL-20', 'SI90', 'SRT'}); grid on
ylabel(['Response time (s)'])
ylim([0, 25])
title(['Response time - Utt'])
set(gcf, 'color', 'white'); 
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Resptime_Utt.jpg')

%% MCL&SRT

for i = 1:length(list)
    eval(['Sub_',list{i},'= [];'])
end
    
% load
for i = len
    Sub_MCL = [Sub_MCL, DATA_withSNR(i).MCL];
    Sub_20 = [Sub_20, DATA_withSNR(i).dB20];
    Sub_90 = [Sub_90, DATA_withSNR(i).SI90];
    Sub_SRT = [Sub_SRT, DATA_withSNR(i).SRT];
end
Sub_90_L = [-32.3,-32.3,-31.25,-34.7,-38.85,-38.6,-30.5];
Sub_90_R = [-26.6,-27.8,-23.45,-30.5,-33.95,-37.7,-29.3];
Sub_SRT_L = [-35.84,-34.9,-34.41,-40.54,-40.81,-45.09,-34.21];
Sub_SRT_R = [-32.19,-34.34,-35.23,-35.99,-38.33,-40.81,-34.79];

mean_MCL = mean(Sub_MCL);
mean_MCL_std = std(double(Sub_MCL));
mean_90 = mean(Sub_90);
mean_90_std = std(double(Sub_90));
mean_SRT = mean(Sub_SRT);
mean_SRT_std = std(double(Sub_SRT));

% plot
figure(22)
b=bar(Xc, [mean(Sub_MCL),mean(Sub_20),mean(Sub_90), mean(Sub_SRT)], 'FaceColor', 'flat'); grid on
%set(gca,'color','white','Xtick', [], 'Ytick', [-50 -40 -30 0 40 60 70]);
set(gcf, 'color','white')
b.CData(1,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.4940 0.1840 0.5560];
b.CData(2,:) = [0.9290 0.6940 0.1250];
%legend('MCL', 'MCL-20dB', 'SI90%', 'SRT')
%yline(52, '--', 'lineWidth', 1);
ylim([-50 80])

%% Gathering results

load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\DATA_withSNR.mat');
%DATA_withSNR = struct;

sub = length(DATA_withSNR)+1;

DATA_withSNR(sub).subject = subject;
DATA_withSNR(sub).MCL = MCL;
DATA_withSNR(sub).dB20 = dB20;
DATA_withSNR(sub).SI90 = SI90;
DATA_withSNR(sub).SRT = SRT;
DATA_withSNR(sub).All_Acc = Mean_Acc;

for j = 1:length(list)
    eval(['DATA_withSNR(sub).Acc_',list{j},' = Mean_Acc_',list{j},';']);
end

DATA_withSNR(sub).Acc_L = Mean_Acc_L;
for j = 1:length(list)
    eval(['DATA_withSNR(sub).Acc_L_',list{j},' = Mean_Acc_L_',list{j},';']);
end

DATA_withSNR(sub).Acc_R = Mean_Acc_R;
for j = 1:length(list)
    eval(['DATA_withSNR(sub).Acc_R_',list{j},' = Mean_Acc_R_',list{j},';']);
    eval(['DATA_withSNR(sub).Self_',list{j},' = Mean_self_',condition{j},';']); 
end

for j = 1:5
    eval(['DATA_withSNR(sub).Acc_'+string(j)+' = Mean_Acc_'+string(j)+';']);
end

DATA_withSNR(sub).Behavior1_att = accb_at;
DATA_withSNR(sub).Behavior1_utt = accb_un;
DATA_withSNR(sub).Behavior2_att = accb_at2;
DATA_withSNR(sub).Behavior2_utt = accb_un2;
for j = 1:length(list)
    eval(['DATA_withSNR(sub).Behavior2_att_',list{j},' = beh_att_',condition{j},';']);
    eval(['DATA_withSNR(sub).Behavior2_utt_',list{j},' = beh_utt_',condition{j},';']);
end

% correlation
DATA_withSNR(sub).Corr_att = corr_att;
DATA_withSNR(sub).Corr_Utt = corr_unatt;

for j = 1:length(list)
    eval(['DATA_withSNR(sub).all_acc_',list{j},'= Acc_',list{j},';']);end

DATA_withSNR(sub).all_acc_L = Acc_L;
DATA_withSNR(sub).all_acc_R = Acc_R;
for i = 1:5
    eval(['DATA_withSNR(sub).all_acc_'+string(i)+'= Acc_'+string(i)+';']); end

DATA_withSNR(sub).Dir = dir;
DATA_withSNR(sub).self_all = self_all;
% save('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\DATA_withSNR.mat', 'DATA_withSNR');

%% all acc
list = {'mcl','20', '90','srt'};

for i = 1:length(list)
    eval(['load(''C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\all_acc_',list{i},'.mat'');']);end

% new data
all_acc_mcl = [all_acc_mcl; Acc_MCL];
all_acc_20 = [all_acc_20; Acc_20];
all_acc_90 = [all_acc_90; Acc_90];
all_acc_srt = [all_acc_srt; Acc_SRT];

for i = 1:length(list)
    eval(['save(''C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\all_acc_',list{i},'.mat'', ''all_acc_',list{i},''');']);end

%% Aeverage results across all subject
%load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\DATA_withSNR.mat');
% load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\DATA_withSNR.mat');
% 
trials_mcl = [15,22,24,27,33,38,42];
trials_20 = [17,20,25,28,32,36,41];
trials_90 = [16,19,23,30,34,37,40];
trials_srt = [18,21,26,29,31,35,39];
condition = {'mcl', '20', '90', 'srt'};
list = {'MCL', '20', '90', 'SRT'};

% len = [1,3,4,5,6,8,9,11,12,13,15,17,20,23]; % online good
len = [1,3,4,5,6,7,8,9,11,13,14,15,17,20,22,23]; % offline good - 전체에서

% len = [2,7,9,10,12,16,18,19,21,22]; % bad
% len = [1:length(DATA_withSNR)];

c = 1;
Sub_self_all = [];
for i = len
    % accuracy-condition
    Sub_Acc(c) = DATA_withSNR(i).All_Acc;

    % behavior test
    Sub_Beh1_att(c) = DATA_withSNR(i).Behavior1_att;
    Sub_Beh1_utt(c) = DATA_withSNR(i).Behavior1_utt;
    % behavior test2
    Sub_Beh2_att(c) = DATA_withSNR(i).Behavior2_att;
    Sub_Beh2_utt(c) = DATA_withSNR(i).Behavior2_utt;
    % self
    Sub_self_all = [Sub_self_all; DATA_withSNR(i).self_all];
    
   for j = 1:length(list)
    eval(['Sub_Acc_'+string(list(j))+'(c) = DATA_withSNR(i).Acc_'+string(list(j))]);
    eval(['Sub_Beh2_att_'+string(list(j))+'(c) = DATA_withSNR(i).Behavior2_att_'+string(list(j))]);
    eval(['Sub_Beh2_utt_'+string(list(j))+'(c) = DATA_withSNR(i).Behavior2_utt_'+string(list(j))]);
    eval(['Sub_Self_'+string(list(j))+'(c) = DATA_withSNR(i).Self_'+string(list(j))]);
   end 
   
   for z = 1:5
       eval(['Sub_Acc_'+string(z)+'(c) = DATA_withSNR(i).Acc_'+string(z)]);
   end
    c = c+1;
end

% mean
Ave_Acc = mean(Sub_Acc);
Ave_Beh1_att = mean(Sub_Beh1_att);
Ave_Beh1_utt = mean(Sub_Beh1_utt);
Ave_Beh2_att = mean(Sub_Beh2_att);
Ave_Beh2_utt = mean(Sub_Beh2_utt);

for j = 1:length(list)
    eval(['Ave_Acc_'+string(list(j))+' = mean(Sub_Acc_'+string(list(j))+');']);
    eval(['Ave_Beh2_att_'+string(list(j))+' =  mean(Sub_Beh2_att_'+string(list(j))+');']);
    eval(['Ave_Beh2_utt_'+string(list(j))+' =  mean(Sub_Beh2_utt_'+string(list(j))+');']);
    eval(['Ave_Self'+string(list(j))+' = mean(Sub_Self_'+string(list(j))+');']);
end 

for z = 1:5
   eval(['Ave_Acc_'+string(z)+' = nanmean(Sub_Acc_'+string(z)+');']);
end

%% Ave results plot

cond = 'rej9';
% cond = 'bad'

% acc-condi
Xa = categorical({'All','MCL','MCL-20', 'SI90', 'SRT'});
Xa = reordercats(Xa,{'All','MCL','MCL-20', 'SI90', 'SRT'});
Y = [Ave_Acc, Ave_Acc_MCL, Ave_Acc_20, Ave_Acc_90, Ave_Acc_SRT];
Ave_Acc_std = std(Sub_Acc);
for i = 1:length(list)
    eval(['Ave_Acc_',list{i},'_std = std(Sub_Acc_',list{i},');']);
end
all_std = [Ave_Acc_std, Ave_Acc_MCL_std, Ave_Acc_20_std, Ave_Acc_90_std, Ave_Acc_SRT_std];

figure(24)
clf
b = bar(Xa, Y, 'FaceColor', 'flat');  hold on
b.CData(2,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.9290 0.6940 0.1250];
b.CData(5,:) = [0.4940 0.1840 0.5560];
b.CData(1,:) = [0.4660 0.6740 0.1880];
grid on
er = errorbar(Xa,Y,-all_std,all_std);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1;  
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
% refline([0, chance]);
title('Ave - Accuracy - Conditions')
%plot(Xa, [Sub_Acc; Sub_Acc_MCL; Sub_Acc_20; Sub_Acc_90; Sub_Acc_SRT], '--ok');
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\Ave_Accuracy_Condtions_'+string(cond)+'.jpg')

% condi-self
Xc = categorical({'MCL','MCL-20dB', 'SI 90%', 'SI 50%'});
Xc = reordercats(Xc,{'MCL','MCL-20dB', 'SI 90%', 'SI 50%'});
Y = [Ave_SelfMCL, Ave_Self20, Ave_Self90, Ave_SelfSRT];
for i = 1:length(list)
    eval(['Ave_Self_',list{i},'_std = std(Sub_Self_',list{i},');']);
end
all_self_std = [Ave_Self_MCL_std, Ave_Self_20_std, Ave_Self_90_std, Ave_Self_SRT_std];

figure(25)
clf
b = bar(Xc, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410];
b.CData(2,:) = [0.8500 0.3250 0.0980];
b.CData(3,:) = [0.9290 0.6940 0.1250];
b.CData(4,:) = [0.4940 0.1840 0.5560];
grid on
er = errorbar(Xc,Y,-all_self_std,all_self_std);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1;  
set(gcf, 'color', 'white')
ylim([0 5])
ylabel('Self-Report')
% refline([0, chance]);
title('Ave - Self-report - Conditions')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\Ave_Self_Condtions_'+string(cond)+'.jpg')

% acc-self
Xn = categorical({'1','2','3', '4', '5'});
Xn = reordercats(Xn,{'1','2','3', '4', '5'});
Y = [Ave_Acc_1, Ave_Acc_2, Ave_Acc_3, Ave_Acc_4, Ave_Acc_5];
for i = 1:5
    eval(['Ave_Acc_'+string(i)+'_std = nanstd(Sub_Acc_'+string(i)+');']);
end
all_accn_std = [Ave_Acc_1_std, Ave_Acc_2_std, Ave_Acc_3_std, Ave_Acc_4_std, Ave_Acc_5_std];

figure(26)
clf
b = bar(Xn, Y, 'FaceColor', 'flat');  hold on
b.CData(2,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.9290 0.6940 0.1250];
b.CData(5,:) = [0.4940 0.1840 0.5560];
b.CData(1,:) = [0.4660 0.6740 0.1880];
grid on
er = errorbar(Xn,Y,-all_accn_std,all_accn_std);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1; 
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
% refline([0, chance]);
title('Ave - Accuracy - Self-report')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\Ave_Accuracy_Self_'+string(cond)+'.jpg')

% beh2-condi
% Y = [Ave_Beh2_att, Ave_Beh2_att_MCL, Ave_Beh2_att_20, Ave_Beh2_att_90, Ave_Beh2_att_SRT];
Y = [Ave_Beh2_att_MCL, Ave_Beh2_att_20, Ave_Beh2_att_90, Ave_Beh2_att_SRT];
Y2 = [Ave_Beh2_utt_MCL, Ave_Beh2_utt_20, Ave_Beh2_utt_90, Ave_Beh2_utt_SRT];
Ave_Beh2_std = std(Sub_Beh2_att);
for i = 1:length(list)
    eval(['Ave_Beh2_att_',list{i},'_std = std(Sub_Beh2_att_',list{i},');']);
    eval(['Ave_Beh2_utt_',list{i},'_std = std(Sub_Beh2_utt_',list{i},');']);
end
% all_beh2_std = [Ave_Beh2_std, Ave_Beh2_MCL_std, Ave_Beh2_20_std, Ave_Beh2_90_std, Ave_Beh2_SRT_std];
all_beh2_att_std = [Ave_Beh2_att_MCL_std, Ave_Beh2_att_20_std, Ave_Beh2_att_90_std, Ave_Beh2_att_SRT_std];
all_beh2_utt_std = [Ave_Beh2_utt_MCL_std, Ave_Beh2_utt_20_std, Ave_Beh2_utt_90_std, Ave_Beh2_utt_SRT_std];
figure(27)
clf
y = [Y; Y2]';
ngroups = size(y, 1);
nbars = size(y, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5)); 

b = bar([1,2,3,4], y, 'FaceColor', 'flat');  hold on
err = [all_beh2_att_std; all_beh2_utt_std]';
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    er = errorbar(x, y(:,i), err(:,i), '.');
    er.Color = [0 0 0];  
    er.LineStyle = 'none';  
    er.LineWidth = 1; 
end
% b.CData(1,:) = [0.4660 0.6740 0.1880];
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Accuracy (%)')
% plot(Xc, [Sub_Beh2_att_MCL;Sub_Beh2_att_20;Sub_Beh2_att_90;Sub_Beh2_att_SRT]', ':ok', 'lineWidth', 1, 'MarkerFaceColor' ,'w')
% yline(33.93, '--', 'lineWidth', 1); 
title('Ave - Behavior test 2_ Attended')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\Ave_Beh2_'+string(cond)+'.jpg')

% beh1-condi
X = categorical({'Attended','Unattended'});
X = reordercats(X,{'Attended','Unattended'});
Y = [Ave_Beh1_att, Ave_Beh1_utt];
Ave_Beh1_att_std = std(Sub_Beh1_att);
Ave_Beh1_utt_std = std(Sub_Beh1_utt);
all_beh1_std = [Ave_Beh1_att_std, Ave_Beh1_utt_std];

figure(28)
clf
b = bar(X, Y, 'FaceColor', 'flat');  hold on
b.CData(1,:) = [0 0.4470 0.7410];
b.CData(2,:) = [0.8500 0.3250 0.0980];
grid on
er = errorbar(X,Y,-all_beh1_std,all_beh1_std);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1; 
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Accuracy (%)')
% refline([0, chance]);
title('Ave - Behavior test 1')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\Ave_Beh1_'+string(cond)+'.jpg')

% Correlation
for i = 1:4
    eval(['Sub_Corr_att_',list{i},' = [];']);
    eval(['Sub_Corr_utt_',list{i},' = [];']);
    eval(['Sub_Corr_Matt_',list{i},' = [];']);
    eval(['Sub_Corr_Mutt_',list{i},' = [];']);
end  

for s = len %1:length(DATA_withSNR)
    corr_att = DATA_withSNR(s).Corr_att;
    corr_unatt = DATA_withSNR(s).Corr_Utt;
    
    for i = 1:4
        eval(['corr_att_',list{i},'=[];']);
        eval(['corr_utt_',list{i},'=[];']);
    end
    
    for i=1:28
        j = i+14;
        if length(find(trials_mcl == j)) == 1;
            corr_att_MCL = [corr_att_MCL; corr_att(i,:)];
            corr_utt_MCL = [corr_utt_MCL; corr_unatt(i,:)];
        elseif length(find(trials_20 == j)) == 1;
            corr_att_20 = [corr_att_20; corr_att(i,:)];
            corr_utt_20 = [corr_utt_20; corr_unatt(i,:)];
        elseif length(find(trials_90 == j)) == 1;
            corr_att_90 = [corr_att_90; corr_att(i,:)];
            corr_utt_90 = [corr_utt_90; corr_unatt(i,:)];
        elseif length(find(trials_srt == j)) == 1;
            corr_att_SRT = [corr_att_SRT; corr_att(i,:)];
            corr_utt_SRT = [corr_utt_SRT; corr_unatt(i,:)];
        end
    end
     
    for z = 1:length(list) 
        eval(['Sub_Corr_Matt_',list{z},' = [Sub_Corr_Matt_',list{z},' , mean(corr_att_',list{z},',2)];']);  % trial by subject
        eval(['Sub_Corr_Mutt_',list{z},' = [Sub_Corr_Mutt_',list{z},' , mean(corr_utt_',list{z},',2)];']);
        
        eval(['Sub_Corr_att_',list{z},'{s} = corr_att_',list{z},';']);
        eval(['Sub_Corr_utt_',list{z},'{s} = corr_utt_',list{z},';']);
    end
end

for z = 1:length(list) 
    eval(['Ave_Corr_att_',list{z},'= mean(Sub_Corr_Matt_',list{z},',2);']);
    eval(['Ave_Corr_utt_',list{z},'= mean(Sub_Corr_Mutt_',list{z},',2);']);
end

% 함께
AU = categorical({'Att','Unatt'});
AU = reordercats(AU,{'Att','Unatt'});
dd = {'MCL', 'MCL-20dB', 'SI 90%', 'SI 50%'};

figure(32)
clf
for i = 1:4
    subplot(1,4,i)
    h = boxplot(eval(['[Ave_Corr_att_',list{i},', Ave_Corr_utt_',list{i},']']),AU, 'color','br'); 
    if i == 1
        ylabel('Mean correlation', 'FontSize', 15); end
    set(h,{'linew'},{1.5})
    title(dd{i},'FontSize', 15)   
    ylim([-0.05 0.1])
    set(gca,'linew',1)
end
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\Ave_Corr_'+string(cond)+'.jpg')
%supylabel('Mean Correlation')
%sgtitle('Att & Unatt Correlation - Condition', 'FontSize', 20)

%% Wilcoxon signed rank test 
% x = Sub_Acc_MCL;
% y = Sub_Acc_SRT;

x = mean(Sub_Corr_Matt_MCL,1);
y = mean(Sub_Corr_Matt_20,1);

[p,h] = signrank(x,y)

%% Diff - acc
%=================================================
%----------------- Acc unatt speech 와의 SPL 차이 값.
diffSPL = [];
Acc_cond_diff = [];
Indi_diff_SI90 = [];
Indi_diff_SRT = [];
sublabel = [];
self_cond_diff = [];
diffSPL_self = [];

% len = [1,3,4,5,6,8,11,12,13,15,17,20,23];
label = 'rej7';
for s = len
    for r = 1:7
        diffSPL = [diffSPL, 0];
        sublabel = [sublabel, s];end
    for r = 1:7
        diffSPL = [diffSPL, -20];
        sublabel = [sublabel, s];end
    for r = 1:7
        diffSPL = [diffSPL, double(DATA_withSNR(s).SI90)];
        Indi_diff_SI90 = [Indi_diff_SI90, double(DATA_withSNR(s).SI90)];
        sublabel = [sublabel, s];end
    for r = 1:7
        diffSPL = [diffSPL, double(DATA_withSNR(s).SRT)];
        Indi_diff_SRT = [Indi_diff_SRT, double(DATA_withSNR(s).SRT)];
        sublabel = [sublabel, s];end
    Acc_cond_diff = [Acc_cond_diff, all_acc_mcl(s,:)];
    Acc_cond_diff = [Acc_cond_diff, all_acc_20(s,:)];
    Acc_cond_diff = [Acc_cond_diff, all_acc_90(s,:)];
    Acc_cond_diff = [Acc_cond_diff, all_acc_srt(s,:)];
    diffSPL_self = [diffSPL_self,0];
    diffSPL_self = [diffSPL_self,-20];
    diffSPL_self = [diffSPL_self,double(DATA_withSNR(s).SI90)];
    diffSPL_self = [diffSPL_self,double(DATA_withSNR(s).SRT)];
    self_cond_diff = [self_cond_diff, DATA_withSNR(s).Self_MCL];
    self_cond_diff = [self_cond_diff, DATA_withSNR(s).Self_20];
    self_cond_diff = [self_cond_diff, DATA_withSNR(s).Self_90];
    self_cond_diff = [self_cond_diff, DATA_withSNR(s).Self_SRT];
end

% 내림 차순
[diffSPL_desc,q] = sort(diffSPL,'descend');
[diffSPL_self_desc,q_s] = sort(diffSPL_self,'descend');
Indi_diff_SRT = sort(Indi_diff_SRT, 'descend');
Indi_diff_SI90 = sort(Indi_diff_SI90, 'descend');
si90cut_diff = [];
srtcut_diff = [];
submcl_self = [];
sub20_self = [];
sub90_self = [];
subsrt_self = [];
Acc_desc_diff = [];
self_desc_diff = [];
for j = 1:length(q)
    Acc_desc_diff = [Acc_desc_diff, Acc_cond_diff(q(j))];
end
for j = 1:length(q_s)
    self_desc_diff = [self_desc_diff, self_cond_diff(q_s(j))]; end

mclcut_diff = find(diffSPL_desc == 0);
mcl20cut_diff = find(diffSPL_desc == -20);
for i = 1:length(Indi_diff_SRT)
    si90cut_diff = [si90cut_diff, find(diffSPL_desc == Indi_diff_SI90(i))];
    srtcut_diff = [srtcut_diff, find(diffSPL_desc == Indi_diff_SRT(i))];
end
srtcut_diff = unique(srtcut_diff);
si90cut_diff = unique(si90cut_diff);

figure(28)
% 전부
scatter(diffSPL_desc, Acc_desc_diff,'k'); 
hold on
% mcl +20dB
% scatter(diffSPL_desc(1:mcl20cut_diff(end)), Acc_desc_diff(1:mcl20cut_diff(end)),'MarkerEdgeColor', [0 0.4470 0.7410]);
% 20 + 90 + srt
scatter(diffSPL_desc(mclcut_diff(end)+1:end), Acc_desc_diff(mclcut_diff(end)+1:end),'MarkerEdgeColor',[0.8500 0.3250 0.0980]); grid on 
% 90+ srt
scatter(diffSPL_desc([si90cut_diff,srtcut_diff]), Acc_desc_diff([si90cut_diff,srtcut_diff]),'MarkerEdgeColor', [0.9290 0.6940 0.1250]);  
% srt 만
scatter(diffSPL_desc(srtcut_diff), Acc_desc_diff(srtcut_diff),'MarkerEdgeColor', [0.4940 0.1840 0.5560]); 
% legend({'MCL', 'MCL-20dB', 'SI90', 'SRT'}, 'AutoUpdate','off');
m = lsline;
% set(m(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(m(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(m(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(m(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(m(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
set(gcf, 'color','white')
ylim([0 180])
legend(m(1:4),{'SRT','SI90', '20dB', 'All'}, 'AutoUpdate','off','location','northwest')
ylabel('Decoder Accuracy (%)')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Accuracy')
Slope = [];
Intercept = [];
% line data save
for i = 1:length(m)
    B = [ones(size(m(i).XData(:))), m(i).XData(:)]\m(i).YData(:);
    Slope(i) = B(2);
    Intercept(i) = B(1);
end

%----------- 피험자별 모양 다르게
submcl = [];
sub20 = [];
sub90 = [];
subsrt = [];
for i = 1:28:length(diffSPL)
    submcl = [submcl, linspace(i,i+6,7)];end  % mcl에 대해 각 sub index
for i = 8:28:length(diffSPL)
    sub20 = [sub20, linspace(i,i+6,7)];end
for i = 15:28:length(diffSPL)
    sub90 = [sub90, linspace(i,i+6,7)];end
for i = 22:28:length(diffSPL)
    subsrt = [subsrt, linspace(i,i+6,7)];end

siz = 5;
figure(29)
% 전부
gscatter(diffSPL, Acc_cond_diff,sublabel, [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    
hold on
% mcl+20
% gscatter(diffSPL([submcl,sub20]), Acc_cond_diff([submcl,sub20]), ...
%             sublabel([submcl,sub20]),[0 0.4470 0.7410], 'o+*pxsd^h<>v_|.');  hold on
% srt + 90 + 20
gscatter(diffSPL([sub20,sub90,subsrt]), Acc_cond_diff([sub20,sub90,subsrt]),...
            sublabel([sub20,sub90,subsrt]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); 
% srt + 90
gscatter(diffSPL([sub90,subsrt]), Acc_cond_diff([sub90,subsrt]),...
            sublabel([sub90,subsrt]), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 만
gscatter(diffSPL([subsrt]), Acc_cond_diff([subsrt]),...
            sublabel([subsrt]), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 

for i = 1:length(Slope)
    h(i) = refline(Slope(i), Intercept(i));
end
% set(h(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(h(4), 'color', [0 0.4470 0.7410], 'LineWidth', 2)
set(h(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 2)
set(h(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 2)
set(h(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)
% curve fitting
x = diffSPL_desc;
[fit,S] = polyfit(diffSPL_desc, Acc_desc_diff, 2);
% cur = (fit(1)*(x.^2))+(fit(2)*x)+(fit(3));
[yfit,delta] = polyval(fit,diffSPL_desc,S);
plot(diffSPL_desc, yfit, ':', 'color', [.25 .25 .25], 'LineWidth', 2);
% find peak
[maxy, idx] = max(yfit);
peakdiffspl = diffSPL_desc(idx);

ylim([0 120])
legend(h(1:4),{'SRT','SRT+SI90', 'SRT+SI90+20dB', 'All'}, 'AutoUpdate','off','location','northwest')
set(gcf, 'color','white')
ylabel('Decoder Accuracy (%)')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Accuracy')

saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\DiffSPL_Acc_'+string(label)+'.jpg')
%% Self
submcl_self = 1:4:28;
sub20_self = 2:4:28;
sub90_self = 3:4:28;
subsrt_self = 4:4:28;
sublabel_self = [];
for i = 1:7
    eval(['sublabel_self = [sublabel_self, linspace(',num2str(i),',',num2str(i),',4)];'])
end
for j = 1:length(q_s)
    self_desc_diff = [self_desc_diff, self_cond_diff(q_s(j))]; end
    

figure(34)
% 전부
scatter(diffSPL_self_desc, self_desc_diff,'k'); 
hold on
% mcl +20dB
% scatter(diffSPL_desc(1:mcl20cut_diff(end)), Acc_desc_diff(1:mcl20cut_diff(end)),'MarkerEdgeColor', [0 0.4470 0.7410]);
% 20 + 90 + srt
scatter(diffSPL_self_desc([sub20_self,sub90_self,subsrt_self]), self_desc_diff([sub20_self,sub90_self,subsrt_self]),'MarkerEdgeColor',[0.8500 0.3250 0.0980]); grid on 
% 90+ srt
scatter(diffSPL_self_desc([sub90_self,subsrt_self]), self_desc_diff([sub90_self,subsrt_self]),'MarkerEdgeColor', [0.9290 0.6940 0.1250]);  
% srt 만
scatter(diffSPL_self_desc(subsrt_self), self_desc_diff(subsrt_self),'MarkerEdgeColor', [0.4940 0.1840 0.5560]); 
% legend({'MCL', 'MCL-20dB', 'SI90', 'SRT'}, 'AutoUpdate','off');
m = lsline;
% set(m(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(m(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(m(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(m(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(m(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
set(gcf, 'color','white')
ylim([0 6])
legend(m(1:4),{'SRT','SI90', '20dB', 'All'}, 'AutoUpdate','off','location','northwest')
ylabel('Self-Report answer')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Accuracy')
Slope = [];
Intercept = [];
% line data save
for i = 1:length(m)
    B = [ones(size(m(i).XData(:))), m(i).XData(:)]\m(i).YData(:);
    Slope(i) = B(2);
    Intercept(i) = B(1);
end

%----------- 피험자별 모양 다르게
siz = 5;
figure(35)
% 전부
gscatter(diffSPL_self, self_cond_diff,sublabel_self, [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    
hold on
% mcl+20
% gscatter(diffSPL([submcl,sub20]), Acc_cond_diff([submcl,sub20]), ...
%             sublabel([submcl,sub20]),[0 0.4470 0.7410], 'o+*pxsd^h<>v_|.');  hold on
% srt + 90 + 20
gscatter(diffSPL_self([sub20_self,sub90_self,subsrt_self]), self_cond_diff([sub20_self,sub90_self,subsrt_self]),...
            sublabel_self([sub20_self,sub90_self,subsrt_self]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); 
% srt + 90
gscatter(diffSPL_self([sub90_self,subsrt_self]), self_cond_diff([sub90_self,subsrt_self]),...
            sublabel_self([sub90_self,subsrt_self]), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 만
gscatter(diffSPL_self([subsrt_self]), self_cond_diff([subsrt_self]),...
            sublabel_self([subsrt_self]), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 

for i = 1:length(Slope)
    h(i) = refline(Slope(i), Intercept(i));
end
% set(h(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(h(4), 'color', [0 0.4470 0.7410], 'LineWidth', 2)
set(h(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 2)
set(h(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 2)
set(h(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)

ylim([0 5])
legend(h(1:4),{'SRT','SRT+SI90', '20','All'}, 'AutoUpdate','off','location','northwest')
set(gcf, 'color','white')
ylabel('Self-Report answer')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Accuracy')

% saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\DiffSPL_Self_'+string(label)+'.jpg')

%% diff corr
%================================================================%
%=============================== diff SPL
diffSPL = [];
Corr_att_cond_diff= [];
Corr_utt_cond_diff= [];
Indi_diff_SI90 = [];
Indi_diff_SRT = [];
for s = len
    
    %for r = 1:46
        for rr = 1:7
            diffSPL = [diffSPL, 0];end
        for rr = 1:7
            diffSPL = [diffSPL, -20];end
        for rr = 1:7
            diffSPL = [diffSPL, double(DATA_withSNR(s).SI90)];
            Indi_diff_SI90 = [Indi_diff_SI90, double(DATA_withSNR(s).SI90)];end
        for rr = 1:7
            diffSPL = [diffSPL, double(DATA_withSNR(s).SRT)];
            Indi_diff_SRT = [Indi_diff_SRT, double(DATA_withSNR(s).SRT)];end
    %end
%     Corr_cond_diff = [Corr_cond_diff, Ave_Corr_att_MCL(s)];
%     Corr_cond_diff = [Corr_cond_diff, Ave_Corr_att_20(s)];
%     Corr_cond_diff = [Corr_cond_diff, Ave_Corr_att_90(s)];
%     Corr_cond_diff = [Corr_cond_diff, Ave_Corr_att_SRT(s)];
     % att
     Corr_att_cond_diff = [Corr_att_cond_diff; Sub_Corr_Matt_MCL(:,s)];
     Corr_att_cond_diff = [Corr_att_cond_diff; Sub_Corr_Matt_20(:,s)];
     Corr_att_cond_diff = [Corr_att_cond_diff; Sub_Corr_Matt_90(:,s)];
     Corr_att_cond_diff = [Corr_att_cond_diff; Sub_Corr_Matt_SRT(:,s)];
     % utt
     Corr_utt_cond_diff = [Corr_utt_cond_diff; Sub_Corr_Mutt_MCL(:,s)];
     Corr_utt_cond_diff = [Corr_utt_cond_diff; Sub_Corr_Mutt_20(:,s)];
     Corr_utt_cond_diff = [Corr_utt_cond_diff; Sub_Corr_Mutt_90(:,s)];
     Corr_utt_cond_diff = [Corr_utt_cond_diff; Sub_Corr_Mutt_SRT(:,s)];    

end

% 내림 차순
[diffSPL_desc,q] = sort(diffSPL,'descend');
Indi_diff_SRT = sort(Indi_diff_SRT, 'descend');
Indi_diff_SI90 = sort(Indi_diff_SI90, 'descend');
srtcut_diff = [];
Corr_att_desc_diff = [];
Corr_utt_desc_diff = [];
for j = 1:length(q)
    Corr_att_desc_diff = [Corr_att_desc_diff, Corr_att_cond_diff(q(j))];
    Corr_utt_desc_diff = [Corr_utt_desc_diff, Corr_utt_cond_diff(q(j))];
end

mclcut_diff = find(diffSPL_desc == 0);
mcl20cut_diff = find(diffSPL_desc == -20);
for i = 1:length(Indi_diff_SRT)
    srtcut_diff = [srtcut_diff, find(diffSPL_desc == Indi_diff_SRT(i))];
end
srtcut_diff = unique(srtcut_diff);

figure(34)
% scatter(diffSPL_desc(1:mcl20cut_diff(end)), Corr_att_desc_diff(1:mcl20cut_diff(end)),'k');  hold on
% 전부
scatter(diffSPL_desc, Corr_att_desc_diff,'MarkerEdgeColor', [0 0.4470 0.7410]);    
hold on
% srt si90 20
scatter(diffSPL_desc(mclcut_diff(end)+1:end), Corr_att_desc_diff(mclcut_diff(end)+1:end),'MarkerEdgeColor',[0.8500 0.3250 0.0980]); grid on 
set(gcf, 'color','white')
% mcl&mcl20 제외 = srt&si90
scatter(diffSPL_desc(mcl20cut_diff(end)+1:end), Corr_att_desc_diff(mcl20cut_diff(end)+1:end),'MarkerEdgeColor', [0.9290 0.6940 0.1250]);  
% srt 만
scatter(diffSPL_desc(srtcut_diff), Corr_att_desc_diff(srtcut_diff),'MarkerEdgeColor', [0.4940 0.1840 0.5560]); 
m = lsline;
% set(m(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(m(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(m(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(m(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(m(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
ylim([-0.15 0.35])
legend(m(1:4),{'SRT','SRT+SI90', 'SRT+SI90+20dB', 'All'}, 'AutoUpdate','off')
ylabel('Mean Correlation')
xlabel('difference SPL (dBA)')
title('Individual SPL difference -Att Correlation')
Slope_att = [];
Intercept_att = [];
% line data save
for i = 1:length(m)
    B = [ones(size(m(i).XData(:))), m(i).XData(:)]\m(i).YData(:);
    Slope_att(i) = B(2);
    Intercept_att(i) = B(1);
end
%utt
figure(35)
% scatter(diffSPL_desc(1:mcl20cut_diff(end)), Corr_utt_desc_diff(1:mcl20cut_diff(end)),'k');  hold on
% 전부
scatter(diffSPL_desc, Corr_utt_desc_diff,'MarkerEdgeColor', [0 0.4470 0.7410]);    
hold on
% 20 si90 srt
scatter(diffSPL_desc(mclcut_diff(end)+1:end), Corr_utt_desc_diff(mclcut_diff(end)+1:end),'MarkerEdgeColor',[0.8500 0.3250 0.0980]); grid on 
set(gcf, 'color','white')
% mcl&mcl20 제외 = srt&si90
scatter(diffSPL_desc(mcl20cut_diff(end)+1:end), Corr_utt_desc_diff(mcl20cut_diff(end)+1:end),'MarkerEdgeColor', [0.9290 0.6940 0.1250]);  
% srt 만
scatter(diffSPL_desc(srtcut_diff), Corr_utt_desc_diff(srtcut_diff),'MarkerEdgeColor', [0.4940 0.1840 0.5560]); 
u = lsline;
% set(u(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(u(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(u(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(u(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(u(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
ylim([-0.15 0.35])
legend(u(1:4),{'SRT','SRT+SI90', 'SRT+SI90+20dB', 'All'}, 'AutoUpdate','off')
ylabel('Mean Correlation')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Unatt Correlation')
Slope_utt = [];
Intercept_utt = [];
% line data save
for i = 1:length(u)
    B = [ones(size(u(i).XData(:))), u(i).XData(:)]\u(i).YData(:);
    Slope_utt(i) = B(2);
    Intercept_utt(i) = B(1);
end

%----------- 피험자별 모양 다르게
%att
siz = 5;
figure(36)
% gscatter(diffSPL([submcl,sub20]), Corr_att_cond_diff([submcl,sub20]), ...
%             sublabel([submcl,sub20]),'k', 'o+*.xsd^',0.0001);  hold on
% 전부
gscatter(diffSPL, Corr_att_cond_diff,sublabel,[0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    
hold on
% mcl 제외
gscatter(diffSPL([sub20,sub90,subsrt]), Corr_att_cond_diff([sub20,sub90,subsrt]),...
            sublabel([sub20,sub90,subsrt]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz);
% mcl&mcl20 제외 = srt&si90
gscatter(diffSPL([sub90,subsrt]), Corr_att_cond_diff([sub90,subsrt]),...
            sublabel([sub90,subsrt]), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 만
gscatter(diffSPL([subsrt]),Corr_att_cond_diff([subsrt]),...
            sublabel([subsrt]), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 

for i = 1:length(Slope_utt)
    a(i) = refline(Slope_att(i), Intercept_att(i));
end
% set(a(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(a(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(a(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(a(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(a(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
set(gcf, 'color','white')
% curve fitting
% x = diffSPL_desc;
[fit,S] = polyfit(diffSPL_desc, Corr_att_desc_diff, 2);
[yfit, delta] = polyval(fit, diffSPL_desc,S);
% cur = (fit(1)*(x.^2))+(fit(2)*x)+(fit(3));
plot(diffSPL_desc, yfit, ':', 'color', [.25 .25 .25], 'LineWidth', 3.3);
ylim([-0.13 0.28])
legend(a(1:4), {'SRT','SRT+SI90', 'SRT+SI90+20dB', 'All'}, 'AutoUpdate','off','location','northwest')
ylabel('Attended Correlation')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Att Correlation')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\DiffSPL_Corr_att_'+string(label)+'.jpg')

%unatt
figure(37)
% gscatter(diffSPL([submcl,sub20]), Corr_utt_cond_diff([submcl,sub20]), ...
%             sublabel([submcl,sub20]),'k', 'o+*.xsd^',0.0001);  hold on
% 전부
gscatter(diffSPL, Corr_utt_cond_diff,sublabel,[0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz );    
hold on
% 20 90 srt
gscatter(diffSPL([sub20,sub90,subsrt]), Corr_utt_cond_diff([sub20,sub90,subsrt]),...
            sublabel([sub20,sub90,subsrt]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); 
% mcl&mcl20 제외 = srt&si90
gscatter(diffSPL([sub90,subsrt]), Corr_utt_cond_diff([sub90,subsrt]),...
            sublabel([sub90,subsrt]), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 만
gscatter(diffSPL([subsrt]),Corr_utt_cond_diff([subsrt]),...
            sublabel([subsrt]), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 
for i = 1:length(Slope_utt)
    u(i) = refline(Slope_utt(i), Intercept_utt(i));
end
% set(u(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(u(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(u(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(u(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(u(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
set(gcf, 'color','white')
% curve fitting
x = diffSPL_desc;
fit = polyfit(diffSPL_desc, Corr_utt_desc_diff, 2);
cur = (fit(1)*(x.^2))+(fit(2)*x)+(fit(3));
plot(diffSPL_desc, cur, ':', 'color', [.25 .25 .25], 'LineWidth', 3.3);
ylim([-0.13 0.28])
legend(u(1:4), {'SRT','SRT+SI90', 'SRT+SI90+20dB', 'All'}, 'AutoUpdate','off','location','northwest')
ylabel('Unattended Correlation')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Unatt Correlation')
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\DiffSPL_Corr_utt_'+string(label)+'.jpg')

%% 거르기

for i = 1:length(list)
    eval(['minus_AveCorr_',list{i},' = Ave_Corr_att_',list{i},' - Ave_Corr_utt_',list{i},';']);
    eval(['minus_SubCorr_',list{i},' = Sub_Corr_Matt_',list{i},' - Sub_Corr_Mutt_',list{i},';']);
end

judg = [];
judg_sub = [];
for i = 1:length(list)
    for c = 1:7 % trial
        for s = 1:length(minus_SubCorr_20)
            if eval(['minus_AveCorr_',list{i},'(c) > minus_SubCorr_',list{i},'(c,s)'])
                judg_sub(c,s) = 0;
            else judg_sub(c,s) = 1;
            end
        end
    end
    
    judg = [judg; judg_sub];
end
% 40 이하면 좀
mm = mean(judg)*100;

%% Wilcoxon signed rank test 
% x = Sub_Acc_MCL;
% y = Sub_Acc_SRT;

% x = mean(Sub_Corr_Mutt_MCL(:,len));
% y = mean(Sub_Corr_Mutt_SRT(:,len));

x = OffSub_Acc_mcl;
y = OffSub_Acc_90;
% x = mean(OffSub_Corr_Matt_MCL);
% y = mean(OffSub_Corr_Matt_SRT);
% x=[];
% y=[];
% for i = 1:length(OffDATA)
%     x = [x,OffDATA(i).acc_srt];
%     y = [y,OffDATA_2(i).acc_srt];
% end

[p,h] = signrank(x,y)

%% condition 별 - offline
clear
clc
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
tmax    = 250;
lambda = 10;

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
    
    % decoder train
    model = mTRFtrain(att_env(1:14), EEG(1:14), fs, Dir, tmin, tmax, lambda, 'verbose', 0);
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
% save('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA_2.mat', 'OffDATA_2');

% save('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA_delta.mat', 'OffDATA_delta');

%% Offline plot
% offlen = [1,3,4,5,6,8,9,11,12,14,16,19,22];  % on 기준 13 명
offlen = [1,3,4,5,6,7,8,9,11,12,13,14,16,19,21,22]; % off 기준 16 명
cond = 'rej10'
condition = {'mcl', '20', '90', 'srt'};
list = {'MCL', '20', '90', 'SRT'};
% load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA.mat')
% load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA_2.mat')
% load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA_all.mat')
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA_optimal.mat')
OffDATA = OffDATA_2(offlen);
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\DATA_withSNR.mat');

for s = 1:length(OffDATA) % length(OffDATA)
    OffSub_Acc(s) = OffDATA(s).all_acc;
%     OffSub_Acc(s) = OffDATA_2(s).all_acc;
    for i = 1:4
        eval(['OffSub_Acc_',condition{i},'(s) = OffDATA(s).acc_',condition{i},';']);
%         eval(['OffSub_Acc_',condition{i},'(s) = OffDATA_2(s).acc_',condition{i},';']);        
    end
end
OffAve_Acc = mean(OffSub_Acc);
for i = 1:4
    eval(['OffAve_Acc_',condition{i},' = mean(OffSub_Acc_',condition{i},');']);
    eval(['OffAve_Acc_',condition{i},'_std = std(OffSub_Acc_',condition{i},');']);
end 
OffAve_Acc_std = std(OffSub_Acc);

% acc-condi
Xa = categorical({'All','MCL','MCL-20', 'SI90', 'SRT'});
Xa = reordercats(Xa,{'All','MCL','MCL-20', 'SI90', 'SRT'});
Y = [OffAve_Acc, OffAve_Acc_mcl, OffAve_Acc_20, OffAve_Acc_90, OffAve_Acc_srt];
all_std = [OffAve_Acc_std, OffAve_Acc_mcl_std, OffAve_Acc_20_std, OffAve_Acc_90_std, OffAve_Acc_srt_std];
figure(24)
clf
b = bar(Xa, Y, 'FaceColor', 'flat');  hold on
b.CData(2,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.9290 0.6940 0.1250];
b.CData(5,:) = [0.4940 0.1840 0.5560];
b.CData(1,:) = [0.4660 0.6740 0.1880];
er = errorbar(Xa,Y,-all_std,all_std);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1;  
grid on
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
% refline([0, chance]);
title('Offline - Mean Accuracy - Conditions')
%plot(Xa, [Sub_Acc; Sub_Acc_MCL; Sub_Acc_20; Sub_Acc_90; Sub_Acc_SRT], '--ok');
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\OffAve_Accuracy_Condtions_'+string(cond)+'.jpg')

% Correlation
for i = 1:4
    eval(['OffSub_Corr_Matt_',list{i},' = [];']);
    eval(['OffSub_Corr_Mutt_',list{i},' = [];']);
    eval(['OffSub_Corr_att_',list{i},' = [];']);
    eval(['OffSub_Corr_utt_',list{i},' = [];']);
end  

for s = 1:length(OffDATA)
        
    for z = 1:length(list) 
        eval(['OffSub_Corr_Matt_',list{z},' = [OffSub_Corr_Matt_',list{z},' , mean(OffDATA(s).corr_att_',condition{z},')];']);  % trial by subject
        eval(['OffSub_Corr_Mutt_',list{z},' = [OffSub_Corr_Mutt_',list{z},' , mean(OffDATA(s).corr_utt_',condition{z},')];']);
        
        eval(['OffSub_Corr_att_',list{z},'(s,:) = OffDATA(s).corr_att_',condition{z},';']);
        eval(['OffSub_Corr_utt_',list{z},'(s,:) = OffDATA(s).corr_utt_',condition{z},';']);
    end
end

for z = 1:length(list) 
    eval(['OffAve_Corr_att_',list{z},'= mean(OffSub_Corr_Matt_',list{z},',2);;']);
    eval(['OffAve_Corr_utt_',list{z},'= mean(OffSub_Corr_Mutt_',list{z},',2);']);
end

% 함께
AU = categorical({'Att','Unatt'});
AU = reordercats(AU,{'Att','Unatt'});

figure(32)
clf
for i = 1:4
    subplot(1,4,i)
    h = boxplot(eval(['[reshape(OffSub_Corr_att_',list{i},' ,[1, length(OffDATA)*7]); reshape(OffSub_Corr_utt_',list{i},',[1, length(OffDATA)*7])];'])'...
                        ,AU, 'color','br'); 
    if i == 1
        ylabel('Mean correlation', 'FontSize', 15); end
    set(h,{'linew'},{1.5})
    title(list{i},'FontSize', 15)   
    ylim([-0.15 0.25])
    set(gca,'linew',1)
end
%supylabel('Mean Correlation')
% sgtitle('Att & Unatt Correlation - Condition', 'FontSize', 20)
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\OffAve_Corr_Condtions_'+string(cond)+'.jpg')

%==================================================================%
% offline diffSNR
% 평균 안낸거
% unatt speech 와의 SPL 차이 값.
diffSPL = [];
Acc_cond_diff = [];
i = 1;
for s = [1,3,4,5,6,7,8,9,11,13,14,15,17,20,22,23]; % offline good
    
    diffSPL = [diffSPL, 0];
    diffSPL = [diffSPL, -20];
    diffSPL = [diffSPL, double(DATA_withSNR(s).SI90)];
    diffSPL = [diffSPL, double(DATA_withSNR(s).SRT)];
    
    Acc_cond_diff = [Acc_cond_diff, OffSub_Acc_mcl(i)];
    Acc_cond_diff = [Acc_cond_diff, OffSub_Acc_20(i)];
    Acc_cond_diff = [Acc_cond_diff, OffSub_Acc_90(i)];
    Acc_cond_diff = [Acc_cond_diff, OffSub_Acc_srt(i)];
    i = i+1;
end

% 내림 차순
% [diffSPL,q] = sort(diffSPL,'descend');
% Acc_desc_diff = [];
% for j = 1:length(q)
%     Acc_desc_diff = [Acc_desc_diff, Acc_cond_diff(q(j))];
% end

figure(27)
clf
%plot(MCL_all(:,1), MCL_all(:,2), 'ok', 'LineWidth', 1.5);
scatter(diffSPL, Acc_cond_diff, 'k'); grid on
set(gcf, 'color','white')
ylim([0 110])
%xlim([15 75])
m = refline;
ylabel('Decoder Accuracy (%)')
xlabel('difference SPL (dBA)')
title('Individual difference of SPL - Offline Accuracy')
Slope = [];
Intercept = [];
% line data save
for i = 1:length(m)
    B = [ones(size(m(i).XData(:))), m(i).XData(:)]\m(i).YData(:);
    Slope(i) = B(2);
    Intercept(i) = B(1);
end
%-------------------------------------------------------%
%----------- 피험자별 모양 다르게
submcl = 1:4:length(diffSPL);
sub20 = 2:4:length(diffSPL);
sub90 = 3:4:length(diffSPL);
subsrt = 4:4:length(diffSPL);

siz = 7;
figure(27)
clf
% mcl
gscatter(diffSPL(submcl), Acc_cond_diff(submcl), submcl, [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    
hold on
% 20
gscatter(diffSPL(sub20), Acc_cond_diff(sub20),...
            sub20, [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); 
% 90
gscatter(diffSPL(sub90), Acc_cond_diff(sub90),...
            sub90, [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 
gscatter(diffSPL(subsrt), Acc_cond_diff(subsrt),...
            subsrt, [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 
h = refline(Slope, Intercept);

set(h, 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)

ylim([0 110])
set(gcf, 'color','white')
ylabel('Decoder Accuracy (%)')
xlabel('difference SPL (dBA)')
title('Off_Individual SPL difference - Accuracy')
leg=findobj('type','legend')
delete(leg)
% estimate pearson corr
[r,p] = corrcoef(diffSPL, Acc_cond_diff)
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\OffAcc_DiffSPL_'+string(cond)+'.jpg')

% ------------------- Corr
% diff SPL
diffSPL = [];
Corr_att_cond_diff= [];
Corr_utt_cond_diff= [];
i=1;
for s = offlen
    
    for rr = 1:7
        diffSPL = [diffSPL, 0];end
    for rr = 1:7
        diffSPL = [diffSPL, -20];end
    for rr = 1:7
        diffSPL = [diffSPL, double(DATA_withSNR(s).SI90)];end
    for rr = 1:7
        diffSPL = [diffSPL, double(DATA_withSNR(s).SRT)];end

     % att
     Corr_att_cond_diff = [Corr_att_cond_diff, OffSub_Corr_att_MCL(i,:)];
     Corr_att_cond_diff = [Corr_att_cond_diff, OffSub_Corr_att_20(i,:)];
     Corr_att_cond_diff = [Corr_att_cond_diff, OffSub_Corr_att_90(i,:)];
     Corr_att_cond_diff = [Corr_att_cond_diff, OffSub_Corr_att_SRT(i,:)];
     % utt
     Corr_utt_cond_diff = [Corr_utt_cond_diff, OffSub_Corr_utt_MCL(i,:)];
     Corr_utt_cond_diff = [Corr_utt_cond_diff, OffSub_Corr_utt_20(i,:)];
     Corr_utt_cond_diff = [Corr_utt_cond_diff, OffSub_Corr_utt_90(i,:)];
     Corr_utt_cond_diff = [Corr_utt_cond_diff, OffSub_Corr_utt_SRT(i,:)];    
    i=i+1;
end

% Attended
figure(30)
clf
%plot(MCL_all(:,1), MCL_all(:,2), 'ok', 'LineWidth', 1.5);
scatter(diffSPL, Corr_att_cond_diff, 20 , 'b', 'filled'); grid on
set(gcf, 'color','white')
ylim([-0.3 0.4])
%xlim([15 75])
m = refline;
ylabel('Mean Correlation')
xlabel('difference SPL (dBA)')
title('Individual difference SPL - Att Correlation')
Slope = [];
Intercept = [];
% line data save
for i = 1:length(m)
    B = [ones(size(m(i).XData(:))), m(i).XData(:)]\m(i).YData(:);
    Slope(i) = B(2);
    Intercept(i) = B(1);
end
%-----------------------------------------%
% 피험자별
submcl = [];
sub20 = [];
sub90 = [];
subsrt = [];
for i = 1:28:length(diffSPL)
    submcl = [submcl, linspace(i,i+6,7)]; 
    sub20 = [sub20, linspace(i+7,i+13,7)];
    sub90 = [sub90, linspace(i+14,i+20,7)];
    subsrt = [subsrt, linspace(i+21,i+27,7)];
end

%----------- 피험자별 모양 다르게
siz = 5;
figure(30)
clf
% mcl
gscatter(diffSPL(submcl), Corr_att_cond_diff(submcl), submcl, [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    
hold on
% 20
gscatter(diffSPL(sub20), Corr_att_cond_diff(sub20),...
            sub20, [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); 
% 90
gscatter(diffSPL(sub90), Corr_att_cond_diff(sub90),...
            sub90, [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 
gscatter(diffSPL(subsrt), Corr_att_cond_diff(subsrt),...
            subsrt, [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 
h = refline(Slope, Intercept);
set(h, 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)
ylim([-0.15 0.3])
set(gcf, 'color','white')
ylabel('Envelop Correlation')
xlabel('difference SPL (dBA)')
title('Off_Individual SPL difference - Att Corr')
leg=findobj('type','legend')
delete(leg)
% estimate pearson corr
[r_att,p_att] = corrcoef(diffSPL, Corr_att_cond_diff)
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\OffCorr_Att_DiffSPL_'+string(cond)+'.jpg')

% Unatt
figure(31)
clf
%plot(MCL_all(:,1), MCL_all(:,2), 'ok', 'LineWidth', 1.5);
scatter(diffSPL, Corr_utt_cond_diff, 20 , 'r', 'filled'); grid on
set(gcf, 'color','white')
ylim([-0.3 0.4])
%xlim([15 75])
h = lsline;
ylabel('Mean Correlation')
xlabel('difference SPL (dBA)')
title('Individual difference SPL - Unatt Correlation')
Slope = [];
Intercept = [];
% line data save
for i = 1:length(h)
    B = [ones(size(h(i).XData(:))), h(i).XData(:)]\h(i).YData(:);
    Slope(i) = B(2);
    Intercept(i) = B(1);
end

% 피험자별
figure(31)
clf
% mcl
gscatter(diffSPL(submcl), Corr_utt_cond_diff(submcl), submcl, [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    
hold on
% 20
gscatter(diffSPL(sub20), Corr_utt_cond_diff(sub20),...
            sub20, [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); 
% 90
gscatter(diffSPL(sub90), Corr_utt_cond_diff(sub90),...
            sub90, [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 
gscatter(diffSPL(subsrt), Corr_utt_cond_diff(subsrt),...
            subsrt, [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 
h = refline(Slope, Intercept);
set(h, 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)
ylim([-0.15 0.3])
set(gcf, 'color','white')
ylabel('Envelop Correlation')
xlabel('difference SPL (dBA)')
title('Off_Individual SPL difference - Unatt Corr')
leg=findobj('type','legend')
delete(leg)
% estimate pearson corr
[r_utt,p_utt] = corrcoef(diffSPL, Corr_utt_cond_diff)
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\OffCorr_Utt_DiffSPL_'+string(cond)+'.jpg')

%% Wilcoxon signed rank test 

% x = OffSub_Acc_srt;
% y = OffSub_Acc_20;

% x = OffSub_Corr_Matt_MCL;
% y = OffSub_Corr_Matt_90;
% x=[];
% y=[];
% for i = 1:length(OffDATA_2)
%     x = [x,OffDATA(i).acc_srt];
%     y = [y,OffDATA_2(i).acc_srt];
% end

x = OffSub_Acc_srt(:,1);
y = OffSub_Acc_srt(:,2);

[p,h] = signrank(x,y)

%% 250 / 500 비교
cond = 'rej10'
condition = {'mcl', '20', '90', 'srt'};
list = {'MCL', '20', '90', 'SRT'};

for s = 1:length(OffDATA)
    OffSub_Acc(s,1) = OffDATA(s).all_acc;
    OffSub_Acc(s,2) = OffDATA_2(s).all_acc;
    for i = 1:4
        eval(['OffSub_Acc_',condition{i},'(s,1) = OffDATA(s).acc_',condition{i},';']);
        eval(['OffSub_Acc_',condition{i},'(s,2) = OffDATA_2(s).acc_',condition{i},';']);
    end
end
OffAve_Acc(1) = mean(OffSub_Acc(:,1));
OffAve_Acc(2) = mean(OffSub_Acc(:,2));
for i = 1:4
    eval(['OffAve_Acc_',condition{i},'(1) = mean(OffSub_Acc_',condition{i},'(:,1));']);
    eval(['OffAve_Acc_',condition{i},'_std(1) = std(OffSub_Acc_',condition{i},'(:,1));']);
    eval(['OffAve_Acc_',condition{i},'(2) = mean(OffSub_Acc_',condition{i},'(:,2));']);
    eval(['OffAve_Acc_',condition{i},'_std(2) = std(OffSub_Acc_',condition{i},'(:,2));']);
end 
OffAve_Acc_std(1) = std(OffSub_Acc(:,1));
OffAve_Acc_std(2) = std(OffSub_Acc(:,2));

%-------
% plot
Y = [OffAve_Acc(1), OffAve_Acc_mcl(1), OffAve_Acc_20(1), OffAve_Acc_90(1), OffAve_Acc_srt(1)];
Y2 = [OffAve_Acc(2), OffAve_Acc_mcl(2), OffAve_Acc_20(2), OffAve_Acc_90(2), OffAve_Acc_srt(2)];

all_std = [OffAve_Acc_std(1), OffAve_Acc_mcl_std(1), OffAve_Acc_20_std(1), OffAve_Acc_90_std(1), OffAve_Acc_srt_std(1)];
all_std2 = [OffAve_Acc_std(2), OffAve_Acc_mcl_std(2), OffAve_Acc_20_std(2), OffAve_Acc_90_std(2), OffAve_Acc_srt_std(2)];
figure(27)
clf
y = [Y; Y2]';
ngroups = size(y, 1);
nbars = size(y, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5)); 
X = categorical({'All','MCL','MCL-20dB', 'SI 90%', 'SI 50%'});
X = reordercats(X,{'All','MCL','MCL-20dB', 'SI 90%', 'SI 50%'});

b = bar([1,2,3,4,5], y, 'FaceColor', 'flat');  hold on
one = [];
two = [];
for i = 1:length(OffDATA)
    one(i,1) = OffDATA(i).all_acc;
    one(i,2) = OffDATA(i).acc_mcl;
    one(i,3) = OffDATA(i).acc_20;
    one(i,4) = OffDATA(i).acc_90;
    one(i,5) = OffDATA(i).acc_srt;
    
    two(i,1) = OffDATA_2(i).all_acc;
    two(i,2) = OffDATA_2(i).acc_mcl;
    two(i,3) = OffDATA_2(i).acc_20;
    two(i,4) = OffDATA_2(i).acc_90;
    two(i,5) = OffDATA_2(i).acc_srt;
    
end
%[one(:,2);two(:,2)], [one(:,3);two(:,3)], [one(:,4);two(:,4)], [one(:,5);two(:,5)]]
for i = 1:5
    plot([i-0.15,i+0.15],[[one(:,i),two(:,i)]'], '--ok')
end

saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\OffAcc_250500_'+string(cond)+'.jpg')

% err = [all_std; all_std2]';
% for i = 1:nbars
%     x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
%     er = errorbar(x, y(:,i), err(:,i), '.');
%     er.Color = [0 0 0];  
%     er.LineStyle = 'none';  
%     er.LineWidth = 1; 
% end
% b.CData(1,:) = [0.4660 0.6740 0.1880];
set(gcf, 'color', 'white')
ylim([10 100])
ylabel('Accuracy (%)')
% plot(Xc, [Sub_Beh2_att_MCL;Sub_Beh2_att_20;Sub_Beh2_att_90;Sub_Beh2_att_SRT]', ':ok', 'lineWidth', 1, 'MarkerFaceColor' ,'w')
% yline(33.93, '--', 'lineWidth', 1); 
% title('Ave - Behavior test 2_ Attended')

%% Plot - Corr 250/500 비교
condition = {'mcl', '20', '90', 'srt'};
list = {'MCL', '20', '90', 'SRT'};
for sub = 1:length(OffDATA)   
    for i = 1:4
        eval(['OffCorr_att_',condition{i},'(sub,:,1) = OffDATA(sub).corr_att_',condition{i},';']);
        eval(['OffCorr_utt_',condition{i},'(sub,:,1) = OffDATA(sub).corr_utt_',condition{i},';']);
        
        eval(['OffCorr_att_',condition{i},'(sub,:,2) = OffDATA_2(sub).corr_att_',condition{i},';']);
        eval(['OffCorr_utt_',condition{i},'(sub,:,2) = OffDATA_2(sub).corr_utt_',condition{i},';']);
    end
end

AU = categorical({'~250 ms','~500 ms'});
AU = reordercats(AU,{'~250 ms','~500 ms'});
for i = 1:4
    subplot(1,4,i)
    h = boxplot(eval(['[reshape(OffCorr_att_',condition{i},'(:,:,1), [1, length(OffDATA)*7]); reshape(OffCorr_att_',condition{i},'(:,:,2), [1, length(OffDATA)*7])];'])'...
                        ,AU, 'color','br'); 
    
%     plot(
    if i == 1
        ylabel('Mean correlation', 'FontSize', 15); end
    set(h,{'linew'},{1.5})
    title(list{i},'FontSize', 15)   
    ylim([-0.2 0.3])
    set(gca,'linew',1)
end

%% delta/ theta - subjective scale 
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA_delta.mat')
load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\data_withSNR\OffDATA_theta.mat')
offlen = [3,4,5,6,8,11,13,15,17,1,20,23];
condition = {'mcl', '20', '90', 'srt'};
list = {'MCL', '20', '90', 'SRT'};
freq = {'theta'};

% off - subjective scales 뽑기 / offdata 없는 사람빼고 10
for c = 1:length(list) 
%     eval(['Sub_Self_',list{c},'(8) = [];'])
    eval(['OffSub_Self_',list{c},' = [];'])
    for s = [1:9,11:eval(['length(OffDATA_',freq{1},');'])+1]
        eval(['OffSub_Self_',list{c},' = [OffSub_Self_',list{c},' , Sub_Self_',list{c},'(s)];'])
    end
end

% lji 뒤로 가있는거 정리
OffDATA = struct;
eval(['OffDATA = OffDATA_',freq{1},'(10);'])
eval(['OffDATA = [OffDATA, OffDATA_',freq{1},'([1:9,11:length(OffDATA_',freq{1},')])];'])

for SubIdx = 1:length(OffDATA)
    for c = 1:length(list) 
        eval(['OffAcc_',list{c},'_',freq{1},'(SubIdx) = OffDATA(SubIdx).acc_',condition{c},';'])
    end
end

% plot
x = [OffSub_Self_MCL, OffSub_Self_20, OffSub_Self_90, OffSub_Self_SRT];
% y = [OffAcc_MCL_delta, OffAcc_20_delta, OffAcc_90_delta, OffAcc_SRT_delta];
y = [OffAcc_MCL_theta, OffAcc_20_theta, OffAcc_90_theta, OffAcc_SRT_theta];
% Acc - Subjective
figure(1)
clf
scatter(x,y, 'k')
% xlim([0 5])
xlim([0 5])
ylim([0 100])
% xlabel('Self report answer')
xlabel('Subjective scale (%)')
ylabel(['Decoder Accuracy _ ',freq{1},'(%)'])
refline
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\OffAcc_Subj_'+string(freq{1})+'.jpg')
[r,p] = corrcoef(x, y)
% self report
% a = [];
% for i = 1:5
%     a = [a, ones(1,7)*i];
% end
% scatter(a, [Sub_Acc_1, Sub_Acc_2, Sub_Acc_3, Sub_Acc_4, Sub_Acc_5], 'k');
% refline
% xlim([0.5 5.5])
% ylim([0 110])
% xlabel('Self report answer')
% ylabel('Decoder Accuracy (%)')
% xticks([1,2,3,4,5]); yticks(0:20:100);


    
    
    
    
    
 