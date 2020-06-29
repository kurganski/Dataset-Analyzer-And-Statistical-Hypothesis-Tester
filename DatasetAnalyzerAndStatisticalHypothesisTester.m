function varargout = DatasetAnalyzerAndStatisticalHypothesisTester(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DatasetAnalyzerAndStatisticalHypothesisTester_OpeningFcn, ...
                   'gui_OutputFcn',  @DatasetAnalyzerAndStatisticalHypothesisTester_OutputFcn, ...
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

function varargout = DatasetAnalyzerAndStatisticalHypothesisTester_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function DatasetAnalyzerAndStatisticalHypothesisTester_OpeningFcn(hObject, ~, handles, varargin)
warning off;
addpath([cd '\functions'], [cd '\icons'], [cd '\info']);
handles.MainWindow.Visible = 'off';


handles.output = hObject;
guidata(hObject, handles);

graphs = getGraphs();

setappdata(handles.MainWindow,'HistogramIcon',imread('HistogramPlot.png'));
setappdata(handles.MainWindow,'HeatMapIcon',imread('HeatMapChart.png'));
setappdata(handles.MainWindow,'ErrorBarIcon',imread('ErrorBarPlot.png'));
setappdata(handles.MainWindow,'ScatterIcon',imread('ScatterPlot.png'));
setappdata(handles.MainWindow,'PieIcon',imread('PieChart.png'));
setappdata(handles.MainWindow,'ScatterPlotMatrixIcon',imread('ScatterPlotMatrix.png'));
setappdata(handles.MainWindow,'ScatterHistIcon',imread('ScatterHist.png'));

setFigureInCenter(handles.MainWindow);
setappdata(handles.MainWindow,'graphs',graphs);


% NEW FUNCTIONALITY
%  
% точный макнемара сделать
% точный Кохрена сделать
% точный для 3 дихотомических добавить
% зависимые номинативные выборки критерий добавить
% добавить хвосты и доверительные инервалы для дихотомиеских критериев


% USER DESCRIPTIONS
% 


% CODE REFACTOR
% 
% вызов ошибки сделать методом
% не запускать фильтрацию таблицы каждый раз, если значения фильтров пустые

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function OpenDataTable_Callback(hObject, eventdata, handles)

[FileName, PathName] = uigetfile({'*.xlsx;*.xls;*.csv'}, 'Выберите файл таблицы данных');    
if ~FileName                         
    return;
end

try
    h = waitbar(0,'Загрузка данных','WindowStyle','modal'); 
    
    % если надо csv, то UTF-8
    if FileName(end-2:end) == "csv"
        
        T = readtable([PathName FileName],...
            'TextType','string',...
            'Encoding','UTF-8',...
            'ReadVariableNames',0 ...
            );
        
    else
        T = readtable([PathName FileName],...
            'TextType','string',...
            'ReadVariableNames',0 ...
            );
    end
    
    if exist('h','var')
        waitbar(0.5,h);
    end
    
    [dataFrame, dataFrameNamesAndTypes] = setTableFieldsTypes(T);
    
catch
    
    if exist('h','var')
        close(h);
    end
    
    errordlg({'Не удалось прочитать данные.';...
        'Файл должен иметь расширение "xlsx", "xls" или "csv",';...
        'а данные должен быть представлены в виде двухмерной таблицы без объединенных столбцов/строк.'},...
        'Ошибка чтения файла','modal');
    return;
end

if length(unique(dataFrameNamesAndTypes(1,:))) ~= length(dataFrameNamesAndTypes(1,:))
    
    if exist('h','var')
        close(h);
    end
    
    errordlg({'Не удалось прочитать данные.';...
        'Имена столбцов должны быть уникальными.'},...
        'Ошибка чтения файла','modal');
    return;    
end

setappdata(handles.MainWindow,'dataFrame',dataFrame);
setappdata(handles.MainWindow,'dataFrameNamesAndTypes',dataFrameNamesAndTypes);

handles.GraphPopupmenu.String = getGraphsNames(getappdata(handles.MainWindow,'graphs'));

handles.FilterPopupMenu1.String = ["" dataFrameNamesAndTypes(1,:)];
handles.FilterPopupMenu2.String = ["" dataFrameNamesAndTypes(1,:)];
handles.FilterPopupMenu3.String = ["" dataFrameNamesAndTypes(1,:)];
handles.FilterPopupMenu4.String = ["" dataFrameNamesAndTypes(1,:)];
handles.FilterPopupMenu5.String = ["" dataFrameNamesAndTypes(1,:)];

handles.ShowColPopupmenu1.String = dataFrameNamesAndTypes(1,:);
handles.ShowColPopupmenu2.String = dataFrameNamesAndTypes(1,:);
handles.ShowColPopupmenu3.String = dataFrameNamesAndTypes(1,:);

GraphPopupmenu_Callback(hObject, eventdata, handles);

handles.GraphPopupmenu.Enable = 'On';
handles.BuildButton.Enable = 'On';
handles.SaveDataTable.Enable = 'On';
handles.ColumnAdderMenu.Enable = 'On';

handles.FilterPopupMenu1.Enable = 'On';
handles.FilterPopupMenu2.Enable = 'On';
handles.FilterPopupMenu3.Enable = 'On';
handles.FilterPopupMenu4.Enable = 'On';
handles.FilterPopupMenu5.Enable = 'On';

handles.EquationPopupMenu1.Enable = 'On';
handles.EquationPopupMenu2.Enable = 'On';
handles.EquationPopupMenu3.Enable = 'On';
handles.EquationPopupMenu4.Enable = 'On';
handles.EquationPopupMenu5.Enable = 'On';

handles.FilterValuePopupMenu1.Enable = 'On';
handles.FilterValuePopupMenu2.Enable = 'On';
handles.FilterValuePopupMenu3.Enable = 'On';
handles.FilterValuePopupMenu4.Enable = 'On';
handles.FilterValuePopupMenu5.Enable = 'On';

if exist('h','var')
    waitbar(0.75,h);
end

ShowAnalyzedData_Callback(hObject, eventdata, handles); 

if size(dataFrameNamesAndTypes, 2) > 2
    handles.ShowColPopupmenu1.Value = 1;
    handles.ShowColPopupmenu2.Value = 2;
    handles.ShowColPopupmenu3.Value = 3;
else
    handles.ShowColPopupmenu1.Value = 1;
    handles.ShowColPopupmenu2.Value = 1;
    handles.ShowColPopupmenu3.Value = 1;    
end

ShowColPopupmenu_Callback(hObject, eventdata, handles);

handles.DataTable.Visible = 'On';

handles.ShowColPopupmenu1.Visible = 'On';
handles.ShowColPopupmenu2.Visible = 'On';
handles.ShowColPopupmenu3.Visible = 'On';

handles.ShowColList1.Visible = 'On';
handles.ShowColList2.Visible = 'On';
handles.ShowColList3.Visible = 'On';

if exist('h','var')
    waitbar(1,h);
    close(h);
end


function ColumnAdderMenu_Callback(hObject, eventdata, handles)

dataFrame = getappdata(handles.MainWindow,'dataFrame');
dataFrameNamesAndTypes = getappdata(handles.MainWindow,'dataFrameNamesAndTypes');

transferData.dataFrame = dataFrame;
transferData.dataFrameNamesAndTypes = dataFrameNamesAndTypes;
transferData.mainWindowHandles = handles;

DataSampleAdder(transferData);


function SaveDataTable_Callback(hObject, eventdata, handles)

[FileName,PathName] = uiputfile({'*.xlsx';'*.xls';'*.csv'}, ...
    'Выберите файл для сохранения анализируемых данных');

if ~FileName                         
    return;
end

dataFrameNamesAndTypes = getappdata(handles.MainWindow,'dataFrameNamesAndTypes');
names = cellstr(dataFrameNamesAndTypes(1,:));

dataFrame = getappdata(handles.MainWindow,'dataFrame');
dataFrame = cell2table([names; table2cell(dataFrame)]);

writetable(dataFrame, [PathName FileName],'FileType','spreadsheet','WriteVariableNames',0);


function AboutMenu_Callback(hObject, eventdata, handles)

msgbox (...
    {...
    "Dataset Analyzer And Statistical Hypothesis Tester" ;...
    "Версия: 0.5" ;...
    "" ;...
    "Приложение предназначено для визуализации и анализа табличных данных.";...
    "Основные особенности:" ;...
    " - поддержка xls, xlsx, csv файлов;" ;...
    " - отображение загруженной таблицы данных;" ;...
    " - построение графиков и диаграмм для анализа данных;" ;...
    " - автоматический подбор и расчет критериев проверки статистических гипотез о различии выборок;" ;...
    " - встроенная справка по графикам и диаграммам;" ;...
    " - применение до 3 фильтров к анализируемым данным;" ;...
    "" ;...
    "" ;...
    "Автор: Курганский Андрей Андреевич (k-and92@mail.ru)" ;...
    "" ;...
    "" ;...
    },...
    'О программе','WindowStyle','modal');


function GraphPopupmenu_Callback(hObject, eventdata, handles)

graphs = getappdata(handles.MainWindow,'graphs');
graphDescriptions = getGraphsDescriptions(getappdata(handles.MainWindow,'graphs'));

dataFrameNamesAndTypes = getappdata(handles.MainWindow,'dataFrameNamesAndTypes');

allDataNames = ["" dataFrameNamesAndTypes(1,:)];
stringDataNames = ["" dataFrameNamesAndTypes(1,dataFrameNamesAndTypes(2,:)=="номинативный")];
numericDataNames = ["" dataFrameNamesAndTypes(1,dataFrameNamesAndTypes(2,:)=="непрерывный")];
logicalDataNames = ["" dataFrameNamesAndTypes(1,dataFrameNamesAndTypes(2,:)=="дихотомический")];

numericAndLogicalDataNames = [""  dataFrameNamesAndTypes(1, dataFrameNamesAndTypes(2,:)=="непрерывный" |...
                                dataFrameNamesAndTypes(2,:)=="дихотомический")];

stringAndLogicalDataNames = [""  dataFrameNamesAndTypes(1, dataFrameNamesAndTypes(2,:)=="номинативный" |...
                                dataFrameNamesAndTypes(2,:)=="дихотомический")];


allMenuToDefaultState(handles);
handles.HelpText.String = graphDescriptions(handles.GraphPopupmenu.Value);

switch getMenuString(handles.GraphPopupmenu)
    
    case graphs.hist.name
        
        imshow(getappdata(handles.MainWindow,'HistogramIcon'),...
            'Parent',handles.IconAxes);
        
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
        
        handles.uipanel1.Title = 'Выборки';
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {'Абсолютная','Нормированная','Трехмерная'};
    
        
    case graphs.catHist.name
        
        imshow(getappdata(handles.MainWindow,'HistogramIcon'),...
            'Parent',handles.IconAxes);      
        
        handles.Y1popupmenu.String = numericDataNames;
        handles.Y1popupmenu.Enable = 'On';
        
        handles.X1popupmenu.String = stringAndLogicalDataNames;        
        handles.X1popupmenu.Enable = 'On'; 
        
        handles.uipanel1.Title = 'Выборка';
        handles.uipanel2.Title = 'Факторная выборка'; 
        
        
    case graphs.scatterPlot.name
        
        imshow(getappdata(handles.MainWindow,'ScatterIcon'),...
            'Parent',handles.IconAxes);        
        
        handles.Y1popupmenu.String = numericDataNames;
        handles.Y1popupmenu.Enable = 'On';
        
        handles.X1popupmenu.String = numericDataNames;
        handles.X2popupmenu.String = numericDataNames;
        handles.X3popupmenu.String = numericDataNames;
        handles.X4popupmenu.String = numericDataNames;
        handles.X5popupmenu.String = numericDataNames;
        handles.X6popupmenu.String = numericDataNames;
        
        handles.X1popupmenu.Enable = 'On';
        handles.X2popupmenu.Enable = 'On';
        handles.X3popupmenu.Enable = 'On';
        handles.X4popupmenu.Enable = 'On';
        handles.X5popupmenu.Enable = 'On';
        handles.X6popupmenu.Enable = 'On';  
        
        handles.uipanel1.Title = 'Зависимая выборка';
        handles.uipanel2.Title = 'Независимые выборки'; 
        
    case graphs.catScatter.name
        
        imshow(getappdata(handles.MainWindow,'ScatterIcon'),...
            'Parent',handles.IconAxes);  
        
        handles.Y1popupmenu.String = numericDataNames;
        handles.Y1popupmenu.Enable = 'On';
        
        handles.Y2popupmenu.String = numericDataNames;
        handles.Y2popupmenu.Enable = 'On';        
        
        handles.X1popupmenu.String = stringAndLogicalDataNames;
        handles.X1popupmenu.Enable = 'On';
        
        handles.uipanel1.Title = 'Выборки';
        handles.uipanel2.Title = 'Факторная выборка'; 
        
        
    case graphs.scatterHist.name
        
        imshow(getappdata(handles.MainWindow,'ScatterHistIcon'),...
            'Parent',handles.IconAxes);  
        
        handles.Y1popupmenu.String = numericDataNames;
        handles.Y1popupmenu.Enable = 'On';
        
        handles.Y2popupmenu.String = numericDataNames;
        handles.Y2popupmenu.Enable = 'On';        
        
        handles.X1popupmenu.String = stringAndLogicalDataNames;
        handles.X1popupmenu.Enable = 'On';
        
        handles.uipanel1.Title = 'Выборки';
        handles.uipanel2.Title = 'Факторная выборка';         
        
    
    case graphs.scatterPlotMatrix.name  
        
        imshow(getappdata(handles.MainWindow,'ScatterPlotMatrixIcon'),...
            'Parent',handles.IconAxes); 
        
        handles.MuText.Visible = 'On';        
        handles.MuText.String = 'Факторная выборка';
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = allDataNames; 
        
        handles.X1popupmenu.String = numericDataNames;
        handles.X2popupmenu.String = numericDataNames;
        handles.X3popupmenu.String = numericDataNames;
        handles.X4popupmenu.String = numericDataNames;
        handles.X5popupmenu.String = numericDataNames;
        handles.X6popupmenu.String = numericDataNames;
        
        handles.X1popupmenu.Enable = 'On';
        handles.X2popupmenu.Enable = 'On';
        handles.X3popupmenu.Enable = 'On';
        handles.X4popupmenu.Enable = 'On';
        handles.X5popupmenu.Enable = 'On';
        handles.X6popupmenu.Enable = 'On'; 
        
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
        
        handles.uipanel1.Title = 'Выборки по оси ординат'; 
        handles.uipanel2.Title = 'Выборки по оси абцисс';
    
    case graphs.pie.name
        
        imshow(getappdata(handles.MainWindow,'PieIcon'),...
            'Parent',handles.IconAxes);
        
        handles.Y1popupmenu.String = stringAndLogicalDataNames;
        handles.Y1popupmenu.Enable = 'On';
        
        handles.uipanel1.Title = 'Выборка';
        
    case graphs.heatMap.name
        
        imshow(getappdata(handles.MainWindow,'HeatMapIcon'),...
            'Parent',handles.IconAxes);        
        
        handles.Y1popupmenu.String = numericDataNames;
        handles.Y1popupmenu.Enable = 'On';
        
        handles.X1popupmenu.String = allDataNames;
        handles.X2popupmenu.String = allDataNames;
        handles.X1popupmenu.Enable = 'On';
        handles.X2popupmenu.Enable = 'On';      
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {'Среднее','Медиана','Сумма'};
        
        handles.uipanel1.Title = 'Зависимая выборка';
        handles.uipanel2.Title = 'Независимые выборки';
        
    case graphs.corrMatrix.name
        
        imshow(getappdata(handles.MainWindow,'HeatMapIcon'),...
            'Parent',handles.IconAxes);        
        
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
        
        handles.X1popupmenu.String = numericDataNames;
        handles.X2popupmenu.String = numericDataNames;
        handles.X3popupmenu.String = numericDataNames;
        handles.X4popupmenu.String = numericDataNames;
        handles.X5popupmenu.String = numericDataNames;
        handles.X6popupmenu.String = numericDataNames;
        
        handles.X1popupmenu.Enable = 'On';
        handles.X2popupmenu.Enable = 'On';
        handles.X3popupmenu.Enable = 'On';
        handles.X4popupmenu.Enable = 'On';
        handles.X5popupmenu.Enable = 'On';
        handles.X6popupmenu.Enable = 'On'; 
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {'Пирсона','Кендалла','Спирмена'};  
        
        handles.uipanel1.Title = 'Выборки по оси ординат'; 
        handles.uipanel2.Title = 'Выборки по оси абцисс';
        
    case graphs.distributionDiagram.name
        
        imshow(getappdata(handles.MainWindow,'ErrorBarIcon'),...
            'Parent',handles.IconAxes);   
        
        handles.Y1popupmenu.String = numericDataNames;
        handles.Y1popupmenu.Enable = 'On';
        
        handles.X1popupmenu.String = stringAndLogicalDataNames;        
        handles.X1popupmenu.Enable = 'On';
        
        handles.uipanel1.Title = 'Выборка';
        handles.uipanel2.Title = 'Факторная выборка';

    case graphs.oneNumCriteria.name
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';        
        handles.ValueLevelText.String = 'Уровень значимости:';
        
        handles.MuEdit.Visible = 'On';
        handles.MuText.Visible = 'On';
        handles.MuText.String = 'Медиана / Мат. ожидание:'; 
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            'Двусторонняя альтернативная гипотеза',...
            'Левосторонняя альтернативная гипотеза',...
            'Правосторонняя альтернативная гипотеза'...
            };        
        
        handles.GraphAdditionalPopupMenu3.Visible = 'On';
        handles.GraphAdditionalPopupMenu3.String = {...
            'Выборка не ранжирована',...
            'Выборка ранжирована'...
            };    
        
        handles.Y1popupmenu.String = numericDataNames;        
        handles.Y1popupmenu.Enable = 'On';
        
        handles.uipanel1.Title = 'Выборка';
    
    case graphs.twoNumCriteria.name
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';
        handles.ValueLevelText.String = 'Уровень значимости:';
                
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {...
            'Выборки независимы',...
            'Выборки зависимы'....
            };  
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            'Двусторонняя альтернативная гипотеза',...
            'Левосторонняя альтернативная гипотеза',...
            'Правосторонняя альтернативная гипотеза'...
            };        
        
        handles.GraphAdditionalPopupMenu3.Visible = 'On';
        handles.GraphAdditionalPopupMenu3.String = {...
            'Выборки не ранжированы',...
            'Выборки ранжированы'...
            };    
        
        handles.Y1popupmenu.String = numericDataNames;
        handles.Y2popupmenu.Enable = 'On';       
        
        handles.Y2popupmenu.String = numericDataNames;        
        handles.Y1popupmenu.Enable = 'On';  
        
        handles.uipanel1.Title = 'Выборки';
    
    case graphs.threeNumCriteria.name
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';
        handles.ValueLevelText.String = 'Уровень значимости:';
                
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {...
            'Выборки независимы',...
            'Выборки зависимы'....
            };          
                        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            'Сравнение: Тьюки-Крамера',...
            'Сравнение: Бонферрони',....
            'Сравнение: Данна-Сидака',....
            'Сравнение: Фишера (LSD)',....
            'Сравнение: Шеффи'....
            }; 
        
        handles.GraphAdditionalPopupMenu3.Visible = 'On';
        handles.GraphAdditionalPopupMenu3.String = {...
            'Выборки не ранжированы',...
            'Выборки ранжированы'...
            };    
        
        handles.Y1popupmenu.String = numericDataNames;        
        handles.Y1popupmenu.Enable = 'On';
        
        handles.Y2popupmenu.String = numericDataNames;
        handles.Y2popupmenu.Enable = 'On'; 
        
        handles.Y3popupmenu.String = numericDataNames;
        handles.Y3popupmenu.Enable = 'On'; 
        
        handles.Y4popupmenu.String = numericDataNames;
        handles.Y4popupmenu.Enable = 'On'; 
        
        handles.Y5popupmenu.String = numericDataNames;
        handles.Y5popupmenu.Enable = 'On'; 
        
        handles.Y6popupmenu.String = numericDataNames;
        handles.Y6popupmenu.Enable = 'On'; 
        
        handles.X1popupmenu.String = stringAndLogicalDataNames;        
        handles.X1popupmenu.Enable = 'On'; 
        
        handles.uipanel1.Title = 'Выборки';
        handles.uipanel2.Title = 'Факторная выборка';
    
    case graphs.multiAnova.name        
        
        handles.Y1popupmenu.String = numericDataNames;
        handles.Y1popupmenu.Enable = 'On';          
        
        handles.X1popupmenu.String = allDataNames;
        handles.X2popupmenu.String = allDataNames;
        handles.X3popupmenu.String = allDataNames;
        handles.X4popupmenu.String = allDataNames;
        handles.X5popupmenu.String = allDataNames;
        handles.X6popupmenu.String = allDataNames;
        
        handles.X1popupmenu.Enable = 'On';
        handles.X2popupmenu.Enable = 'On';
        handles.X3popupmenu.Enable = 'On';
        handles.X4popupmenu.Enable = 'On';
        handles.X5popupmenu.Enable = 'On';
        handles.X6popupmenu.Enable = 'On';  
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';        
        handles.ValueLevelText.String = 'Уровень значимости:'; 
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {'Тип суммы квадратов: I',...
                                                    'Тип суммы квадратов: II',...
                                                    'Тип суммы квадратов: III',...
                                                    };
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            'Сравнение: Тьюки-Крамера',...
            'Сравнение: Бонферрони',....
            'Сравнение: Данна-Сидака',....
            'Сравнение: Фишера (LSD)',....
            'Сравнение: Шеффи'....
            };
        
        handles.uipanel1.Title = 'Выборка';
        handles.uipanel2.Title = 'Факторные выборки';
        
