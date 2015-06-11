function [ traceArray ] = getTraces( frames, centers, radii )
%GETTRACES Summary of this function goes here
%   Detailed explanation goes here
frame_dim = size(frames);
frame_len = frame_dim(1);
frame_width = frame_dim(2);
num_frames = frame_dim(3);
num_circles = length(radii);
traceArray = zeros(num_circles, num_frames);
%frame must be square!!
[rr, cc] = meshgrid(1:frame_len);
% for i=1:num_frames
%    for j = 1:num_circles
%       currentCenter = centers(j,:);
%       currentRadius = radii(j);
%       mask = sqrt((rr-currentCenter(1)).^2+(cc-currentCenter(2)).^2)<=currentRadius;
%       maskedFrame = mask.*frames(:,:,i);
%       traceArray(j,i) = sum(sum(maskedFrame));
%    end
% end

for j = 1:num_circles
    currentCenter = centers(j,:);
    currentRadius = radii(j);
    mask = sqrt((rr-currentCenter(1)).^2+(cc-currentCenter(2)).^2)<=currentRadius;
    %masked_frames = frames(repmat(mask,[1,1,num_frames]));
    %masked_frames_size = size(masked_frames,1);
    %mask_size = masked_frames_size/num_frames;
    %%for i = 1:mask_size:masked_frames_size-mask_size
    for i = 1:num_frames
      %traceArray(j,i) = sum(masked_frames((i-1)*mask_size+1:i*mask_size));
      maskedFrame = mask.*frames(:,:,i);
      traceArray(j,i) = sum(sum(maskedFrame));
      %%frame = frames(:,:,i);
      %%traceArray(j,i) = sum(frame(mask));
      %%traceArray(j,(i/mask_size)+1) = sum(masked_frames(i:i+mask_size));
    end
end



end

