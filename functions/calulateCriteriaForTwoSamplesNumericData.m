function infoStr = calulateCriteriaForTwoSamplesNumericData( ...
              datasets, significanceLevel, isDatasetsRanged, isDatasetsIndependent, tailStr )

infoStr = "Анализ выборок:";
isAllNormalDistribution = false;

for x = 1:size(datasets,2)
    infoStr = [infoStr; " - " + datasets(x).name + " [ тип данных: " + datasets(x).type + "]"];
end


% узнаю распределения, если не ранжированы выборки
if isDatasetsRanged
    infoStr = [infoStr; "Выборки ранжированы"];
else
    infoStr = [infoStr; "Выборки не ранжированы"];
    
    for x = 1:size(datasets,2)   
        % если adtest == 0, то нормальное
        isAllNormalDistribution = ~adtest(datasets(x).dataset, 'Alpha', significanceLevel);
        if ~isAllNormalDistribution
            break;
        end
    end    
end


infoStr = [infoStr; ""];
infoStr = [infoStr; "Уровень значимости: " + num2str(significanceLevel)];
infoStr = [infoStr; "Тип гипотезы: " + tailStr];

tail = getDictValue(tailStr);

if isDatasetsIndependent
    
        infoStr = [infoStr; "Выборки независимы"];
        isVarianceEqual = ~vartest2(datasets(1).dataset, datasets(2).dataset, 'Alpha', significanceLevel, 'Tail', tail);
        
        if isAllNormalDistribution
            
            infoStr = [infoStr; "Все выборки распределены нормально (по критерию Андерсона-Дарлинга)"];
            
            if isVarianceEqual
                
                infoStr = [infoStr; "Дисперсии равны"];
                infoStr = [infoStr; ""];
                
                [h,p,ci,stats] = ttest2(datasets(1).dataset, datasets(2).dataset, 'Alpha', significanceLevel, 'Tail', tail);
                                
                infoStr = [infoStr; "Примененный критерий: двухвыборочный критерий Стьюдента (two-sample t-Test)"];
                infoStr = [infoStr; "Нулевая гипотеза: выборки имеют независимые нормальные распределения с одинаковыми МО и одинаковыми неизвестными дисперсиями: " + getHypothesisResultStr(h)];
                infoStr = [infoStr; "Функция в Matlab R2017a: ttest2(x, y, alpha)"];
                infoStr = [infoStr; ""];
                
                infoStr = [infoStr; "p-значение: " + num2str(p)];
                infoStr = [infoStr; "Значение критерия: " + num2str(stats.tstat)];
                infoStr = [infoStr; "Число степеней свободы: " + num2str(stats.df)];
                infoStr = [infoStr; "Расчетное ско разности выборок: " + num2str(stats.sd)];
                infoStr = [infoStr; "Доверительный интервал: " + num2str(ci(1)) + "..." + num2str(ci(2))];
                infoStr = addPvalueReference(infoStr, p);
                
            else
                infoStr = [infoStr; "Дисперсии не равны"];
                infoStr = [infoStr; ""];
                
                [h,p,ci,stats] = ttest2(datasets(1).dataset, datasets(2).dataset,...
                    'Alpha', significanceLevel, 'Vartype','unequal', 'Tail', tail);                
                
                infoStr = [infoStr; "Примененный критерий: двухвыборочный критерий Стьюдента (two-sample t-Test)"];
                infoStr = [infoStr; "Нулевая гипотеза: выборки имеют независимые нормальные распределения с одинаковыми МО и разными дисперсиями: " + getHypothesisResultStr(h)];
                infoStr = [infoStr; "Функция в Matlab R2017a: ttest2(x, y, alpha, 'Vartype','unequal')"];
                infoStr = [infoStr; ""];
                
                infoStr = [infoStr; "p-значение: " + num2str(p)];
                infoStr = [infoStr; "Значение критерия: " + num2str(stats.tstat)];
                infoStr = [infoStr; "Число степеней свободы: " + num2str(stats.df)];
                infoStr = [infoStr; "Расчетное ско разности выборок: " + num2str(stats.sd)];
                infoStr = [infoStr; "Доверительный интервал: " + num2str(ci(1)) + "..." + num2str(ci(2))];
                infoStr = addPvalueReference(infoStr, p);
                
            end
            
        else
            infoStr = [infoStr; "Не все выборки распределены нормально (по критерию Андерсона-Дарлинга)"];
            
            if isVarianceEqual
                
                infoStr = [infoStr; "Дисперсии равны"];
                infoStr = [infoStr; ""];
                [p,h,stats] = ranksum(datasets(1).dataset, datasets(2).dataset, 'alpha', significanceLevel, 'tail', tail);                        
                
                infoStr = [infoStr; "Примененный критерий: Критерий Манна-Уитни-Уилкоксона (Mann-Whitney-Wilcoxon rank test)"];
                infoStr = [infoStr; "Нулевая гипотеза: выборки имеют непрерывные распределениям с одинаковыми медианами: " + getHypothesisResultStr(h)];
                infoStr = [infoStr; "Функция в Matlab R2017a: ranksum(x, y, alpha)"];
                infoStr = [infoStr; ""];
                
                infoStr = [infoStr; "p-значение: " + num2str(p)];
                infoStr = [infoStr; "Значение критерия: " + num2str(stats.ranksum )];
                infoStr = [infoStr; "Значение z-критерия: " + num2str(stats.zval)];
                infoStr = addPvalueReference(infoStr, p);
                
            else
                infoStr = [infoStr; "Дисперсии не равны"];
                infoStr = [infoStr; ""];
                
                [h,p,k] = kstest2(datasets(1).dataset, datasets(2).dataset, 'Alpha', significanceLevel);               
                
                infoStr = [infoStr; "Примененный критерий: Критерий Колмогорова-Смирнова (Kolmogorov-Smirnov test)"];
                infoStr = [infoStr; "Нулевая гипотеза: выборки имеют непрерывное одинаковое распределение: " + getHypothesisResultStr(h)];
                infoStr = [infoStr; "Функция в Matlab R2017a: kstest2(x, y, alpha)"];
                infoStr = [infoStr; ""];
                
                infoStr = [infoStr; "p-значение: " + num2str(p)];
                infoStr = [infoStr; "Значение критерия: " + num2str(k)];
                infoStr = addPvalueReference(infoStr, p);                
