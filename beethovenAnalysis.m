artistName = 'celibidache';
audioFilename = strcat(artistName,'.wav');
csvName = strcat(artistName,'.csv');
%audioFilename = 'gustavoDudamel.wav';



basicParameter = basicParameterInitialize();
basicParameter.nfft = 137;
basicParameter.window = 1024;
[X, basicParameter.sr] = audio2spectrogram(audioFilename, basicParameter);

d1 = audioread(audioFilename);
% 
if size(d1,2) == 2
    dMono = (d1(:,1) + d1(:,2))/2;
end

tempoInf =csvread(csvName);

if exist(strcat(artistName,'.mat'), 'file')
    load(strcat(artistName,'.mat'));
else
    result =[];
    result.name = artistName;
    result.ratio = {};
end

%%
result.ratio{targetPart} = amsterdamRatio(cursor_info,basicParameter);
amsterdamRatio(cursor_info, basicParameter)

save(strcat(artistName,'.mat'), 'result')

%%
soundSample = d1(targetT*sr:(targetTend)*sr,1:2);

 
playTickFromCursor(soundSample, cursor_info, basicParameter, 0.3)

%%
sr = basicParameter.sr;
hop = basicParameter.nfft;
freqL = 50;
freqH = 200;
gamma = 1.2;
smoothFrame = 5;
range = 3;
soundOn = true;
plotOn = true;


targetPart = 2;

timeList = [592.2 595; 540.2 543; 609.2 614.6; 532.9 536; 597 599.8; 520.8 528.8];



targetT = tempoInf(timeList(targetPart,1) * 10)/100;
targetTend = tempoInf(timeList(targetPart,2) * 10)/100;

if soundOn
soundsc(d1(targetT*sr:(targetTend)*sr,1:2), 44100);
end

%
% targetX = X(freqL:freqH,targetT*sr/hop:(targetT+duration)*sr/hop);
targetX = log(1+gamma*X(freqL:freqH,targetT*sr/hop:(targetTend)*sr/hop));
targetXdX = max(targetX - [zeros(size(targetX,1),1) targetX(:, 1:end-1)], 0);
% targetXdXsmooth = max(targetX - ([zeros(size(targetX,1),1) targetX(:, 1:end-1)] + [zeros(size(targetX,1),2) targetX(:, 1:end-2)] )/2, 0);
targetXdXsmooth = severalFrameDifference(targetX, smoothFrame);
targetXdXsmoothNorm = targetXdXsmooth ./ max(sum(targetXdXsmooth));
%


[pks, locs] = findpeaks(sum(targetXdXsmoothNorm), 'MinPeakHeight',0.3,'MinPeakDistance',20);
[~, maxPksIdx] = max(pks(1:3));
maxPksLoc = locs(maxPksIdx);

%

featC = zeros(size(targetX,2)-range,1);
for i = range+1:size(targetX,2)-range
    featC(i) = sum(sum( targetXdXsmoothNorm(:,maxPksLoc-range:maxPksLoc+range)) .* sum(targetXdXsmoothNorm(:,i-range:i+range)) );


end

if plotOn figure(2); plot(featC); end

%


%%


% imagesc(targetX(1:100, :))
% axis x

plot(sum(targetX))
hold on
plot(sum(targetXdX))
% hold on

plot(sum(targetXdXsmooth))

% hold off

%%

soundsc(d1(targetT*sr:(targetTend)*sr,1:2), 44100);


featE =  sgolayfilt(sum(targetXdXsmooth),7,21);
plot(featE(2:end))




%%
targetXnorm = targetX ./ max(sum(targetX));


plot(sum(targetXnorm))
%%


