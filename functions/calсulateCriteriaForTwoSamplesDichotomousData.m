function infoStr = calulateCriteriaForTwoSamplesDichotomousData( ...
                            datasets, significanceLevel, isDatasetsIndependent, tailStr )

infoStr = "������ �������:";

for x = 1:size(datasets,2)
    infoStr = [infoStr; " - " + datasets(x).name + " [ ��� ������: " + datasets(x).type + "]"];
end


infoStr = [infoStr; ""];
infoStr = [infoStr; "������� ����������: " + num2str(significanceLevel)];
infoStr = [infoStr; ""];

tail = getDictValue(tailStr);


if isDatasetsIndependent
    
    infoStr = [infoStr; "������� ����������"];
    infoStr = [infoStr; ""];
    
    if isDichotomousIndependentDatasetsLarge(datasets)    
        
        infoStr = [infoStr; "������� �������"];
        infoStr = [infoStr; ""];
        
        [h,p,ci,zval] = ztest2(datasets, significanceLevel, tail);
        
        infoStr = [infoStr; "����������� ��������: �������������� z-�������� � ��������� ������ (two-sample z-Test)"];
        infoStr = [infoStr; "������� ��������: ������� �� ����� ����������� ������������: " + getHypothesisResultStr(h)];
        infoStr = [infoStr; "��� �������������� ��������: " + tailStr];
        infoStr = [infoStr; "�������� ������ ��. � ������-������������� ����������. �.�����. ��������, �. 1998 - 459 �."];
        infoStr = [infoStr; ""];
        
        infoStr = [infoStr; "p-��������: " + num2str(p)];
        infoStr = [infoStr; "�������� ��������: " + num2str(zval)];
        infoStr = [infoStr; "������������� ��������: " + num2str(ci(1)) + "..." + num2str(ci(2))];
        infoStr = [infoStr; "������� �������� ��� �������������� ��������� = (m1 + m2)/(n1 + n2),"];
        infoStr = [infoStr; "��� m1 � m2 - ���������� '1' � ��������, n1 � n2 - ������� �������"];
    
    else
        
        infoStr = [infoStr; "���� ��� ����� ������� ����"];        
        
        [h,p,stats] = fishertest(crosstab(datasets(1).dataset,datasets(2).dataset), 'Alpha', significanceLevel, 'Tail',tail);
        
        infoStr = [infoStr; "����������� ��������: �������������� ������ �������� ������ (two-sample Fisher's exact Test)"];
        infoStr = [infoStr; "������� ��������: ������� �� ����� ����������� ������������: " + getHypothesisResultStr(h)];
        infoStr = [infoStr; "��� �������������� ��������: " + tailStr];
        infoStr = [infoStr; "�������� ������: https://www.mathworks.com/help/stats/fishertest.html"];
        infoStr = [infoStr; ""];
        
        infoStr = [infoStr; "p-��������: " + num2str(p)];
        infoStr = [infoStr; "�������� ����� �������: " + num2str(stats.OddsRatio)];
        infoStr = [infoStr; "��������������� ������������� �������� ��� ��������� ������: " ...
            + num2str(stats.ConfidenceInterval(1)) + "..." + num2str(stats.ConfidenceInterval(2))];
    end  
    
else
    
    datasets = replaceNanStrings(datasets);
                
    infoStr = [infoStr; "������� ��������"];
    infoStr = [infoStr; ""];
    
    [h,p,chi2] = mcnemar2(datasets, significanceLevel, 'Edwards');
    
    infoStr = [infoStr; "����������� ��������: �������� ��������� � ��������� �������� (McNiemar�s test)"];
    infoStr = [infoStr; "������� ��������: ������� �� ����� ����������� ������������: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "p-��������: " + num2str(p)];
    infoStr = [infoStr; "��-�������: " + num2str(chi2)];
    
    infoStr = [infoStr; ""];
    [h,p,chi2] = mcnemar2(datasets, significanceLevel, 'Yates');
    
    infoStr = [infoStr; "����������� ��������: �������� ��������� � ��������� ������ (McNiemar�s test)"];
    infoStr = [infoStr; "������� ��������: ������� �� ����� ����������� ������������: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "p-��������: " + num2str(p)];
    infoStr = [infoStr; "��-�������: " + num2str(chi2)];
    infoStr = [infoStr; ""];
    infoStr = [infoStr;...
        "���� �������� �� ����� ����������, �� �������� ���������� ��������� ������ �������� ���������, ������� ���� �� ����������" ];
    
end


end