%     Выявление различий 1й дихотомической выборки    
    case graphs.oneDichCriteria.name
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';        
        handles.ValueLevelText.String = 'Уровень значимости:';
        
        handles.MuEdit.Visible = 'On';
        handles.MuText.Visible = 'On';
        handles.MuText.String = 'Вероят-ть "1":';       
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            'Двусторонняя альтернативная гипотеза',...
            'Левосторонняя альтернативная гипотеза',...
            'Правосторонняя альтернативная гипотеза'...
            };  
        
        handles.Y1popupmenu.String = logicalDataNames;        
        handles.Y1popupmenu.Enable = 'On';
    
        handles.uipanel1.Title = 'Выборка';
    
    case graphs.twoDichCriteria.name
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';        
        handles.ValueLevelText.String = 'Уровень значимости:';        
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {...
            'Выборки независимы',...
            'Выборки зависимы'...
            };                
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            'Двусторонняя альтернативная гипотеза',...
            'Левосторонняя альтернативная гипотеза',...
            'Правосторонняя альтернативная гипотеза'...
            };        
        
        handles.Y1popupmenu.String = logicalDataNames;        
        handles.Y1popupmenu.Enable = 'On';
        
        handles.Y2popupmenu.String = logicalDataNames;
        handles.Y2popupmenu.Enable = 'On'; 
    
        handles.uipanel1.Title = 'Выборки';
        
    case graphs.threeDichCriteria.name
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';        
        handles.ValueLevelText.String = 'Уровень значимости:';
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {...
            'Выборки независимы',...
            'Выборки зависимы'...
            };    
        
        handles.Y1popupmenu.String = logicalDataNames;        
        handles.Y1popupmenu.Enable = 'On';
        
        handles.Y2popupmenu.String = logicalDataNames;
        handles.Y2popupmenu.Enable = 'On';
        
        handles.Y3popupmenu.String = logicalDataNames;        
        handles.Y3popupmenu.Enable = 'On';
        
        handles.Y4popupmenu.String = logicalDataNames;
        handles.Y4popupmenu.Enable = 'On';
        
        handles.Y5popupmenu.String = logicalDataNames;        
        handles.Y5popupmenu.Enable = 'On';
        
        handles.Y6popupmenu.String = logicalDataNames;
        handles.Y6popupmenu.Enable = 'On'; 
    
        handles.uipanel1.Title = 'Выборки';
        
        
