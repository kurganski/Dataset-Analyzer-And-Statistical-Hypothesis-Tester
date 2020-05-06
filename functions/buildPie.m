function buildPie( data, axesHandle )

if nargin == 1
    axesHandle = gca;
end

labels = unique(data);

pieData = zeros(size(labels,1),1);

for x = 1:size(labels,1)
    pieData(x) = sum( data == labels(x) );
end

if isnumeric(labels)
    labels = num2str(labels);
end

pieData = pieData / size(data,1);

labels = strcat(labels, ": ");
labels = strcat(labels, num2str(pieData*100));
labels = strcat(labels, " %");
labels =  cellstr(labels);

pie(axesHandle, pieData, labels);
set(axesHandle, 'XColor',[0.94 0.94 0.94],'YColor',[0.94 0.94 0.94],...
    'XTick',[],'YTick',[],'Color',[0.94 0.94 0.94]);

end

