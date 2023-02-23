%% Data Preparation
clear
clc
% load data
load 'DATA(3conditions)_rev210330.mat'

% Data Settings
EEG    = DATA(3).EEG;
SPEECH = DATA(3).SPEECH;
INDEX  = DATA(3).INDEX;

%% Individual Time-lag Analysis (only positive lags)

% ======================= Parameter Settings =========================== %
% Decoder Parameters 
Dir    = -1; % 1 for forward, -1 for backward
fs     = 64;
dur    = 60;
lambda = 10;

% Time-lag (tau) params
tmin    = 0;                       % min time-lag(ms)
tminIdx = floor(tmin/1000*fs);     % tmin2idx
tmax    = 250;                     % max time-lag(ms)
tmaxIdx = ceil(tmax/1000*fs);      % tmax2idx
timeLag = length(tminIdx:tmaxIdx); % time-lag points between tmin and tmax
t       = sort( 1 * ( linspace(tmin, tmax, timeLag) ) );

% Experimental Params
Nchans  = length(EEG(1).chanlocs); % Number of Channels
Ntrials = size(EEG(1).data,1); % half of trials for each direction

% Loop over Subjects
for SubIdx = 1:length(EEG)

        % initialize SampledTrials cell array
        eeg_cell        = cell( Ntrials, 1 ); % cell for eeg data
        attended_cell   = cell( Ntrials, 1 ); % cell for attended speech
        unattended_cell = cell( Ntrials, 1 ); % cell for unattended speech
        
        % loop over SampledTrials
        for i = 1:Ntrials
            % TRIALS
            eeg_cell{i}        = squeeze(EEG(SubIdx).data(i, :, :))';
            attended_cell{i}   = SPEECH(INDEX(SubIdx).a(i),:)';
            unattended_cell{i} = SPEECH(INDEX(SubIdx).u(i),:)';
        end % The end of Ntrials loop
        
        % individual time-lags
        for ti = 1:length(t)
            % Attention Decoding
            % Train model
            model = mTRFtrain(attended_cell(1:14), eeg_cell(1:14), fs, Dir, t(ti), t(ti), lambda, 'verbose', 0); 

            [pred_att, stats_att] = mTRFpredict(attended_cell(15:end), eeg_cell(15:end), model, 'verbose', 0);
            [pred_unatt, stats_unatt] = mTRFpredict(unattended_cell(15:end), eeg_cell(15:end), model, 'verbose', 0);
                     
                for tr = 1:7
                    if stats_att.r(tr) > stats_unatt.r(tr)
                        acc(tr) = 1;
                    else acc(tr) = 0; end
                end
            Accs(SubIdx,ti)   = mean(acc);
         end

         disp(['Subject' num2str(SubIdx) ' finished!'])
                   
end % end time-lag
        
%%
% Decoder Parameters 
Dir    = -1; % 1 for forward, -1 for backward
fs     = 64;
dur    = 60;
lambda = 10;

% Time-lag (tau) params
tmin    = 0;                       % min time-lag(ms)
tmax    = 250;                     % max time-lag(ms)

% Experimental Params
Nchans  = length(EEG(1).chanlocs); % Number of Channels
Ntrials = size(EEG(1).data,1); % half of trials for each direction
% Loop over Subjects
for SubIdx = 1:length(EEG)

        % initialize SampledTrials cell array
        eeg_cell        = cell( Ntrials, 1 ); % cell for eeg data
        attended_cell   = cell( Ntrials, 1 ); % cell for attended speech
        unattended_cell = cell( Ntrials, 1 ); % cell for unattended speech
        
        % loop over SampledTrials
        for i = 1:Ntrials
            % TRIALS - ceda
%             eeg_cell{i}        = DATA{SubIdx}(:,:,i);
%             attended_cell{i}   = Allspeech(30+i,:)';
%             unattended_cell{i} = Allspeech(i,:)';
            
            % TRIALS
            eeg_cell{i}        = squeeze(EEG(SubIdx).data(i, :, :))';
            attended_cell{i}   = SPEECH(INDEX(SubIdx).a(i),:)';
            unattended_cell{i} = SPEECH(INDEX(SubIdx).u(i),:)';
        end % The end of Ntrials loop
        
        % Attention Decoding
        % Train model
%         model = mTRFtrain(attended_cell(1:14), eeg_cell(1:14), fs, Dir, tmin, tmax, lambda, 'verbose', 0); 
% 
%         [pred_att, stats_att] = mTRFpredict(attended_cell(15:end), eeg_cell(15:end), model, 'verbose', 0);
%         [pred_unatt, stats_unatt] = mTRFpredict(unattended_cell(15:end), eeg_cell(15:end), model, 'verbose', 0);
% 
%             for tr = 1:length(stats_att.r)
%                 if stats_att.r(tr) > stats_unatt.r(tr)
%                     acc(tr) = 1;
%                 else acc(tr) = 0; end
%             end

            [stats,stats1,stats2,~] = mTRFattncrossval(attended_cell, unattended_cell, eeg_cell, ...
                fs, Dir, tmin, tmax, lambda, 'verbose', 0);
            
            Accs(SubIdx)   = stats.acc;

        disp(['Subject' num2str(SubIdx) ' finished!'])
end

mean(Accs)
     


                   