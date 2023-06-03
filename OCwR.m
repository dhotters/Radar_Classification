clc; clear all;

data = load('./Data/1/001_mon_wal_1.mat');
 



rm  = data.hil_resha_aligned(:,:,3);

figure(1);
imagesc(20*log10(abs(rm))); 
colormap('jet'); 
colorbar('east'); 
xlabel("time samples"); 
ylabel("range samples");