%                 
            end            
        end              
    else         
        
        if isAllNormalDistribution
            
            infoStr = [infoStr; "Все выборки распределены нормально (по критерию Андерсона-Дарлинга)"];
            infoStr = [infoStr; ""];
            
            [h,p,ci,stats] = ttest(datasets(1).dataset, datasets(2).dataset, 'Alpha', significanceLevel, 'Tail', tail);
            
            infoStr = [infoStr; "Примененный критерий: Парный критерий Стьюдента (Paired t-Test)"];
            infoStr = [infoStr; "Нулевая гипотеза: выборка из разностей значений выборок имеет нормальное распределение с нулевым МО и неизвестной дисперсией: " + getHypothesisResultStr(h)];
            infoStr = [infoStr; "Функция в Matlab R2017a: ttest(x, y, alpha)"];
            infoStr = [infoStr; ""];
            
            infoStr = [infoStr; "p-значение: " + num2str(p)];
            infoStr = [infoStr; "Значение критерия: " + num2str(stats.tstat)];
            infoStr = [infoStr; "Число степеней свободы: " + num2str(stats.df)];
            infoStr = [infoStr; "Расчетное ско разности выборок: " + num2str(stats.sd)];
            infoStr = [infoStr; "Доверительный интервал: " + num2str(ci(1)) + "..." + num2str(ci(2))];
            infoStr = addPvalueReference(infoStr, p);
            
        else
            infoStr = [infoStr; "не все выборки распределены нормально (по критерию Андерсона-Дарлинга)"];
            infoStr = [infoStr; ""];
            
            [p,h,stats] = signrank(datasets(1).dataset, datasets(2).dataset, 'alpha', significanceLevel, 'tail', tail);
            
            infoStr = [infoStr; "Примененный критерий: Критерий Манна-Уитни-Уилкоксона (Mann-Whitney-Wilcoxon rank test)"];
            infoStr = [infoStr; "Нулевая гипотеза: выборка из разностей значений выборок имеет распределение с нулевой медианой: " + getHypothesisResultStr(h)];
            infoStr = [infoStr; "Функция в Matlab R2017a: signrank(x, y, alpha)"];
            infoStr = [infoStr; ""];
            
            infoStr = [infoStr; "p-значение: " + num2str(p)];
            infoStr = [infoStr; "Значение критерия: " + num2str(stats.signrank)];
            infoStr = [infoStr; "Значение z-критерия: " + num2str(stats.zval)];
            infoStr = addPvalueReference(infoStr, p);
            
        end
end

end

