function buildScatterPlots(dataY, dataX, axesHandle)

if nargin == 2
    axesHandle = gca;
end

for x = 1:size(dataX,2)
    plot(axesHandle, dataX(:,x), dataY, 's');
end

end