%     Выявление различий 2х номинативных выборок
    case graphs.twoCatCriteria.name
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';        
        handles.ValueLevelText.String = 'Уровень значимости:';
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {...
            'Выборки независимы',...
            'Выборки зависимы'...
            };  
        
        handles.Y1popupmenu.String = stringDataNames;        
        handles.Y1popupmenu.Enable = 'On';
        
        handles.Y2popupmenu.String = stringDataNames;
        handles.Y2popupmenu.Enable = 'On'; 
    
        handles.uipanel1.Title = 'Выборки';
    
    case graphs.threeCatCriteria.name
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';        
        handles.ValueLevelText.String = 'Уровень значимости:';
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {...
            'Выборки независимы',...
            'Выборки зависимы'...
            };   
        
        handles.Y1popupmenu.String = stringDataNames;        
        handles.Y1popupmenu.Enable = 'On';
        
        handles.Y2popupmenu.String = stringDataNames;
        handles.Y2popupmenu.Enable = 'On';
        
        handles.Y3popupmenu.String = stringDataNames;        
        handles.Y3popupmenu.Enable = 'On';
        
        handles.Y4popupmenu.String = stringDataNames;
        handles.Y4popupmenu.Enable = 'On';
        
        handles.Y5popupmenu.String = stringDataNames;        
        handles.Y5popupmenu.Enable = 'On';
        
        handles.Y6popupmenu.String = stringDataNames;
        handles.Y6popupmenu.Enable = 'On'; 
    
        handles.uipanel1.Title = 'Выборки';
        
    % таблица сопряженности
    case graphs.crossTab.name
        
        handles.Y1popupmenu.String = stringAndLogicalDataNames;
        handles.Y2popupmenu.String = stringAndLogicalDataNames;
        handles.Y3popupmenu.String = stringAndLogicalDataNames;
        handles.Y4popupmenu.String = stringAndLogicalDataNames;
        handles.Y5popupmenu.String = stringAndLogicalDataNames;
        handles.Y6popupmenu.String = stringAndLogicalDataNames;
        
        handles.Y1popupmenu.Enable = 'On';
        handles.Y2popupmenu.Enable = 'On';
        handles.Y3popupmenu.Enable = 'On';
        handles.Y4popupmenu.Enable = 'On';
        handles.Y5popupmenu.Enable = 'On';
        handles.Y6popupmenu.Enable = 'On';   
    
        handles.uipanel1.Title = 'Выборки'; 
         
    case graphs.logitregression.name
                
        handles.MuText.Visible = 'On';        
        handles.MuText.String = 'Зависимая переменная';
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = stringAndLogicalDataNames;   
        
        handles.GraphAdditionalPopupMenu3.Visible = 'Off';
        handles.GraphAdditionalPopupMenu3.String = {...
            'Использовать взаимодействия',...
            'Не использовать взаимодействия'...
            };   
        
        handles.Y1popupmenu.String = numericAndLogicalDataNames;
        handles.Y2popupmenu.String = numericAndLogicalDataNames;
        handles.Y3popupmenu.String = numericAndLogicalDataNames;
        handles.Y4popupmenu.String = numericAndLogicalDataNames;
        handles.Y5popupmenu.String = numericAndLogicalDataNames;
        handles.Y6popupmenu.String = numericAndLogicalDataNames;
        
        handles.Y1popupmenu.Enable = 'On';
        handles.Y2popupmenu.Enable = 'On';
        handles.Y3popupmenu.Enable = 'On';
        handles.Y4popupmenu.Enable = 'On';
        handles.Y5popupmenu.Enable = 'On';
        handles.Y6popupmenu.Enable = 'On';   
        
        handles.X1popupmenu.String = numericAndLogicalDataNames;
        handles.X2popupmenu.String = numericAndLogicalDataNames;
        handles.X3popupmenu.String = numericAndLogicalDataNames;
        handles.X4popupmenu.String = numericAndLogicalDataNames;
        handles.X5popupmenu.String = numericAndLogicalDataNames;
        handles.X6popupmenu.String = numericAndLogicalDataNames;
        
        handles.X1popupmenu.Enable = 'On';
        handles.X2popupmenu.Enable = 'On';
        handles.X3popupmenu.Enable = 'On';
        handles.X4popupmenu.Enable = 'On';
        handles.X5popupmenu.Enable = 'On';
        handles.X6popupmenu.Enable = 'On';  
    
        handles.uipanel1.Title = 'Предикторы'; 
        handles.uipanel2.Title = 'Предикторы'; 
        
        
         
    otherwise
        
        assert(0,'некорректное значение графика');
