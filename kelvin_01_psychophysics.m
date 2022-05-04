clear all

no_bins=10; % even number
no_trls=10;
no_staircase = 30;

fs=44100;
duration=.095; % mean and range arbitrary
pitch=1; %0.5:0.15:2 % mean should be 1, range symmetric around 1 (log space)
ILD=0; % -10:2:10 % range should be symmetric around 0
consonant=.5; %0:0.2:1 % range has to be between 0 and 1, symmetric around .5

ISI=.8;
ramp_ms=5; % hanning window in ms

addpath Scripts/STRAIGHTV40_007c/

features={'pitch' 'ILD' 'consonant' 'duration'};

pp_no=input('Participant no. ');
mkdir(strcat('pp_',num2str(pp_no)));
f_no=input('Block no. ');

% load two source stimuli

sylFiles={'ta_low_human' 'ti_low_human'};

for ii=1:length(sylFiles)
    [Y,FS]=audioread([sylFiles{ii},'.wav']);
    Y=Y./std(Y);
    s{ii}.wav=Y;
    s{ii}.f0raw3 = MulticueF0v14(s{ii}.wav,FS); % fundamental freq (F0) contour -> physical pitch
    s{ii}.ap = exstraightAPind(s{ii}.wav,FS,s{ii}.f0raw3); % aperiodicity
    s{ii}.n3sgram = exstraightspec(s{ii}.wav,s{ii}.f0raw3,FS);
end;

% match onsets and durations, shorten to standard duration

for ii=1:2
    stimonset(ii)=min(find(s{ii}.f0raw3>1));
end

if stimonset(1)~=stimonset(2)
    diffonset=abs(stimonset(1)-stimonset(2));
    s{find(stimonset==max(stimonset))}.n3sgram(:,1:diffonset)=[];
    s{find(stimonset==max(stimonset))}.ap(:,1:diffonset)=[];
    s{find(stimonset==max(stimonset))}.f0raw3(1:diffonset)=[];
    s{find(stimonset==min(stimonset))}.n3sgram(:,end-diffonset+1:end)=[];
    s{find(stimonset==min(stimonset))}.ap(:,end-diffonset+1:end)=[];
    s{find(stimonset==min(stimonset))}.f0raw3(end-diffonset+1:end)=[];
end

for ii=1:2
    lenDiff=length(find(s{ii}.f0raw3>1))-(duration*1000);
    
    if lenDiff>0
        
        dropBins=floor((1:lenDiff)*length(find(s{ii}.f0raw3>0))/lenDiff);
        s{ii}.n3sgram(:,dropBins)=[];
        s{ii}.ap(:,dropBins)=[];
        s{ii}.f0raw3(dropBins)=[];
        
    elseif lenDiff<0
        
        addBins=round(min(find(s{ii}.f0raw3>0)):length(find(s{ii}.f0raw3>0))/-lenDiff:max(find(s{ii}.f0raw3>0))); % check for different durations
        longer.f0raw3=[];
        longer.ap=[];
        longer.n3sgram=[];
        
        for i=1:length(s{ii}.f0raw3)
            if length(find(addBins==i))>0
                longer.f0raw3=[longer.f0raw3 s{ii}.f0raw3(i) s{ii}.f0raw3(i)];
                longer.ap=[longer.ap s{ii}.ap(:,i) s{ii}.ap(:,i)];
                longer.n3sgram=[longer.n3sgram s{ii}.n3sgram(:,i) s{ii}.n3sgram(:,i)];
                
            else
                longer.f0raw3=[longer.f0raw3 s{ii}.f0raw3(i)];
                longer.ap=[longer.ap s{ii}.ap(:,i)];
                longer.n3sgram=[longer.n3sgram s{ii}.n3sgram(:,i)];
            end
        end
        
        s{ii}.n3sgram=longer.n3sgram;
        s{ii}.ap=longer.ap;
        s{ii}.f0raw3=longer.f0raw3;
    end
end


for ii=1:2
    durations(ii)=length(s{ii}.f0raw3);
