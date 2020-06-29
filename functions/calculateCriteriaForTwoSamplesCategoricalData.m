function infoStr = calculateCriteriaForTwoSamplesCategoricalData( ...
                                datasets, significanceLevel, isDatasetsIndependent )

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
    
    showCrossTab(tbl,chi2,p,labels, datasetsNames);
    
    if isnan(p)
        h = NaN;
    else
        h = cast(p <= significanceLevel, 'like', p);        
    end    
    
    infoStr = [infoStr; "����������� ��������: �������� ��-������� (Chi-square test)"];
    infoStr = [infoStr; "������� ��������: ������� ����� ���������� �������������: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "��-�������: " + num2str(chi2)];
    infoStr = [infoStr; "p-��������: " + num2str(p)];
    
else
    
    datasets = replaceNanStrings(datasets);
    infoStr = [infoStr; "������� ��������"];
    infoStr = [infoStr; ""];
    
end



end