end


function FilterPopupMenu_Callback(hObject, eventdata, handles)

dataFrameNamesAndTypes = getappdata(handles.MainWindow,'dataFrameNamesAndTypes');
dataFrame = getappdata(handles.MainWindow,'dataFrame');

if hObject == handles.FilterPopupMenu1
    handleNumber = "1";
elseif hObject == handles.FilterPopupMenu2    
    handleNumber = "2";
elseif hObject == handles.FilterPopupMenu3    
    handleNumber = "3";
elseif hObject == handles.FilterPopupMenu4        
    handleNumber = "4";
elseif hObject == handles.FilterPopupMenu5    
    handleNumber = "5";
else
    assert(0,"Неопределенный указатель фильтра данных")
end

eval("handles.FilterValuePopupMenu" + handleNumber + ".Value = 1;");
eval("handles.EquationPopupMenu" + handleNumber + ".Value = 1;");

if hObject.Value == 1
    
    eval("handles.FilterValuePopupMenu" + handleNumber + ".String = ' ';");
    eval("handles.EquationPopupMenu" + handleNumber + ".String = ' ';");
    
elseif dataFrameNamesAndTypes(2, hObject.Value-1) == "номинативный" || ...
        dataFrameNamesAndTypes(2, hObject.Value-1) == "дихотомический"
    
    dataName = getMenuString(hObject);
    data = dataFrame{:,find(dataFrameNamesAndTypes(1,:)==dataName)};
    
    data = replaceNaN(data);
    uniqueData = unique(data);
    
    eval("handles.FilterValuePopupMenu" + handleNumber + ".Style = 'popupmenu';");
    eval("handles.FilterValuePopupMenu" + handleNumber + ".String = uniqueData;");
        
    eval("handles.EquationPopupMenu" + handleNumber + ".String = {'=='; '~='};");
    
