function filteredPeakLoc = detectAmsterdam(peakLoc, peakAmp, period)
    %Input: location of peak (vector), amplitude of each peak (vector)
    %Output: Location of filtered peaks (consist with 3-1-2 amsterdam
    %rhythm)
    
    %Check whether the first peak is the start note of the pattern
    while peakAmp(1) < peakAmp(2) *0.8
        peakAmp(1) = [];
        peakLoc(1) = [];
    end
    
    filteredPeakLoc = [];
    filteredPeakLoc(1) = peakLoc(1);

    for i = 2 : length(peakLoc)
       
        
        
        
        if mod(peakLoc(i) - peakLoc(1), period) < period/10 & peakLoc(i) - peakLoc(1) > period *0.9
            filteredPeakLoc(length(filteredPeakLoc)+1) = peakLoc(i);
            continue
        end
        
        
        cond1 = mod(peakLoc(i) - peakLoc(1), period) > period / 2.6;
        cond2 = mod(peakLoc(i) - peakLoc(1), period) < period *0.72;
        
        if cond1 & cond2
            filteredPeakLoc(length(filteredPeakLoc)+1) = peakLoc(i);
        end
    end
    
    
    peakInterval = diff(filteredPeakLoc);
    peakInterval(1:3)/peakInterval(2)
    sum(peakInterval(1:2))/peakInterval(3)


end