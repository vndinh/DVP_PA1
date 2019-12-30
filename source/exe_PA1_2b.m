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

% PSNR between i-th frame and reconstructed frame using Horn-Schunck method
psnr_HS16 = zeros(num_frames,1);  % with block size of 16x16
psnr_HS32 = zeros(num_frames,1);  % with block size of 32x32
psnr_HS64 = zeros(num_frames,1);  % with block size of 64x64

for j = 1:length(blk_size)
  for i = 1:num_frames
    % Load 2 continuous frames
    fr_1 = YUV_READER(f_id, width, height, YUV_type, i, 1);
    fr_2 = YUV_READER(f_id, width, height, YUV_type, i+1, 1);
  
    % Estimate motion vectors
    [v1_LK, v2_LK] = PA1_1a(fr_1, fr_2, blk_size(j));
    [v1_HS, v2_HS] = PA1_2a(fr_1, fr_2, blk_size(j));
    
    switch blk_size(j)
      case 16
        % Determine PSNR
        [psnr_LK16(i), ~] = PA1_1b(fr_1, fr_2, v1_LK, v2_LK, blk_size(j));
        [psnr_HS16(i), ~] = PA1_1b(fr_1, fr_2, v1_HS, v2_HS, blk_size(j));
      case 32
        % Determine PSNR
        [psnr_LK32(i), ~] = PA1_1b(fr_1, fr_2, v1_LK, v2_LK, blk_size(j));
        [psnr_HS32(i), ~] = PA1_1b(fr_1, fr_2, v1_HS, v2_HS, blk_size(j));
        
      case 64
        % Determine PSNR
        [psnr_LK64(i), ~] = PA1_1b(fr_1, fr_2, v1_LK, v2_LK, blk_size(j));
        [psnr_HS64(i), ~] = PA1_1b(fr_1, fr_2, v1_HS, v2_HS, blk_size(j));
      otherwise
        disp('ERROR: Block size does not exists');
    end
  end
end

% Plot PSNR graph
min_LK16 = min(psnr_LK16); max_LK16 = max(psnr_LK16);
min_HS16 = min(psnr_HS16); max_HS16 = max(psnr_HS16);
lower = floor(min(min_LK16, min_HS16));
upper = floor(max(max_LK16, max_HS16)) + 1;
figure('Name', 'PA1-2b: 16x16');
subplot(3,1,1);
hold on;
plot(1:num_frames, psnr_LK16, 'b-o'); 
plot(1:num_frames, psnr_HS16, 'r-^');
title('PA1-2b: 16x16');
axis([0 num_frames+1, lower upper]);
xlabel('Frame Number');
ylabel('PSNR (dB)');
legend('Lucas-Kanade', 'Horn-Schunck');
hold off;

min_LK32 = min(psnr_LK32); max_LK32 = max(psnr_LK32);
min_HS32 = min(psnr_HS32); max_HS32 = max(psnr_HS32);
lower = floor(min(min_LK32, min_HS32));
upper = floor(max(max_LK32, max_HS32)) + 1;
subplot(3,1,2);
hold on;
plot(1:num_frames, psnr_LK32, 'b-o'); 
plot(1:num_frames, psnr_HS32, 'r-^');
title('PA1-2b: 32x32');
axis([0 num_frames+1, lower upper]);
xlabel('Frame Number');
ylabel('PSNR (dB)');
legend('Lucas-Kanade', 'Horn-Schunck');
hold off;

min_LK64 = min(psnr_LK64); max_LK64 = max(psnr_LK64);
min_HS64 = min(psnr_HS64); max_HS64 = max(psnr_HS64);
lower = floor(min(min_LK64, min_HS64));
upper = floor(max(max_LK64, max_HS64)) + 1;
subplot(3,1,3);
hold on;
plot(1:num_frames, psnr_LK64, 'b-o'); 
plot(1:num_frames, psnr_HS64, 'r-^');
title('PA1-2b: 64x64');
axis([0 num_frames+1, lower upper]);
xlabel('Frame Number');
ylabel('PSNR (dB)');
legend('Lucas-Kanade', 'Horn-Schunck');
hold off;

min_HS = min(min(min_HS16, min_HS32), min_HS64);
max_HS = max(max(max_HS16, max_HS32), max_HS64);
lower = floor(min_HS);
upper = floor(max_HS) + 1;
figure('Name', 'PA1-2b');
hold on;
plot(1:num_frames, psnr_HS16, 'r-s');
plot(1:num_frames, psnr_HS32, 'g-o');
plot(1:num_frames, psnr_HS64, 'b-^');
title('PA1-2b: Horn-Schunck Algorithm');
axis([0 num_frames+1, lower upper]);
legend('16x16', '32x32', '64x64');
xlabel('Frame Number');
ylabel('PSNR (dB)');
hold off;
fclose(f_id);


