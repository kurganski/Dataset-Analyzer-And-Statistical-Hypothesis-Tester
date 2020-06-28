function infoStr = calulateCriteriaForMultipleSamplesNumericData( ...
               datasets, significanceLevel, isDatasetsIndependentStr, ...
               isDatasetsRangedStr, cmprTypeStr, groupData)

infoStr = "������ �������:";

for x = 1:size(datasets,2)
    infoStr = [infoStr;  " - " + datasets(x).name + " [ ��� ������: " + datasets(x).type + "]"];
end

if ~isempty(groupData)
    infoStr = [infoStr; "��� ��������� �� ������ �� �������: "];
    infoStr = [infoStr; " - " + groupData.name + " [ ��� ������: " + groupData.type + "]"];
end

cmprType = getDictValue(cmprTypeStr);
isDatasetsIndependent = getDictValue(isDatasetsIndependentStr);
isDatasetsRanged = getDictValue(isDatasetsRangedStr);

infoStr = [infoStr; ""];
infoStr = [infoStr; isDatasetsIndependentStr];
infoStr = [infoStr; "������� ����������: " + num2str(significanceLevel)];

% ����� �������������, ���� �� ����������� �������
isAllNormalDistribution = false;
if ~isDatasetsRanged
    for x = 1:size(datasets,2)
        % ���� adtest == 0, �� ����������
        isAllNormalDistribution = ~adtest(datasets(x).dataset, 'Alpha', significanceLevel);
        if ~isAllNormalDistribution
            break;
        end        
    end
    
    
end

isAllVarianceEqual = false;
if ~isDatasetsRanged
    for x = 1:size(datasets,2)
        % ���� adtest == 0, �� ����������
        isAllVarianceEqual = ~vartest2(datasets(x).dataset, 'Alpha', significanceLevel);
        if ~isAllNormalDistribution
            break;
        end        
    end 
end

dataForAnova = groupDataForAnova(datasets);
handle = figure('Position',[50 50 850 550], 'Visible','off');
setFigureInCenter(handle);

%%% TEST - remove later
% isAllNormalDistribution = true;
%%% TEST - remove later

if isDatasetsIndependent
      
    infoStr = [infoStr; "������� ����������"];
    infoStr = [infoStr; ""];   
                
    
    if isAllNormalDistribution && isAllVarianceEqual
        
        infoStr = [infoStr; "��� ������� ������������ ��������� � ��������� ��������� " ;...
                        "(�� �������� ���������-�������� � F-�������� ��������������)"];  
        infoStr = [infoStr; ""];
        
        if isempty(groupData)
            [~,~,stats] = anova1(replaceNanStrings(dataForAnova));
            stats.gnames = {datasets(:).name}';
        else
            dataForAnova(groupData.dataset == "") = [];
            groupData.dataset(groupData.dataset == "") = [];            
            [~,~,stats] = anova1(dataForAnova, groupData.dataset);            
        end
        
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
        infoStr = [infoStr; "�� ��� ������� ������������ ��������� ��� ��������� �� ����� " ;...
            "(�� �������� ���������-�������� � F-�������� ��������������)"];
        infoStr = [infoStr; ""];
        
        if isempty(groupData)
            [~,~,stats] = kruskalwallis(replaceNanStrings(dataForAnova));
            stats.gnames = {datasets(:).name}';
        else
            dataForAnova(groupData.dataset == "") = [];
            groupData.dataset(groupData.dataset == "") = [];     
            [~,~,stats] = kruskalwallis(dataForAnova, groupData.dataset);            
        end
                            
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
    
    infoStr = [infoStr; "������� ��������"];
    infoStr = [infoStr; ""];   
    
    if isAllNormalDistribution
        
        infoStr = [infoStr; "��� ������� ������������ ��������� (�� �������� ���������-��������)"];
        infoStr = [infoStr; ""];
                    
        [~,~,stats] = ranova1(replaceNanStrings(dataForAnova)); 
        
        stats.gnames = {datasets(:).name}';   
        figure(handle);                     
        multcompare(stats, 'Alpha', significanceLevel, 'CType', cmprType);                  
        
        infoStr = [infoStr; "����������� ��������: ������ ��������� ��������� ��������� (Repeated measures ANOVA)"];
        infoStr = [infoStr; cmprTypeStr];       
        infoStr = [infoStr; "�������� ������ ��. � ������-������������� ����������. �.�����. ��������, �. 1998 - 459 �."];
        infoStr = [infoStr; "������� �� ������� � ����������� �������������: https://www.mathworks.com/help/stats/ranova.html"]; 
        infoStr = [infoStr; ""];        
        infoStr = [infoStr; "SS - ����� ���������;"];
        infoStr = [infoStr; "df - ������� �������;"];
        infoStr = [infoStr; "MS - ������� �������� ���������;"];
        infoStr = [infoStr; "F - F-����������;"];
        infoStr = [infoStr; "Prob>F - p-�������� (��� F-�������������);"];
        infoStr = [infoStr; "Columns - ������������� ����� ��������;"];
        infoStr = [infoStr; "Error - ������������� ������ ������;"];
        infoStr = [infoStr; "Total - �������� �������������."];  
        
    else
        infoStr = [infoStr; "�� ��� ������� ������������ ���������"]; 
                
        [~,~,stats] = friedman(replaceNanStrings(dataForAnova));
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

