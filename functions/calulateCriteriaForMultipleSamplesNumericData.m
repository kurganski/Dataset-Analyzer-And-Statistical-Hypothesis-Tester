function infoStr = calulateCriteriaForMultipleSamplesNumericData( ...
               datasets, significanceLevel, isDatasetsIndependentStr, isDatasetsRangedStr, cmprTypeStr)

infoStr = "������ �������:";

for x = 1:size(datasets,2)
    infoStr = [infoStr; datasets(x).name + " [ ��� ������: " + datasets(x).type + "]"];
end

cmprType = getDictValue(cmprTypeStr);
isDatasetsIndependent = getDictValue(isDatasetsIndependentStr);
isDatasetsRanged = getDictValue(isDatasetsRangedStr);

isAllNormalDistribution = false;
infoStr = [infoStr; ""];
infoStr = [infoStr; isDatasetsIndependentStr];
infoStr = [infoStr; "������� ����������: " + num2str(significanceLevel)];

% ����� �������������, ���� �� ����������� �������
if ~isDatasetsRanged
    for x = 1:size(datasets,2)
        % ���� adtest == 0, �� ����������
        isAllNormalDistribution = ~adtest(datasets(x).dataset, 'Alpha', significanceLevel);
        if ~isAllNormalDistribution
            break;
        end        
    end
end

dataForAnova = groupDataForAnova(datasets);
handle = figure('Position',[50 50 850 550], 'Visible','off');
setFigureInCenter(handle);

% sg
isAllNormalDistribution = true;
%         fg

if isDatasetsIndependent
      
    infoStr = [infoStr; ""];
    
    if isAllNormalDistribution
        
        infoStr = [infoStr; "��� ������� ������������ ��������� (�� �������� ���������-��������)"];        
        
        [~,~,stats] = anova1(dataForAnova);
        stats.gnames = {datasets(:).name}';
        figure(handle);
        multcompare(stats, 'Alpha', significanceLevel, 'CType', cmprType);        
        
        infoStr = [infoStr; "����������� ��������: ������ ��������� (ANOVA)"];
        infoStr = [infoStr; cmprTypeStr];       
        infoStr = [infoStr; "������� � Matlab R2017a: anova1(y) � multcompare(stats)"];
        infoStr = [infoStr; "������� �� ������� � ����������� �������������: https://www.mathworks.com/help/stats/anova1.html"]; 
        infoStr = [infoStr; "������� �� ������ ���������: https://www.mathworks.com/help/stats/multcompare.html"];
        infoStr = [infoStr; ""];        
        infoStr = [infoStr; "SS - ����� ���������;"];
        infoStr = [infoStr; "df - ������� �������;"];
        infoStr = [infoStr; "MS - ������� �������� ���������;"];
        infoStr = [infoStr; "F - F-����������;"];
        infoStr = [infoStr; "Prob>F - p-�������� (��� F-�������������);"];
        infoStr = [infoStr; "Groups - ������������� ����� ��������;"];
        infoStr = [infoStr; "Error - ������������� ������ ������;"];
        infoStr = [infoStr; "Total - �������� �������������."];
        
    else
        infoStr = [infoStr; "�� ��� ������� ������������ ��������� (�� �������� ���������-��������)"];
                        
        [~,~,stats] = kruskalwallis(dataForAnova);
        stats.gnames = {datasets(:).name}';          
        figure(handle);      
        multcompare(stats, 'Alpha', significanceLevel, 'CType', cmprType);         
        
        infoStr = [infoStr; "����������� ��������: ������ ��������� ��������-������� (Kruskal-Wallis ANOVA)"];
        infoStr = [infoStr; cmprTypeStr];       
        infoStr = [infoStr; "������� � Matlab R2017a: kruskalwallis(y) � multcompare(stats)"];
        infoStr = [infoStr; "������� �� ������� � ����������� �������������: https://www.mathworks.com/help/stats/kruskalwallis.html"];
        infoStr = [infoStr; "������� �� ������ ���������: https://www.mathworks.com/help/stats/multcompare.html"];
        infoStr = [infoStr; ""];
        infoStr = [infoStr; "SS - ����� ���������;"];
        infoStr = [infoStr; "df - ������� �������;"];
        infoStr = [infoStr; "MS - ������� �������� ���������;"];
        infoStr = [infoStr; "Chi-sq - ��-�������-����������;"];
        infoStr = [infoStr; "Prob>Chi-sq - p-�������� (��� ��-�������-�������������);"];
        infoStr = [infoStr; "Groups - ������������� ����� ��������;"];
        infoStr = [infoStr; "Error - ������������� ������ ������;"];
        infoStr = [infoStr; "Total - �������� �������������."];
        
    end
    
