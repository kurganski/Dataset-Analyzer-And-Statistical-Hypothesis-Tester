function ShowAnalyzedData( handles )

h = waitbar(0,'Выполняется отображение таблицы','WindowStyle','modal');

dataFrameNamesAndTypes = getappdata(handles.MainWindow,'dataFrameNamesAndTypes');
dataFrame = getappdata(handles.MainWindow,'dataFrame');

waitbar(0.1,h);

dataFrame = filterDataFrame(dataFrame, dataFrameNamesAndTypes, handles);

waitbar(0.5,h);

handles.DataTable.Data = prepareDataForTable(dataFrame);
handles.DataTable.UserData = {size(dataFrame,1), getNoEmptyDataLengths(dataFrame)};
handles.DataTable.ColumnName = dataFrameNamesAndTypes(1,:);

waitbar(1,h);
close(h);

end

