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

function varargout = DatasetAnalyzerAndStatisticalHypothesisTester_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function DatasetAnalyzerAndStatisticalHypothesisTester_OpeningFcn(hObject, eventdata, handles, varargin)
warning off;
addpath([cd '\functions'], [cd '\icons'], [cd '\info']);
handles.MainWindow.Visible = 'off';


handles.output = hObject;
guidata(hObject, handles);

[graphsNames, graphsHelpInfos] = getGraphs();

setappdata(handles.MainWindow,'HistogramIcon',imread('HistogramPlot.png'));
setappdata(handles.MainWindow,'HeatMapIcon',imread('HeatMapChart.png'));
setappdata(handles.MainWindow,'ErrorBarIcon',imread('ErrorBarPlot.png'));
setappdata(handles.MainWindow,'ScatterIcon',imread('ScatterPlot.png'));
setappdata(handles.MainWindow,'PieIcon',imread('PieChart.png'));

setFigureInCenter(handles.MainWindow);
setappdata(handles.MainWindow,'graphs',graphsNames);
setappdata(handles.MainWindow,'graphHelpStr',graphsHelpInfos);


% TODO: 
% �������� ���������
% �������� ��������� ���������� ��������
% ������� �������� �� ���-�� ����� ��� �� ��������

% �������� ������� ������������� CROSSTAB
% gplotmatrix 
% �������� ��� ������ � ������������� ������� �������������
% �������� ������ ������ ��� �������
% �� ��������� ���������� ������� ������ ���, ���� �������� �������� ������


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function OpenDataTable_Callback(hObject, eventdata, handles)

[FileName, PathName] = uigetfile({'*.xlsx;*.xls;*.csv'}, '�������� ���� ������� ������');    
if ~FileName                         
    return;
end

try
    h = waitbar(0,'�������� ������','WindowStyle','modal'); 
    
    % ���� ���� csv, �� UTF-8
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
    
    waitbar(0.5,h);
    
catch
    close(h);
    errordlg({'���������� ��������� ������.';...
        '���������, ��� ���� ����� ���������� "xlsx", "xls" ��� "csv",';...
        '� ������ ������������ � ���� ���������� ������� ��� ��������� ��������'},...
        '������ �������� �����','modal');
    return;
end

[dataFrame, dataFrameNamesAndTypes] = setTableFieldsTypes(T);
setappdata(handles.MainWindow,'dataFrame',dataFrame);
setappdata(handles.MainWindow,'dataFrameNamesAndTypes',dataFrameNamesAndTypes);

handles.GraphPopupmenu.String = getappdata(handles.MainWindow,'graphs');
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

waitbar(0.75,h);

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

waitbar(1,h);
close(h);


function ColumnAdderMenu_Callback(hObject, eventdata, handles)

dataFrame = getappdata(handles.MainWindow,'dataFrame');
dataFrameNamesAndTypes = getappdata(handles.MainWindow,'dataFrameNamesAndTypes');

transferData.dataFrame = dataFrame;
transferData.dataFrameNamesAndTypes = dataFrameNamesAndTypes;
transferData.mainWindowHandles = handles;

DataSampleAdder(transferData);


function SaveDataTable_Callback(hObject, eventdata, handles)

[FileName,PathName] = uiputfile({'*.xlsx';'*.xls';'*.csv'}, ...
    '�������� ���� ��� ���������� ������������� ������');

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
    "������: 0.5" ;...
    "" ;...
    "���������� ������������� ��� ������������ � ������� ��������� ������.";...
    "�������� �����������:" ;...
    " - ��������� xls, xlsx, csv ������;" ;...
    " - ����������� ����������� ������� ������;" ;...
    " - ���������� �������� � �������� ��� ������� ������;" ;...
    " - �������������� ������ � ������ ��������� �������� �������������� ������� � �������� �������;" ;...
    " - ���������� ������� �� �������� � ����������;" ;...
    " - ���������� �� 3 �������� � ������������� ������;" ;...
    "" ;...
    "" ;...
    "�����: ���������� ������ ��������� (k-and92@mail.ru)" ;...
    "" ;...
    "" ;...
    },...
    '� ���������','WindowStyle','modal');


