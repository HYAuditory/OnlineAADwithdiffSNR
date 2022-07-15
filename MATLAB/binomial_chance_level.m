%% binomial chance level
% parameter
n = 736;   % # of trials
p = 0.5; % probability of correctness
y = 0.95; % the 95th percentile of binomial cdf

% inverse of binomial cdf
x = binoinv(y,n,p); % x is # of trials corresponding to y
(x/n) * 100 % in percentage