else
    
    infoStr = [infoStr; ""];    
    
    if isAllNormalDistribution
        
        infoStr = [infoStr; "��� ������� ������������ ��������� (�� �������� ���������-��������)"];
        
        dataForRepeatedAnova = transformToRepeatedAnova(dataForAnova);
        [~,~,stats] = anova1(dataForRepeatedAnova);        
        stats.gnames = {datasets(:).name}';
        stats.df = (size(dataForRepeatedAnova,1) - 1)*(size(dataForRepeatedAnova,2) - 1);        
        figure(handle);
        multcompare(stats, 'Alpha', significanceLevel, 'CType', cmprType);        
        
        infoStr = [infoStr; "����������� ��������: ������ ��������� ��������� ��������� (Repeated measures ANOVA)"];
        infoStr = [infoStr; cmprTypeStr];       
        infoStr = [infoStr; "������� � Matlab R2017a: anova1(y) (����������������) � multcompare(stats)"];
        infoStr = [infoStr; "������� �� ������� � ����������� �������������: https://www.mathworks.com/help/stats/anova1.html"];  
%         infoStr = [infoStr; "������� �� ����������� ������� � ����������� �������������: "]; 
        infoStr = [infoStr; "������� �� ������ ���������: https://www.mathworks.com/help/stats/multcompare.html"];
        infoStr = [infoStr; ""];        
        infoStr = [infoStr; "SS - ����� ���������;"];
        infoStr = [infoStr; "df - ������� �������;"];
        infoStr = [infoStr; "MS - ������� �������� ���������;"];
        infoStr = [infoStr; "F - F-����������;"];
        infoStr = [infoStr; "Prob>F - p-�������� (��� F-�������������);"];
        infoStr = [infoStr; "Groups - ������������� ����� ��������;"];
        infoStr = [infoStr; "Error - ������������� ������ ������;"];
        infoStr = [infoStr; "Total - �������� �������������."];
        
    else
        infoStr = [infoStr; "�� ��� ������� ������������ ���������"]; 
                
        reps = 1;
        [~,~,stats] = friedman(dataForAnova, reps);
        stats.gnames = {datasets(:).name}';   
        figure(handle);                     
        multcompare(stats, 'Alpha', significanceLevel, 'CType', cmprType);              
        
        infoStr = [infoStr; "����������� ��������: ������ ��������� �������� (Friedman�s ANOVA)"];
        infoStr = [infoStr; cmprTypeStr];       
        infoStr = [infoStr; "������� � Matlab R2017a: friedman(y) � multcompare(stats)"];
        infoStr = [infoStr; "������� �� ������� � ����������� �������������: https://www.mathworks.com/help/stats/friedman.html"];
        infoStr = [infoStr; "������� �� ������ ���������: https://www.mathworks.com/help/stats/multcompare.html"];
        infoStr = [infoStr; ""];
        infoStr = [infoStr; "SS - ����� ���������;"];
        infoStr = [infoStr; "df - ������� �������;"];
        infoStr = [infoStr; "MS - ������� �������� ���������;"];
        infoStr = [infoStr; "Chi-sq - ��-�������-����������;"];
        infoStr = [infoStr; "Prob>Chi-sq - p-�������� (��� ��-�������-�������������);"];
        infoStr = [infoStr; "Columns - ������������� ����� ��������;"];
        infoStr = [infoStr; "Interaction - ������������� ��� ��������������;"];
        infoStr = [infoStr; "Error - ������������� ������ ������;"];
        infoStr = [infoStr; "Total - �������� �������������."];
        
    end   
end

handle.Visible = 'on';

end