end

if durations(1)~=durations(2)
    diffdur=abs(durations(1)-durations(2));
    s{find(durations==max(durations))}.n3sgram(:,end-diffdur+1:end)=[];
    s{find(durations==max(durations))}.ap(:,end-diffdur+1:end)=[];
    s{find(durations==max(durations))}.f0raw3(end-diffdur+1:end)=[];
end

for ii=1:2
    s{ii}.wav=exstraightsynth(s{ii}.f0raw3,s{ii}.n3sgram,s{ii}.ap,FS);
    s{ii}.wav=s{ii}.wav./std(s{ii}.wav);
end

% determine stimulus range

stim_order=[1 6 11; 2 6 10; 3 6 9; 4 6 8; 5 6 7];

%% determine value limits

if f_no == 1 % pitch
    flim=[.8 1.2];
elseif f_no == 2 % ILD for human pure tone : -10 -5 0 5 10 dB
    flim=[-15 15];
elseif f_no == 3 % consonant
    flim=[0 1];
elseif f_no == 4 % duration1
    flim=[55 135]/1000;
end


%% run behavioural session

staircase_counter=0;
correct=[];
stepsize=.15;
to_plot=[];

while staircase_counter<no_staircase
    
    fvals=[flim(1):diff(flim)/no_bins:flim(2)];

    
    if randsample(1:2,1)==1
        stim_order=randsample([3 6 6],3);
    else
        stim_order=randsample([6 6 9],3);
    end
    
    oddball=find(stim_order~=6);
    
    for j=1:length(stim_order)
        tic;

        if f_no == 1 % pitch
            pitch=fvals(stim_order(j));
        elseif f_no == 2 % ILD
            ILD=fvals(stim_order(j));
        elseif f_no == 3 % consonant
            consonant=fvals(stim_order(j));
        elseif f_no == 4 % duration
            duration=fvals(stim_order(j));
        end

        [pitch ILD consonant duration];

        % pitch
        synthParams.fundamentalFrequencyMappingTable=pitch; % pitch
        synthParams.frequencyAxisMappingTable=1; % human -> rat

        % consonant
        stimulus.f0raw3=consonant*s{1}.f0raw3+(1-consonant)*s{2}.f0raw3;
        stimulus.n3sgram=consonant*s{1}.n3sgram+(1-consonant)*s{2}.n3sgram;
        stimulus.ap=consonant*s{1}.ap+(1-consonant)*s{2}.ap;

        % duration
        lenDiff=length(find(stimulus.f0raw3>1))-round(duration*1000);

        if lenDiff>0

            dropBins=floor((1:lenDiff)*length(find(stimulus.f0raw3>0))/lenDiff);
            stimulus.n3sgram(:,dropBins)=[];
            stimulus.ap(:,dropBins)=[];
            stimulus.f0raw3(dropBins)=[];

        elseif lenDiff<0

            addBins=round(min(find(stimulus.f0raw3>0)):length(find(stimulus.f0raw3>0))/-lenDiff:max(find(stimulus.f0raw3>0))); % check for different durations
            longer.f0raw3=[];
            longer.ap=[];
            longer.n3sgram=[];

            for ii=1:length(stimulus.f0raw3)
                if length(find(addBins==ii))>0
                    longer.f0raw3=[longer.f0raw3 stimulus.f0raw3(ii) stimulus.f0raw3(ii)];
                    longer.ap=[longer.ap stimulus.ap(:,ii) stimulus.ap(:,ii)];
                    longer.n3sgram=[longer.n3sgram stimulus.n3sgram(:,ii) stimulus.n3sgram(:,ii)];

                else
                    longer.f0raw3=[longer.f0raw3 stimulus.f0raw3(ii)];
                    longer.ap=[longer.ap stimulus.ap(:,ii)];
                    longer.n3sgram=[longer.n3sgram stimulus.n3sgram(:,ii)];
                end
            end

            stimulus.n3sgram=longer.n3sgram;
            stimulus.ap=longer.ap;
            stimulus.f0raw3=longer.f0raw3;

        end

        % extract
        y=exstraightsynth(stimulus.f0raw3,stimulus.n3sgram,stimulus.ap,fs,synthParams);
        y=y/std(y);
        hw=hann(2*round(ramp_ms*fs/1000));
        y(1:round(ramp_ms*fs/1000))=y(1:round(ramp_ms*fs/1000)).*hw(1:round(ramp_ms*fs/1000));
        y(end-round(ramp_ms*fs/1000)+1:end)=y(end-round(ramp_ms*fs/1000)+1:end).*hw(round(ramp_ms*fs/1000)+1:end);

        % ILD

        if ILD<0
            for ii=1:1000
                find_spl(ii)=spl(y*ii/1000,'air')-spl(y,'air');
            end
            y=[y*find(abs(find_spl-ILD)==min(abs(find_spl-ILD)))/1000 y];
        elseif ILD>0
            for ii=1:1000
                find_spl(ii)=spl(y,'air')-spl(y*ii/1000,'air');
            end
            y=[y y*find(abs(find_spl-ILD)==min(abs(find_spl-ILD)))/1000];
        elseif ILD==0
            y=[y y];
        end

        finish_trl=toc;
        pause(ISI-duration-finish_trl)

        sound(y,fs)
    end
    response=input('Which tone was the oddball? (1|2|3) ','s');
    if str2double(response)>=1&str2double(response)<=3
        if oddball==str2double(response)
            correct=[correct 1];
        else
            correct=[correct 0];
        end
    else
        correct=[correct NaN];
    end
        
    if length(correct)>3
        if mean(correct(end-2:end))==1  % correct response - 3 times
            flim=(flim-mean(flim))*(1-stepsize)+mean(flim);
            display('up')
        elseif correct(end)==0
            flim=(flim-mean(flim))*(1+stepsize)+mean(flim);
            display('down')
        end
    end  
    to_plot=[to_plot diff(flim)];
    staircase_counter=staircase_counter+1;
