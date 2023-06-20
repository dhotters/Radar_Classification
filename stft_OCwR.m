function [TimeAxisSpectrogram, DopplerAxisSpectrogram, Data_spectrogram2] = stft_OCwR(rm)
%% Spectogram
PRF=122; %Pulse Repetition Frequency
WindowLength = 150; %Window length in samples (not in seconds or ms!!!)
OverlapPercentage = 0.95; %Percentage of overlap of STFT windows 
NFFTPoints = 4*WindowLength; %Number of points of each FFT (we are extending the FFT by 4 times)
Rbin_start = 1;
Rbin_stop = 480;
n_samples = length(rm);
Ts = PRF/2;
myvector = sum(rm(Rbin_start:Rbin_stop,:));
record_length=length(rm)/n_samples*Ts;

Data_spectrogram2=0;
for RBin=Rbin_start:1:Rbin_stop
    Data_temp = fftshift(spectrogram(rm(RBin,:),WindowLength,round(WindowLength*OverlapPercentage),NFFTPoints),1);
    Data_spectrogram2=Data_spectrogram2+abs(Data_temp);
end

Data_spectrogram2=flipud(Data_spectrogram2);
plot_data = abs(Data_spectrogram2);
Data_spectrogram2 = plot_data./max(plot_data);

clipping_level = -10.0; % dB
clipping_level = 10^(clipping_level/20);

Data_spectrogram2(Data_spectrogram2<clipping_level)= clipping_level;

DopplerAxisSpectrogram=linspace(-PRF/2,PRF/2,size(Data_spectrogram2,1));
TimeAxisSpectrogram=linspace(0, record_length, size(Data_spectrogram2,2));

% h2 = figure(2);
% set(h2,'Position',[100 100 900 400])
% imagesc(TimeAxisSpectrogram,DopplerAxisSpectrogram,20*log10(abs(Data_spectrogram2)./max(abs(Data_spectrogram2)))); 
% ylim([-PRF/2 PRF/2]);
% axis xy;
% colormap('turbo');
% axis xy;
% colorbar('EastOutside'); 
% xlabel("Time (s)"); 
% ylabel("Frequency (Hz)");
end