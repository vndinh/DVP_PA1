clc; clear; close all;

% Parameter
width = 352;
height = 288;
YUV_type = [1, 0.5, 0.5]; 
blk_size = 4; 

% Read yuv file
f_name = '..\data\Calendar_CIF30.yuv';
f_id = fopen(f_name, 'r');
fr_1 = YUV_READER(f_id, width, height, YUV_type, 10, 1);
fr_2 = YUV_READER(f_id, width, height, YUV_type, 11, 1);

figure('Name', 'PA1-1a: Lucas-Kanade Algorithm');
for i = 1:length(blk_size)
  % Estimate motion vectors
  [v1, v2] = PA1_1a(fr_1, fr_2, blk_size(i));
  
  % Plot the optical flows
  subplot(1,3,i)
  imshow(uint8(fr_1)); % Show the 10th frame
  hold on;
  id1 = blk_size(i) / 2 - 1;
  id2 = width - blk_size(i) / 2;
  id3 = height - blk_size(i) / 2;
  [x, y] = meshgrid(id1:blk_size(i):id2, id1:blk_size(i):id3);
  quiver(x, y, v1, v2, 1, 'color', 'b', 'linewidth', 1.5);
  blkSize = num2str(blk_size(i));
  title(strcat(blkSize, 'x', blkSize));
  hold off;
end
fclose(f_id);