elseif dataFrameNamesAndTypes(2, hObject.Value-1) == "непрерывный"
    
    eval("handles.FilterValuePopupMenu" + handleNumber + ".String = ' ';");
    eval("handles.FilterValuePopupMenu" + handleNumber + ".Style = 'edit';");
    
    eval("handles.EquationPopupMenu" + handleNumber + ".String = {'=='; '~='; '>'; '>='; '<'; '<='};");
          
else    
    assert(0,"Неопределенный номер строки фильтра")    
end


ShowAnalyzedData_Callback(hObject, eventdata, handles);                 


function ShowAnalyzedData_Callback(hObject, eventdata, handles)

ShowAnalyzedData(handles);
DataTable_CellSelectionCallback(0, 0, handles);


function DataTable_CellSelectionCallback(hObject, eventdata, handles)

try
    isOneColSelected = CheckColsNumberSelected(eventdata.Indices);
catch
    isOneColSelected = false;
end

if isOneColSelected
    
    handles.DataTable.Enable = 'off';
    
    dataFrameLengths = handles.DataTable.UserData{2};
    dataFrameNamesAndTypes = getappdata(handles.MainWindow,'dataFrameNamesAndTypes');

    selectedCol = eventdata.Indices(1,2);

    handles.TableTextInfo.String = "Число строк: " + ...
                                    num2str(dataFrameLengths(selectedCol)) + " из " + ...
                                    num2str(handles.DataTable.UserData{1}) + " ("   + ...
                                    dataFrameNamesAndTypes(2,selectedCol)  + ...
                                    " тип данных)";                            
   
    handles.DataTable.Enable = 'on';
    
else
     handles.TableTextInfo.String = ...
        'Для просмотра статистики столбца выберите ячейку / ячейки столбца';
end


function GraphAdditionalPopupMenu1_Callback(hObject, eventdata, handles)


graphs = getappdata(handles.MainWindow,'graphs');

switch getMenuString(handles.GraphPopupmenu)

    case graphs.hist.name
        
        if getMenuString(handles.GraphAdditionalPopupMenu1) == "Трехмерная"
            
            handles.Y3popupmenu.Enable = 'Off';
            handles.Y4popupmenu.Enable = 'Off';
            handles.Y5popupmenu.Enable = 'Off';
            handles.Y6popupmenu.Enable = 'Off';
            
            handles.Y3popupmenu.Value = 1;
            handles.Y4popupmenu.Value = 1;
            handles.Y5popupmenu.Value = 1;
            handles.Y6popupmenu.Value = 1;
            
        else            
            handles.Y3popupmenu.Enable = 'On';
            handles.Y4popupmenu.Enable = 'On';
            handles.Y5popupmenu.Enable = 'On';
            handles.Y6popupmenu.Enable = 'On';  
        end     
        
    case graphs.threeNumCriteria.name
        
        if getMenuString(handles.GraphAdditionalPopupMenu1) == "Выборки независимы"
            handles.X1popupmenu.Enable = 'On';     
            
        elseif getMenuString(handles.GraphAdditionalPopupMenu1) == "Выборки зависимы"
            handles.X1popupmenu.Enable = 'Off'; 
            
        else
            assert(0,'некорректное значение свойства графика');   
        end
        
    otherwise
        
end


function GraphAdditionalPopupMenu2_Callback(hObject, eventdata, handles)

graphs = getappdata(handles.MainWindow,'graphs');

switch getMenuString(handles.GraphPopupmenu)

    case graphs.logitregression.name        
        
        dataFrameNamesAndTypes = getappdata(handles.MainWindow,'dataFrameNamesAndTypes');
        responseName = getMenuString(handles.GraphAdditionalPopupMenu2); 
        
        if dataFrameNamesAndTypes(2, dataFrameNamesAndTypes(1,:) == responseName) == "дихотомический"
            handles.GraphAdditionalPopupMenu3.Visible = 'on';
        else
            handles.GraphAdditionalPopupMenu3.Visible = 'off';
        end
        

    otherwise
        
        assert(0,'некорректное значение графика');         
end


function ShowColPopupmenu_Callback(hObject, eventdata, handles)

switch hObject
    
    case handles.ShowColPopupmenu1
        
        values = handles.ShowColPopupmenu1.Value;
        listHandles = handles.ShowColList1;
        textHandles = handles.ShowColText1;
        
        
    case handles.ShowColPopupmenu2
        
        values = handles.ShowColPopupmenu2.Value;
        listHandles = handles.ShowColList2;
        textHandles = handles.ShowColText2;
        
    case handles.ShowColPopupmenu3
        
        values = handles.ShowColPopupmenu3.Value;
        listHandles = handles.ShowColList3;
        textHandles = handles.ShowColText3;
        
    case handles.OpenDataTable
        
        values = [  handles.ShowColPopupmenu1.Value...
                    handles.ShowColPopupmenu2.Value ...
                    handles.ShowColPopupmenu3.Value] ;
                
        listHandles = [ handles.ShowColList1 handles.ShowColList2 handles.ShowColList3 ];
        textHandles = [ handles.ShowColText1 handles.ShowColText2 handles.ShowColText3];
        
    otherwise
        assert(0, 'Вызов не из расшаренного callback');
end
        
cellData = handles.DataTable.Data;
dataFrameNamesAndTypes = getappdata(handles.MainWindow,'dataFrameNamesAndTypes');
numbers = 1:size(cellData,1);

