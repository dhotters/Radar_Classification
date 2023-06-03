clc; clear all;
fprintf('--------------------------------\n')
fprintf('Object Classification with RADAR\n')
fprintf('     Practical assignment\n')
fprintf('--------------------------------\n\n')
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Constants     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

c = 299792458;      % Speed of light (m/s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Read data from file     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[file,path] = uigetfile();
fprintf('File name: %s \n', file)
fprintf('Loading data...\n')
tstart = tic;
data = load([path,file]);
rm  = data.hil_resha_aligned(:,:,3);
tend = toc(tstart);
[range_bins, time_bins] = size(rm);
n_samples = range_bins * time_bins;

fprintf('Finished loading... \n')
fprintf('Load time           : %.3f s\n', tend )
fprintf('--------------------------------\n')
fprintf('Number of range bins: %.0f\n', range_bins)
fprintf('Number of time bins : %.0f\n\n', time_bins)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Radar specifications     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ts = 0.0082;    %   Sampling time (s): PRF = 122 Hz -> Ts = 1/PRF = 8.2 ms
fs = 1/Ts;      %   Sampling frequency (Hz)
f0 = 4.3e9;     %   Carrier frequency (Hz)
lambda0 = c/f0; %   Carrier wavelength (m)
BW = 2.2e9;     %   Bandwidth (Hz)

fprintf('--------------------------------\n')
fprintf('     Radar specifications\n')
fprintf('--------------------------------\n')
fprintf('Carrier frequency: %.2f GHz\n', f0/1e9)
fprintf('Bandwidth        : %.2f GHz\n', BW/1e9)
fprintf('Sampling time    : %.2f ms \n', Ts*1e3)

range_resolution = c/(2*BW);

fprintf('Range resolution : %.4f m\n', range_resolution)
time = linspace(0, time_bins*Ts, time_bins);
range = linspace(0, range_bins*range_resolution, range_bins);
freq = linspace(-fs/2, fs, n_samples);

h1 = figure(1);
set(h1,'Position',[100 100 900 400])
imagesc(time, range, db(abs(rm)));
axis xy;
colormap('turbo');
axis xy;
colorbar('EastOutside'); 
xlabel("Time (s)"); 
ylabel("Range (m)");

