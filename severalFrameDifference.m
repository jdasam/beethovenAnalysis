function diffSmoothed = severalFrameDifference(X, numFrame, weight)

if nargin < 3
    weight = 1:numFrame;
    weight = 1 ./ weight;
end

diffSmoothed = zeros(size(X));

for i = 1:numFrame
    tempX = [zeros(size(X,1),i), X(:,1:end-i)];
    diffSmoothed = diffSmoothed + max(X-tempX*weight(i), 0);
end
    

diffSmoothed = diffSmoothed / numFrame;
    

end