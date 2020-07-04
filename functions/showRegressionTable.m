function showRegressionTable( regTable, testTable, responseName, infoStr, titleStr)

if isempty(regTable)
    return;
end

TabFigure = figure( 'Units','pixels', 'Position',[50 50 1000 500]);
setFigureInCenter(TabFigure);

uicontrol(TabFigure,'Style','text','Units', 'pixels',...
                        'Position', [5 455 990 40],'FontSize',12,...
                        'String', titleStr + " для выборки: " + responseName);   
                    
if ~isempty(testTable)                     
    infoStr = [string(testTable.Properties.VariableNames{3}) + " vs. Constant model: " + num2str(testTable{2,3}); infoStr];
    infoStr = [string(testTable.Properties.VariableNames{4}) + ": " + num2str(testTable{2,4}); infoStr];
end

uicontrol(TabFigure,'Style','text','Units', 'pixels', 'String', infoStr,...
                    'HorizontalAlignment','left','Position', [5 5 990 140],'FontSize',10);                   
                    

infoTable = uitable(TabFigure,'Units', 'pixels', ...
                                        'Position',[5 150 990 300], 'FontSize',10);
                                    
infoTable.Data = regTable.Variables;
infoTable.RowName = regTable.Properties.RowNames;
infoTable.ColumnName = regTable.Properties.VariableNames;

end

