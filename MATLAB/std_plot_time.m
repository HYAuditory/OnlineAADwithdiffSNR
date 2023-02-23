%%


%% standard error

sem_at = std(Accs(:,:,1))/sqrt(length(Accs))'*100;     % one by individual time-lags
%tmp_at = mean(all_acc,2)*100;

sem_un = std(Accs(:,:,2))/sqrt(length(Accs))'*100;     % one by individual time-lags
%tmp_un = mean(all_acc,2)*100;

%%
% tlag = flip(-[-250, -234.375, ...
%        -218.75 , -203.125, -187.5  , -171.875, -156.25 , -140.625, ...
%        -125, -109.375,  -93.75 ,  -78.125,  -62.5  ,  -46.875, ...
%         -31.25 ,  -15.625,    0])';  

    
x = [t(1:end); t(end:-1:1)];
y_at = [Ave_Accs(1:end, 1)'+sem_at(1:end); Ave_Accs(end:-1:1, 1)'-sem_at(end:-1:1)];
y_un = [Ave_Accs(1:end, 2)'+sem_un(1:end); Ave_Accs(end:-1:1, 2)'-sem_un(end:-1:1)];

%%

figure
p = fill(x' ,y_at', 'red');
p.FaceColor = [0.6350 0.0780 0.1840];      
p.EdgeColor = 'none'; 
p.FaceAlpha = 0.1

hold on
p = fill(x' ,y_un', 'blue');
p.FaceColor = [0 0.4470 0.7410];
p.EdgeColor = 'none'; 
p.FaceAlpha = 0.1

plot(t, Ave_Accs(:,1), '-r', 'LineWidth', 2.5);hold on
plot(t, Ave_Accs(:,2), '-b', 'LineWidth', 2.5);

legend('','','Attended', 'Unattended')
ylim([30,90])
set(gcf, 'color', 'white')
xlim([0 407])
ylabel('Accuracy (%)')
xlabel('Time-lags (ms)')
title('Accuracy at individual time-lags')
box('off')

%% 

sem_at = std(Accs(:,:,1))/sqrt(length(Accs))'*100;     % one by individual time-lags
sem_un = std(Accs(:,:,2))/sqrt(length(Accs))'*100;     % one by individual time-lags

y_at = Ave_Accs(:,1)*100;
y_un = Ave_Accs(:,2)*100;

y_at_1 = y_at' + sem_at;
y_at_2 = y_at' - sem_at;
y_un_1 = y_un' + sem_un;
y_un_2 = y_un' - sem_un;


figure

x2 = [t, fliplr(t)];
stand_at = [y_at_1, fliplr(y_at_2)];
stand_un = [y_un_1, fliplr(y_un_2)];
p = fill(x2, stand_at, 'r');
p.FaceColor = [0.6350 0.0780 0.1840];      
p.EdgeColor = 'none'; 
p.FaceAlpha = 0.1
hold on;
p = fill(x2, stand_un, 'b');
p.FaceColor = [0 0.4470 0.7410];
p.EdgeColor = 'none'; 
p.FaceAlpha = 0.1

h1 = plot(t, y_at, '-r', 'LineWidth', 2.5)
h2 = plot(t, y_un, '-b', 'LineWidth', 2.5)
set(gcf, 'color', 'white')
legend([h1 h2], {'Attended', 'Unattended'})
title('Individual Time-Lags\_Offline')



