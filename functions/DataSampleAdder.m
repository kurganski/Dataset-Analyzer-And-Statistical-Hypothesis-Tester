function varargout = DataSampleAdder(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DataSampleAdder_OpeningFcn, ...
                   'gui_OutputFcn',  @DataSampleAdder_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


function varargout = DataSampleAdder_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function DataSampleAdder_CloseRequestFcn(hObject, eventdata, handles)

delete(handles.DataSampleAdder);


function DataSampleAdder_OpeningFcn(hObject, eventdata, handles, varargin)

addpath([cd '\functions'], [cd '\icons'], [cd '\info']);
handles.MainWindow.Visible = 'off';

setFigureInCenter(handles.DataSampleAdder);
handles.HelpText.String = {...
            "Для генерации нового столбца:";...
            "";...
            " - выберите текущий столбец;";...
            " - выберите условие;";...
            " - введите значение для условия;";...
            " - нажмите ""Применить"".";...
            "";...
            "Можно применять несколько раз.";...
            "";...
            "Для добавления к таблице:";...
            "";...
            " - введите название столбца;";...
            " - нажмите ""Добавить в таблицу"".";...
            };

if ~isempty(varargin) && isstruct(varargin{1})
    
    transferData = varargin{1};
    setappdata(handles.DataSampleAdder, 'dataFrame', transferData.dataFrame);
    setappdata(handles.DataSampleAdder, 'dataFrameNamesAndTypes', transferData.dataFrameNamesAndTypes);
    setappdata(handles.DataSampleAdder, 'mainWindowHandles', transferData.mainWindowHandles);  
    handles.ColumnNamePopupMenu.String = ["" transferData.dataFrameNamesAndTypes(1,:)];
    AdderShowAnalyzedData(handles);  
    handles.DataSampleList.UserData = strings(size(transferData.dataFrame,1),1);
    
end

handles.output = hObject;
guidata(hObject, handles);


handles.MainWindow.Visible = 'on';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function AdderShowAnalyzedData(handles)

h = waitbar(0,'Выполняется отображение таблицы','WindowStyle','modal');

dataFrameNamesAndTypes = getappdata(handles.DataSampleAdder,'dataFrameNamesAndTypes');
dataFrame = getappdata(handles.DataSampleAdder,'dataFrame');

waitbar(0.5,h);

handles.DataTable.Data = prepareDataForTable(dataFrame);
handles.DataTable.UserData = {size(dataFrame,1), getNoEmptyDataLengths(dataFrame)};
handles.DataTable.ColumnName = dataFrameNamesAndTypes(1,:);

waitbar(0.8,h);

DataTable_CellSelectionCallback(0, 0, handles);

waitbar(1,h);
close(h);


function DataTable_CellSelectionCallback(hObject, eventdata, handles)

try
    isOneColSelected = CheckColsNumberSelected(eventdata.Indices);
catch
    isOneColSelected = false;
end

if isOneColSelected && eventdata.Indices(2) >= length(handles.ColumnNamePopupMenu.String)
    handles.DeleteColumnButton.Enable = 'on';
    handles.DeleteColumnButton.UserData = eventdata.Indices(2);
else
    handles.DeleteColumnButton.Enable = 'off';
    handles.DeleteColumnButton.UserData = [];
end


function ColumnNamePopupMenu_Callback(hObject, eventdata, handles)

dataFrameNamesAndTypes = getappdata(handles.DataSampleAdder,'dataFrameNamesAndTypes');
dataFrame = getappdata(handles.DataSampleAdder,'dataFrame');

handles.ValueMenuEdit.Value = 1;
handles.EquationPopupMenu.Value = 1;
selectedCol = handles.ColumnNamePopupMenu.Value-1;

if handles.ColumnNamePopupMenu.Value == 1
    
    handles.ValueMenuEdit.String = "";
    handles.EquationPopupMenu.String = "";
    handles.ColumnStatisticsText.String = "";
    return
    
elseif dataFrameNamesAndTypes(2, selectedCol) == "категориальный" || ...
        dataFrameNamesAndTypes(2, selectedCol) == "логический"
    
    dataName = getMenuString(handles.ColumnNamePopupMenu);
    data = dataFrame{:,find(dataFrameNamesAndTypes(1,:)==dataName)};
    
    data = replaceNaN(data);
    uniqueData = unique(data);
    
    handles.ValueMenuEdit.Style = 'popupmenu';
    handles.ValueMenuEdit.String = uniqueData;
        
    handles.EquationPopupMenu.String = {'=='; '~='};    

elseif dataFrameNamesAndTypes(2, selectedCol) == "числовой"  
    
    handles.ValueMenuEdit.String = ' ';
    handles.ValueMenuEdit.Style = 'edit';
    
    handles.EquationPopupMenu.String = {'=='; '~='; '>'; '>='; '<'; '<='};
     
else    
    assert(0,"Неопределенная строка из таблицы")    
end

dataFrameLengths = handles.DataTable.UserData{2};

handles.ColumnStatisticsText.String = "Число строк: " + ...
                num2str(dataFrameLengths(selectedCol)) + " из " + ...
                num2str(handles.DataTable.UserData{1}) + " ("   + ...
                dataFrameNamesAndTypes(2,selectedCol)  + ...
                " тип данных)";
            
            
function ApplyButton_Callback(hObject, eventdata, handles)

dataFrameNamesAndTypes = getappdata(handles.DataSampleAdder,'dataFrameNamesAndTypes');
dataFrame = getappdata(handles.DataSampleAdder,'dataFrame');

newColumn = handles.DataSampleList.UserData;
newValue = handles.ValueEdit.String;

selectedCol = handles.ColumnNamePopupMenu.Value-1;
sampleType = dataFrameNamesAndTypes(2,selectedCol);
filteredCol = dataFrame{:,selectedCol};

newColumn = applyNewValueToSample(handles, newColumn, filteredCol, sampleType, newValue);
if isempty(newColumn)
    return    
end

handles.DataSampleList.UserData = newColumn;

numbers = 1:length(newColumn);
handles.DataSampleList.String = strcat(num2str(numbers'), ") ", newColumn);

newColumnSampleType = getSampleType( newColumn );

handles.NewColumnStatisticsText.String = "Число строк: " + ...
                num2str(length(replaceNaN(newColumn))) + " из " + ...
                num2str(length(newColumn)) + " ("   + ...
                newColumnSampleType  + " тип данных)";


function AddToTableButton_Callback(hObject, eventdata, handles)

newColName = handles.NameEdit.String;
newColumn = handles.DataSampleList.UserData;
newColumnSampleType = getSampleType( newColumn );
newColumn = setSampleType(newColumn, newColumnSampleType);

dataFrameNamesAndTypes = getappdata(handles.DataSampleAdder,'dataFrameNamesAndTypes');
dataFrame = getappdata(handles.DataSampleAdder,'dataFrame');

try
    dataFrame = [dataFrame table(newColumn, 'VariableNames', {newColName})];
catch
    errordlg({'Имя столбца должно быть уникальным, содержать только';...
            'латинские символы и цифры и начинаться с латинсокго символа'},...
            'Ошибка добавления столбца','modal');
    return
    
end

dataFrameNamesAndTypes(1,end+1) = newColName;
dataFrameNamesAndTypes(2,end) = newColumnSampleType;

setappdata(handles.DataSampleAdder, 'dataFrame', dataFrame);
setappdata(handles.DataSampleAdder, 'dataFrameNamesAndTypes', dataFrameNamesAndTypes);

AdderShowAnalyzedData(handles);      


function DeleteColumnButton_Callback(hObject, eventdata, handles)

colToDelete = handles.DeleteColumnButton.UserData;

if isempty(colToDelete)
    return
end

dataFrameNamesAndTypes = getappdata(handles.DataSampleAdder,'dataFrameNamesAndTypes');
dataFrame = getappdata(handles.DataSampleAdder,'dataFrame');

dataFrame(:,colToDelete) = [];
dataFrameNamesAndTypes(:,colToDelete) = [];

setappdata(handles.DataSampleAdder, 'dataFrame', dataFrame);
setappdata(handles.DataSampleAdder, 'dataFrameNamesAndTypes', dataFrameNamesAndTypes);

AdderShowAnalyzedData(handles);  


function SaveAndExitButton_Callback(hObject, eventdata, handles)

dataFrameNamesAndTypes = getappdata(handles.DataSampleAdder,'dataFrameNamesAndTypes');
dataFrame = getappdata(handles.DataSampleAdder,'dataFrame');

mainWindowHandles = getappdata(handles.DataSampleAdder, 'mainWindowHandles');  

setappdata(mainWindowHandles.MainWindow, 'dataFrame', dataFrame);
setappdata(mainWindowHandles.MainWindow, 'dataFrameNamesAndTypes', dataFrameNamesAndTypes);

DataSampleAdder_CloseRequestFcn(hObject, eventdata, handles);

refreshMainFigureAfterTableEdit(mainWindowHandles, dataFrameNamesAndTypes);

ShowAnalyzedData(mainWindowHandles);
