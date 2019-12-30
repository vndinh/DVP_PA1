clc; clear; close all;

% Parameter
width = 352;
height = 288;
YUV_type = [1, 0.5, 0.5]; 
blk_size = [16, 32, 64]; 

% Read yuv file
f_name = '..\data\Calendar_CIF30.yuv';
f_id = fopen(f_name, 'r');
fr_1 = YUV_READER(f_id, width, height, YUV_type, 10, 1);
fr_2 = YUV_READER(f_id, width, height, YUV_type, 11, 1);

figure('Name', 'PA1-1c');
for i = 1:length(blk_size)
  % Estimate motion vectors
  [v1, v2] = PA1_1a(fr_1, fr_2, blk_size(i));

  % Reconstruct frame
  [~, rec_fr] = PA1_1b(fr_1, fr_2, v1, v2, blk_size(i));

  % Calculate the difference
  D1 = abs(fr_1 - rec_fr);
  D2 = abs(fr_1 - fr_2);

  % Plot the difference between reference and recontructed frame
  blkSize = num2str(blk_size(i));
  dest = 2*(i-1)+1;
  subplot(2,3,i); imshow(uint8(D1)); title(strcat(blkSize, 'x', blkSize, ': Reconstruction - 10th'));
  subplot(2,3,i+3); imshow(uint8(D2)); title(strcat(blkSize, 'x', blkSize, ': 11th - 10th'));
end

