%%
% Data analysis
clear
clc
% load
subject = '0713_phj';
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
dB20 = MCL -20;
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
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Accuracy_Direction.jpg')

% direction for conditoin
figure(4)
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
Xn = categorical({'1','2', '3', '4', '5'});
Xn = reordercats(Xn,{'1','2', '3', '4', '5'});
for z = 1:5
    eval(['Mean_Acc_'+string(z)+' = mean(Acc_'+string(z)+');']);
end
Y = [Mean_Acc_1, Mean_Acc_2, Mean_Acc_3, Mean_Acc_4, Mean_Acc_5];
b = bar(Xn, Y, 'FaceColor', 'flat');  hold on
b.CData(2,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.9290 0.6940 0.1250];
b.CData(5,:) = [0.4940 0.1840 0.5560];
b.CData(1,:) = [0.4660 0.6740 0.1880]; grid on
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

% % Part 2
% beh_at2 = Behavior_2(:,1:2);
% beh_un2 = Behavior_2(:,3:4);
% correct_at2 = find(beh_at2=='T');
% correct_un2 = find(beh_un2=='T');
% 
% accb_at2 = (length(correct_at2)/(length(beh_at2)*2))*100;
% accb_un2 = (length(correct_un2)/(length(beh_at2)*2))*100;  
% 
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

% xlable
% load
for i = 1:length(DATA_withSNR)
    Sub_MCL(i) = DATA_withSNR(i).MCL;
    Sub_20(i) = DATA_withSNR(i).dB20;
    Sub_90(i) = DATA_withSNR(i).SI90;
    Sub_SRT(i) = DATA_withSNR(i).SRT;
end

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

load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\DATA_withSNR.mat');
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
%save('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\DATA_withSNR.mat', 'DATA_withSNR');

%% Aeverage results across all subject
%load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\DATA_withSNR.mat');
% 
trials_mcl = [15,22,24,27,33,38,42];
trials_20 = [17,20,25,28,32,36,41];
trials_90 = [16,19,23,30,34,37,40];
trials_srt = [18,21,26,29,31,35,39];
condition = {'mcl', '20', '90', 'srt'};
list = {'MCL', '20', '90', 'SRT'};
for i = 1:length(DATA_withSNR)
    
    % accuracy-condition
    Sub_Acc(i) = DATA_withSNR(i).All_Acc;

    % behavior test
    Sub_Beh1_att(i) = DATA_withSNR(i).Behavior1_att;
    Sub_Beh1_utt(i) = DATA_withSNR(i).Behavior1_utt;
    
    Sub_Beh2_att(i) = DATA_withSNR(i).Behavior2_att;
    Sub_Beh2_utt(i) = DATA_withSNR(i).Behavior2_utt;

   for j = 1:length(list)
    eval(['Sub_Acc_'+string(list(j))+'(i) = DATA_withSNR(i).Acc_'+string(list(j))]);
    eval(['Sub_Beh2_att_'+string(list(j))+'(i) = DATA_withSNR(i).Behavior2_att_'+string(list(j))]);
    eval(['Sub_Beh2_utt_'+string(list(j))+'(i) = DATA_withSNR(i).Behavior2_utt_'+string(list(j))]);
    eval(['Sub_Self_'+string(list(j))+'(i) = DATA_withSNR(i).Self_'+string(list(j))]);
   end 
   
   for z = 1:5
       eval(['Sub_Acc_'+string(z)+'(i) = DATA_withSNR(i).Acc_'+string(z)]);
   end
    
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
%saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Accuracy_Condtions.jpg')

% condi-self
Xc = categorical({'MCL','MCL-20', 'SI90', 'SRT'});
Xc = reordercats(Xc,{'MCL','MCL-20', 'SI90', 'SRT'});
Y = [Ave_SelfMCL, Ave_Self20, Ave_Self90, Ave_SelfSRT];
for i = 1:length(list)
    eval(['Ave_Self_',list{i},'_std = std(Sub_Self_',list{i},');']);
