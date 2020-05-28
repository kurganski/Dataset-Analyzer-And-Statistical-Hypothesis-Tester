function infoStr = calulateAnovan( dataY, datasets, sstypeStr, significanceLevel, cmprTypeStr )

infoStr = "������ �������: '" + dataY.name + "' ��� ��������� �� ������ �� ��������: ";

for x = 1:size(datasets,2)
    infoStr = [infoStr;  " - " + datasets(x).name + " [ ��� ������: " + datasets(x).type + "]"];
end

infoStr = [infoStr; ""];
infoStr = [infoStr; "������� ����������: " + num2str(significanceLevel)];

sstype = getDictValue(sstypeStr);
cmprType = getDictValue(cmprTypeStr);

group = {datasets(:).dataset};

continuousVars = zeros(1, size(datasets,2));
groupingVarsNames = cell(1, size(datasets,2)); 

for x = 1:size(datasets,2)
    
    if datasets(x).type == '��������' 
        continuousVars(x) = x;   
    end
    
    groupingVarsNames(x) = {char(datasets(x).name)};
    
end

continuousVars(continuousVars == 0) = [];

handle = figure('Position',[50 50 850 550], 'Visible','off');
setFigureInCenter(handle);

[~, ~, stats] = anovan( dataY.dataset, ...
        group, ...
        'alpha', significanceLevel ,...
        'sstype', sstype ,...
        'varnames', groupingVarsNames ,...
        'continuous', continuousVars ,...
        'model', 'full');

DIM = 1:length(stats.nlevels);
DIM(stats.nlevels < 2) = [];

infoStr = [infoStr; "����������� ��������: �������������� ������ ��������� (ANOVA)"];
infoStr = [infoStr; cmprTypeStr];
infoStr = [infoStr; "������� � Matlab R2017a: anovan(y, group) � multcompare(stats, 'model', 'full')"];
infoStr = [infoStr; "������� �� ������� � ����������� �������������: https://www.mathworks.com/help/stats/anovan.html"];
infoStr = [infoStr; "������� �� ������ ���������: https://www.mathworks.com/help/stats/multcompare.html"];
infoStr = [infoStr; ""];
infoStr = [infoStr; "source - �������� �������������;"];
infoStr = [infoStr; "Error - ������������� ������ ������;"];
infoStr = [infoStr; "Total - �������� �������������;"];
infoStr = [infoStr; ""];
infoStr = [infoStr; "SS - ����� ���������;"];
infoStr = [infoStr; "df - ������� �������;"];
infoStr = [infoStr; "MS - ������� �������� ���������;"];
infoStr = [infoStr; "Singular? - �������� ����, �������� �� ������� �����������;"];
infoStr = [infoStr; "F - F-���������� (��������� ������� ���������);"];
infoStr = [infoStr; "Prob>F - p-�������� (��� F-�������������)."];

figure(handle);
multcompare(stats, 'Alpha', significanceLevel, 'CType', cmprType, 'Dimension', DIM);
handle.Visible = 'on';

end

