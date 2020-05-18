function infoStr = calulateCriteriaForTwoSamplesNumericData( ...
              datasets, significanceLevel, isDatasetsRanged, isDatasetsIndependent, tailStr )

infoStr = "������ �������:";
isAllNormalDistribution = false;

for x = 1:size(datasets,2)
    infoStr = [infoStr; " - " + datasets(x).name + " [ ��� ������: " + datasets(x).type + "]"];
end


% ����� �������������, ���� �� ����������� �������
if isDatasetsRanged
    infoStr = [infoStr; "������� �����������"];
else
    infoStr = [infoStr; "������� �� �����������"];
    
    for x = 1:size(datasets,2)   
        % ���� adtest == 0, �� ����������
        isAllNormalDistribution = ~adtest(datasets(x).dataset, 'Alpha', significanceLevel);
        if ~isAllNormalDistribution
            break;
        end
    end    
end


infoStr = [infoStr; ""];
infoStr = [infoStr; "������� ����������: " + num2str(significanceLevel)];
infoStr = [infoStr; "��� ��������: " + tailStr];

tail = getDictValue(tailStr);

if isDatasetsIndependent
    
        infoStr = [infoStr; "������� ����������"];
        isVarianceEqual = ~vartest2(datasets(1).dataset, datasets(2).dataset, 'Alpha', significanceLevel, 'Tail', tail);
        
        if isAllNormalDistribution
            
            infoStr = [infoStr; "��� ������� ������������ ��������� (�� �������� ���������-��������)"];
            
            if isVarianceEqual
                
                infoStr = [infoStr; "��������� �����"];
                infoStr = [infoStr; ""];
                
                [h,p,ci,stats] = ttest2(datasets(1).dataset, datasets(2).dataset, 'Alpha', significanceLevel, 'Tail', tail);
                                
                infoStr = [infoStr; "����������� ��������: �������������� �������� ��������� (two-sample t-Test)"];
                infoStr = [infoStr; "������� ��������: ������� ����� ����������� ���������� ������������� � ����������� �� � ����������� ������������ �����������: " + getHypothesisResultStr(h)];
                infoStr = [infoStr; "������� � Matlab R2017a: ttest2(x, y, alpha)"];
                infoStr = [infoStr; ""];
                
                infoStr = [infoStr; "p-��������: " + num2str(p)];
                infoStr = [infoStr; "�������� ��������: " + num2str(stats.tstat)];
                infoStr = [infoStr; "����� �������� �������: " + num2str(stats.df)];
                infoStr = [infoStr; "��������� ��� �������� �������: " + num2str(stats.sd)];
                infoStr = [infoStr; "������������� ��������: " + num2str(ci(1)) + "..." + num2str(ci(2))];
                infoStr = addPvalueReference(infoStr, p);
                
            else
                infoStr = [infoStr; "��������� �� �����"];
                infoStr = [infoStr; ""];
                
                [h,p,ci,stats] = ttest2(datasets(1).dataset, datasets(2).dataset,...
                    'Alpha', significanceLevel, 'Vartype','unequal', 'Tail', tail);                
                
                infoStr = [infoStr; "����������� ��������: �������������� �������� ��������� (two-sample t-Test)"];
                infoStr = [infoStr; "������� ��������: ������� ����� ����������� ���������� ������������� � ����������� �� � ������� �����������: " + getHypothesisResultStr(h)];
                infoStr = [infoStr; "������� � Matlab R2017a: ttest2(x, y, alpha, 'Vartype','unequal')"];
                infoStr = [infoStr; ""];
                
                infoStr = [infoStr; "p-��������: " + num2str(p)];
                infoStr = [infoStr; "�������� ��������: " + num2str(stats.tstat)];
                infoStr = [infoStr; "����� �������� �������: " + num2str(stats.df)];
                infoStr = [infoStr; "��������� ��� �������� �������: " + num2str(stats.sd)];
                infoStr = [infoStr; "������������� ��������: " + num2str(ci(1)) + "..." + num2str(ci(2))];
                infoStr = addPvalueReference(infoStr, p);
                
            end
            
        else
            infoStr = [infoStr; "�� ��� ������� ������������ ��������� (�� �������� ���������-��������)"];
            
            if isVarianceEqual
                
                infoStr = [infoStr; "��������� �����"];
                infoStr = [infoStr; ""];
                [p,h,stats] = ranksum(datasets(1).dataset, datasets(2).dataset, 'alpha', significanceLevel, 'tail', tail);                        
                
                infoStr = [infoStr; "����������� ��������: �������� �����-�����-���������� (Mann-Whitney-Wilcoxon rank test)"];
                infoStr = [infoStr; "������� ��������: ������� ����� ����������� �������������� � ����������� ���������: " + getHypothesisResultStr(h)];
                infoStr = [infoStr; "������� � Matlab R2017a: ranksum(x, y, alpha)"];
                infoStr = [infoStr; ""];
                
                infoStr = [infoStr; "p-��������: " + num2str(p)];
                infoStr = [infoStr; "�������� ��������: " + num2str(stats.ranksum )];
                infoStr = [infoStr; "�������� z-��������: " + num2str(stats.zval)];
                infoStr = addPvalueReference(infoStr, p);
                
            else
                infoStr = [infoStr; "��������� �� �����"];
                infoStr = [infoStr; ""];
                
                [h,p,k] = kstest2(datasets(1).dataset, datasets(2).dataset, 'Alpha', significanceLevel);               
                
                infoStr = [infoStr; "����������� ��������: �������� �����������-�������� (Kolmogorov-Smirnov test)"];
                infoStr = [infoStr; "������� ��������: ������� ����� ����������� ���������� �������������: " + getHypothesisResultStr(h)];
                infoStr = [infoStr; "������� � Matlab R2017a: kstest2(x, y, alpha)"];
                infoStr = [infoStr; ""];
                
                infoStr = [infoStr; "p-��������: " + num2str(p)];
                infoStr = [infoStr; "�������� ��������: " + num2str(k)];
                infoStr = addPvalueReference(infoStr, p);                
