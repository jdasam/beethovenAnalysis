function ratio = amsterdamRatio(onset, basicParameter)
    if isstruct(onset)
        onset = cursorToOnset(onset);
    end

%     onset = sort(onset);

    interval = diff(onset(:,1));
    
    ratio1= zeros(1,3);
    ratio2= zeros(1,2);
    ratio3= zeros(1,1);
    ratio4= zeros(1,3);
    
    for i = 1:length(interval)/3
        index = (i-1) *3 +1;
        ratio1(i,:) = [interval(index) interval(index+1) interval(index+2)] / interval(index+2);
        ratio2(i,:) = [interval(index) + interval(index+1) interval(index+2)] / interval(index+2);
        ratio3(i) = onset(i+3) - onset(i);
        ratio4(i,:) = [onset(i,2) onset(i+1,2) onset(i+2,2)]; 
    end
    
    
    ratio(1, 1:3) = mean(ratio1);
    ratio(2, 1:2) = mean(ratio2);
    ratio(3, 1) = 60 / (mean(ratio3) * basicParameter.nfft / basicParameter.sr);     
    ratio(4, 1:3) = mean(ratio4)/max(mean(ratio4));

    
end


function onset = cursorToOnset(cursor_info)

    for i = 1:length(cursor_info)

        position(i,1:2) = cursor_info(i).Position(1:2);

    end
    onset = sortrows(position);
end

function amplitude = cursorToAmp(cursor_info)

    for i = 1:length(cursor_info)

        amplitude(i) = cursor_info(i).Position(2);

    end
end