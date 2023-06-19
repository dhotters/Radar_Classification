function [TimeAxisSpectrogram, DopplerAxisSpectrogram, Data_spectrogram2] = stft_OCwR(rm)
%% Spectogram
PRF=122; %Pulse Repetition Frequency
WindowLength = 150; %Window length in samples (not in seconds or ms!!!)
OverlapPercentage = 0.95; %Percentage of overlap of STFT windows 
NFFTPoints = 4*WindowLength; %Number of points of each FFT (we are extending the FFT by 4 times)
Rbin_start = 6;
Rbin_stop = 21;
n_samples = length(rm);
Ts = PRF/2;

myvector = sum(rm(Rbin_start:Rbin_stop,:));
record_length=length(rm)/n_samplesTs;

Data_spectrogram=fftshift(spectrogram(myvector,WindowLength,round(WindowLengthOverlapPercentage),NFFTPoints),1);
Data_spectrogram=flipud(Data_spectrogram);
DopplerAxisSpectrogram=linspace(-PRF/2,PRF/2,size(Data_spectrogram,1));
TimeAxisSpectrogram=linspace(0, record_length, size(Data_spectrogram,2));


Data_spectrogram2=0;
for RBin=Rbin_start:1:Rbin_stop
    Data_temp = fftshift(spectrogram(rm(RBin,:),WindowLength,round(WindowLengthOverlapPercentage),NFFTPoints),1);
    Data_spectrogram2=Data_spectrogram2+abs(Data_temp);
end


h2 = figure(2);
set(h2,'Position',[100 100 900 400])
imagesc(TimeAxisSpectrogram,DopplerAxisSpectrogram,mag2db(abs(Data_spectrogram2))); 
ylim([-PRF/2 PRF/2]);
axis xy;
colormap('turbo');
axis xy;
colorbar('EastOutside'); 
xlabel("Time (s)"); 
ylabel("Frequency (Hz)");
end