%                 
            end            
        end              
    else         
        
        if isAllNormalDistribution
            
            infoStr = [infoStr; "��� ������� ������������ ��������� (�� �������� ���������-��������)"];
            infoStr = [infoStr; ""];
            
            [h,p,ci,stats] = ttest(datasets(1).dataset, datasets(2).dataset, 'Alpha', significanceLevel, 'Tail', tail);
            
            infoStr = [infoStr; "����������� ��������: ������ �������� ��������� (Paired t-Test)"];
            infoStr = [infoStr; "������� ��������: ������� �� ��������� �������� ������� ����� ���������� ������������� � ������� �� � ����������� ����������: " + getHypothesisResultStr(h)];
            infoStr = [infoStr; "������� � Matlab R2017a: ttest(x, y, alpha)"];
            infoStr = [infoStr; ""];
            
            infoStr = [infoStr; "p-��������: " + num2str(p)];
            infoStr = [infoStr; "�������� ��������: " + num2str(stats.tstat)];
            infoStr = [infoStr; "����� �������� �������: " + num2str(stats.df)];
            infoStr = [infoStr; "��������� ��� �������� �������: " + num2str(stats.sd)];
            infoStr = [infoStr; "������������� ��������: " + num2str(ci(1)) + "..." + num2str(ci(2))];
            infoStr = addPvalueReference(infoStr, p);
            
        else
            infoStr = [infoStr; "�� ��� ������� ������������ ��������� (�� �������� ���������-��������)"];
            infoStr = [infoStr; ""];
            
            [p,h,stats] = signrank(datasets(1).dataset, datasets(2).dataset, 'alpha', significanceLevel, 'tail', tail);
            
            infoStr = [infoStr; "����������� ��������: �������� �����-�����-���������� (Mann-Whitney-Wilcoxon rank test)"];
            infoStr = [infoStr; "������� ��������: ������� �� ��������� �������� ������� ����� ������������� � ������� ��������: " + getHypothesisResultStr(h)];
            infoStr = [infoStr; "������� � Matlab R2017a: signrank(x, y, alpha)"];
            infoStr = [infoStr; ""];
            
            infoStr = [infoStr; "p-��������: " + num2str(p)];
            infoStr = [infoStr; "�������� ��������: " + num2str(stats.signrank)];
            infoStr = [infoStr; "�������� z-��������: " + num2str(stats.zval)];
            infoStr = addPvalueReference(infoStr, p);
            
        end
end

end

