function showLogitTable( infoTable, responseName )

if isempty(infoTable)
    return;
end

logitTabFigure = figure( 'Units','pixels', 'Position',[50 50 1000 500]);
setFigureInCenter(logitTabFigure);

uicontrol(logitTabFigure,'Style','text','Units', 'pixels',...
                        'Position', [5 455 990 40],'FontSize',12,...
                        'String', "Логистическая регрессия для выборки: " + responseName);

logitTabTable = uitable(logitTabFigure,'Units', 'pixels', ...
                                        'Position',[5 50 990 400], 'FontSize',10);

if isstruct(infoTable)
    logitTabTable.Data = infoTable.data;
    logitTabTable.RowName = infoTable.rowNames;
    logitTabTable.ColumnName = infoTable.colNames;     
else
    logitTabTable.Data = infoTable.Variables;
    logitTabTable.RowName = infoTable.Properties.RowNames;
    logitTabTable.ColumnName = infoTable.Properties.VariableNames;
end

end