for x = 1:length(values)
    
    data = string(cell2mat(cellData(:,values(x))));
    data(ismissing(data)) = " ";
    listHandles(x).String = strcat(num2str(numbers'), ") ", data);      
    
    textHandles(x).String = "Cтрок: " + ...
                                    num2str(sum((data ~= " "))) + " из " + ...
                                    num2str(length(data)) + " ("   + ...
                                    dataFrameNamesAndTypes(2,values(x))  + ...
                                    ")"; 
    
    
    
end
    

function ShowColList_Callback(hObject, eventdata, handles)

handles.ShowColList1.Value = hObject.Value;
handles.ShowColList2.Value = hObject.Value;
handles.ShowColList3.Value = hObject.Value;


function RussianLangMenu_Callback(hObject, eventdata, handles)


function EnglishLangMenu_Callback(hObject, eventdata, handles)


function BuildButton_Callback(hObject, eventdata, handles)

graphFigure = figure('Position',[50 50 800 600], 'Visible', 'off');
setFigureInCenter(graphFigure);
graphFigure.Visible = 'off';

graphs = getappdata(handles.MainWindow,'graphs');

graphProperty = string(getMenuString(handles.GraphAdditionalPopupMenu1));
originDataFrame = getappdata(handles.MainWindow,'dataFrame');
dataFrameNamesAndTypes = getappdata(handles.MainWindow,'dataFrameNamesAndTypes');

dataFrame = filterDataFrame(originDataFrame, dataFrameNamesAndTypes, handles);

if isempty(dataFrame)
    errordlg('Ошибка данных',...
        'Таблица после исключения строк - пустая. Измените параметры исключений','modal');
    return
end

titleSuffix = "";

switch getMenuString(handles.GraphPopupmenu)
    
    case graphs.hist.name  
        
        hold on;
        dataNames = getDataNames(handles, ["Y1","Y2","Y3","Y4","Y5","Y6"]);
        
        if isempty(dataNames)
            errordlg('Выберите данные для графика','Ошибка задания данных','modal');                    
            delete(graphFigure);
            return            
        end
        
        if getMenuString(handles.GraphAdditionalPopupMenu1) == "Трехмерная"            
            if size(dataNames,1) ~= 2
                errordlg('Выберите 2 уникальные выборки для трехмерного графика','Ошибка задания данных','modal');
                delete(graphFigure);
                return
            end
        end
        
        data = retrieveData(dataFrame, dataFrameNamesAndTypes, dataNames);
        buildHistograms(data, gca, graphProperty, dataNames);  
        
        dataNames = checkNormality(data, dataNames);
        
        if getMenuString(handles.GraphAdditionalPopupMenu1) == "Трехмерная"
            titleSuffix = "(" + graphProperty + ")"; 
            titleSuffix = [titleSuffix; dataNames];
        else
            legend(gca,dataNames);
            titleSuffix = "(" + graphProperty + ")";          
        end
        
        title(gca,{getMenuString(handles.GraphPopupmenu) titleSuffix});
    
        
    case graphs.catHist.name
        
        hold on;
        dataYName = getDataNames(handles, "Y1");
        dataXName = getDataNames(handles, "X1"); 
        
        if isempty(dataXName) || isempty(dataYName)
            errordlg('Выберите данные для графика','Ошибка задания данных','modal');                    
            delete(graphFigure);
            return            
        end 
        
        dataY = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYName);
        dataX = retrieveData(dataFrame, dataFrameNamesAndTypes, dataXName);      
        dataX = replaceNaN(dataX);
        
        if isempty(dataX)
            errordlg('Выберите не пустую выборку', ...
                'Ошибка задания данных','modal');            
            delete(graphFigure);
            return;
        end
        
        uniqueXdata = unique(dataX);  
        uniqueXdata(uniqueXdata == "") = " ";
                
        for x = 1:length(uniqueXdata)                
            category = dataY(dataX == uniqueXdata(x));             
            histogram(category, 'DisplayName', uniqueXdata(x));            
        end
        
        xlabel(dataYName);
        legend('show');   
        title({getMenuString(handles.GraphPopupmenu) titleSuffix});
        
            
    case graphs.scatterPlot.name       
        
        hold on;
        
        dataYName = getDataNames(handles, "Y1");
        dataXNames = getDataNames(handles, ["X1","X2","X3","X4","X5","X6"]);        
        
        if isempty(dataXNames) || isempty(dataYName)
            errordlg('Выберите данные для графика','Ошибка задания данных','modal');                    
            delete(graphFigure);
            return            
        end
        
        dataY = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYName);
        dataX = retrieveData(dataFrame, dataFrameNamesAndTypes, dataXNames);        
        
        buildScatterPlots(dataY, dataX, gca);         
        
        legend(dataXNames);
        ylabel(dataYName);
        title(getMenuString(handles.GraphPopupmenu));
        
    case graphs.catScatter.name
        
        hold on;
        
        dataYName = getDataNames(handles, "Y1");
        dataXName = getDataNames(handles, "Y2");
        groupName = getDataNames(handles, "X1");
        
        if isempty(dataXName) || isempty(dataYName) || isempty(groupName)
            errordlg('Выберите данные для графика','Ошибка задания данных','modal');                    
            delete(graphFigure);
            return            
        end        
        
        dataY = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYName);
        dataX = retrieveData(dataFrame, dataFrameNamesAndTypes, dataXName); 
        group = retrieveData(dataFrame, dataFrameNamesAndTypes, groupName); 
        
        if isnumeric(group)
            dataX(isnan(group)) = [];
            dataY(isnan(group)) = [];
            group(isnan(group)) = [];            
        else
            dataX(group == "") = [];
            dataY(group == "") = [];
            group(group == "") = [];
        end
        
        gscatter(dataX,dataY,group,[],[],[],'on',dataXName,dataYName);
        title(getMenuString(handles.GraphPopupmenu));
        
    case graphs.scatterHist.name        
        
        hold on;
        
        dataYName = getDataNames(handles, "Y1");
        dataXName = getDataNames(handles, "Y2");
        groupName = getDataNames(handles, "X1");
        
        if isempty(dataXName) || isempty(dataYName) || isempty(groupName)
            errordlg('Выберите данные для графика','Ошибка задания данных','modal');                    
            delete(graphFigure);
            return            
        end        
        
        dataY = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYName);
        dataX = retrieveData(dataFrame, dataFrameNamesAndTypes, dataXName); 
        group = retrieveData(dataFrame, dataFrameNamesAndTypes, groupName);         
       
        if isnumeric(group)
            dataX(isnan(group)) = [];
            dataY(isnan(group)) = [];
            group(isnan(group)) = [];            
        else
            dataX(group == "") = [];
            dataY(group == "") = [];
            group(group == "") = [];
        end
        
        scatterhist(dataX,dataY,'Group',group,'Kernel','on')
        title(getMenuString(handles.GraphPopupmenu));
        xlabel(dataXName);
        ylabel(dataYName);
        
    case graphs.scatterPlotMatrix.name    
        
        hold on;
        
        dataYNames = getDataNames(handles, ["Y1","Y2","Y3","Y4","Y5","Y6"]); 
        dataXNames = getDataNames(handles, ["X1","X2","X3","X4","X5","X6"]);       
        groupName = getMenuString(handles.GraphAdditionalPopupMenu1);
        
        if isempty(dataYNames) || isempty(dataXNames) || isempty(groupName)
            errordlg('Выберите данные для графика','Ошибка задания данных','modal');                    
            delete(graphFigure);
            return            
        end
        
        dataX = retrieveData(dataFrame, dataFrameNamesAndTypes, dataXNames);
        dataY = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYNames);
        group = retrieveData(dataFrame, dataFrameNamesAndTypes, groupName);
        
        % грязный хак, почему то не видит окно с осью, если запускать со
        % старта приложения
        try
            gplotmatrix(dataX, dataY, group,[],[],[],[],[],cellstr(dataXNames),cellstr(dataYNames));        
        catch
            gplotmatrix(dataX, dataY, group,[],[],[],[],[],cellstr(dataXNames),cellstr(dataYNames));
        end
        
        title(getMenuString(handles.GraphPopupmenu));
        
    case graphs.pie.name
        
        dataYName = getDataNames(handles, "Y1");   
        
        if isempty(dataYName)
            errordlg('Выберите данные для графика','Ошибка задания данных','modal');                    
            delete(graphFigure);
            return            
        end
        
        data = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYName);       
        data = replaceNaN(data);
        
        if isempty(data)
            errordlg('Выберите не пустую выборку', ...
                'Ошибка данных','modal');
            delete(graphFigure);
            return;
        end
        
        buildPie(data, gca);
        
        titleSuffix = dataYName;
        title({getMenuString(handles.GraphPopupmenu) titleSuffix});        
        

    case graphs.heatMap.name
        
        hold on;
        colorDataName = getDataNames(handles, "Y1"); 
        dataXName = getDataNames(handles, "X1");  
        dataYName = getDataNames(handles, "X2");  
        
        if isempty(dataXName) || isempty(dataXName) || isempty(colorDataName)
            errordlg('Выберите данные для графика','Ошибка задания данных','modal');                    
            delete(graphFigure);
            return            
        end
        
        dataY = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYName);
        dataX = retrieveData(dataFrame, dataFrameNamesAndTypes, dataXName);  
        
        dataX = replaceNaN(dataX);
        dataY = replaceNaN(dataY);
        
        if isempty(dataX) || isempty(dataY)
            errordlg('Выберите не пустые выборки',...
                'Ошибка задания данных','modal');            
            delete(graphFigure);
            return;
        end
        
        method = getDictValue(graphProperty);              
        
        hold off;
        heatmap(...
                dataFrame,...
                find(dataFrameNamesAndTypes(1,:)==dataXName),...
                find(dataFrameNamesAndTypes(1,:)==dataYName),...
                'ColorVariable', find(dataFrameNamesAndTypes(1,:)==colorDataName),...
                'ColorMethod', method ...
                ); 
            
        titleSuffix = colorDataName + " (" + graphProperty + ")";
        title({getMenuString(handles.GraphPopupmenu) titleSuffix});
        xlabel(dataXName);
        ylabel(dataYName); 
            
    case graphs.corrMatrix.name
        
        hold off;        
        dataYNames = getDataNames(handles, ["Y1","Y2","Y3","Y4","Y5","Y6"]); 
        dataXNames = getDataNames(handles, ["X1","X2","X3","X4","X5","X6"]);  
        
        if isempty(dataYNames) || isempty(dataXNames) 
            errordlg('Выберите данные для графика','Ошибка задания данных','modal');                    
            delete(graphFigure);
            return            
        end
                
        dataY = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYNames);
        dataX = retrieveData(dataFrame, dataFrameNamesAndTypes, dataXNames);
        method = getDictValue(graphProperty);        
        
        [corrCoeffs, pValues] = corr(dataX, dataY, 'type', method, 'rows', 'pairwise');
        
        subplot(2,1,1)
        heatmap(dataXNames, dataYNames, corrCoeffs);         
        title({getMenuString(handles.GraphPopupmenu) "Коэффициенты " + graphProperty});
        
        subplot(2,1,2)
        heatmap(dataXNames, dataYNames, pValues);  
        title({getMenuString(handles.GraphPopupmenu) 'Значения p'});
        graphFigure.Visible = 'On';
        return
        
    case graphs.distributionDiagram.name        
        
        hold on;
        dataName = getDataNames(handles, "Y1");
        groupName = getDataNames(handles, "X1");         
        
        if isempty(groupName) || isempty(dataName)
            errordlg('Выберите данные для графика','Ошибка задания данных','modal');                    
            delete(graphFigure);
            return            
        end         
        
        data = retrieveData(dataFrame, dataFrameNamesAndTypes, dataName);
        group = retrieveData(dataFrame, dataFrameNamesAndTypes, groupName); 
        
        if isempty(group)
            errordlg('Выберите не пустую выборку',...
                'Ошибка задания данных','modal');            
            delete(graphFigure);
            return;
        end
        
        boxplot(data, group);
        
        xlabel(groupName);
        xtickangle(gca, 45);
        ylabel(dataName);        
        title({getMenuString(handles.GraphPopupmenu) titleSuffix});
    
        
    %   Выявления различий
    case {...
            graphs.oneNumCriteria.name,...
            graphs.twoNumCriteria.name,...
            graphs.threeNumCriteria.name,...
            graphs.oneDichCriteria.name,...
            graphs.twoDichCriteria.name,...
            graphs.threeDichCriteria.name, ...
            graphs.twoCatCriteria.name, ...
            graphs.threeCatCriteria.name...
            }   
        
        dataYNames = getDataNames(handles, ["Y1","Y2","Y3","Y4","Y5","Y6"]); 
        
        if isempty(dataYNames)
            errordlg('Выберите данные для расчета критериев','Ошибка данных','modal');                    
            delete(graphFigure);
            return            
        end
        
        significanceLevel = getNumberFromEdit(handles.ValueLevelEdit);        
        
        if isnan(significanceLevel) || significanceLevel <= 0 || significanceLevel >= 1            
            errordlg('Уровень значимости должен быть задан числом в интервале (0...1)',...
                'Ошибка задания данных','modal');                    
            delete(graphFigure);
            return 
        end     
               
        tailStr = getMenuString(handles.GraphAdditionalPopupMenu2);          
        datasets = createDatasetsForCriteria(dataFrame, dataFrameNamesAndTypes, dataYNames);        
        
        if isempty(datasets)
            errordlg('Выбранные данные содержат пустые столбцы. Выберите другие данные', ...
                'Ошибка задания данных','modal');
            delete(graphFigure);
            return;
        end               
        
        switch getMenuString(handles.GraphPopupmenu)
           
            case graphs.oneNumCriteria.name
                
                mu = getNumberFromEdit(handles.MuEdit);
                
                if isnan(mu)
                    errordlg('Предполагаемое среднее mu должно быть задано числом',...
                        'Ошибка задания данных','modal');
                    delete(graphFigure);
                    return
                end
                
                isDatasetsRanged = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu3));
                
                infoStr = calculateCriteriaForOneSampleNumericData(...
                    datasets, significanceLevel, isDatasetsRanged, mu, tailStr);
                
            case graphs.twoNumCriteria.name
                
                isDatasetsIndependent = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu1));
                isDatasetsRanged = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu3));
                
                infoStr = calculateCriteriaForTwoSamplesNumericData(...
                    datasets, significanceLevel, isDatasetsRanged, isDatasetsIndependent, tailStr);
                
            case graphs.threeNumCriteria.name                                
                
                dataXName = getDataNames(handles, "X1");
                groupData = createDatasetsForCriteria(dataFrame, dataFrameNamesAndTypes, dataXName);                
                
                isDatasetsIndependentStr = getMenuString(handles.GraphAdditionalPopupMenu1);
                isDatasetsRangedStr = getMenuString(handles.GraphAdditionalPopupMenu3);
                cmprTypeStr = getMenuString(handles.GraphAdditionalPopupMenu2);
                                
                if isempty(groupData) && size(datasets,2) < 3
                    errordlg(['Для сбалансированного анализа дисперсий должно быть выбрано' ...
                            'не менее 3х уникальных выборок'],...
                        'Ошибка задания данных','modal');
                    delete(graphFigure);
                    return
                end
                
                if ~isempty(groupData) && size(datasets,2) ~= 1
                    errordlg(['Для несбалансирвоанного анализа дисперсий должна быть выбрана'...
                            'одна целевая выборка и одна разбивающая целевую на группы'],...
                        'Ошибка задания данных','modal');
                    delete(graphFigure);
                    return
                end              
                
                infoStr = calculateCriteriaForMultipleSamplesNumericData(...
                    datasets, significanceLevel, isDatasetsIndependentStr, isDatasetsRangedStr, cmprTypeStr, groupData);
                          
