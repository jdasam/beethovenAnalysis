 dataSet = getFileListWithExtension('*.wav');
 
 resultSum = [];
 resultSum.ratio1 = {};
 
 
 for i=1:length(dataSet)
     artistName = dataSet{i};
     matName = strcat(artistName, '.mat');
     
     load(matName)
     
     resultSum.ratio1{i} = result.ratio{1};
     resultSum.ratio2{i} = result.ratio{2};
    resultSum.ratio3{i} = result.ratio{3};
    resultSum.ratio4{i} = result.ratio{4};
    resultSum.ratio5{i} = result.ratio{5};


     
 end
 %
 figure(1)
set(1, 'DefaultAxesLineStyleOrder', {'-', '--'})
% set(1, 'DefaultAxesLineStyleOrder', {'+'})

 hold on
 for i=1:length(resultSum.ratio1)
     plot([ resultSum.ratio4{i}(2,1)  resultSum.ratio2{i}(2,1) resultSum.ratio1{i}(2,1) resultSum.ratio3{i}(2,1)] , 'LineWidth', 3)
     
     
 end
 legend(dataSet, 'FontSize', 25, 'LineWidth', 1) 
 hold off
 