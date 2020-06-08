function infoStr = calulateCriteriaForTwoSamplesDichotomousData( ...
                            datasets, significanceLevel, isDatasetsIndependent, tailStr )

infoStr = "������ �������:";

for x = 1:size(datasets,2)
    infoStr = [infoStr; " - " + datasets(x).name + " [ ��� ������: " + datasets(x).type + "]"];
end


infoStr = [infoStr; ""];
infoStr = [infoStr; "������� ����������: " + num2str(significanceLevel)];
infoStr = [infoStr; "��� ��������: " + tailStr];
infoStr = [infoStr; ""];

tail = getDictValue(tailStr);


if isDatasetsIndependent
    
    if isDichotomousDatasetsLarge(datasets)    
        
        infoStr = [infoStr; "������� �������"];
        
        [h,p,ci,zval] = ztest2(datasets, significanceLevel, tailStr);
        
        infoStr = [infoStr; "����������� ��������: �������������� z-�������� � ��������� ������ (two-sample z-Test)"];
        infoStr = [infoStr; "������� ��������: ������� ����� ����������� ���������� ������������� � ����������� �� � ����������� ������������ �����������: " + getHypothesisResultStr(h)];
        infoStr = [infoStr; "�������� ������ ��. � ������-������������� ����������. �.�����. ��������, �. 1998 - 459 �."];
        infoStr = [infoStr; ""];
        
        infoStr = [infoStr; "p-��������: " + num2str(p)];
        infoStr = [infoStr; "�������� ��������: " + num2str(zval)];
        infoStr = [infoStr; "������������� ��������: " + num2str(ci(1)) + "..." + num2str(ci(2))];
        infoStr = [infoStr; "������� �������� ��� �������������� ��������� = (m1 + m2)/(n1 + n2),"];
        infoStr = [infoStr; "��� m1 � m2 - ���������� '1' � ��������, n1 � n2 - ������� �������"];
    
    else
        
        infoStr = [infoStr; "���� ��� ����� ������� ����"];
        
        [h,p,ci,stats] = fisherExactTest(datasets, significanceLevel, tailStr);
        
        infoStr = [infoStr; "����������� ��������: �������������� ������ �������� ������ (two-sample Fisher's exact Test)"];
        infoStr = [infoStr; "������� ��������: ������� ����� ����������� ���������� ������������� � ����������� �� � ����������� ������������ �����������: " + getHypothesisResultStr(h)];
        infoStr = [infoStr; "�������� ������ ��. � ������-������������� ����������. �.�����. ��������, �. 1998 - 459 �."];
        infoStr = [infoStr; ""];
        
        infoStr = [infoStr; "p-��������: " + num2str(p)];
        infoStr = [infoStr; "�������� ��������: " + num2str(stats.tstat)];
        infoStr = [infoStr; "����� �������� �������: " + num2str(stats.df)];
        infoStr = [infoStr; "��������� ��� �������� �������: " + num2str(stats.sd)];
        infoStr = [infoStr; "������������� ��������: " + num2str(ci(1)) + "..." + num2str(ci(2))];
    end  
    
else
        
    infoStr = [infoStr; "������� ��������"];
    infoStr = [infoStr; ""];
    
    [h,p,ci,stats] = macnimar2(datasets, 'Alpha', significanceLevel, 'Tail', tail);
    
    infoStr = [infoStr; "����������� ��������: �������������� �������� ��������� (two-sample t-Test)"];
    infoStr = [infoStr; "������� ��������: ������� ����� ����������� ���������� ������������� � ����������� �� � ����������� ������������ �����������: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; "������� � Matlab R2017a: ttest2(x, y, alpha)"];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "p-��������: " + num2str(p)];
    infoStr = [infoStr; "�������� ��������: " + num2str(stats.tstat)];
    infoStr = [infoStr; "����� �������� �������: " + num2str(stats.df)];
    infoStr = [infoStr; "��������� ��� �������� �������: " + num2str(stats.sd)];
    infoStr = [infoStr; "������������� ��������: " + num2str(ci(1)) + "..." + num2str(ci(2))];
    
end


end

