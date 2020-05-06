function infoStr = calulateCriteriaForOneSampleCategoricalData( ...
                    datasets, significanceLevel, supposedProbability, tailStr )

infoStr = "������ �������:";              
infoStr = [infoStr; " - " + datasets.name + " [ ��� ������: " + datasets.type + "]"];  

infoStr = [infoStr; ""];
infoStr = [infoStr; "������� ����������: " + num2str(significanceLevel)];
infoStr = [infoStr; "��� ��������: " + tailStr];

tail = getDictValue(tailStr);

if datasets.type == "����������"
   isLogical = true; 
end

if isLogical
    
    [h,p,stats] = signtest(datasets.dataset, 'Alpha', significanceLevel, 'Tail', tail);
    
    infoStr = [infoStr; ""];
    infoStr = [infoStr; "����������� ��������: �������������� �������� ������ (one-sample signtest)"];
    infoStr = [infoStr; "������� ��������: ������� ����� ����������� ������������� �  ������� ��������: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; "������� � Matlab R2017a: signtest(x, alpha)"];
    infoStr = [infoStr; ""];    
    
    infoStr = [infoStr; "p-��������: " + num2str(p)];
    infoStr = [infoStr; "�������� ��������: " + num2str(stats.sign)];
    infoStr = [infoStr; "�������� z-��������: " + num2str(stats.zval)];
    infoStr = addPvalueReference(infoStr, p);
    
else
    
    [h,p,ci,stats] = vartest(datasets.dataset, 'Alpha', significanceLevel, 'Tail', tail);
    
end

end

