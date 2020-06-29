function refreshMainFigureAfterTableEdit( handles, dataFrameNamesAndTypes )

graphDescriptions = getGraphsDescriptions(getappdata(handles.MainWindow,'graphs'));

allMenuToDefaultState(handles);

handles.HelpText.String = graphDescriptions(1);
handles.GraphPopupmenu.Value = 1;

numericDataNames = ["" dataFrameNamesAndTypes(1,dataFrameNamesAndTypes(2,:)=="числовой")];

handles.Y1popupmenu.String = numericDataNames;
handles.Y2popupmenu.String = numericDataNames;
handles.Y3popupmenu.String = numericDataNames;
handles.Y4popupmenu.String = numericDataNames;
handles.Y5popupmenu.String = numericDataNames;
handles.Y6popupmenu.String = numericDataNames;

handles.Y1popupmenu.Enable = 'On';
handles.Y2popupmenu.Enable = 'On';
handles.Y3popupmenu.Enable = 'On';
handles.Y4popupmenu.Enable = 'On';
handles.Y5popupmenu.Enable = 'On';
handles.Y6popupmenu.Enable = 'On';

handles.GraphAdditionalPopupMenu1.Visible = 'On';
handles.GraphAdditionalPopupMenu1.String = {'Абсолютная','Нормированная'};
imshow(getappdata(handles.MainWindow,'HistogramIcon'),...
    'Parent',handles.IconAxes);

handles.FilterPopupMenu1.String = ["" dataFrameNamesAndTypes(1,:)];
handles.FilterPopupMenu2.String = ["" dataFrameNamesAndTypes(1,:)];
handles.FilterPopupMenu3.String = ["" dataFrameNamesAndTypes(1,:)];
handles.FilterPopupMenu4.String = ["" dataFrameNamesAndTypes(1,:)];
handles.FilterPopupMenu5.String = ["" dataFrameNamesAndTypes(1,:)];

handles.ShowColPopupmenu1.String = dataFrameNamesAndTypes(1,:);
handles.ShowColPopupmenu2.String = dataFrameNamesAndTypes(1,:);
handles.ShowColPopupmenu3.String = dataFrameNamesAndTypes(1,:);

end