end
all_self_std = [Ave_Self_MCL_std, Ave_Self_20_std, Ave_Self_90_std, Ave_Self_SRT_std];

figure(25)
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

% acc-self
Xn = categorical({'1','2','3', '4', '5'});
Xn = reordercats(Xn,{'1','2','3', '4', '5'});
Y = [Ave_Acc_1, Ave_Acc_2, Ave_Acc_3, Ave_Acc_4, Ave_Acc_5];
for i = 1:5
    eval(['Ave_Acc_'+string(i)+'_std = nanstd(Sub_Acc_'+string(i)+');']);
end
all_accn_std = [Ave_Acc_1_std, Ave_Acc_2_std, Ave_Acc_3_std, Ave_Acc_4_std, Ave_Acc_5_std];

figure(26)
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

% beh2-condi
Y = [Ave_Beh2_att, Ave_Beh2_att_MCL, Ave_Beh2_att_20, Ave_Beh2_att_90, Ave_Beh2_att_SRT];
Ave_Beh2_std = std(Sub_Beh2_att);
for i = 1:length(list)
    eval(['Ave_Beh2_',list{i},'_std = std(Sub_Beh2_att_',list{i},');']);
end
all_beh2_std = [Ave_Beh2_std, Ave_Beh2_MCL_std, Ave_Beh2_20_std, Ave_Beh2_90_std, Ave_Beh2_SRT_std];

figure(27)
b = bar(Xa, Y, 'FaceColor', 'flat');  hold on
b.CData(2,:) = [0 0.4470 0.7410];
b.CData(3,:) = [0.8500 0.3250 0.0980];
b.CData(4,:) = [0.9290 0.6940 0.1250];
b.CData(5,:) = [0.4940 0.1840 0.5560];
b.CData(1,:) = [0.4660 0.6740 0.1880];
grid on
er = errorbar(Xa,Y,-all_beh2_std,all_beh2_std);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1; 
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Accuracy (%)')
% refline([0, chance]);
title('Ave - Behavior test 2_ Attended')

% beh1-condi
X = categorical({'Attended','Unattended'});
X = reordercats(X,{'Attended','Unattended'});
Y = [Ave_Beh1_att, Ave_Beh1_utt];
Ave_Beh1_att_std = std(Sub_Beh1_att);
Ave_Beh1_utt_std = std(Sub_Beh1_utt);
all_beh1_std = [Ave_Beh1_att_std, Ave_Beh1_utt_std];

figure(28)
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

% Correlation
for i = 1:4
    eval(['Sub_Corr_att_',list{i},' = [];']);
    eval(['Sub_Corr_utt_',list{i},' = [];']);
end  


for s = 1:length(DATA_withSNR)
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
%         eval(['Sub_Corr_att_',list{z},' = [Sub_Corr_att_',list{z},' ; mean(corr_att_',list{z},')];']);
%         eval(['Sub_Corr_utt_',list{z},' = [Sub_Corr_utt_',list{z},' ; mean(corr_utt_',list{z},')];']);
        
        eval(['Sub_Corr_att_',list{z},'{s} = corr_att_',list{z},';']);
        eval(['Sub_Corr_utt_',list{z},'{s} = corr_utt_',list{z},';']);
    end
end

for z = 1:length(list) 
%     eval(['Ave_Corr_att_',list{z},'= mean(Sub_Corr_att_',list{z},',2);;']);
%     eval(['Ave_Corr_utt_',list{z},'= mean(Sub_Corr_utt_',list{z},',2);']);

end




figure(17)
boxplot([Ave_Corr_att_MCL, Ave_Corr_att_20, Ave_Corr_att_90, Ave_Corr_att_SRT],{'MCL','MCL-20', 'SI90', 'SRT'},'Colors','r'); grid on
ylabel(['Mean Correlation'])
xlabel(['Conditions'])
ylim([-0.2 0.2])
title(['Attended Correlation-Condition']); hold on
%saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Correlation_Att_Condition_box.jpg')

