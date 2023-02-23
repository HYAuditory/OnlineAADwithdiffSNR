
origin = Allsource_snr(2).sat1;
rmsRef = 2*10.^(-5);
% mcl 짜리
mcl = 75;
tormsu =10^(mcl/20)*(rmsRef);
y = (origin./rms(origin)).*tormsu ;

rr = 35;
tormsa =10^(rr/20)*(rmsRef);
x = (origin./rms(origin)).*tormsa ;

rr = -40;
tormsa =10^(rr/20)*(rms(y));
x1 = (origin./rms(origin)).*tormsa ;

sr = snr(x,y)


r = 20 * log10(rms(x1) / rms(y))
