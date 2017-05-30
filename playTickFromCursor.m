function [] = playTickFromCursor(sample, cursor_info, basicParameter, speed)
    
    position = [];
    
    for i = 1:length(cursor_info)
        position(i) = cursor_info(i).DataIndex;
    end
    
    
    sampleIndex = position * basicParameter.nfft + basicParameter.window/2;
    
    for i = 1:length(sampleIndex)
        sample(sampleIndex,1:2) = 0.6;
    end
    
    soundsc(sample, basicParameter.sr * speed);


end