function infoStr = calulateCriteriaForOneSampleNumericData(...
                                datasets, significanceLevel, isDatasetsRanged, mu, tailStr )

infoStr = "Анализ выборок:";
isNormalDistribution = ~adtest(datasets.dataset, 'Alpha', significanceLevel);        
infoStr = [infoStr; " - " + datasets.name + " [ тип данных: " + datasets.type + "]"];

if isDatasetsRanged
    isNormalDistribution = 0;
end

infoStr = [infoStr; ""];
infoStr = [infoStr; "Уровень значимости: " + num2str(significanceLevel)];
infoStr = [infoStr; "Тип гипотезы: " + tailStr];

tail = getDictValue(tailStr);

if isNormalDistribution
        
        infoStr = [infoStr; "Выборка распределена нормально (по критерию Андерсона-Дарлинга)"];
        
        [h,p,ci,stats] = ttest(datasets.dataset, mu, 'Alpha', significanceLevel, 'Tail', tail);
                
        infoStr = [infoStr; ""];
        infoStr = [infoStr; "Примененный критерий: одновыборочный критерий Стьюдента (one-sample t-Test)"];
        infoStr = [infoStr; "Нулевая гипотеза: выборка имеет нормальное распределение с неизвестной дисперсией и мат. ожиданием " + num2str(mu) + ": " + getHypothesisResultStr(h)];
        infoStr = [infoStr; "Функция в Matlab R2017a: ttest(x, mu, alpha)"];
        infoStr = [infoStr; ""];
             
        infoStr = [infoStr; "p-значение: " + num2str(p)];
        infoStr = [infoStr; "Значение критерия: " + num2str(stats.tstat)];
        infoStr = [infoStr; "Число степеней свободы: " + num2str(stats.df)];
        infoStr = [infoStr; "Расчетное ско выборки: " + num2str(stats.sd)];
        infoStr = [infoStr; "Доверительный интервал: " + num2str(ci(1)) + "..." + num2str(ci(2))];
        infoStr = addPvalueReference(infoStr, p); 
        
    else
        infoStr = [infoStr; "Выборка распределена не нормально (по критерию Андерсона-Дарлинга)"];
        
        [p,h,stats] = signtest(datasets.dataset, mu, 'alpha', significanceLevel, 'tail', tail);
        
        infoStr = [infoStr; ""];
        infoStr = [infoStr; "Примененный критерий: критерий знаков (sign test)"];
        infoStr = [infoStr; "Нулевая гипотеза: выборка имеет непрерывное распределение с медианой " + num2str(mu) + ": " + getHypothesisResultStr(h)];
        infoStr = [infoStr; "Функция в Matlab R2017a: signtest(x, mu, alpha)"];
        infoStr = [infoStr; ""];
        
        infoStr = [infoStr; "p-значение: " + num2str(p)];
        infoStr = [infoStr; "Значение критерия: " + num2str(stats.sign)];
        infoStr = [infoStr; "Значение z-критерия: " + num2str(stats.zval)];
        infoStr = addPvalueReference(infoStr, p);         
        
end
end

