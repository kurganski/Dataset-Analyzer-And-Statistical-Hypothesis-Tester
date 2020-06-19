function infoStr = calulateCriteriaForOneSampleNumericData(...
                                datasets, significanceLevel, isDatasetsRanged, mu, tailStr )

infoStr = "������ �������:";
isNormalDistribution = ~adtest(datasets.dataset, 'Alpha', significanceLevel);        
infoStr = [infoStr; " - " + datasets.name + " [ ��� ������: " + datasets.type + "]"];

if isDatasetsRanged
    isNormalDistribution = 0;
end

infoStr = [infoStr; ""];
infoStr = [infoStr; "������� ����������: " + num2str(significanceLevel)];

tail = getDictValue(tailStr);

if isNormalDistribution
        
        infoStr = [infoStr; "������� ������������ ��������� (�� �������� ���������-��������)"];
        
        [h,p,ci,stats] = ttest(datasets.dataset, mu, 'Alpha', significanceLevel, 'Tail', tail);
                
        infoStr = [infoStr; ""];
        infoStr = [infoStr; "����������� ��������: �������������� �������� ��������� (one-sample t-Test)"];
        infoStr = [infoStr; "������� ��������: ������� ����� ���������� ������������� � ����������� ���������� � ���. ��������� " + num2str(mu) + ": " + getHypothesisResultStr(h)];
        infoStr = [infoStr; "��� �������������� ��������: " + tailStr];
        infoStr = [infoStr; "������� � Matlab R2017a: ttest(x, mu, alpha)"];
        infoStr = [infoStr; ""];
             
        infoStr = [infoStr; "p-��������: " + num2str(p)];
        infoStr = [infoStr; "�������� ��������: " + num2str(stats.tstat)];
        infoStr = [infoStr; "����� �������� �������: " + num2str(stats.df)];
        infoStr = [infoStr; "��������� ��� �������: " + num2str(stats.sd)];
        infoStr = [infoStr; "������������� ��������: " + num2str(ci(1)) + "..." + num2str(ci(2))];
        
    else
        infoStr = [infoStr; "������� ������������ �� ��������� (�� �������� ���������-��������)"];
        
        [p,h,stats] = signtest(datasets.dataset, mu, 'alpha', significanceLevel, 'tail', tail);
        
        infoStr = [infoStr; ""];
        infoStr = [infoStr; "����������� ��������: �������� ������ (sign test)"];
        infoStr = [infoStr; "������� ��������: ������� ����� ����������� ������������� � �������� " + num2str(mu) + ": " + getHypothesisResultStr(h)];
        infoStr = [infoStr; "��� �������������� ��������: " + tailStr];
        infoStr = [infoStr; "������� � Matlab R2017a: signtest(x, mu, alpha)"];
        infoStr = [infoStr; ""];
        
        infoStr = [infoStr; "p-��������: " + num2str(p)];
        infoStr = [infoStr; "�������� ��������: " + num2str(stats.sign)];
        infoStr = [infoStr; "�������� z-��������: " + num2str(stats.zval)];
        
end
end

