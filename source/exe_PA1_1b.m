clc; clear; close all;

% Parameter
width = 352;
height = 288;
YUV_type = [1, 0.5, 0.5]; 
blk_size = [16, 32, 64]; 

% Read yuv file
f_name = '..\data\Calendar_CIF30.yuv';
f_id = fopen(f_name, 'r');

num_frames = 20;
% PSNR between i-th frame and reconstructed frame using Lucas-Kanada method
psnr_LK16 = zeros(num_frames,1);  % with block size of 16x16
psnr_LK32 = zeros(num_frames,1);  % with block size of 32x32
psnr_LK64 = zeros(num_frames,1);  % with block size of 32x32
for j = 1:length(blk_size)
  for i = 1:num_frames
    % Load 2 continuous frames
    fr_1 = YUV_READER(f_id, width, height, YUV_type, i, 1);
    fr_2 = YUV_READER(f_id, width, height, YUV_type, i+1, 1);
  
    % Estimate motion vectors
    [v1, v2] = PA1_1a(fr_1, fr_2, blk_size(j));
  
    % Reconstruct frame and determine PSNR
    switch blk_size(j)
      case 16
        [psnr_LK16(i), ~] = PA1_1b(fr_1, fr_2, v1, v2, blk_size(j));
      case 32
        [psnr_LK32(i), ~] = PA1_1b(fr_1, fr_2, v1, v2, blk_size(j));
      case 64
        [psnr_LK64(i), ~] = PA1_1b(fr_1, fr_2, v1, v2, blk_size(j));
      otherwise
        disp('ERROR: Block size does not exists');
    end
  end
end
% Plot PSNR graph
min_LK16 = min(psnr_LK16); max_LK16 = max(psnr_LK16);
min_LK32 = min(psnr_LK32); max_LK32 = max(psnr_LK32);
min_LK64 = min(psnr_LK64); max_LK64 = max(psnr_LK64);
min_LK = min(min(min_LK16, min_LK32), min_LK64);
max_LK = max(max(max_LK16, max_LK32), max_LK64);
lower = floor(min_LK);
upper = floor(max_LK) + 1;

figure('Name', 'PA1-1b');
hold on;
plot(1:num_frames, psnr_LK16, 'r-s');
plot(1:num_frames, psnr_LK32, 'g-o');
plot(1:num_frames, psnr_LK64, 'b-^');
title('PA1-1b: PSNR by reconstructed frames');
axis([0 num_frames+1, lower upper]);
legend('16x16', '32x32', '64x64');
xlabel('Frame Number');
ylabel('PSNR (dB)');
hold off;
fclose(f_id);