function GraphPopupmenu_Callback(hObject, eventdata, handles)

graphs = getappdata(handles.MainWindow,'graphs');
graphHelpStr = getappdata(handles.MainWindow,'graphHelpStr');
dataFrameNamesAndTypes = getappdata(handles.MainWindow,'dataFrameNamesAndTypes');

allDataNames = ["" dataFrameNamesAndTypes(1,:)];
stringDataNames = ["" dataFrameNamesAndTypes(1,dataFrameNamesAndTypes(2,:)=="��������������")];
numericDataNames = ["" dataFrameNamesAndTypes(1,dataFrameNamesAndTypes(2,:)=="��������")];
logicalDataNames = ["" dataFrameNamesAndTypes(1,dataFrameNamesAndTypes(2,:)=="����������")];
stringAndLogicalDataNames =[""  dataFrameNamesAndTypes(1, dataFrameNamesAndTypes(2,:)=="��������������" |...
                                dataFrameNamesAndTypes(2,:)=="����������")];


allMenuToDefaultState(handles);
handles.HelpText.String = graphHelpStr(handles.GraphPopupmenu.Value);

switch getMenuString(handles.GraphPopupmenu)
    
    case graphs(1)
        
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
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {'����������','�������������'};
        
    case graphs(2)
        
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
        
    case graphs(3)
        
        imshow(getappdata(handles.MainWindow,'PieIcon'),...
            'Parent',handles.IconAxes);
        
        handles.Y1popupmenu.String = stringAndLogicalDataNames;
        handles.Y1popupmenu.Enable = 'On';
        
    case graphs(4)
        
        imshow(getappdata(handles.MainWindow,'HeatMapIcon'),...
            'Parent',handles.IconAxes);        
        
        handles.Y1popupmenu.String = numericDataNames;
        handles.Y1popupmenu.Enable = 'On';
        
        handles.X1popupmenu.String = allDataNames;
        handles.X2popupmenu.String = allDataNames;
        handles.X1popupmenu.Enable = 'On';
        handles.X2popupmenu.Enable = 'On';      
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {'�������','�������','�����'};
        
    case graphs(5)
        
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
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {'�������','��������','��������'};      
        
    case graphs(6)
        
        imshow(getappdata(handles.MainWindow,'ErrorBarIcon'),...
            'Parent',handles.IconAxes);   
        
        handles.Y1popupmenu.String = numericDataNames;
        handles.Y1popupmenu.Enable = 'On';
        
        handles.X1popupmenu.String = stringAndLogicalDataNames;        
        handles.X1popupmenu.Enable = 'On';
        
    case graphs(7)
        
        imshow(getappdata(handles.MainWindow,'HistogramIcon'),...
            'Parent',handles.IconAxes);      
        
        handles.Y1popupmenu.String = numericDataNames;
        handles.Y1popupmenu.Enable = 'On';
        
        handles.X1popupmenu.String = stringAndLogicalDataNames;        
        handles.X1popupmenu.Enable = 'On';          
    