% % %       
            case graphs.oneDichCriteria.name
                
                supposedProbability = getNumberFromEdit(handles.MuEdit);                
                
                if isnan(supposedProbability)
                    errordlg('Предполагаемая вероятность должна быть задана числом в диапазоне (0...1)',...
                        'Ошибка задания данных','modal');
                    delete(graphFigure);
                    return
                end
                
                datasets(1).dataset = replaceNaN(datasets(1).dataset);
                
                infoStr = calculateCriteriaForOneSampleDichotomousData(...
                    datasets, significanceLevel, supposedProbability, tailStr);
                
            case graphs.twoDichCriteria.name
                
                isDatasetsIndependent = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu1));
                        
                if size(datasets,2) ~= 2
                    errordlg(' Выберите 2 уникальные выборки',...
                        'Ошибка задания данных','modal');
                    delete(graphFigure);
                    return
                end    
                
                [~,emptyFlag] = replaceNanStrings(datasets);
                
                if emptyFlag
                    errordlg('После удаления NaN одна или более выборок стали пустыми',...
                        'Ошибка задания данных','modal');
                    delete(graphFigure);
                    return                    
                end
                
                infoStr = calculateCriteriaForTwoSamplesDichotomousData(...
                    datasets, significanceLevel, isDatasetsIndependent, tailStr);
                
            case graphs.threeDichCriteria.name                
                
                isDatasetsIndependent = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu1));
                              
                if size(datasets,2) < 3
                    errordlg(' Выберите не менее 3х уникальных выборок',...
                        'Ошибка задания данных','modal');
                    delete(graphFigure);
                    return
                end                
                
                [~,emptyFlag] = replaceNanStrings(datasets);
                
                if emptyFlag
                    errordlg('После удаления NaN одна или более выборок стали пустыми',...
                        'Ошибка задания данных','modal');
                    delete(graphFigure);
                    return                    
                end
                
                infoStr = calculateCriteriaForMultipleSamplesDichotomousData(...
                    datasets, significanceLevel, isDatasetsIndependent);
                
            case graphs.twoCatCriteria.name
                
                isDatasetsIndependent = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu1));
                    
                if size(datasets,2) ~= 2
                    errordlg(' Выберите 2 уникальные выборки',...
                        'Ошибка задания данных','modal');
                    delete(graphFigure);
                    return
                end        
                
                [~,emptyFlag] = replaceNanStrings(datasets);
                
                if emptyFlag
                    errordlg('После удаления NaN одна или более выборок стали пустыми',...
                        'Ошибка задания данных','modal');
                    delete(graphFigure);
                    return                    
                end
                
                infoStr = calculateCriteriaForTwoSamplesCategoricalData(...
                    datasets, significanceLevel, isDatasetsIndependent);
                
            case graphs.threeCatCriteria.name
                
                isDatasetsIndependent = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu1));
                          
                if size(datasets,2) < 3
                    errordlg(' Выберите не менее 3х уникальных выборок',...
                        'Ошибка задания данных','modal');
                    delete(graphFigure);
                    return
                end        
                
                [~,emptyFlag] = replaceNanStrings(datasets);
                
                if emptyFlag
                    errordlg('После удаления NaN одна или более выборок стали пустыми',...
                        'Ошибка задания данных','modal');
                    delete(graphFigure);
                    return                    
                end
                
                infoStr = calculateCriteriaForMultipleSamplesCategoricalData(...
                    datasets, significanceLevel, isDatasetsIndependent);
                
        end               
        
        printInfo(graphFigure, infoStr); 
                
    case graphs.multiAnova.name
        
        significanceLevel = getNumberFromEdit(handles.ValueLevelEdit);
                
        if isnan(significanceLevel) || significanceLevel <= 0 || significanceLevel >= 1
            errordlg('Уровень значимости должен быть задан числом в интервале (0...1)',...
                'Ошибка задания данных','modal');
            delete(graphFigure);
            return
        end
        
        sstypeStr = getMenuString(handles.GraphAdditionalPopupMenu1);
        cmprTypeStr = getMenuString(handles.GraphAdditionalPopupMenu2);
        
        dataYName = getDataNames(handles, "Y1");
        dataXNames = getDataNames(handles, ["X1","X2","X3","X4","X5","X6"]);
        
        if any(dataXNames == dataYName)
            errordlg('Выберите целевую переменную отличную от исходных',...
                'Ошибка задания данных','modal');
            delete(graphFigure);
            return
        end
        
        if size(dataXNames,2) < 2 || isempty(dataYName)
            errordlg('Выберите целевую переменную и 2 или более уникальных исходных',...
                'Ошибка задания данных','modal');
            delete(graphFigure);
            return
        end
        
        dataY = createDatasetsForCriteria(dataFrame, dataFrameNamesAndTypes, dataYName);
        datasets = createDatasetsForCriteria(dataFrame, dataFrameNamesAndTypes, dataXNames);
        
        infoStr = calculateAnovan(dataY, datasets, sstypeStr, significanceLevel, cmprTypeStr);
        printInfo(graphFigure, infoStr);        
        
    
    case graphs.crossTab.name
    
        dataNames = getDataNames(handles, ["Y1","Y2","Y3","Y4","Y5","Y6"]);        
        
        if size(dataNames,1) < 2
            errordlg('Выберите 2 или более уникальных выборок',...
                'Ошибка задания данных','modal');
            delete(graphFigure);
            return
        end        
        
        datasets = createDatasetsForCriteria(dataFrame, dataFrameNamesAndTypes, dataNames);
        
        [tbl,chi2,p,labels] = callCrosstab(datasets);
        
        showCrossTab(tbl, chi2, p, labels, dataNames);
        delete(graphFigure);
        return 
    
    case graphs.logitregression.name        
        
        responseName = getMenuString(handles.GraphAdditionalPopupMenu2); 
        interactionsMode = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu3));
        predictorsNames = getDataNames(handles,...
                        ["X1","X2","X3","X4","X5","X6","Y1","Y2","Y3","Y4","Y5","Y6"]); 
        
        if isempty(responseName) || responseName == ""
            errordlg('Выберите зависимую переменную','Ошибка задания данных','modal');                    
            delete(graphFigure);
            return            
        end        
        
        if isempty(predictorsNames)
            errordlg('Выберите предикторы',...
                'Ошибка задания данных','modal');
            delete(graphFigure);
            return
        end          
        
        response = retrieveData(dataFrame, dataFrameNamesAndTypes, responseName);
        predictors = retrieveData(dataFrame, dataFrameNamesAndTypes, predictorsNames); 
        
        if dataFrameNamesAndTypes(2, dataFrameNamesAndTypes(1,:) == responseName) == "дихотомический"
            isBinaryResponse = true;
        else
            isBinaryResponse = false;
        end
                
        [~,emptyFlag] = replaceNanStrings([predictors, response]);
                
        if emptyFlag
            errordlg('После удаления NaN не осталось наблюдений. Выберите другие выборки',...
                'Ошибка задания данных','modal');
            delete(graphFigure);
            return
        end                
                
        infoTable = calculateLogit(predictors, response, interactionsMode, isBinaryResponse, predictorsNames);
        
        showLogitTable(infoTable, responseName);        
        delete(graphFigure);
        return
        
    otherwise
        
        assert(0,'некорректное значение графика');       
end   
        
graphFigure.Visible = 'On';
    



