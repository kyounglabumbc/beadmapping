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
for i=1:num_frames
   for j = 1:num_circles
      currentCenter = centers(j,:);
      currentRadius = radii(j);
      mask = sqrt((rr-currentCenter(1)).^2+(cc-currentCenter(2)).^2)<=currentRadius;
      maskedFrame = mask.*frames(:,:,i);
      traceArray(j,i) = sum(sum(maskedFrame));
   end
end

end