%   ��������� �������� 1� �������� �������
    case graphs(8)
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';        
        handles.ValueLevelText.String = '������� ����������:';
        
        handles.MuEdit.Visible = 'On';
        handles.MuText.Visible = 'On';
        handles.MuText.String = '������� / ���. ��������:'; 
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            '������������ �������������� ��������',...
            '������������� �������������� ��������',...
            '�������������� �������������� ��������'...
            };        
        
        handles.GraphAdditionalPopupMenu3.Visible = 'On';
        handles.GraphAdditionalPopupMenu3.String = {...
            '������� �� �����������',...
            '������� �����������'...
            };    
        
        handles.Y1popupmenu.String = numericDataNames;        
        handles.Y1popupmenu.Enable = 'On';
    
    case graphs(9)
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';
        handles.ValueLevelText.String = '������� ����������:';
                
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {...
            '������� ����������',...
            '������� ��������'....
            };  
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            '������������ �������������� ��������',...
            '������������� �������������� ��������',...
            '�������������� �������������� ��������'...
            };        
        
        handles.GraphAdditionalPopupMenu3.Visible = 'On';
        handles.GraphAdditionalPopupMenu3.String = {...
            '������� �� �����������',...
            '������� �����������'...
            };    
        
        handles.Y1popupmenu.String = numericDataNames;
        handles.Y2popupmenu.Enable = 'On';       
        
        handles.Y2popupmenu.String = numericDataNames;        
        handles.Y1popupmenu.Enable = 'On';  
    
    case graphs(10)
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';
        handles.ValueLevelText.String = '������� ����������:';
                
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {...
            '������� ����������',...
            '������� ��������'....
            };          
        
        handles.MuText.Visible = 'On';
        handles.MuText.String = '����� ��������:'; 
        
        handles.MuEdit.Visible = 'On';
        handles.MuEdit.String = '1';
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            '���������: �����-�������',...
            '���������: ����������',....
            '���������: �����-������',....
            '���������: ������ (LSD)',....
            '���������: �����'....
            }; 
        
        handles.GraphAdditionalPopupMenu3.Visible = 'On';
        handles.GraphAdditionalPopupMenu3.String = {...
            '������� �� �����������',...
            '������� �����������'...
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
    
    case graphs(11)        
        
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
        handles.ValueLevelText.String = '������� ����������:'; 
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {'��� ����� ���������: I',...
                                                    '��� ����� ���������: II',...
                                                    '��� ����� ���������: III',...
                                                    };
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            '���������: �����-�������',...
            '���������: ����������',....
            '���������: �����-������',....
            '���������: ������ (LSD)',....
            '���������: �����'....
            };
        
%     ��������� �������� 1� �������������� �������    
    case graphs(12)
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';        
        handles.ValueLevelText.String = '������� ����������:';
        
        handles.MuEdit.Visible = 'On';
        handles.MuText.Visible = 'On';
        handles.MuText.String = '������-�� "0":';       
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            '������������ �������������� ��������',...
            '������������� �������������� ��������',...
            '�������������� �������������� ��������'...
            };  
        
        handles.Y1popupmenu.String = logicalDataNames;        
        handles.Y1popupmenu.Enable = 'On';
    
    case graphs(13)
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';        
        handles.ValueLevelText.String = '������� ����������:';
        
        handles.MuEdit.Visible = 'On';
        handles.MuText.Visible = 'On';
        handles.MuText.String = '������-�� "+":';
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {...
            '������� ����������',...
            '������� ��������'...
            };                
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            '������������ �������������� ��������',...
            '������������� �������������� ��������',...
            '�������������� �������������� ��������'...
            };        
        
        handles.Y1popupmenu.String = stringAndLogicalDataNames;        
        handles.Y1popupmenu.Enable = 'On';
        
        handles.Y2popupmenu.String = stringAndLogicalDataNames;
        handles.Y2popupmenu.Enable = 'On'; 
    
    case graphs(14)
        
        handles.ValueLevelEdit.Visible = 'On';
        handles.ValueLevelText.Visible = 'On';        
        handles.ValueLevelText.String = '������� ����������:';
        
        handles.MuEdit.Visible = 'On';
        handles.MuText.Visible = 'On';
        handles.MuText.String = '������-�� "+":';
        
        handles.GraphAdditionalPopupMenu1.Visible = 'On';
        handles.GraphAdditionalPopupMenu1.String = {...
            '������� ����������',...
            '������� ��������'...
            };                
        
        handles.GraphAdditionalPopupMenu2.Visible = 'On';
        handles.GraphAdditionalPopupMenu2.String = {...
            '������������ �������������� ��������',...
            '������������� �������������� ��������',...
            '�������������� �������������� ��������'...
            };        
        
        handles.Y1popupmenu.String = stringAndLogicalDataNames;        
        handles.Y1popupmenu.Enable = 'On';
        
        handles.Y2popupmenu.String = stringAndLogicalDataNames;
        handles.Y2popupmenu.Enable = 'On';
        
        handles.Y3popupmenu.String = stringAndLogicalDataNames;        
        handles.Y3popupmenu.Enable = 'On';
        
        handles.Y4popupmenu.String = stringAndLogicalDataNames;
        handles.Y4popupmenu.Enable = 'On';
        
        handles.Y5popupmenu.String = stringAndLogicalDataNames;        
        handles.Y5popupmenu.Enable = 'On';
        
        handles.Y6popupmenu.String = stringAndLogicalDataNames;
        handles.Y6popupmenu.Enable = 'On'; 
        
    otherwise
        
        assert(0,'������������ �������� �������');
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
    assert(0,"�������������� ��������� ������� ������")