end

figure;plot(to_plot)

fvals=[flim(1):diff(flim)/no_bins:flim(2)];


% determine stimulus order

stim_order=[repmat(1:no_bins+1,1,no_trls)' ones(no_trls*(no_bins+1),2)*(no_bins/2+1)];
stim_order=[randsample(1:length(stim_order),length(stim_order))' stim_order];
stim_order=sortrows(stim_order);
stim_order=stim_order(:,[3 4 2]);
for i=1:length(stim_order)
    stim_order(i,:)=randsample(stim_order(i,:),3);
end
correct=[];

ready_proceed=input('Press [enter] to continue');

%% run behavioural session

for i=1:length(stim_order)
    oddball=find(stim_order(i,:)~=6);
    if length(oddball)==0
        oddball=randsample(1:3,1);
    end
    
    for j=1:length(stim_order(i,:))
        tic;
        
        if f_no == 1 % pitch
            pitch=fvals(stim_order(i,j));
        elseif f_no == 2 % ILD
            ILD=fvals(stim_order(i,j));
        elseif f_no == 3 % consonant
            consonant=fvals(stim_order(i,j));
        elseif f_no == 4 % duration
            duration=fvals(stim_order(i,j));
        end
        
        [pitch ILD consonant duration];
        
        % pitch
        synthParams.fundamentalFrequencyMappingTable=pitch; % pitch
        synthParams.frequencyAxisMappingTable=1; % human -> rat
        
        % consonant
        stimulus.f0raw3=consonant*s{1}.f0raw3+(1-consonant)*s{2}.f0raw3;
        stimulus.n3sgram=consonant*s{1}.n3sgram+(1-consonant)*s{2}.n3sgram;
        stimulus.ap=consonant*s{1}.ap+(1-consonant)*s{2}.ap;
        
        % duration
        lenDiff=length(find(stimulus.f0raw3>1))-round(duration*1000);
        
        if lenDiff>0
            
            dropBins=floor((1:lenDiff)*length(find(stimulus.f0raw3>0))/lenDiff);
            stimulus.n3sgram(:,dropBins)=[];
            stimulus.ap(:,dropBins)=[];
            stimulus.f0raw3(dropBins)=[];
            
        elseif lenDiff<0
            
            addBins=round(min(find(stimulus.f0raw3>0)):length(find(stimulus.f0raw3>0))/-lenDiff:max(find(stimulus.f0raw3>0))); % check for different durations
            longer.f0raw3=[];
            longer.ap=[];
            longer.n3sgram=[];
            
            for ii=1:length(stimulus.f0raw3)
                if length(find(addBins==ii))>0
                    longer.f0raw3=[longer.f0raw3 stimulus.f0raw3(ii) stimulus.f0raw3(ii)];
                    longer.ap=[longer.ap stimulus.ap(:,ii) stimulus.ap(:,ii)];
                    longer.n3sgram=[longer.n3sgram stimulus.n3sgram(:,ii) stimulus.n3sgram(:,ii)];
                    
                else
                    longer.f0raw3=[longer.f0raw3 stimulus.f0raw3(ii)];
                    longer.ap=[longer.ap stimulus.ap(:,ii)];
                    longer.n3sgram=[longer.n3sgram stimulus.n3sgram(:,ii)];
                end
            end
            
            stimulus.n3sgram=longer.n3sgram;
            stimulus.ap=longer.ap;
            stimulus.f0raw3=longer.f0raw3;
            
        end
        
        % extract
        y=exstraightsynth(stimulus.f0raw3,stimulus.n3sgram,stimulus.ap,fs,synthParams);
        y=y/std(y);
        hw=hann(2*round(ramp_ms*fs/1000));
        y(1:round(ramp_ms*fs/1000))=y(1:round(ramp_ms*fs/1000)).*hw(1:round(ramp_ms*fs/1000));
        y(end-round(ramp_ms*fs/1000)+1:end)=y(end-round(ramp_ms*fs/1000)+1:end).*hw(round(ramp_ms*fs/1000)+1:end);
        
        % ILD
        
        if ILD<0
            for ii=1:1000
                find_spl(ii)=spl(y*ii/1000,'air')-spl(y,'air');
            end
            y=[y*find(abs(find_spl-ILD)==min(abs(find_spl-ILD)))/1000 y];
        elseif ILD>0
            for ii=1:1000
                find_spl(ii)=spl(y,'air')-spl(y*ii/1000,'air');
            end
            y=[y y*find(abs(find_spl-ILD)==min(abs(find_spl-ILD)))/1000];
        elseif ILD==0
            y=[y y];
        end
        
        finish_trl=toc;
        pause(ISI-duration-finish_trl)
        
        sound(y,fs)
    end
    response=input('Which tone was the oddball? (1|2|3) ','s');
    if str2double(response)>=1&str2double(response)<=3
        if oddball==str2double(response)
            correct(i)=1;
        else
            correct(i)=0;
        end
    else
        correct(i)=NaN;
    end
end


devs=sum(stim_order-6,2);
unique_devs=unique(devs);

correct(find(devs<0))=1-correct(find(devs<0));

for i=1:length(unique_devs)
    mean_correct(i)=mean(correct(find(devs==unique_devs(i))));
end

figure
[param]=sigm_fit(unique_devs,mean_correct,[0 1 NaN NaN],[],1);
ylim([-.1 1.1])
xlim([-5.5 5.5])

isfile=dir(strcat('ahn_beh_pilot_pp',num2str(pp_no),'_s',num2str(f_no),'.mat'));
if length(isfile)>0
    save(strcat('pp_',num2str(pp_no),'/ahn_beh_pilot_pp',num2str(pp_no),'_s',num2str(f_no),'_duplicate.mat'),'correct','mean_correct','devs','stim_order','flim','param')
else
    save(strcat('pp_',num2str(pp_no),'/ahn_beh_pilot_pp',num2str(pp_no),'_s',num2str(f_no),'.mat'),'correct','mean_correct','devs','stim_order','flim','param')
end