% Unattended Correlation boxplots
%figure(18)
boxplot([Ave_Corr_utt_MCL, Ave_Corr_utt_20, Ave_Corr_utt_90, Ave_Corr_utt_SRT],{'MCL','MCL-20', 'SI90', 'SRT'}, 'Colors', 'b'); grid on
ylabel(['Mean Correlation'])
xlabel(['Conditions'])
ylim([-0.2 0.2])
title(['Unttended Correlation-Condition'])
%saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\'+string(subject)+'\Correlation_Utt_Condition_box.jpg')

%% SRT/MCL - ACC graph
X = categorical({'sub01','sub02','sub03'});
X = reordercats(X,{'sub01','sub02','sub03'});

SRT_all = [];
q=[];
% load
for i = 1:length(DATA_withSNR)
    SRT_all(i,1) = DATA_withSNR(i).SRT;
    MCL_all(i,1) = DATA_withSNR(i).MCL;
    Acc_all(i,1) = DATA_withSNR(i).All_Acc;
    Acc_all(i,2) = DATA_withSNR(i).Acc_MCL;
    Acc_all(i,3) = DATA_withSNR(i).Acc_20;
    Acc_all(i,4) = DATA_withSNR(i).Acc_90;
    Acc_all(i,5) = DATA_withSNR(i).Acc_SRT;
end
% SRT 값에 따른 내림차순
[SRT_all,q] = sort(SRT_all,'descend');

for j = 1:length(DATA_withSNR)
    SRT_all(j,2:6) = Acc_all(q(j),:);
end
% MCL 값에 따른 내림차순
[MCL_all,p] = sort(MCL_all,'descend');

for i = 1:length(DATA_withSNR)
    MCL_all(i,2:6) = Acc_all(p(i),:);
end

% all acc - srt
figure(1)
scatter(SRT_all(1:4,1), SRT_all(1:4,2), 'k'); grid on
%plot(SRT_all(:,1), SRT_all(:,2), '-ok', 'LineWidth', 1.5); grid on
set(gcf, 'color','white')
ylim([30 100])
xlim([-50 -30])
hline = refline;
hline.Color = 'r';
ylabel('Decoder Accuracy (%)')
xlabel('SRT (dB SNR)')
title('Individual SRT - All Accuracy')

% srt acc - srt
figure(2)
scatter(SRT_all(1:4,1), SRT_all(1:4,6), 'k'); grid on
%plor(SRT_all(:,1)', SRT_all(:,6)', '-ok', 'LineWidth', 1.5); grid on
set(gcf, 'color','white')
ylim([30 100])
xlim([-50 -30])
hline = refline;
hline.Color = 'r';
ylabel('Decoder Accuracy (%)')
xlabel('SRT (dB SNR)')
title('Individual SRT - SRT Accuracy')

% all acc - mcl
figure(3)
%plot(MCL_all(:,1), MCL_all(:,2), 'ok', 'LineWidth', 1.5);
scatter(MCL_all(2:5,1), MCL_all(2:5,2), 'k'); grid on
set(gcf, 'color','white')
ylim([30 100])
xlim([50 75])
hline = refline;
hline.Color = 'r';
ylabel('Decoder Accuracy (%)')
xlabel('MCL (dB HL)')
title('Individual MCL - All Accuracy')

% mcl acc - mcl
figure(4)
%plot(MCL_all(:,1), MCL_all(:,2), 'ok', 'LineWidth', 1.5);
scatter(MCL_all(2:5,1), MCL_all(2:5,3), 'k'); grid on
set(gcf, 'color','white')
ylim([30 100])
xlim([50 75])
hline = refline;
hline.Color = 'r';
ylabel('Decoder Accuracy (%)')
xlabel('MCL (dB HL)')
title('Individual MCL - MCL Accuracy')

%% Self-Acc - Scatter
X = [1;2;3;4;5];
for i = 1:length(Sub_Acc_1)-1
    X = [X, [1;2;3;4;5]];
end