end

eval("handles.FilterValuePopupMenu" + handleNumber + ".Value = 1;");
eval("handles.EquationPopupMenu" + handleNumber + ".Value = 1;");

if hObject.Value == 1
    
    eval("handles.FilterValuePopupMenu" + handleNumber + ".String = ' ';");
    eval("handles.EquationPopupMenu" + handleNumber + ".String = ' ';");
    
elseif dataFrameNamesAndTypes(2, hObject.Value-1) == "��������������" || ...
        dataFrameNamesAndTypes(2, hObject.Value-1) == "����������"
    
    dataName = getMenuString(hObject);
    data = dataFrame{:,find(dataFrameNamesAndTypes(1,:)==dataName)};
    
    data = replaceNaN(data);
    uniqueData = unique(data);
    
    eval("handles.FilterValuePopupMenu" + handleNumber + ".Style = 'popupmenu';");
    eval("handles.FilterValuePopupMenu" + handleNumber + ".String = uniqueData;");
        
    eval("handles.EquationPopupMenu" + handleNumber + ".String = {'=='; '~='};");
    
elseif dataFrameNamesAndTypes(2, hObject.Value-1) == "��������"
    
    eval("handles.FilterValuePopupMenu" + handleNumber + ".String = ' ';");
    eval("handles.FilterValuePopupMenu" + handleNumber + ".Style = 'edit';");
    
    eval("handles.EquationPopupMenu" + handleNumber + ".String = {'=='; '~='; '>'; '>='; '<'; '<='};");
          
else    
    assert(0,"�������������� ����� ������ �������")    
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

    handles.TableTextInfo.String = "����� �����: " + ...
                                    num2str(dataFrameLengths(selectedCol)) + " �� " + ...
                                    num2str(handles.DataTable.UserData{1}) + " ("   + ...
                                    dataFrameNamesAndTypes(2,selectedCol)  + ...
                                    " ��� ������)";                            
   
    handles.DataTable.Enable = 'on';
    
else
     handles.TableTextInfo.String = ...
        '��� ��������� ���������� ������� �������� ������ / ������ �������';
end


function GraphAdditionalPopupMenu1_Callback(hObject, eventdata, handles)

graphs = getappdata(handles.MainWindow,'graphs');

switch getMenuString(handles.GraphPopupmenu)
    
    case graphs(10)
        
        if getMenuString(handles.GraphAdditionalPopupMenu1) == '������� ����������'
            handles.X1popupmenu.Enable = 'On';     
            
        elseif getMenuString(handles.GraphAdditionalPopupMenu1) == '������� ��������'
            handles.X1popupmenu.Enable = 'Off'; 
            
        else
            assert(0,'������������ �������� �������� �������');   
        end
        
        
    otherwise
        
end


function ShowColPopupmenu_Callback(hObject, eventdata, handles)

switch hObject
    
    case handles.ShowColPopupmenu1
        
        values = handles.ShowColPopupmenu1.Value;
        listHandles = handles.ShowColList1;
        
    case handles.ShowColPopupmenu2
        
        values = handles.ShowColPopupmenu2.Value;
        listHandles = handles.ShowColList2;
        
    case handles.ShowColPopupmenu3
        
        values = handles.ShowColPopupmenu3.Value;
        listHandles = handles.ShowColList3;
        
    case handles.OpenDataTable
        
        values = [  handles.ShowColPopupmenu1.Value...
                    handles.ShowColPopupmenu2.Value ...
                    handles.ShowColPopupmenu3.Value] ;
                
        listHandles = [ handles.ShowColList1 handles.ShowColList2 handles.ShowColList3 ];
        
    otherwise
        assert(0, '����� �� ������������ callback');
end
        
cellData = handles.DataTable.Data;

