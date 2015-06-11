% ask user how many vido files in system
%should i be specifying the folder we will read from?
filenome = input('Please enter the file name: ','s');
number = input ('please enter the number of traces: ');
i = 1;
ii = int2str(i);
loadme = strcat(filenome,ii, '.csv');
CurrentPlot = csvread(loadme);
col1 = CurrentPlot(:, 1);
col2 = CurrentPlot(:, 2);
col3 = CurrentPlot(:,3);


%    a = 0;

%waitforbuttonpress;

S.fh = figure('units','pixels',...
              'name','Trace Analysis',...
              'numbertitle','off',...
              'resize','off',...
              'keypressfcn',{@fh_kpfcn,filenome,number});
figData.counter = 1;
guidata(S.fh, figData);
%guidata(S.fh,S);
plot(col1, col2, 'g',col1,col3, 'r');
title('Current Trace Pair: 1');
%pause;
%i = i + a;
%close(gcf);










%NOTES
%for n=10:1:30
%   outputString = sprintf('I am %d years old', n)
%end
%
%f = cell(N, 1);
%for i=1:N
%   f{i} = strcat('f', num2str(i));
%end