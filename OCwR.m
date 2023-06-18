clc; clear all; close all;
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
time_axis = (0:time_bins-1)*Ts;
range_axis = linspace(1, 4.8, range_bins);
frequency_axis = linspace(-fs/2, fs/2, n_samples/time_bins);

frequency_plot = fftshift(fft(rm, [], 1),1);

% 
% onesweep = true;
% sample_number = linspace(1, time_bins, time_bins);
% filestring = 'test';
% if onesweep
%     video_file=['./',filestring,'.avi'];
%     writerObj = VideoWriter(video_file);
%     open(writerObj); 
%     for i=1:length(sample_number)
%         sample = sample_number(i);
%         one_sweep = rm(:,sample);
%         one_sweep_fft = fftshift(fft(one_sweep, [], 1),1);
% 
%         h2 = figure(2);
%         set(h2,'Position',[100 100 900 400])
% 
%         subplot(2,1,1)
%         plot(range_axis, db(abs(one_sweep)),'linewidth',2)
%         title('Sample', num2str(i))
%         grid()
%         xlim([1, 4.8])
%         ylim([0, 130])
%         xlabel('Range (m)')
%         ylabel('Power (dB)')
% 
%         subplot(2,1,2)
%         plot(frequency_axis, db(abs(one_sweep_fft)),'linewidth',2)
%         ylim([0, 130])
%         xlim([min(frequency_axis), max(frequency_axis)])
%         grid()
%         xlabel('Frequency (Hz)')
%         ylabel('Power (dB)')
%         frame = getframe(h2);
%         writeVideo(writerObj,frame);
%     end
%     close(writerObj);
% end


h1 = figure(1);
subplot(2,1,1)
set(h1,'Position',[100 100 900 400])
imagesc(time_axis, range_axis, db(abs(rm)));
set(gca,'clim',[0,110])
axis xy;
colormap('turbo');
axis xy;
colorbar('EastOutside'); 
xlabel("Time (s)"); 
ylabel("Range (m)");

subplot(2,1,2)
imagesc(time_axis, frequency_axis, db(frequency_plot));
set(gca,'clim',[0, 130])
axis xy;
colormap('turbo');
axis xy;
colorbar('EastOutside'); 
xlabel("Time (s)"); 
ylabel("Frequency (Hz)");



matrix = zeros(128, 454);
for i=1:480
    data_new = stft(rm(i,:), fs);
    matrix = matrix + data_new;
    
end

h2 = figure(2);
set(h2,'Position',[100 100 900 400])
imagesc(db(abs(matrix)))
%set(gca,'clim',[90, 130])
axis xy;
colormap('turbo');
axis xy;
colorbar('EastOutside'); 
xlabel("Time (s)"); 
ylabel("Frequency (Hz)");


%% Feature extraction
% using equations given lecture 7 slide 14
% F(i, j) is the spectogram where i is the doppler bin and j the time bin
fc = zeros(length(matrix(:, 1)), 1);
bc = zeros(length(fc), 1);
for j = 1:length(matrix(1, :))
    % loop over time bins

    % what is fc at this time bin ? 
    fF_sum = 0;
    F_sum = 0;
    for i = 1:length(matrix(:, 1))
        % loop over doppler bins
        F_ij = db(abs(matrix(i, j))); % spectogram value

        f_i = fs/length(matrix(:, 1)) * i;

        fF_sum = fF_sum + f_i * F_ij;
        F_sum = F_sum + F_ij;

    end
    fc_j = fF_sum/F_sum;
    fc(j) = fc_j;

    s = 0;
    for i = 1:length(matrix(:, 1))
        % loop over doppler bins
        F_ij = db(abs(matrix(i, j))); % spectogram value
        s = s + (f_i - fc_j)^2*F_ij;
    end

    B_cj = sqrt(s/F_sum);
    bc(j) = B_cj;
end

% histogram
h3 = figure(3);
histogram(db(abs(matrix)));

%% Our features
f_torso = mean(fc);
BW_torso = max(fc) - min(fc);
BW_tot = mean(bc);
mu = mean(db(abs(matrix)), "all"); % average signal strenght
sigma = std(db(abs(matrix)),0 , "all"); % standard deviation of the histogram


