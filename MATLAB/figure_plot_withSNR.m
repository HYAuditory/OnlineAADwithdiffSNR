
%% Accuracy - Condition
% acc-condi
Xa = categorical({'MCL','MCL-20dB', 'SI 90%', 'SI 50%'});
Xa = reordercats(Xa,{'MCL','MCL-20dB', 'SI 90%', 'SI 50%'});
Y = [ Ave_Acc_MCL, Ave_Acc_20, Ave_Acc_90, Ave_Acc_SRT];
Ave_Acc_std = std(Sub_Acc);
for i = 1:length(list)
    eval(['Ave_Acc_',list{i},'_std = std(Sub_Acc_',list{i},');']);
end
all_std = [Ave_Acc_MCL_std, Ave_Acc_20_std, Ave_Acc_90_std, Ave_Acc_SRT_std];

figure(24)
b = bar(Xa, Y, 'FaceColor', 'flat');   hold on
b.CData(1,:) = [0 0.4470 0.7410];
b.CData(2,:) = [0.8500 0.3250 0.0980];
b.CData(3,:) = [0.9290 0.6940 0.1250];
b.CData(4,:) = [0.4940 0.1840 0.5560];

yline(54.66, '--', 'lineWidth', 1); 
er = errorbar(Xa,Y,-all_std,all_std);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1.5;  
set(gcf, 'color', 'white')
ylim([0 100])
ylabel('Decoder Accuracy (%)')
title('Ave - Accuracy - Conditions')
% plot(Xa, [ Sub_Acc_MCL; Sub_Acc_20; Sub_Acc_90; Sub_Acc_SRT], ':ok', 'lineWidth', 1, 'MarkerFaceColor' ,'w');

% saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\Ave_Accuracy_Condtions_'+string(cond)+'.jpg')

%% Correlation - Condition - bar

Ya = [mean(Ave_Corr_att_MCL), mean(Ave_Corr_att_20), mean(Ave_Corr_att_90), mean(Ave_Corr_att_SRT)];
Yu = [mean(Ave_Corr_utt_MCL), mean(Ave_Corr_utt_20), mean(Ave_Corr_utt_90), mean(Ave_Corr_utt_SRT)];

% for l = 1:length(list)
%     eval(['SSub_corr_att_',list{l},'=[];']);
%     eval(['SSub_corr_utt_',list{l},'=[];']);
% end

% for s = len
%     for l = 1:length(list)
%         eval(['SSub_corr_att_',list{l},'= [SSub_corr_att_',list{l},'; Sub_Corr_Matt_',list{l},'(:,s)];']);
%         eval(['SSub_corr_utt_',list{l},'= [SSub_corr_utt_',list{l},'; Sub_Corr_Mutt_',list{l},'(:,s)];']);
%     end
% end

for i = 1:length(list)
    eval(['Ave_Corr_att_',list{i},'_std = std(Ave_Corr_att_',list{i},');']);
    eval(['Ave_Corr_utt_',list{i},'_std = std(Ave_Corr_utt_',list{i},');']);
end
all_att_std = [Ave_Corr_att_MCL_std, Ave_Corr_att_20_std, Ave_Corr_att_90_std, Ave_Corr_att_SRT_std];
all_utt_std = [Ave_Corr_utt_MCL_std, Ave_Corr_utt_20_std, Ave_Corr_utt_90_std, Ave_Corr_utt_SRT_std];

figure(32)
b = bar(Xa, [Ya; Yu], 'FaceColor', 'flat');   hold on
% b.CData(1,:) = [0 0.4470 0.7410];
% b.CData(2,:) = [0.8500 0.3250 0.0980];
% b.CData(3,:) = [0.9290 0.6940 0.1250];
% b.CData(4,:) = [0.4940 0.1840 0.5560];
er = errorbar([Xa;Xa],[Ya;Yu],[-all_att_std; -all_utt_std],[all_att_std; all_utt_std]);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1.5;  
set(gcf, 'color', 'white')
ylabel('Mean Correlation (%)')
plot(Xa, [ Ave_Corr_att_MCL';  Ave_Corr_att_20';  Ave_Corr_att_90';  Ave_Corr_att_SRT'], ':ok', 'lineWidth', 1, 'MarkerFaceColor' ,'w');

% Example data 
model_series = [Ya; Yu]'; 
model_error = [all_att_std; all_utt_std]';
indiv = [[ Ave_Corr_att_MCL';  Ave_Corr_att_20';  Ave_Corr_att_90';  Ave_Corr_att_SRT'];[Ave_Corr_utt_MCL';  Ave_Corr_utt_20';  Ave_Corr_utt_90';  Ave_Corr_utt_SRT']]';
b = bar( model_series, 'grouped'); hold on
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(model_series);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange

for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    b = boxplot(indiv(:,1+(4*(i-1)):i*4), Xa); hold on
%     errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none', 'linewidth', 1);
%     plot(x, indiv(:,1+((i-1)*4):i*4), ':ok', 'lineWidth', 1, 'MarkerFaceColor' ,'w');
end
ylim([-0.03 0.1])
% legend('Attended', 'Unattended')
ylabel('Mean Correlation')

figure(33)
b = bar(Xa, Yu, 'FaceColor', 'flat');   hold on
b.CData(1,:) = [0 0.4470 0.7410];
b.CData(2,:) = [0.8500 0.3250 0.0980];
b.CData(3,:) = [0.9290 0.6940 0.1250];
b.CData(4,:) = [0.4940 0.1840 0.5560];
er = errorbar(Xa,Yu,-all_utt_std,all_utt_std);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1.5;  
set(gcf, 'color', 'white')
ylabel('Mean Correlation')
plot(Xa, [ Ave_Corr_utt_MCL';  Ave_Corr_utt_20';  Ave_Corr_utt_90';  Ave_Corr_utt_SRT'], ':ok', 'lineWidth', 1, 'MarkerFaceColor' ,'w');

% att / unatt 

subplot(1,2,1)
b = bar(Xa, Ya, 'FaceColor', [0 0.4470 0.7410]); hold on
ylim([-0.015 0.08])
er = errorbar(Xa,Ya,-all_att_std,all_att_std);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1.5; 
set(gcf, 'color', 'white')
ylabel('Mean Correlation')

subplot(1,2,2)
b = bar(Xa, Yu, 'FaceColor', [0.8500 0.3250 0.0980]); hold on
er = errorbar(Xa,Yu,-all_utt_std,all_utt_std);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1.5; 
ylim([-0.015 0.08])

%% Correlation - Condition - box

