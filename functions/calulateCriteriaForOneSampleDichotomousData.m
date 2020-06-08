function infoStr = calulateCriteriaForOneSampleDichotomousData( ...
                    datasets, significanceLevel, supposedProbability, tailStr )

infoStr = "������ �������:";              
infoStr = [infoStr; " - " + datasets.name + " [ ��� ������: " + datasets.type + "]"];  

infoStr = [infoStr; ""];
infoStr = [infoStr; "������� ����������: " + num2str(significanceLevel)];
infoStr = [infoStr; "��� ��������: " + tailStr];

if isDichotomousDatasetsLarge(datasets) 
    
    [h,p,ci,zval] = ztest1(datasets.dataset, significanceLevel, supposedProbability, tailStr);
    
    infoStr = [infoStr; "����������� ��������: �������������� z-�������� � ��������� ������ (one-sample z-Test)"];
    infoStr = [infoStr; "������� ��������: ������� ����� ����������� ���������� ������������� � ����������� �� � ����������� ������������ �����������: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; "�������� ������ ��. � ������-������������� ����������. �.�����. ��������, �. 1998 - 459 �."];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "p-��������: " + num2str(p)];
    infoStr = [infoStr; "�������� ��������: " + num2str(zval)];
    infoStr = [infoStr; "������������� ��������: " + num2str(ci(1)) + "..." + num2str(ci(2))];
    infoStr = [infoStr; "������� �������� ��� �������������� ��������� = (m1 + p2*n)/(2*n),"];
    infoStr = [infoStr; "��� m1 - ���������� '1' � �������, p2 - ��������� ����������� '1', n - ������ �������"];
    
else
    
    [h,p,ci,stats] = binom(datasets.dataset, significanceLevel, tail);
    
end

end

