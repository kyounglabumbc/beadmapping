function [ newCentersL, newCentersR, newRadii ] = addCirclesManual(frame, lcenters, rcenters, fradii, geotrans)
%ADDCIRCLESMANUAL Summary of this function goes here
%   Detailed explanation goes here
figure(1)
imagesc(frame);
% plot the current circles
viscircles(lcenters, fradii,'EdgeColor','b');
viscircles(rcenters, fradii,'EdgeColor','b');
width = size(frame,2);
h = uicontrol('style','slider','Min',1,'Max',15,'Value',5,'Position', [400 20 120 20]);
k = uicontrol('Style', 'text',...
       'Units','normalized',...
       'Position', [0.9 0.2 0.1 0.1]); 
newCentersL = [];
newCentersR = [];
newRadii = [];
numNew = 0;
while(1)
   disp('Click where you would like to add a center'); 
   [x,y] = ginput(1); 
   disp('Enter the radius');
   radius = 5;
   circle = viscircles([x,y], radius);
   disp('Hit space to accept');
   while(~waitforbuttonpress)
       radius = get(h,'value');
       circle.Visible = 'off';
       circle = viscircles([x,y], radius);
       circle.Visible = 'on';
   end
   numNew = numNew+1;
   newRadii(numNew) = radius;
   if(x<width/2)
      newCentersL(numNew,1) = x;
      newCentersL(numNew,2) = y;
      [rx, ry] = transformPointsInverse(geotrans, x, y);
      newCentersR(numNew,1) = rx;
      newCentersR(numNew,2) = ry;
   else
      newCentersR(numNew,1) = x;
      newCentersR(numNew,2) = y;
      [lx, ly] = transformPointsForward(geotrans, x, y);
      newCentersL(numNew,1) = lx;
      newCentersL(numNew,2) = ly;
   end
   if(input('Do you want to add another? y or n','s')~='y')
      return 
   end
   
end

end