AU = categorical({'MCL', 'MCL-20dB', 'SI 90%', 'SI 50%'});
AU = reordercats(AU,{'MCL', 'MCL-20dB', 'SI 90%', 'SI 50%'});
dd = {'Attened','Unattened'};
figure(32)
for i = 1:2
    subplot(1,2,i)
    if i == 1
        h = boxplot([Ave_Corr_att_MCL, Ave_Corr_att_20, Ave_Corr_att_90, Ave_Corr_att_SRT], AU, 'color','b');
        ylabel('Mean correlation', 'FontSize', 15);
    else h = boxplot([Ave_Corr_utt_MCL, Ave_Corr_utt_20, Ave_Corr_utt_90, Ave_Corr_utt_SRT], AU, 'color','r'); end
    set(h,{'linew'},{1.5})
    title(dd{i},'FontSize', 15)   
    ylim([-0.03 0.1])
    set(gca,'linew',1)
end

%=========================================



%% SPL - acc

figure(27)
% 전부
gscatter(dBSPL, Acc_cond_a,sublabel, 'k', 'o+*pxsd^h<>v_|.',0.0001);    
hold on
% mcl
gscatter(dBSPL([submcl]), Acc_cond_a([submcl]), ...
            sublabel([submcl]),[0 0.4470 0.7410], 'o+*pxsd^h<>v_|.');  hold on
