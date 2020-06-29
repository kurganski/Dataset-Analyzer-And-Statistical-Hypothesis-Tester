function infoStr = calculateCriteriaForMultipleSamplesDichotomousData(...
                    datasets, significanceLevel, isDatasetsIndependent)
                

infoStr = "������ �������:";      
datasetsNames = strings(1,size(datasets,2));

for x = 1:size(datasets,2)
    infoStr = [infoStr; " - " + datasets(x).name + " [ ��� ������: " + datasets(x).type + "]"];
    datasetsNames(x) = datasets(x).name;
end

infoStr = [infoStr; ""];
infoStr = [infoStr; "������� ����������: " + num2str(significanceLevel)];
infoStr = [infoStr; ""];

if isDatasetsIndependent   
    
    infoStr = [infoStr; "������� ����������"];
    infoStr = [infoStr; ""]; 
    
    [tbl,chi2,p,labels] = callCrosstab(datasets); 
    
    showCrossTab( tbl,chi2,p,labels, datasetsNames);
    
    if isnan(p)
        h = NaN;
    else
        h = cast(p <= significanceLevel, 'like', p);        
    end    
    
    infoStr = [infoStr; "����������� ��������: �������� ��-������� (Chi-square test)"];
    infoStr = [infoStr; "������� ��������: ������� ����� ���������� �������������: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; "������� �� ������� � ����������� �������������: https://www.mathworks.com/help/stats/crosstab.html"];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "��-�������: " + num2str(chi2)];
    infoStr = [infoStr; "p-��������: " + num2str(p)];    
    
else
        
    infoStr = [infoStr; "������� ��������"];
    infoStr = [infoStr; ""];
    
    datasets = replaceNanStrings(datasets);
    data = groupDataForAnova(datasets);
    
    if isempty(data)
        h = NaN;
        p = NaN;
        stats.Q = NaN;
        stats.df = NaN;
    else
        [h,p,stats] = cochraneQtest( data, significanceLevel );        
    end   
    
    infoStr = [infoStr; "����������� ��������: �������� ��-������� (Chi-square test)"];
    infoStr = [infoStr; "������� ��������: ������� ����� ���������� �������������: " + getHypothesisResultStr(h)];    
    infoStr = [infoStr; "������� �� ������� � ����������� �������������: https://www.mathworks.com/matlabcentral/fileexchange/16753-cochran-q-test"];
   
    infoStr = [infoStr; ""];
    infoStr = [infoStr; "p-��������: " + num2str(p)];
    infoStr = [infoStr; "�������� Q-��������: " + num2str(stats.Q)];
    infoStr = [infoStr; "����� �������� �������: " + num2str(stats.df)];
    infoStr = [infoStr; ""];
    infoStr = [infoStr; "�������� ��� ����� ������� ���� �� ����������"];
    
end
                
                
                
end