sumX = sum(targetXdX);
acfResult = acf(sumX', 600);
plot(acfResult)

threshold1 = 20;
[~, period] = max(acfResult(threshold1:end));
period = period + threshold1;



%%
featD =  sgolayfilt(sum(targetXnorm),7,21);
% plot(featD)
 findpeaks(featD, 'MinPeakHeight',0.5,'MinPeakDistance',20, 'threshold', 0)
[pksD, locsD] = findpeaks(featD, 'MinPeakHeight',0.5,'MinPeakDistance',10, 'threshold', 0);
peakIntervalD = diff(locsD);
peakIntervalD(1:3)/peakIntervalD(2);

filteredPeakLoc = detectAmsterdam(locsD, pksD, period);


%%

featA = sum(targetX);
[pks, locs] = findpeaks(featA, 'MinPeakHeight',1,'MinPeakDistance',20);
 findpeaks(featA, 'MinPeakHeight',1,'MinPeakDistance',20)
peakInterval = diff(locs);

[~, maxPksIdx] = max(pks(1:3));
maxPksLoc = locs(maxPksIdx);
% maxPksLoc = 43;


%%
featB = -sum(targetX);
[pks, locsB] = findpeaks(featB ,'MinPeakHeight',-20,'MinPeakDistance',20);
findpeaks(featB ,'MinPeakHeight',-20,'MinPeakDistance',30)

%%
featC = zeros(600,1);
range = 4;
for i = range+1:600
%    featC(i) = sum(sum( targetX(:,locsB(1):locsB(2)) .* targetX(:,locsB(1)+i:locsB(2)+i) ));
%     featC(i) = sum(sum( targetX(:,maxPksLoc-range:maxPksLoc+range) .* targetX(:,i-range:i+range) ));
%     featC(i) = sum(sum( targetXdXsmooth(:,maxPksLoc-range:maxPksLoc+range) .* targetXdX(:,i-range:i+range) ));
    featC(i) = sum(sum( featE(:,maxPksLoc-range:maxPksLoc+range)) .* sum(targetXdX(:,i-range:i+range)) );

%     featC(i) = sum(sum( featA(:,maxPksLoc-range:maxPksLoc+10) .* featA(:,maxPksLoc-range+i:maxPksLoc+10+i) ));

end

plot(featC)
%%
lag = 130;
plot(sum(targetX(:,1:600)) )

hold on
for i = 1:10
    lag = i * 20;
    plot([zeros(1,lag)  sum( targetX(:,maxPksLoc-range:maxPksLoc+range))])

end
hold off


%%
[pksC, locsC] = findpeaks(featC, 'MinPeakDistance',20, 'threshold',0.01, 'MinPeakHeight', 4);
findpeaks(featC, 'MinPeakDistance',20, 'threshold',0.01, 'MinPeakHeight', 4)
peakIntervalC = diff([ locsC]);
peakIntervalC(1:3)/peakIntervalC(2)

%%
featR = zeros(900,1);
for i = 1:900
%     featR(i) = sum(sum(targetXdX(:,i:end)) .* sum(targetXdX(:,1:end-i+1))) / sum(sum(targetXdX.^2));
%     featR(i) = sum(sum(targetX(:,i:end)) .* sum(targetX(:,1:end-i+1))) / sum(sum(targetX.^2));
    featR(i) = sum(featC(i:end) .* featC(1:end-i+1)) / sum(featC.^2);
    
    
end
plot(featR)
[pksR, locsR] = findpeaks(featR, 'MinPeakDistance',5, 'threshold',0)

%%
lag = 100;

plot(sum(targetX(:,lag:end)))
hold on
plot(sum(targetX(:,1:end-lag+1)))
hold off

%%

subbandEnergy = zeros(1,size(targetX,2));

for i=1:length(subbandEnergy)
    subbandEnergy(i) = sum(dMono(targetT*sr+(i-1)*hop:targetT*sr+i*hop).^2);
    
end
plot(subbandEnergy);



%%
minFreq = 10;
maxFreq = 3000;
bins = 10;
fs = 44100;

% sparKernel= sparseKernel(minFreq, maxFreq, bins, fs);
% cq = constQ(d1(100000:100441)', sparKernel);

scq = shortConstantQ(d1, 4092, minFreq, maxFreq, bins, fs);


%%
19 41 52 77
13 40 48 69
20 56 73 107
3 26 34 62
18 47 55 85

360 425 448 520
70  142 172 246
50 124 156 227
373 440 470 533
420 488 515 590
%%
r = [18328064 18339840 18343936 18354688]

(r(2:4) - r(1:3)) / (r(4)-r(1))


% targetT= 592.2;
% targetT = 596.9;
% targetT = 609; % rattle string
% targetT = 540.2;
% targetT = 606.8; %celibidache
% targetT = 443.6; %karajan
% targetT = 558; % gardiner
% targetT = 443.3; %toscanini
% targetT = 627; % bruggen
% targetT = 456.5; %dudamel
% targetT = 616.3; %bernstein
% targetT = 621.5; %barenboim
% targetT = 441.2; %kleiber
% targetT = 581.2; %kleiber2 
% targetT = 596.7; %kleiber2, string
% targetT = 622.8; %solti 
% targetT = 639.4; %solti string
% targetT = 468.6; %masur
% targetT = 486.5; %masur string
% targetT = 415.3; %masur wind
% targetT= 1;

