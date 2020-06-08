function buildErrorBar( dataY, dataX, axesHandle)

if nargin == 2
    axesHandle = gca;
end

dataY(dataX=="" | isempty(dataY) | ismissing(dataX)) = [];
dataX(dataX==""| isempty(dataY) | ismissing(dataX)) = [];

boxplot(axesHandle, dataY, dataX);
    
end

