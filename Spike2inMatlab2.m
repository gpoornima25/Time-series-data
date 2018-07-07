clear all
% close all
clc

% split file into baseline, PTZ nad paralyzing agent (PA) ( PB- pancuronium bromide , AB- alpha bungratoxin)

%from  CutSpikeTrace.m
[openmkfile,openmkpath]=uigetfile('*.smr','Please select the Spike file');
fid=fopen([openmkpath openmkfile],'rb'); %,'ieee-le')
cd(openmkpath)
[WholeLFP,LFPheader]=SONGetChannel(fid, 1);
 [WholeEKG,EKGheader]=SONGetChannel(fid, 2);
figure; 
ax2=subplot(211)
fi=(1:length(WholeEKG))/10000;
plot(fi,WholeEKG);axis([-inf inf -4000 4000]);xlabel('sec')
title('glass electrode ~ 1.5Mohms')

ax1=subplot(212)
fi=(1:length(WholeLFP))/10000;
plot(fi,WholeLFP);axis([-inf inf -4000 4000]);xlabel('sec')
title('metal electrode ~0.6Mohms')

linkaxes([ax1,ax2],'x')

%
tt=1e4
LFP0=WholeEKG( 170*tt:540*tt);
LFP0=LFP0-mean(LFP0);
figure;plot(LFP0)

%%Bandpass filter 1 to 50Hz
[c k] = cheby1(2,0.5,[1 50]/5000,'bandpass'); 
LFPf50 = filtfilt(c,k,double(LFP0));
[f1 fftdata1]=fftshow(LFPf50,10000);

% 
% %  notch filter
% 
% %2Hz notch
% Fs=10000;
%     d = designfilt('bandstopiir','FilterOrder',2, ...
%                    'HalfPowerFrequency1',1.99,'HalfPowerFrequency2',2.01, ...
%                    'DesignMethod','butter','SampleRate',Fs);
% %     fvtool(d,'Fs',Fs)
%     LFPn50 = filtfilt(d,LFPf50);
% [f2 fftdata2]=fftshow(LFPn50,10000);suptitle( ' ')


figure; 
ax2=subplot(211)
fi=(1:length(LFP0))/10000;
plot(fi,LFP0);axis([-inf inf -inf inf]);xlabel('sec')
title('raw')

ax1=subplot(212)
fi=(1:length(LFPf50))/10000;
plot(fi,LFPf50);axis([-inf inf -2000 2000]);xlabel('sec')
title('filtered')

linkaxes([ax1,ax2],'x')


%%


%50Hz notch
Fs=10000;
    d = designfilt('bandstopiir','FilterOrder',50, ...
                   'HalfPowerFrequency1',49.99,'HalfPowerFrequency2',50.01, ...
                   'DesignMethod','butter','SampleRate',Fs);
%     fvtool(d,'Fs',Fs)
    LFPnn50 = filtfilt(d,LFPn50);
[f2 fftdata2]=fftshow(LFPnn50,10000);suptitle( ' ')


figure; 
ax2=subplot(211)
fi=(1:length(LFP0))/10000;
plot(fi,LFP0);axis([-inf inf -2000 2000]);xlabel('sec')
title('raw')

ax1=subplot(212)
fi=(1:length(LFPnn50))/10000;
plot(fi,LFPnn50);axis([-inf inf -2000 2000]);xlabel('sec')
title('filtered')

linkaxes([ax1,ax2],'x')