Sub_Acc_4no = fillmissing(Sub_Acc_4, 'constant', 0)
Sub_Acc_5no = fillmissing(Sub_Acc_5, 'constant', 0)

for i = 1:length(X)
    eval(['scatter(X(i,:),[Sub_Acc_' + string(i) + ']'', ''filled''); hold on']);
end
ylim([40 100])
xlim([0 6])
set(gcf, 'color','white')
set(gca,'color','white','Xtick', [1,2,3,4, 5]);
ax = plot(X(:,1)', [Ave_Acc_1, Ave_Acc_2, Ave_Acc_3, Ave_Acc_4,Ave_Acc_5] ,'--k'); grid on


%% dB SPL - Acc & Corr - All
%load('C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\DATA_withSNR.mat');
% 컨디션별 평균치
dBSPL = [];
Acc_cond= [];
for s = 1:length(DATA_withSNR)
    
    dBSPL = [dBSPL, double(DATA_withSNR(s).MCL)];
    dBSPL = [dBSPL, double(DATA_withSNR(s).dB20)];
    dBSPL = [dBSPL, (double(DATA_withSNR(s).MCL)+double(DATA_withSNR(s).SI90))];
    dBSPL = [dBSPL, (double(DATA_withSNR(s).MCL)+double(DATA_withSNR(s).SRT))];
    Acc_cond = [Acc_cond, DATA_withSNR(s).Acc_MCL];
    Acc_cond = [Acc_cond, DATA_withSNR(s).Acc_20];
    Acc_cond = [Acc_cond, DATA_withSNR(s).Acc_90];
    Acc_cond = [Acc_cond, DATA_withSNR(s).Acc_SRT];
end

% 내림 차순
[dBSPL,q] = sort(dBSPL,'descend');
Acc_desc = [];
for j = 1:length(q)
    Acc_desc = [Acc_desc, Acc_cond(q(j))];
end

figure(25)
%plot(MCL_all(:,1), MCL_all(:,2), 'ok', 'LineWidth', 1.5);
scatter(dBSPL, Acc_desc, 'k'); grid on
set(gcf, 'color','white')
ylim([30 100])
xlim([15 75])
hline = refline;
hline.Color = 'r';
ylabel('Decoder Accuracy (%)')
xlabel('dB SPL')
title('Individual SPL - Accuracy')


% 평균 안낸거
dBSPL = [];
Acc_cond_a= [];
for s = 1:length(DATA_withSNR)
    
    for r = 1:7
        dBSPL = [dBSPL, double(DATA_withSNR(s).MCL)];end
    for r = 1:7
        dBSPL = [dBSPL, double(DATA_withSNR(s).dB20)];end
    for r = 1:7
        dBSPL = [dBSPL, (double(DATA_withSNR(s).MCL)+double(DATA_withSNR(s).SI90))];end
    for r = 1:7
        dBSPL = [dBSPL, (double(DATA_withSNR(s).MCL)+double(DATA_withSNR(s).SRT))];end
    Acc_cond_a = [Acc_cond_a, all_acc_mcl(s,:)];
    Acc_cond_a = [Acc_cond_a, all_acc_20(s,:)];
    Acc_cond_a = [Acc_cond_a, all_acc_90(s,:)];
    Acc_cond_a = [Acc_cond_a, all_acc_srt(s,:)];
end

% 내림 차순
[dBSPL,q] = sort(dBSPL,'descend');
Acc_desc_a = [];
for j = 1:length(q)
    Acc_desc_a = [Acc_desc_a, Acc_cond_a(q(j))];
end

figure(26)
%plot(MCL_all(:,1), MCL_all(:,2), 'ok', 'LineWidth', 1.5);
scatter(dBSPL, Acc_desc_a, 'k'); grid on
set(gcf, 'color','white')
ylim([0 110])
xlim([15 75])
hline = refline;
hline.Color = 'r';
ylabel('Decoder Accuracy (%)')
xlabel('dB SPL')
title('Individual SPL - Accuracy')

% unatt speech 와의 차이 값.
diffSPL = [];
Acc_cond_diff = [];
for s = 1:length(DATA_withSNR)
    
    for r = 1:7
        diffSPL = [diffSPL, 0];end
    for r = 1:7
        diffSPL = [diffSPL, -20];end
    for r = 1:7
        diffSPL = [diffSPL, double(DATA_withSNR(s).SI90)];end
    for r = 1:7
        diffSPL = [diffSPL, double(DATA_withSNR(s).SRT)];end
    Acc_cond_diff = [Acc_cond_diff, all_acc_mcl(s,:)];
    Acc_cond_diff = [Acc_cond_diff, all_acc_20(s,:)];
    Acc_cond_diff = [Acc_cond_diff, all_acc_90(s,:)];
    Acc_cond_diff = [Acc_cond_diff, all_acc_srt(s,:)];
    
end

% 내림 차순
[diffSPL,q] = sort(diffSPL,'descend');
Acc_desc_diff = [];
for j = 1:length(q)
    Acc_desc_diff = [Acc_desc_diff, Acc_cond_diff(q(j))];
end

figure(27)
%plot(MCL_all(:,1), MCL_all(:,2), 'ok', 'LineWidth', 1.5);
scatter(diffSPL, Acc_desc_diff, 'k'); grid on
set(gcf, 'color','white')
ylim([0 110])
%xlim([15 75])
hline = refline;
hline.Color = 'r';
ylabel('Decoder Accuracy (%)')
xlabel('difference dB SPL')
title('Individual difference SPL to Unatt - Accuracy')

% Correlation
% SPL
dBSPL = [];
Corr_cond= [];
for s = 1:length(DATA_withSNR)
    
        for r = 1:46
            for rr = 1:7
                dBSPL = [dBSPL, double(DATA_withSNR(s).MCL)];end
            for rr = 1:7
                dBSPL = [dBSPL, double(DATA_withSNR(s).dB20)];end
            for rr = 1:7
                dBSPL = [dBSPL, (double(DATA_withSNR(s).MCL)+double(DATA_withSNR(s).SI90))];end
            for rr = 1:7
                dBSPL = [dBSPL, (double(DATA_withSNR(s).MCL)+double(DATA_withSNR(s).SRT))];end
        end
%     Corr_cond = [Corr_cond, Ave_Corr_att_MCL(s)];
%     Corr_cond = [Corr_cond, Ave_Corr_att_20(s)];
%     Corr_cond = [Corr_cond, Ave_Corr_att_90(s)];
%     Corr_cond = [Corr_cond, Ave_Corr_att_SRT(s)];

     Corr_cond = [Corr_cond, Sub_Corr_att_MCL{s}];
     Corr_cond = [Corr_cond, Sub_Corr_att_20{s}];
     Corr_cond = [Corr_cond, Sub_Corr_att_90{s}];
     Corr_cond = [Corr_cond, Sub_Corr_att_SRT{s}];
end

% 내림 차순
[dBSPL,q] = sort(dBSPL,'descend');
Corr_desc = [];
for j = 1:length(q)
    Corr_desc = [Corr_desc, Corr_cond(q(j))];
end

figure(28)
%plot(MCL_all(:,1), MCL_all(:,2), 'ok', 'LineWidth', 1.5);
sz = 10;
scatter(dBSPL, Corr_desc, sz, 'k'); grid on
set(gcf, 'color','white')
ylim([-0.3 0.4])
xlim([15 75])
hline = refline;
hline.Color = 'r';
ylabel('Mean Correlation')
xlabel('dB SPL')
title('Individual dB SPL - Correlation')

% diff SPL
diffSPL = [];
Corr_cond_diff= [];
for s = 1:length(DATA_withSNR)
    
    for r = 1:46
        for rr = 1:7
            diffSPL = [diffSPL, 0];end
        for rr = 1:7
            diffSPL = [diffSPL, -20];end
        for rr = 1:7
            diffSPL = [diffSPL, double(DATA_withSNR(s).SI90)];end
        for rr = 1:7
            diffSPL = [diffSPL, double(DATA_withSNR(s).SRT)];end
    end
%     Corr_cond_diff = [Corr_cond_diff, Ave_Corr_att_MCL(s)];
%     Corr_cond_diff = [Corr_cond_diff, Ave_Corr_att_20(s)];
%     Corr_cond_diff = [Corr_cond_diff, Ave_Corr_att_90(s)];
%     Corr_cond_diff = [Corr_cond_diff, Ave_Corr_att_SRT(s)];

     Corr_cond_diff = [Corr_cond_diff, Sub_Corr_att_MCL{s}];
     Corr_cond_diff = [Corr_cond_diff, Sub_Corr_att_20{s}];
     Corr_cond_diff = [Corr_cond_diff, Sub_Corr_att_90{s}];
     Corr_cond_diff = [Corr_cond_diff, Sub_Corr_att_SRT{s}];

end

% 내림 차순
[diffSPL,q] = sort(diffSPL,'descend');
Corr_desc_diff = [];
for j = 1:length(q)
    Corr_desc_diff = [Corr_desc_diff, Corr_cond_diff(q(j))];
end

figure(29)
%plot(MCL_all(:,1), MCL_all(:,2), 'ok', 'LineWidth', 1.5);
scatter(diffSPL, Corr_desc_diff, 10 , 'k'); grid on
set(gcf, 'color','white')
ylim([-0.3 0.4])
%xlim([15 75])
hline = refline;
hline.Color = 'r';
ylabel('Mean Correlation')
xlabel('difference dB SPL')
title('Individual difference dB SPL to Unatt - Correlation')

%% Volume difference

H_L = [16,18,21,25,26,28,29,34,35,29];        %12  /16,18,21,25,26,28,29,34,36,40,41,43
L_H = [17,19,20,22,24,27,30,32,33,36,38,40,41,42];  %14  /17,19,20,22,24,27,30,32,33,35,37,39,42,44
high_low = [];
low_high = [];
for i = 1:length(Acc)-14
    
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
trial = 42;
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
%start = [1, start];
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
    
    %fvtool(design);
    
    eeg = filtfilt(design, eeg');

    % downsample
    eeg = resample(eeg,64,srate);

    % zscore
    eeg = zscore(eeg);

    EEG{j} = eeg;
 
end
att_env={};
utt_env={};
for i = 1:trial
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


[stats,stats1,stats2,~] = mTRFattncrossval(att_env, utt_env, EEG, ...
    fs, Dir, tmin, tmax, lambda, 'verbose', 0);
%% condition - individual time-lags
stim = {};
resp = {};
for i = 1:14
    stim{i} = att_env{i};
    resp{i} = EEG{i};
end

model = {};
pred_att = {};
pred_utt = {};
acc = [];
weight = {};

for ti = 1:17
    
    acc_mcl = [];
    acc_20 = [];
    acc_90 = [];
    acc_srt = [];
    
    model{ti} = mTRFtrain(stim, resp, fs, Dir, t(ti), t(ti), lambda, 'verbose', 0);

    for i = 1:30

        j = i+14;
        if length(find(trials_mcl == j)) == 1;
            [pred_att_mcl{ti,i}, stats_mcl{ti,i}] = mTRFpredict(att_env{i+14}, EEG{i+14}, model{ti});
            [pred_utt_mcl{ti,i}, stats_mcl{ti,i}] = mTRFpredict(utt_env{i+14}, EEG{i+14}, model{ti});
            [corr_att_mcl,err_att_mcl] = mTRFevaluate(att_env{i+14}', pred_att_mcl{ti,i});
            [corr_utt_MCL,err_utt_mcl] = mTRFevaluate(utt_env{i+14}', pred_utt_mcl{ti,i});
            
            if corr_att_mcl > corr_utt_MCL
                acc_mcl = [acc_mcl,1];
            else acc_mcl = [acc_mcl,0]; end
            
        elseif length(find(trials_20 == j)) == 1;
            [pred_att_20{ti,i}, stats_20{ti,i}] = mTRFpredict(att_env{i+14}, EEG{i+14}, model{ti});
            [pred_utt_20{ti,i}, stats_20{ti,i}] = mTRFpredict(utt_env{i+14}, EEG{i+14}, model{ti});
            [corr_att_20,err_att_20] = mTRFevaluate(att_env{i+14}', pred_att_20{ti,i});
            [corr_utt_20,err_utt_20] = mTRFevaluate(utt_env{i+14}', pred_utt_20{ti,i});
            
            if corr_att_20 > corr_utt_20
                acc_20 = [acc_20,1];
            else acc_20 = [acc_20,0]; end
            
        elseif length(find(trials_90 == j)) == 1;
            [pred_att_90{ti,i}, stats_90{ti,i}] = mTRFpredict(att_env{i+14}, EEG{i+14}, model{ti});
            [pred_utt_90{ti,i}, stats_90{ti,i}] = mTRFpredict(utt_env{i+14}, EEG{i+14}, model{ti});
            [corr_att_90,err_att_90] = mTRFevaluate(att_env{i+14}', pred_att_90{ti,i});
            [corr_utt_90,err_utt_90] = mTRFevaluate(utt_env{i+14}', pred_utt_90{ti,i});
                        
            if corr_att_90 > corr_utt_90
                acc_90 = [acc_90,1];
            else acc_90 = [acc_90,0]; end
            
        elseif length(find(trials_srt == j)) == 1;
            [pred_att_srt{ti,i}, stats_srt{ti,i}] = mTRFpredict(att_env{i+14}, EEG{i+14}, model{ti});
            [pred_utt_srt{ti,i}, stats_srt{ti,i}] = mTRFpredict(utt_env{i+14}, EEG{i+14}, model{ti});
            [corr_att_SRT,err_att_srt] = mTRFevaluate(att_env{i+14}', pred_att_srt{ti,i});
            [corr_utt_SRT,err_utt_srt] = mTRFevaluate(utt_env{i+14}', pred_utt_srt{ti,i});
                        
            if corr_att_SRT > corr_utt_SRT
                acc_srt = [acc_srt,1];
            else acc_srt = [acc_srt,0]; end
            
        end
              
    end
    
    Acc_mcl(ti) = mean(acc_mcl);
    Acc_20(ti) = mean(acc_20);
    Acc_90(ti) = mean(acc_90);
    Acc_srt(ti) = mean(acc_srt);
    
%     weight{ti} = model{ti}.w;
end

% Acc_mcl = mean(acc_mcl)*100;
% Acc_20 = mean(acc_20)*100;
% Acc_90 = mean(acc_90)*100;
% Acc_srt = mean(acc_srt)*100;
% plot(Acc, '-o', 'LineWidth', 2);

figure(1)
plot(t,Acc_mcl*100, '-o', 'LineWidth',2)
title('mcl')
% ylim([50 100])
figure(2)
plot(t,Acc_20*100, '-o', 'LineWidth',2)
title('20')
% ylim([50 100])
figure(3)
plot(t,Acc_90*100, '-o', 'LineWidth',2)
title('90')
% ylim([50 100])
figure(4)
plot(t,Acc_srt*100, '-o', 'LineWidth',2)
title('srt')
% ylim([50 100])
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

% for i = 1:ti
%     figure(i)
%     set(gcf, 'color', 'w')
%     subplot(121)
%     topoplot(weight{i}(3:end),  Chanloc_ob);
% %     subplot(122)
% %     topoplot(Ave_AUD_w(3:end,i),  Chanloc_ob);
%     
%     sgtitle(t(i));
% end
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
Pilot_result(i).Corratt_SRT = corr_att_SRT;
Pilot_result(i).Corrutt = corr_unatt;
Pilot_result(i).Corrutt_MCL = corr_utt_MCL;
Pilot_result(i).Corrutt_20 = corr_utt_20;
Pilot_result(i).Corrutt_90 = corr_utt_90;
Pilot_result(i).Corrutt_SRT = corr_utt_SRT;
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
    
    
    
    