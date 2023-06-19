function [f_torso, BW_torso, BW_tot, sigma] = getFeatures(matrix, fs)
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
% h3 = figure(3);
% histogram(db(abs(matrix)));

%% Our features
f_torso = mean(fc);
BW_torso = max(fc) - min(fc);
BW_tot = mean(bc);
mu = mean(db(abs(matrix)), "all"); % average signal strenght
sigma = std(db(abs(matrix)),0 , "all"); % standard deviation of the histogram
end

