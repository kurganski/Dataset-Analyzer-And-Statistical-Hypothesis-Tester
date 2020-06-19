function infoStr = calulateCriteriaForTwoSamplesCategoricalData( ...
                                datasets, significanceLevel, isDatasetsIndependent )

infoStr = "������ �������:";

for x = 1:size(datasets,2)
    infoStr = [infoStr; " - " + datasets(x).name + " [ ��� ������: " + datasets(x).type + "]"];
end

infoStr = [infoStr; ""];
infoStr = [infoStr; "������� ����������: " + num2str(significanceLevel)];
infoStr = [infoStr; ""];

if isDatasetsIndependent   
    
    infoStr = [infoStr; "������� ����������"];
    infoStr = [infoStr; ""]; 
    
    [tbl,chi2,p,labels] = crosstab(datasets(1).dataset, datasets(2).dataset);
    
    showCrossTab(tbl, labels);
    
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
        
    infoStr = [infoStr; "������� ��������"];
    infoStr = [infoStr; ""];
    
end



end

