function showGroupedData( initDataset, groupData, dataXName, datasets )


TabFigure = figure( 'Units','pixels', 'Position',[50 50 700 700]);
setFigureInCenter(TabFigure);

uicontrol(TabFigure,'Style','text','Units', 'pixels',...
                        'Position', [5 660 695 30],'FontSize',12,...
                        'String', 'Результат группировки выборки');

data = cell(size(datasets(1).dataset,1), size(datasets,2) + 2);
colNames = strings(1,size(datasets,2) + 2);

data(:,1) = num2cell(initDataset.dataset);
data(:,2) = num2cell(groupData);

colNames(1) = initDataset.name;
colNames(2) = dataXName;

for x = 3:size(data,2)
   
    data(:,x) = num2cell(datasets(x-2).dataset);
    colNames(x) = datasets(x-2).name;
    
end           
                 
data = cellfun(@(x) ifStr2char(x), data, 'UniformOutput',0);

infoTable = uitable(TabFigure,'Units', 'pixels', 'Position',[5 5 695 650], 'FontSize',10);                                    
infoTable.Data = data;
infoTable.ColumnName = char(colNames');

end


function charStr = ifStr2char(data)

charStr = data;
if isstring(data)
    charStr = char(data);
end
end
