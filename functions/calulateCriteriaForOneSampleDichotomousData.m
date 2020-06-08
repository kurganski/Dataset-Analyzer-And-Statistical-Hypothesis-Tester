function infoStr = calulateCriteriaForOneSampleDichotomousData( ...
                    datasets, significanceLevel, supposedProbability, tailStr )

infoStr = "Анализ выборки:";              
infoStr = [infoStr; " - " + datasets.name + " [ тип данных: " + datasets.type + "]"];  

infoStr = [infoStr; ""];
infoStr = [infoStr; "Уровень значимости: " + num2str(significanceLevel)];
infoStr = [infoStr; "Тип гипотезы: " + tailStr];

if isDichotomousDatasetsLarge(datasets) 
    
    [h,p,ci,zval] = ztest1(datasets.dataset, significanceLevel, supposedProbability, tailStr);
    
    infoStr = [infoStr; "Примененный критерий: одновыборочный z-критерий с поправкой Йейтса (one-sample z-Test)"];
    infoStr = [infoStr; "Нулевая гипотеза: выборки имеют независимые нормальные распределения с одинаковыми МО и одинаковыми неизвестными дисперсиями: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; "Описание метода см. в Медико-биологическая статистика. С.Гланц. Практика, М. 1998 - 459 с."];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "p-значение: " + num2str(p)];
    infoStr = [infoStr; "Значение критерия: " + num2str(zval)];
    infoStr = [infoStr; "Доверительный интервал: " + num2str(ci(1)) + "..." + num2str(ci(2))];
    infoStr = [infoStr; "Среднее значение для доверительного интервала = (m1 + p2*n)/(2*n),"];
    infoStr = [infoStr; "где m1 - количество '1' в выборке, p2 - ожидаемая вероятность '1', n - размер выборки"];
    
else
    
    [h,p,ci,stats] = binom(datasets.dataset, significanceLevel, tail);
    
end

end

