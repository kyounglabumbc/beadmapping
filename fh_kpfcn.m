
function [] = fh_kpfcn(H,callbackInfo,filenome, numTraces)          
% Figure keypressfcn
S = guidata(H);
%P = get(S.fh,'position');
%set(S.tx,'string',E.Key)
switch callbackInfo.Key
    case 'rightarrow'
        if(S.counter<numTraces)
            S.counter = S.counter+1;
            traceID = S.counter;
            %assignin('base','a',1);
            ii = int2str(traceID);
            loadme = strcat(filenome,ii, '.csv');
            CurrentPlot = csvread(loadme);
            col1 = CurrentPlot(:, 1);
            col2 = CurrentPlot(:, 2);
            col3 = CurrentPlot(:,3);
            plot(col1, col2, 'g',col1,col3,'r');
            title(strcat('Current Trace Pair: ',ii));
            guidata(H,S);
        end
    case 'leftarrow'
        if(S.counter > 1)
            S.counter = S.counter-1;
            traceID = S.counter;
            %assignin('base','a',1);
            ii = int2str(traceID);
            loadme = strcat(filenome,ii, '.csv');
            CurrentPlot = csvread(loadme);
            col1 = CurrentPlot(:, 1);
            col2 = CurrentPlot(:, 2);
            col3 = CurrentPlot(:,3);
            plot(col1, col2, 'g',col1,col3,'r');
            title(strcat('Current Trace Pair: ',ii));
            guidata(H,S);
        end
    case 'uparrow'
%        set(S.fh,'pos',P+[0 5 0 0])
    case 'downarrow'
%        set(S.fh,'pos',P+[0 -5 0 0])
    otherwise  
end