numbers = 1:size(cellData,1);

for x = 1:length(values)
    
    data = string(cell2mat(cellData(:,values(x))));
    data(ismissing(data)) = " ";
    listHandles(x).String = strcat(num2str(numbers'), ") ", data);    
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
    errordlg('������ ������',...
        '������� ����� ���������� ����� - ������. �������� ��������� ����������','modal');
    return
end

titleSuffix = "";

switch getMenuString(handles.GraphPopupmenu)
    
    case graphs(1)  
        
        hold on;
        dataNames = getDataNames(handles, ["Y1","Y2","Y3","Y4","Y5","Y6"]);
        
        if isempty(dataNames)
            errordlg('�������� ������ ��� �������','������ ������� ������','modal');                    
            delete(graphFigure);
            return            
        end
        
        data = retrieveData(dataFrame, dataFrameNamesAndTypes, dataNames);
        buildHistograms(data, gca, graphProperty);  
        
        dataNames = checkNormality(data, dataNames);
        
        legend(dataNames);
        titleSuffix = "(" + graphProperty + ")";
        title({getMenuString(handles.GraphPopupmenu) titleSuffix});
        
    case graphs(2)       
        
        hold on;
        
        dataYName = getDataNames(handles, "Y1");
        dataXNames = getDataNames(handles, ["X1","X2","X3","X4","X5","X6"]);        
        
        if isempty(dataXNames) || isempty(dataYName)
            errordlg('�������� ������ ��� �������','������ ������� ������','modal');                    
            delete(graphFigure);
            return            
        end
        
        dataY = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYName);
        dataX = retrieveData(dataFrame, dataFrameNamesAndTypes, dataXNames);        
        
        buildScatterPlots(dataY, dataX, gca);         
        
        legend(dataXNames);
        ylabel(dataYName);
        title(getMenuString(handles.GraphPopupmenu));
        
    case graphs(3)
        
        dataYName = getDataNames(handles, "Y1");   
        
        if isempty(dataYName)
            errordlg('�������� ������ ��� �������','������ ������� ������','modal');                    
            delete(graphFigure);
            return            
        end
        
        data = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYName);       
        data = replaceNaN(data);
        
        if isempty(data)
            errordlg('��������� ������ �������� ������ �������. �������� ������ ������', ...
                '������ ������','modal');
            delete(graphFigure);
            return;
        end
        
        buildPie(data, gca);
        
        titleSuffix = dataYName;
        title({getMenuString(handles.GraphPopupmenu) titleSuffix});        
        

    case graphs(4)
        
        hold on;
        colorDataName = getDataNames(handles, "Y1"); 
        dataXName = getDataNames(handles, "X1");  
        dataYName = getDataNames(handles, "X2");  
        
        if isempty(dataXName) || isempty(dataXName) || isempty(colorDataName)
            errordlg('�������� ������ ��� �������','������ ������� ������','modal');                    
            delete(graphFigure);
            return            
        end
        
        dataY = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYName);
        dataX = retrieveData(dataFrame, dataFrameNamesAndTypes, dataXName);  
        
        dataX = replaceNaN(dataX);
        dataY = replaceNaN(dataY);
        
        if isempty(dataX) || isempty(dataY)
            errordlg('��������� ������ �������� ������ �������. �������� ������ ������',...
                '������ ������� ������','modal');            
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
            
    case graphs(5)
        
        hold off;        
        dataYNames = getDataNames(handles, ["Y1","Y2","Y3","Y4","Y5","Y6"]); 
        
        if isempty(dataYNames)
            errordlg('�������� ������ ��� �������','������ ������� ������','modal');                    
            delete(graphFigure);
            return            
        end
                
        dataY = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYNames);
        method = getDictValue(graphProperty);        
        
        [corrCoeffs, pValues] = corr(dataY, dataY, 'type', method, 'rows', 'pairwise');
        
        subplot(2,1,1)
        heatmap(dataYNames, dataYNames, corrCoeffs);         
        title({getMenuString(handles.GraphPopupmenu) "������������ " + graphProperty});
        
        subplot(2,1,2)
        heatmap(dataYNames, dataYNames, pValues);  
        title({getMenuString(handles.GraphPopupmenu) '�������� p'});
        graphFigure.Visible = 'On';
        return
        
    case graphs(6)        
        
        hold on;
        dataYName = getDataNames(handles, "Y1");
        dataXName = getDataNames(handles, "X1");         
        
        if isempty(dataXName) || isempty(dataYName)
            errordlg('�������� ������ ��� �������','������ ������� ������','modal');                    
            delete(graphFigure);
            return            
        end         
        
        dataY = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYName);
        dataX = retrieveData(dataFrame, dataFrameNamesAndTypes, dataXName);      
        dataX = replaceNaN(dataX);         
        
        if isempty(dataX)
            errordlg('��������� ������ �������� ������ �������. �������� ������ ������',...
                '������ ������� ������','modal');            
            delete(graphFigure);
            return;
        end
        
        buildErrorBar(dataY, dataX, gca); 
        
        xlabel(dataXName);
        xtickangle(gca, 45)
        ylabel(dataYName);        
        title({getMenuString(handles.GraphPopupmenu) titleSuffix});
    
    case graphs(7)
        
        hold on;
        dataYName = getDataNames(handles, "Y1");
        dataXName = getDataNames(handles, "X1"); 
        
        if isempty(dataXName) || isempty(dataYName)
            errordlg('�������� ������ ��� �������','������ ������� ������','modal');                    
            delete(graphFigure);
            return            
        end 
        
        dataY = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYName);
        dataX = retrieveData(dataFrame, dataFrameNamesAndTypes, dataXName);      
        dataX = replaceNaN(dataX);
        
        if isempty(dataX)
            errordlg('��������� ������ �������� ������ �������. �������� ������ ������', ...
                '������ ������� ������','modal');            
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
        
        
    %   ��������� ��������
    case {graphs{8}, graphs{9}, graphs{10}, graphs{11}, graphs{12}, graphs{13} }   
        
        dataYNames = getDataNames(handles, ["Y1","Y2","Y3","Y4","Y5","Y6"]); 
        
        if isempty(dataYNames)
            errordlg('�������� ������ ��� ������� ���������','������ ������','modal');                    
            delete(graphFigure);
            return            
        end
        
        significanceLevel = getNumberFromEdit(handles.ValueLevelEdit);        
        
        if isnan(significanceLevel) || significanceLevel <= 0 || significanceLevel >= 1            
            errordlg('������� ���������� ������ ���� ����� ������ � ��������� (0...1)',...
                '������ ������� ������','modal');                    
            delete(graphFigure);
            return 
        end     
               
        tail = getMenuString(handles.GraphAdditionalPopupMenu2);          
        datasets = createDatasetsForCriteria(dataFrame, dataFrameNamesAndTypes, dataYNames);        
        
        if isempty(datasets)
            errordlg('��������� ������ �������� ������ �������. �������� ������ ������', ...
                '������ ������� ������','modal');
            delete(graphFigure);
            return;
        end               
        
        switch getMenuString(handles.GraphPopupmenu)
           
            case graphs(8)
                
                mu = getNumberFromEdit(handles.MuEdit);
                
                if isnan(mu)
                    errordlg('������������� ������� mu ������ ���� ������ ������',...
                        '������ ������� ������','modal');
                    delete(graphFigure);
                    return
                end
                
                isDatasetsRanged = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu3));
                
                infoStr = calulateCriteriaForOneSampleNumericData(...
                    datasets, significanceLevel, isDatasetsRanged, mu, tail);
                
            case graphs(9)
                
                isDatasetsIndependent = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu1));
                isDatasetsRanged = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu3));
                
                infoStr = calulateCriteriaForTwoSamplesNumericData(...
                    datasets, significanceLevel, isDatasetsRanged, isDatasetsIndependent, tail);
                
            case graphs(10)                                
                
                dataXName = getDataNames(handles, "X1");
                groupData = createDatasetsForCriteria(dataFrame, dataFrameNamesAndTypes, dataXName);                
                
                isDatasetsIndependentStr = getMenuString(handles.GraphAdditionalPopupMenu1);
                isDatasetsRangedStr = getMenuString(handles.GraphAdditionalPopupMenu3);
                cmprTypeStr = getMenuString(handles.GraphAdditionalPopupMenu2);
                
                reps = getNumberFromEdit(handles.MuEdit);
                
                if isnan(reps) || reps <= 0 || round(reps) ~= reps
                    errordlg('����� ��������� ��������� � ������� ������ ���� ������������� � �����',...
                        '������ ������� ������','modal');
                    delete(graphFigure);
                    return
                end
                
                if isempty(groupData) && size(datasets,2) < 3
                    errordlg(['��� ����������������� ������� ��������� ������ ���� �������' ...
                            '�� ������ 3� ���������� �������'],...
                        '������ ������� ������','modal');
                    delete(graphFigure);
                    return
                end
                
                if ~isempty(groupData) && size(datasets,2) ~= 1
                    errordlg(['��� ������������������� ������� ��������� ������ ���� �������'...
                            '���� ������� ������� � ���� ����������� ������� �� ������'],...
                        '������ ������� ������','modal');
                    delete(graphFigure);
                    return
                end              
                
                infoStr = calulateCriteriaForMultipleSamplesNumericData(...
                    datasets, significanceLevel, isDatasetsIndependentStr, isDatasetsRangedStr, cmprTypeStr, reps, groupData);
            
                
            case graphs(11)
                
                significanceLevel = getNumberFromEdit(handles.ValueLevelEdit);
                
                if isnan(significanceLevel) || significanceLevel <= 0 || significanceLevel >= 1
                    errordlg('������� ���������� ������ ���� ����� ������ � ��������� (0...1)',...
                        '������ ������� ������','modal');
                    delete(graphFigure);
                    return
                end
                
                sstypeStr = getMenuString(handles.GraphAdditionalPopupMenu1);
                cmprTypeStr = getMenuString(handles.GraphAdditionalPopupMenu2);
                
                dataYName = getDataNames(handles, "Y1");
                dataXNames = getDataNames(handles, ["X1","X2","X3","X4","X5","X6"]);
                
                if any(dataXNames == dataYName)
                    errordlg('�������� ������� ���������� �������� �� ��������',...
                        '������ ������� ������','modal');
                    delete(graphFigure);
                    return
                end
                
                if size(dataXNames,2) < 2 || isempty(dataYName)
                    errordlg('�������� ������� ���������� � 2 ��� ����� ���������� ��������',...
                        '������ ������� ������','modal');
                    delete(graphFigure);
                    return
                end
                
                dataY = createDatasetsForCriteria(dataFrame, dataFrameNamesAndTypes, dataYName);
                datasets = createDatasetsForCriteria(dataFrame, dataFrameNamesAndTypes, dataXNames);
                
                infoStr = calulateAnovan(dataY, datasets, sstypeStr, significanceLevel, cmprTypeStr);
                printInfo(graphFigure, infoStr);
                
            case graphs(12)                
                
                supposedProbability = getNumberFromEdit(handles.MuEdit);                
                
                if isnan(supposedProbability)
                    errordlg('�������������� ����������� ������ ���� ������ ������ � ��������� (0...1)',...
                        '������ ������� ������','modal');
                    delete(graphFigure);
                    return
                end
                
                infoStr = calulateCriteriaForOneSampleCategoricalData(...
                    datasets, significanceLevel, supposedProbability, tail);
                
            case graphs(13)
                
                isDatasetsIndependent = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu1));
                isDatasetsSmall = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu3) );
                
                infoStr = calulateCriteriaForTwoSamplesCategoricalData(...
                    datasets, significanceLevel, isDatasetsSmall, isDatasetsIndependent, tail);
                
            case graphs(14)
                
                isDatasetsSmall = getDictValue(getMenuString(handles.GraphAdditionalPopupMenu3) );
                
                infoStr = calulateCriteriaForMultipleSamplesCategoricalData(...
                    datasets, significanceLevel, isDatasetsSmall, tail);
                
        end               
        
        printInfo(graphFigure, infoStr); 
                
    otherwise
        
        assert(0,'������������ �������� �������');       
end   
        
graphFigure.Visible = 'On';
    