% 20
gscatter(dBSPL([sub20]), Acc_cond_a([sub20]),...
            sublabel([sub20]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.'); 
% 90
gscatter(dBSPL([sub90]), Acc_cond_a([sub90]),...
            sublabel([sub90]), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.');  
% srt 만
gscatter(dBSPL([subsrt]), Acc_cond_a([subsrt]),...
            sublabel([subsrt]), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.');
for m = 1:length(Slope_spl)
    h(m) = refline(Slope_spl(m), Intercept_spl(m));
end

% set(h(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(h(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(h(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(h(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(h(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)

ylim([0 110])
% legend(h(1:5),{'SRT','SI90', '20dB', 'MCL','All'}, 'AutoUpdate','off','location','northwest')
ylabel('Decoder Accuracy (%)')
xlabel('SPL (dBA)')
title('Individual SPL - Accuracy - Sub Condition trials')
s=findobj('type','legend')
delete(s)

figure(28)
% curve fitting
x = dBSPL_desc;
[fit,S] = polyfit(dBSPL_desc, Acc_desc_a, 2);
[yfit,delta] = polyval(fit,dBSPL_desc,S);
%cur = (fit(1)*(x.^2))+(fit(2)*x)+(fit(3));
% [yfit,delta] = polyconf(fit, dBSPL_desc, S);

ysem_1 = yfit+delta;
ysem_2 = yfit-delta;
stand2 = [ysem_1, fliplr(ysem_2)];

% confidence intervals
sem = std(yfit)/sqrt(length(yfit));

N = length(yfit);
CI95 = tinv([0.025 0.975], N-1);                    % Calculate 95% Probability Intervals Of t-Distribution
yCI95 = bsxfun(@times, sem, CI95(:));              % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ‘x’

ysem = yfit+yCI95;
x2 = [dBSPL_desc, fliplr(dBSPL_desc)];
stand = [ysem(1,:), fliplr(ysem(2,:))];

p = fill(x2, stand, 'r'); hold on
p.FaceColor = [0.2 0.2 0.2]; 
p.EdgeColor = 'none'; 
p.FaceAlpha = 0.3;
plot(dBSPL_desc, yfit, '-', 'color', [.25 .25 .25], 'LineWidth', 2); 
ylim([0 110])

%==========================================
%=============================== diff spl =
%==========================================
figure(30)
% 전부
scatter(diffSPL_desc, Acc_desc_diff,'k'); 
hold on
% mcl +20dB
scatter(diffSPL_desc(1:mcl20cut_diff(end)), Acc_desc_diff(1:mcl20cut_diff(end)),'MarkerEdgeColor', [0 0.4470 0.7410]);
% 20 
scatter(diffSPL_desc(mclcut(end)+1:mcl20cut_diff(end)), Acc_desc_diff(mclcut(end)+1:mcl20cut_diff(end)),'MarkerEdgeColor',[0.8500 0.3250 0.0980]); grid on 
% 90+ srt
scatter(diffSPL_desc([si90cut_diff]), Acc_desc_diff([si90cut_diff]),'MarkerEdgeColor', [0.9290 0.6940 0.1250]);  
% srt 만
scatter(diffSPL_desc(srtcut_diff), Acc_desc_diff(srtcut_diff),'MarkerEdgeColor', [0.4940 0.1840 0.5560]); 
legend({'MCL', 'MCL-20dB', 'SI90', 'SRT'}, 'AutoUpdate','off');
m = lsline;
set(m(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(m(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(m(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(m(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(m(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
set(gcf, 'color','white')
ylim([0 180])
legend(m(1:5),{'SRT','SI90', '20dB', 'MCL', 'All'}, 'AutoUpdate','off','location','northwest')
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

figure(29)
% 전부
gscatter(diffSPL, Acc_cond_diff,sublabel, 'k', 'o+*pxsd^h<>v_|.',0.0001);    
hold on
% mcl+20
gscatter(diffSPL([submcl,sub20]), Acc_cond_diff([submcl,sub20]), ...
            sublabel([submcl,sub20]),[0 0.4470 0.7410], 'o+*pxsd^h<>v_|.');  hold on
% 20
gscatter(diffSPL([sub20]), Acc_cond_diff([sub20]),...
            sublabel([sub20]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.');  
% srt + 90
gscatter(diffSPL([sub90]), Acc_cond_diff([sub90]),...
            sublabel([sub90]), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.');  
% srt 만
gscatter(diffSPL([subsrt]), Acc_cond_diff([subsrt]),...
            sublabel([subsrt]), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.'); 

for i = 1:length(Slope)
    h(i) = refline(Slope(i), Intercept(i));
end
% set(h(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(h(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(h(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(h(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(h(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)

ylim([0 110])
legend(h(1:5),{'SI 50%','SI 90%', 'MCL-20dB', 'MCL'}, 'AutoUpdate','off','location','northwest')
% curve fitting
x = diffSPL_desc;
[fit,S] = polyfit(diffSPL_desc, Acc_desc_diff, 2);
[yfit,delta] = polyval(fit,diffSPL_desc,S);
% cur = (fit(1)*(x.^2))+(fit(2)*x)+(fit(3));
plot(diffSPL_desc, yfit, ':', 'color', [.25 .25 .25], 'LineWidth', 3.3);
set(gcf, 'color','white')
ylabel('Decoder Accuracy (%)')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Accuracy')

%% SPL - corr

%attended
figure(32)
% 전부
% gscatter(dBSPL, Corr_att_cond,sublabel,[0 0.4470 0.7410], 'o+*pxsd^' );    
% mcl
gscatter(dBSPL([submcl]), Corr_att_cond([submcl]), ...
            sublabel([submcl]),'k', 'o+*pxsd^h<>v_|.',0.0001);hold on
% 20
gscatter(dBSPL([sub20]), Corr_att_cond([sub20]),...
            sublabel([sub20]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.'); 
% 90
gscatter(dBSPL([sub90]), Corr_att_cond([sub90]),...
            sublabel([sub90]), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.');  
% srt 만
gscatter(dBSPL([subsrt]), Corr_att_cond([subsrt]),...
            sublabel([subsrt]), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.'); 
for i = 1:length(Slope_att)
    h(i) = refline(Slope_att(i), Intercept_att(i));
end
% set(h(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(h(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(h(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(h(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(h(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
set(gcf, 'color','white')
% curve fitting
x = dBSPL_desc;
[fit, S] = polyfit(dBSPL_desc, Corr_att_desc, 2);
% cur = (fit(1)*(x.^2))+(fit(2)*x)+(fit(3));
[yfit,delta] = polyval(fit, dBSPL_desc, S);
plot(dBSPL_desc, yfit, ':', 'color', [.25 .25 .25], 'LineWidth', 3.3);

ylim([-0.15 0.25])
legend(h(1:4), {'SI 50%','SI 90%', 'MCL-20dB', 'MCL'}, 'AutoUpdate','off','location','northwest')
ylabel('Mean Correlation')
xlabel('SPL (dBA)')
title('Attended')


%unattended
figure(33)
% 전부
% gscatter(dBSPL, Corr_utt_cond,sublabel,[0 0.4470 0.7410], 'o+*pxsd^' );    
% mcl
gscatter(dBSPL([submcl]), Corr_utt_cond([submcl]), ...
            sublabel([submcl]),'k', 'o+*pxsd^h<>v_|.',0.0001); hold on
% 20
gscatter(dBSPL([sub20]), Corr_utt_cond([sub20]),...
            sublabel([sub20]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.');
% 90
gscatter(dBSPL([sub90]), Corr_utt_cond([sub90]),...
            sublabel([sub90]), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.');  
% srt 만
gscatter(dBSPL([subsrt]), Corr_utt_cond([subsrt]),...
            sublabel([subsrt]), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.'); 
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
x = dBSPL_desc;
[fit, S] = polyfit(dBSPL_desc, Corr_utt_desc, 2);
% cur = (fit(1)*(x.^2))+(fit(2)*x)+(fit(3));
[yfit,delta] = polyval(fit, dBSPL_desc, S);
plot(dBSPL_desc, yfit, ':', 'color', [.25 .25 .25], 'LineWidth', 3.3);

ylim([-0.15 0.25])
legend(u(1:4), {'SI 50%','SI 90%', 'MCL-20dB', 'MCL'}, 'AutoUpdate','off','Location','northwest')
ylabel('Mean Correlation')
xlabel('SPL (dBA)')
title('Unatteded')

%% Diff - acc
%=================================================
%----------------- Acc unatt speech 와의 SPL 차이 값.
diffSPL = [];
Acc_cond_diff = [];
Indi_diff_SI90 = [];
Indi_diff_SRT = [];
sublabel = [];

len = [1,3,4,5,6,8,11,12,13,15,17,20,23];
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
end

% 내림 차순
[diffSPL_desc,q] = sort(diffSPL,'descend');
Indi_diff_SRT = sort(Indi_diff_SRT, 'descend');
Indi_diff_SI90 = sort(Indi_diff_SI90, 'descend');
si90cut_diff = [];
srtcut_diff = [];
Acc_desc_diff = [];
for j = 1:length(q)
    Acc_desc_diff = [Acc_desc_diff, Acc_cond_diff(q(j))];
end

mclcut_diff = find(diffSPL_desc == 0);
mcl20cut_diff = find(diffSPL_desc == -20);
for i = 1:length(Indi_diff_SRT)
    si90cut_diff = [si90cut_diff, find(diffSPL_desc == Indi_diff_SI90(i))];
    srtcut_diff = [srtcut_diff, find(diffSPL_desc == Indi_diff_SRT(i))];
end
srtcut_diff = unique(srtcut_diff);
si90cut_diff = unique(si90cut_diff);

figure(28)
clf
% 전부
% scatter(diffSPL_desc, Acc_desc_diff,'k'); 
% mcl +20dB
% scatter(diffSPL_desc(1:mcl20cut_diff(end)), Acc_desc_diff(1:mcl20cut_diff(end)),'MarkerEdgeColor', [0 0.4470 0.7410]);
% 20 + 90 + srt
scatter(diffSPL_desc(mclcut_diff(end)+1:end), Acc_desc_diff(mclcut_diff(end)+1:end),'MarkerEdgeColor',[0.8500 0.3250 0.0980]); grid on 
% 90+ srt
hold on
scatter(diffSPL_desc([si90cut_diff,srtcut_diff]), Acc_desc_diff([si90cut_diff,srtcut_diff]),'MarkerEdgeColor', [0.9290 0.6940 0.1250]);  
% srt 만
scatter(diffSPL_desc(srtcut_diff), Acc_desc_diff(srtcut_diff),'MarkerEdgeColor', [0.4940 0.1840 0.5560]); 
% legend({'MCL', 'MCL-20dB', 'SI90', 'SRT'}, 'AutoUpdate','off');
m = lsline;
% set(m(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
% set(m(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(m(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(m(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(m(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
set(gcf, 'color','white')
ylim([0 180])
legend(m(1:3),{'SRT','SI90', '20dB'}, 'AutoUpdate','off','location','northwest')
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
clf
% 전부
% gscatter(diffSPL, Acc_cond_diff,sublabel, [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    

% mcl+20
% gscatter(diffSPL([submcl,sub20]), Acc_cond_diff([submcl,sub20]), ...
%             sublabel([submcl,sub20]),[0 0.4470 0.7410], 'o+*pxsd^h<>v_|.');  hold on
% srt + 90 + 20
gscatter(diffSPL([sub20,sub90,subsrt]), Acc_cond_diff([sub20,sub90,subsrt]),...
            sublabel([sub20,sub90,subsrt]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); hold on
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
% set(h(4), 'color', [0 0.4470 0.7410], 'LineWidth', 2)
set(h(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 2)
set(h(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 2)
set(h(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)
% % curve fitting
% x = diffSPL_desc;
% [fit,S] = polyfit(diffSPL_desc, Acc_desc_diff, 2);
% % cur = (fit(1)*(x.^2))+(fit(2)*x)+(fit(3));
% [yfit,delta] = polyval(fit,diffSPL_desc,S);
% plot(diffSPL_desc, yfit, ':', 'color', [.25 .25 .25], 'LineWidth', 2);
% find peak
[maxy, idx] = max(yfit);
peakdiffspl = diffSPL_desc(idx);
xlim([-45 -18])
ylim([0 110])
% legend(h(1:3),{'SRT','SRT+SI90', 'SRT+SI90+20dB'}, 'AutoUpdate','off','location','northwest')
set(gcf, 'color','white')
ylabel('Decoder Accuracy (%)')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Accuracy')
xticks(linspace(-45,-20,6))
s=findobj('type','legend')
delete(s)
% saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\DiffSPL_Acc_'+string(label)+'.jpg')
%% corr -corr -p-value
%Corr_utt_cond_diff
y = Acc_cond_diff;
[r_20,p_20] = corrcoef(diffSPL([sub20,sub90,subsrt]), y([sub20,sub90,subsrt]));
[r_90,p_90] = corrcoef(diffSPL([sub90,subsrt]), y([sub90,subsrt]));
[r_50,p_50] = corrcoef(diffSPL([subsrt]), y([subsrt]));
[r_mcl,p_mcl] = corrcoef(diffSPL, y);
% self -diffspl
x = diffSPL_desc(si90cut_diff);
y = Acc_desc_diff(si90cut_diff);
[r,p] = corrcoef(x,y);

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
% scatter(diffSPL_desc, Corr_att_desc_diff,'MarkerEdgeColor', [0 0.4470 0.7410]);    
hold on
% srt si90 20
scatter(diffSPL_desc(mclcut_diff(end)+1:end), Corr_att_desc_diff(mclcut_diff(end)+1:end),'MarkerEdgeColor',[0.8500 0.3250 0.0980]); grid on 
set(gcf, 'color','white')
% mcl&mcl20 제외 = srt&si90
scatter(diffSPL_desc(mcl20cut_diff(end)+1:end), Corr_att_desc_diff(mcl20cut_diff(end)+1:end),'MarkerEdgeColor', [0.9290 0.6940 0.1250]);  
% srt 만
scatter(diffSPL_desc(srtcut_diff), Corr_att_desc_diff(srtcut_diff),'MarkerEdgeColor', [0.4940 0.1840 0.5560]); 
m = lsline;
set(m(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(m(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(m(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
ylim([-0.15 0.35])
legend(m(1:3),{'SRT','SRT+SI90', 'SRT+SI90+20dB'}, 'AutoUpdate','off')
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
% scatter(diffSPL_desc, Corr_utt_desc_diff,'MarkerEdgeColor', [0 0.4470 0.7410]);    
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
% set(u(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(u(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(u(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(u(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
ylim([-0.15 0.35])
% legend(u(1:4),{'SRT','SRT+SI90', 'SRT+SI90+20dB'}, 'AutoUpdate','off')
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
% gscatter(diffSPL, Corr_att_cond_diff,sublabel,[0 0.4470 0.7410], 'o+*pxsd^', siz);    
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
% set(a(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(a(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 2)
set(a(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 2)
set(a(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)
set(gcf, 'color','white')
% curve fitting
% x = diffSPL_desc;
[fit,S] = polyfit(diffSPL_desc, Corr_att_desc_diff, 2);
[yfit, delta] = polyval(fit, diffSPL_desc,S);
% cur = (fit(1)*(x.^2))+(fit(2)*x)+(fit(3));
% plot(diffSPL_desc, yfit, ':', 'color', [.25 .25 .25], 'LineWidth', 3.3);
ylim([-0.13 0.28])
xlim([-45 -18])
% legend(a(1:3), {'SRT','SRT+SI90', 'SRT+SI90+20dB'}, 'AutoUpdate','off','location','northwest')
ylabel('Attended Correlation')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Att Correlation')
% s=findobj('type','legend')
% delete(s)
%unatt
figure(37)
% gscatter(diffSPL([submcl,sub20]), Corr_utt_cond_diff([submcl,sub20]), ...
%             sublabel([submcl,sub20]),'k', 'o+*.xsd^',0.0001);  hold on
% 전부
% gscatter(diffSPL, Corr_utt_cond_diff,sublabel,[0 0.4470 0.7410], 'o+*pxsd^', siz );    
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
% set(u(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(u(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 2)
set(u(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 2)
set(u(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)
set(gcf, 'color','white')
% curve fitting
x = diffSPL_desc;
fit = polyfit(diffSPL_desc, Corr_utt_desc_diff, 2);
cur = (fit(1)*(x.^2))+(fit(2)*x)+(fit(3));
% plot(diffSPL_desc, cur, ':', 'color', [.25 .25 .25], 'LineWidth', 3.3);
ylim([-0.13 0.28])
xlim([-45 -18])
% legend(u(1:4), {'SRT','SRT+SI90', 'SRT+SI90+20dB', 'All'}, 'AutoUpdate','off','location','northwest')
ylabel('Unattended Correlation')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Unatt Correlation')
s=findobj('type','legend')
delete(s)
%% diff spl - corr
%att
figure(34)
scatter(diffSPL_desc(1:mclcut_diff(end)), Corr_att_desc_diff(1:mclcut_diff(end)),'MarkerEdgeColor',[0 0.4470 0.7410]);  hold on  
hold on
% 20
scatter(diffSPL_desc(mclcut_diff(end)+1:mcl20cut_diff(end)), Corr_att_desc_diff(mclcut_diff(end)+1:mcl20cut_diff(end)),'MarkerEdgeColor',[0.8500 0.3250 0.0980]); grid on 
set(gcf, 'color','white')
% si90
scatter(diffSPL_desc(si90cut_diff), Corr_att_desc_diff(si90cut_diff),'MarkerEdgeColor', [0.9290 0.6940 0.1250]);  
% srt 만
scatter(diffSPL_desc(srtcut_diff), Corr_att_desc_diff(srtcut_diff),'MarkerEdgeColor', [0.4940 0.1840 0.5560]); 
m = lsline;

set(m(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(m(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(m(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(m(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
ylim([-0.15 0.35])
legend(m(1:4),{'SI 50%','SI 90%', 'MCL-20dB', 'MCL'}, 'AutoUpdate','off')
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
scatter(diffSPL_desc(1:mclcut_diff(end)), Corr_utt_desc_diff(1:mclcut_diff(end)),'k');  hold on
% mcl 제외
scatter(diffSPL_desc(mclcut_diff(end)+1:mcl20cut_diff(end)), Corr_utt_desc_diff(mclcut_diff(end)+1:mcl20cut_diff(end)),'MarkerEdgeColor',[0.8500 0.3250 0.0980]); grid on 
set(gcf, 'color','white')
% mcl&mcl20 제외 = srt&si90
scatter(diffSPL_desc(si90cut_diff), Corr_utt_desc_diff(si90cut_diff),'MarkerEdgeColor', [0.9290 0.6940 0.1250]);  
% srt 만
scatter(diffSPL_desc(srtcut_diff), Corr_utt_desc_diff(srtcut_diff),'MarkerEdgeColor', [0.4940 0.1840 0.5560]); 
u = lsline;
% set(u(5), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5,'LineStyle','--')
set(u(4), 'color', [0 0.4470 0.7410], 'LineWidth', 1.5)
set(u(3), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
set(u(2), 'color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5)
set(u(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
ylim([-0.15 0.35])
legend(u(1:4),{'SI 50%','SI 90%', 'MCL-20dB', 'MCL'}, 'AutoUpdate','off')
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
figure(36)
gscatter(diffSPL([submcl]), Corr_att_cond_diff([submcl]), ...
            sublabel([submcl]),[0 0.4470 0.7410], 'o+*pxsd^h<>v_|.');  hold on
% 전부
% gscatter(diffSPL, Corr_att_cond_diff,sublabel,[0 0.4470 0.7410], 'o+*pxsd^' );    

% mcl 제외
gscatter(diffSPL([sub20]), Corr_att_cond_diff([sub20]),...
            sublabel([sub20]), [0.8500 0.3250 0.0980], 'o+*pxsd^'); hold on 
% mcl&mcl20 제외 = srt&si90
gscatter(diffSPL([sub90]), Corr_att_cond_diff([sub90]),...
            sublabel([sub90]), [0.9290 0.6940 0.1250], 'o+*pxsd^');  
% srt 만
gscatter(diffSPL([subsrt]),Corr_att_cond_diff([subsrt]),...
            sublabel([subsrt]), [0.4940 0.1840 0.5560], 'o+*pxsd^'); 

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
x = diffSPL_desc;
[fit,S] = polyfit(diffSPL_desc, Corr_att_desc_diff, 2);
% cur = (fit(1)*(x.^2))+(fit(2)*x)+(fit(3));
[yfit,delta] = polyval(fit, x, S);

plot(diffSPL_desc, yfit, ':', 'color', [.25 .25 .25], 'LineWidth', 2.5);
ylim([-0.15 0.25])
legend(a(1:4), {'SI 50%','SI 90%', 'MCL-20dB', 'MCL'}, 'AutoUpdate','off','location','northwest')
ylabel('Mean Correlation')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Att Correlation')
% saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\DiffSPL_Corr_att_'+string(label)+'.jpg')

%unatt
figure(37)
gscatter(diffSPL([submcl]), Corr_utt_cond_diff([submcl]), ...
            sublabel([submcl]),[0 0.4470 0.7410], 'o+*pxsd^h<>v_|.');  hold on
% mcl 제외
gscatter(diffSPL([sub20]), Corr_utt_cond_diff([sub20]),...
            sublabel([sub20]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.'); 
% mcl&mcl20 제외 = srt&si90
gscatter(diffSPL([sub90]), Corr_utt_cond_diff([sub90]),...
            sublabel([sub90]), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.');  
% srt 만
gscatter(diffSPL([subsrt]),Corr_utt_cond_diff([subsrt]),...
            sublabel([subsrt]), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.'); 
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
[fit,S] = polyfit(diffSPL_desc, Corr_utt_desc_diff, 2);
% cur = (fit(1)*(x.^2))+(fit(2)*x)+(fit(3));
[yfit,delta] = polyval(fit, x, S);
plot(diffSPL_desc, yfit, ':', 'color', [.25 .25 .25], 'LineWidth', 3.3);
ylim([-0.15 0.25])
legend(u(1:4), {'SI 50%','SI 90%', 'MCL-20dB', 'MCL'}, 'AutoUpdate','off','location','northwest')
ylabel('Mean Correlation')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Unatt Correlation')
% saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\DiffSPL_Corr_utt_'+string(label)+'.jpg')

%% t-test
si90_l = [-32.3, -32.3, -31.25, -34.7, -38.85, -38.6, -30.5];
si90_r = [-26.6, -27.8, -23.45, -30.5, -33.95, -37.7, -29.3];

srt_l = [-35.84, -34.9, -34.41, -40.54, -40.81, -45.09, -34.21];
srt_r = [-32.19, -34.34, -35.23, -35.99, -38.33, -40.81, -34.79];

[h,p] = ttest(x,y,'Alpha', 0.05)

x= [Ave_Acc_MCL; Ave_Acc_20; Ave_Acc_90; Ave_Acc_SRT];
x = [x,fliplr(x')'];

x = [Ave_Acc_MCL;Ave_Acc_MCL;Ave_Acc_MCL;Ave_Acc_20;Ave_Acc_20;Ave_Acc_90];
x(:,2) = [Ave_Acc_20;Ave_Acc_90;Ave_Acc_SRT;Ave_Acc_90;Ave_Acc_SRT;Ave_Acc_SRT];

x = [Sub_Acc_MCL; Sub_Acc_SRT];
[h,p,sigPairs] = ttest_bonf(x);

%% Wilcoxon signed rank test 
% x = Sub_Acc_MCL;
% y = Sub_Acc_SRT;

x = mean(Sub_Corr_Mutt_MCL(:,len));
y = mean(Sub_Corr_Mutt_SRT(:,len));
[p,h] = signrank(x,y)

%% self - condi

% condi-self
Xc = categorical({'MCL','MCL-20dB', 'SI 90%', 'SI 50%'});
Xc = reordercats(Xc,{'MCL','MCL-20dB', 'SI 90%', 'SI 50%'});
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
er = errorbar(Xc,Y,-all_self_std,all_self_std);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1;  
set(gcf, 'color', 'white')
ylim([0 5])
ylabel('Self-Report')
% refline([0, chance]);
title('Ave - Self-report - Conditions')
plot(Xc, [Sub_Self_MCL; Sub_Self_20; Sub_Self_90; Sub_Self_SRT], ':ok', 'lineWidth', 1, 'MarkerFaceColor' ,'w')
%% DiffSPL & self
y = [Sub_Self_MCL, Sub_Self_20, Sub_Self_90, Sub_Self_SRT];

% len = [1,3,4,5,6,8,11,12,13,15,17,20,23];
diffSPL = [];
for i = 1:length(len)
    diffSPL = [diffSPL, 0]; end
for i = 1:length(len)
    diffSPL = [diffSPL, -20]; end
for s = 1:length(len)
    diffSPL = [diffSPL, double(DATA_withSNR(s).SI90)]; end
for s = 1:length(len)
    diffSPL = [diffSPL, double(DATA_withSNR(s).SRT)];
end

% no subject symbol
figure(28)
clf
% 전부
scatter(diffSPL, y,'k'); 
hold on
m = lsline;
set(m(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
set(gcf, 'color','white')
% ylim([0 180])
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
sublabel = [];
for i = 1:4 % condition 개수
    sublabel = [sublabel, linspace(1,length(len),length(len))];end
%----------- 피험자별 모양 다르게
siz = 8;
figure(29)
% mcl
gscatter(diffSPL(1:length(len)), y(1:length(len)) ,sublabel(1:length(len)), [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    
hold on
% 20
gscatter(diffSPL(1+length(len) : length(len)*2), y(1+length(len) : length(len)*2),...
            sublabel(1+length(len) : length(len)*2), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); 
% 90
gscatter(diffSPL(1+length(len)*2 : length(len)*3), y(1+length(len)*2 : length(len)*3),...
            sublabel(1+length(len)*2 : length(len)*3), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 
gscatter(diffSPL(1+length(len)*3 : length(len)*4), y(1+length(len)*3 : length(len)*4),...
            sublabel(1+length(len)*3 : length(len)*4), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 
h = refline(Slope, Intercept);
set(h, 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)
% ylim([0 110])
set(gcf, 'color','white')
ylabel('scale')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - subjective scale')
s=findobj('type','legend')
delete(s)
% estimate pearson corr
[r,p] = corrcoef(diffSPL, y)
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\Ave_Self_SPLdiff_'+string(cond)+'.jpg')
%% spldiff - beh2 acc
Beh2_cond_diff = [];
Acc_cond_diff = [];
diffSPL= [];
Indi_diff_SI90 = [];
Indi_diff_SRT = [];
% len = [1,3,4,5,6,8,11,12,13,15,17];
i=1;
for s = len   
        diffSPL = [diffSPL, 0];
        sublabel = [sublabel, s];

        diffSPL = [diffSPL, -20];
        sublabel = [sublabel, s];

        diffSPL = [diffSPL, double(DATA_withSNR(s).SI90)];
        Indi_diff_SI90 = [Indi_diff_SI90, double(DATA_withSNR(s).SI90)];
        sublabel = [sublabel, s];

        diffSPL = [diffSPL, double(DATA_withSNR(s).SRT)];
        Indi_diff_SRT = [Indi_diff_SRT, double(DATA_withSNR(s).SRT)];
        sublabel = [sublabel, s];
    
    Beh2_cond_diff = [Beh2_cond_diff, Sub_Beh2_att_MCL(i)];
    Beh2_cond_diff = [Beh2_cond_diff, Sub_Beh2_att_20(i)];
    Beh2_cond_diff = [Beh2_cond_diff, Sub_Beh2_att_90(i)];
    Beh2_cond_diff = [Beh2_cond_diff, Sub_Beh2_att_SRT(i)];
    
    Acc_cond_diff = [Acc_cond_diff, Sub_Acc_MCL(i)];
    Acc_cond_diff = [Acc_cond_diff, Sub_Acc_20(i)];
    Acc_cond_diff = [Acc_cond_diff, Sub_Acc_90(i)];
    Acc_cond_diff = [Acc_cond_diff, Sub_Acc_SRT(i)];    
    i = i+1;
end

% 내림 차순
[diffSPL_desc,q] = sort(diffSPL,'descend');
Beh2_desc_diff = [];
Acc_desc_diff = [];
for j = 1:length(q)
    Beh2_desc_diff = [Beh2_desc_diff, Beh2_cond_diff(q(j))];
    Acc_desc_diff = [Acc_desc_diff, Acc_cond_diff(q(j))];
end

% Scatter
figure(19)
scatter(diffSPL_desc, Beh2_desc_diff,'k');
m = lsline;
Slope = [];
Intercept = [];
% line data save
for i = 1:length(m)
    B = [ones(size(m(i).XData(:))), m(i).XData(:)]\m(i).YData(:);
    Slope(i) = B(2);
    Intercept(i) = B(1);
end
%----------- 피험자별 모양 다르게
siz = 8;
figure(19)
clf
% mcl
gscatter(linspace(0,0,length(len)), Sub_Beh2_att_MCL ,len, [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    
hold on
% 20
gscatter(linspace(-20,-20,length(len)), Sub_Beh2_att_20,...
            len, [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); 
% 90
gscatter(Indi_diff_SI90, Sub_Beh2_att_90,...
            len, [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 
gscatter(Indi_diff_SRT, Sub_Beh2_att_SRT,...
            len, [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 
h = refline(Slope, Intercept);
set(h, 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)
% ylim([0 110])
set(gcf, 'color','white')
ylabel('Accuracy (%)')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Behvior2')
s=findobj('type','legend')
delete(s)

% Pearson corr
[r_be2,p_be2] = corrcoef(diffSPL_desc, Beh2_desc_diff)
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\Ave_Beh2_SPLdiff_'+string(cond)+'.jpg')

%------------------------------------------------------------------------%
% spldiff - mean decoder acc
% Scatter
figure(15)
scatter(diffSPL_desc, Acc_desc_diff,'k');
m = lsline;
Slope = [];
Intercept = [];
% line data save
for i = 1:length(m)
    B = [ones(size(m(i).XData(:))), m(i).XData(:)]\m(i).YData(:);
    Slope(i) = B(2);
    Intercept(i) = B(1);
end
%----------- 피험자별 모양 다르게
siz = 8;
figure(15)
clf
% mcl
gscatter(linspace(0,0,length(len)), Sub_Acc_MCL ,len, [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    
hold on
% 20
gscatter(linspace(-20,-20,length(len)), Sub_Acc_20,...
            len, [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); 
% 90
gscatter(Indi_diff_SI90, Sub_Acc_90,...
            len, [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 
gscatter(Indi_diff_SRT, Sub_Acc_SRT,...
            len, [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 
h = refline(Slope, Intercept);
set(h, 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)
ylim([20 100])
set(gcf, 'color','white')
ylabel('Decoder Accuracy (%)')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Mean Acc')
s=findobj('type','legend')
delete(s)
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\Ave_MeanAcc_SPLdiff_'+string(cond)+'.jpg')
% Pearson corr
[r_ma,p_ma] = corrcoef(diffSPL_desc, Acc_desc_diff)

%% Behavior 2 - Decoder accuracy
figure(39)
scatter(Beh2_cond_diff, Acc_cond_diff, 'k');
xlabel('Behavior test 2 (%)')
ylabel('Decoder Accuracy (%)')
m = refline;
Slope = [];
Intercept = [];
% line data save
B = [ones(size(m.XData(:))), m.XData(:)]\m.YData(:);
Slope = B(2);
Intercept = B(1);

% xlim([0 100])
% ylim([0 100])

%----------- 피험자별 모양 다르게
siz = 8;
figure(39)
clf
% mcl
gscatter(Beh2_cond_diff(1:4:length(Beh2_cond_diff)), Acc_cond_diff(1:4:length(Beh2_cond_diff)) ,len, [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    
hold on
% 20
gscatter(Beh2_cond_diff(2:4:length(Beh2_cond_diff)), Acc_cond_diff(2:4:length(Beh2_cond_diff)),...
            len, [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); 
% 90
gscatter(Beh2_cond_diff(3:4:length(Beh2_cond_diff)), Acc_cond_diff(3:4:length(Beh2_cond_diff)),...
            len, [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 
gscatter(Beh2_cond_diff(4:4:length(Beh2_cond_diff)), Acc_cond_diff(4:4:length(Beh2_cond_diff)),...
            len, [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 
h = refline(Slope, Intercept);
set(h, 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)
ylim([20 100])
set(gcf, 'color','white')
xlabel('Behavior test 2 (%)')
ylabel('Decoder Accuracy (%)')
title('Behavior 2 - Mean Acc')
s=findobj('type','legend')
delete(s)

% Pearson corr
[r_b2,p_b2] = corrcoef(Beh2_cond_diff, Acc_cond_diff)
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\Ave_MeanAcc_Beh2_'+string(cond)+'.jpg')
%% DA - beh2 - self - scatter
% 내림 차순

Indi_SRT = sort(Indi_SRT, 'descend');
Indi_SI90 = sort(Indi_SI90, 'descend');
srtcut = [];
si90cut = [];

x = [Sub_Beh2_att_MCL, Sub_Beh2_att_20, Sub_Beh2_att_90, Sub_Beh2_att_SRT];
y = [Sub_Acc_MCL, Sub_Acc_20, Sub_Acc_90, Sub_Acc_SRT];
% x = [Sub_Self_MCL, Sub_Self_20, Sub_Self_90, Sub_Self_SRT];

% acc - beh2
scatter(x,y, 'k')
% xlim([0 5])
xlim([0 100])
ylim([0 100])
% xlabel('Self report answer')
xlabel('Behavior 2 correct answer rate (%)')
ylabel('Decoder Accuracy (%)')
refline

% self report
a = [];
for i = 1:5
    a = [a, ones(1,7)*i];
end
scatter(a, [Sub_Acc_1, Sub_Acc_2, Sub_Acc_3, Sub_Acc_4, Sub_Acc_5], 'k');
refline
xlim([0.5 5.5])
ylim([0 110])
xlabel('Self report answer')
ylabel('Decoder Accuracy (%)')
xticks([1,2,3,4,5]); yticks(0:20:100);

%% self - acc
len = [1,3,4,5,6,8,11,12,13,15,17,20,23];
for cont = 1:5
    eval(['all_acc_',num2str(cont),' = [];']);
end

for i = len
    
    for cont = 1:5
        eval(['all_acc_',num2str(cont),' = [all_acc_',num2str(cont),', DATA_withSNR(i).all_acc_',num2str(cont),'];']);end
end

a = [];
for i = 1:5
    a = [a, ones(1,eval(['length(all_acc_',num2str(i),')']))*i];
end
scatter(a, [all_acc_1, all_acc_2, all_acc_3, all_acc_4, all_acc_5], 'k'); grid on
% r = refline
% r.LineWidth = 1.5
% r.Color = 'k'
hold on
xlim([0.5 5.5])
ylim([0 110])
xlabel('Self report answer')
ylabel('Decoder Accuracy (%)')
xticks([1,2,3,4,5]); yticks(0:20:100);
[fit,S] = polyfit(a, [all_acc_1, all_acc_2, all_acc_3, all_acc_4, all_acc_5], 2);
[yfit,delta] = polyval(fit,a,S);
plot(a, yfit, ':', 'color', [.25 .25 .25], 'LineWidth', 3.3);

%% MCL SRT
% mcl
figure(40)
clf
bar(1, mean(Sub_MCL))
mcl_std = std(double(Sub_MCL)); hold on
er = errorbar(1, mean(Sub_MCL),-mcl_std,mcl_std);  
er.Color = [0 0 0];  
er.LineStyle = 'none';  
er.LineWidth = 1;  
ylabel('SPL (dBA)')
ylim([50 75])
sty = {'o','+','*','p','x','s','d','^','h','<','>','v','_','|','.','.'};
for i = 1:length(Sub_90)
    plot(1,Sub_MCL(i), eval(['''',sty{i},'k''']), 'MarkerFaceColor' ,'w');
end
%si90&si50
y = [mean(Sub_90_L),mean(Sub_90),mean(Sub_90_R);,...
                mean(Sub_SRT_L),mean(Sub_SRT),mean(Sub_SRT_R)];
si90_l_std = std(double(Sub_90_L));
si90_r_std = std(double(Sub_90_R));
si90_std = std(double(Sub_90));
srt_l_std = std(double(Sub_SRT_L));
srt_r_std = std(double(Sub_SRT_R));
srt_std = std(double(Sub_SRT));

ngroups = size(y, 1);
nbars = size(y, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5)); 

figure(41)
clf
b =bar([1,2], y); hold on
err = [si90_l_std,si90_std,si90_r_std; srt_l_std,srt_std,srt_r_std];
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    er = errorbar(x, y(:,i), err(:,i), '.');
    er.Color = [0 0 0];  
    er.LineStyle = 'none';  
    er.LineWidth = 1; 
end
ylabel('SPL difference from ignored sentence')
ylim([-50 0])

for i = 1:length(Sub_90)
    plot([1,2],[Sub_90(i);Sub_SRT(i)], eval(['''',sty{i},'k''']), 'MarkerFaceColor' ,'w');
end


%% All conditions scatter & SPL diff - Acc
%----------------- Acc unatt speech 와의 SPL 차이 값.
diffSPL = [];
Acc_cond_diff = [];
Indi_diff_SI90 = [];
Indi_diff_SRT = [];
sublabel = [];
self_cond_diff = [];
diffSPL_self = [];

len = [1,3,4,5,6,7,8,9,11,13,14,15,17,20,22,23];%[1,3,4,5,6,8,11,12,13,15,17,20,23];
label = 'rej8';
i = 1;
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
%     Acc_cond_diff = [Acc_cond_diff, all_acc_mcl(s,:)];
%     Acc_cond_diff = [Acc_cond_diff, all_acc_20(s,:)];
%     Acc_cond_diff = [Acc_cond_diff, all_acc_90(s,:)];
%     Acc_cond_diff = [Acc_cond_diff, all_acc_srt(s,:)];
    % Offline
    Acc_cond_diff = [Acc_cond_diff, OffSub_Acc_mcl(i)];
    Acc_cond_diff = [Acc_cond_diff, OffSub_Acc_20(i)];
    Acc_cond_diff = [Acc_cond_diff, OffSub_Acc_90(i)];
    Acc_cond_diff = [Acc_cond_diff, OffSub_Acc_srt(i)];
    i = i+1;

end

% 내림 차순
[diffSPL_desc,q] = sort(diffSPL,'descend');
Indi_diff_SRT = sort(Indi_diff_SRT, 'descend');
Indi_diff_SI90 = sort(Indi_diff_SI90, 'descend');
si90cut_diff = [];
srtcut_diff = [];
Acc_desc_diff = [];
for j = 1:length(q)
    Acc_desc_diff = [Acc_desc_diff, Acc_cond_diff(q(j))];
end

mclcut_diff = find(diffSPL_desc == 0);
mcl20cut_diff = find(diffSPL_desc == -20);
for i = 1:length(Indi_diff_SRT)
    si90cut_diff = [si90cut_diff, find(diffSPL_desc == Indi_diff_SI90(i))];
    srtcut_diff = [srtcut_diff, find(diffSPL_desc == Indi_diff_SRT(i))];
end
srtcut_diff = unique(srtcut_diff);
si90cut_diff = unique(si90cut_diff);

% no subject symbol
figure(28)
clf
% 전부
scatter(diffSPL_desc, Acc_desc_diff,'k'); 
hold on
m = lsline;
set(m(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
set(gcf, 'color','white')
% ylim([0 180])
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
figure(28)
clf
% mcl
gscatter(diffSPL([submcl]), Acc_cond_diff([submcl]) ,sublabel([submcl]), [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    
hold on
% 20
gscatter(diffSPL([sub20]), Acc_cond_diff([sub20]),...
            sublabel([sub20]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); 
% 90
gscatter(diffSPL([sub90]), Acc_cond_diff([sub90]),...
            sublabel([sub90]), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt
gscatter(diffSPL([subsrt]), Acc_cond_diff([subsrt]),...
            sublabel([subsrt]), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 

h = refline(Slope, Intercept);

set(h, 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2)

ylim([0 110])
set(gcf, 'color','white')
ylabel('Decoder Accuracy (%)')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Accuracy')
leg=findobj('type','legend')
delete(leg)
% estimate pearson corr
[r,p] = corrcoef(diffSPL_desc, Acc_desc_diff)

saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\DiffSPL_Acc_'+string(label)+'.jpg')
%% All conditions / SPL diff - Corr

%================================================================%
%=============================== diff SPL
len = [1,3,4,5,6,8,11,12,13,15,17,20,23];
diffSPL = [];
Corr_att_cond_diff= [];
Corr_utt_cond_diff= [];
Indi_diff_SI90 = [];
Indi_diff_SRT = [];
for s = 1:length(len)
    
    for rr = 1:7
        diffSPL = [diffSPL, 0];end
    for rr = 1:7
        diffSPL = [diffSPL, -20];end
    for rr = 1:7
        diffSPL = [diffSPL, double(DATA_withSNR(len(s)).SI90)];
        Indi_diff_SI90 = [Indi_diff_SI90, double(DATA_withSNR(len(s)).SI90)];end
    for rr = 1:7
        diffSPL = [diffSPL, double(DATA_withSNR(len(s)).SRT)];
        Indi_diff_SRT = [Indi_diff_SRT, double(DATA_withSNR(len(s)).SRT)];end

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

% Corr-Att
figure(34)
clf
% 전부
scatter(diffSPL_desc, Corr_att_desc_diff,'MarkerEdgeColor', [0 0.4470 0.7410]);    
hold on
m = lsline;
set(m(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
ylim([-0.2 0.35])
ylabel('Mean Correlation')
xlabel('difference SPL (dBA)')
title('Individual SPL difference -Att Correlation')
Slope_att = [];
Intercept_att = [];
% line data save
B = [ones(size(m.XData(:))), m.XData(:)]\m.YData(:);
Slope_att = B(2);
Intercept_att = B(1);

% Corr-Utt
figure(35)
clf
% 전부
scatter(diffSPL_desc, Corr_utt_desc_diff,'MarkerEdgeColor', [0 0.4470 0.7410]);    
hold on
u = lsline;
set(u(1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
ylim([-0.2 0.35])
ylabel('Mean Correlation')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Unatt Correlation')
Slope_utt = [];
Intercept_utt = [];
% line data save
B = [ones(size(u.XData(:))), u.XData(:)]\u.YData(:);
Slope_utt = B(2);
Intercept_utt = B(1);

%----------- 피험자별 모양 다르게
% Corr-Att
siz = 7;
figure(34)
clf
% mcl
gscatter(diffSPL([submcl]), Corr_att_cond_diff([submcl]), sublabel([submcl]), [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz);    
hold on
% 20
gscatter(diffSPL([sub20]), Corr_att_cond_diff([sub20]),...
            sublabel([sub20]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz);
% 90
gscatter(diffSPL([sub90]), Corr_att_cond_diff([sub90]),...
            sublabel([sub90]), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 
gscatter(diffSPL([subsrt]),Corr_att_cond_diff([subsrt]),...
            sublabel([subsrt]), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 

a = refline(Slope_att, Intercept_att);
set(a, 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
set(gcf, 'color','white')
ylim([-0.2 0.25])
ylabel('Envelope Correlation')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Att Correlation')
leg=findobj('type','legend')
delete(leg)
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\DiffSPL_Ccrr_Att_'+string(label)+'.jpg')

% Corr-Utt
figure(35)
clf
% mcl
gscatter(diffSPL([submcl]), Corr_utt_cond_diff([submcl]), sublabel([submcl]), [0 0.4470 0.7410], 'o+*pxsd^h<>v_|.', siz );    
hold on
% 20 
gscatter(diffSPL([sub20]), Corr_utt_cond_diff([sub20]),...
            sublabel([sub20]), [0.8500 0.3250 0.0980], 'o+*pxsd^h<>v_|.', siz); 
% 90
gscatter(diffSPL([sub90]), Corr_utt_cond_diff([sub90]),...
            sublabel([sub90]), [0.9290 0.6940 0.1250], 'o+*pxsd^h<>v_|.', siz);  
% srt 
gscatter(diffSPL([subsrt]),Corr_utt_cond_diff([subsrt]),...
            sublabel([subsrt]), [0.4940 0.1840 0.5560], 'o+*pxsd^h<>v_|.', siz); 

u = refline(Slope_utt, Intercept_utt);
set(u, 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
set(gcf, 'color','white')
ylim([-0.2 0.25])
ylabel('Envelope Correlation')
xlabel('difference SPL (dBA)')
title('Individual SPL difference - Unatt Correlation')
leg=findobj('type','legend')
delete(leg)
saveas(gcf, 'C:\Users\LeeJiWon\Desktop\OpenBCI\AAD\Python\save_data\Ave\DiffSPL_Ccrr_Utt_'+string(label)+'.jpg')

% estimate pearson corr
[r_att,p_att] = corrcoef(diffSPL, Corr_att_cond_diff)
[r_utt,p_utt] = corrcoef(diffSPL, Corr_utt_cond_diff)


