function infoStr = calulateCriteriaForOneSampleDichotomousData( ...
                    datasets, significanceLevel, supposedProbability, tailStr )

infoStr = "Анализ выборки:";              
infoStr = [infoStr; " - " + datasets.name + " [ тип данных: " + datasets.type + "]"];  

infoStr = [infoStr; ""];
infoStr = [infoStr; "Уровень значимости: " + num2str(significanceLevel)];
infoStr = [infoStr; "Тип гипотезы: " + tailStr];

tail = getDictValue(tailStr);

if isDichotomousIndependentDatasetsLarge(datasets) 
    
    [h,p,ci,zval] = ztest1(datasets.dataset, significanceLevel, supposedProbability, tailStr);
    
    infoStr = [infoStr; "Примененный критерий: одновыборочный z-критерий с поправкой Йейтса (one-sample z-Test)"];
    infoStr = [infoStr; "Нулевая гипотеза: Частоты выборки соответствуют ожидаемым: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; "Описание метода см. в Медико-биологическая статистика. С.Гланц. Практика, М. 1998 - 459 с."];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "p-значение: " + num2str(p)];
    infoStr = [infoStr; "Значение критерия: " + num2str(zval)];
    infoStr = [infoStr; "Доверительный интервал: " + num2str(ci(1)) + "..." + num2str(ci(2))];
    infoStr = [infoStr; "Среднее значение для доверительного интервала = (m1 + p2*n)/(2*n),"];
    infoStr = [infoStr; "где m1 - количество '1' в выборке, p2 - ожидаемая вероятность '1', n - размер выборки"];
    
else
        
    [h,p] = binomTest(datasets.dataset, supposedProbability, significanceLevel, 'two, equal counts'); 
    
    infoStr = [infoStr; "Примененный критерий: биноинальный критерий (Binominal Test)"];
    infoStr = [infoStr; "Нулевая гипотеза: Частоты выборки соответствуют ожидаемым: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; "Тип альтернативной гипотезы: Двухсторонняя альтернативная гипотеза (two, equal counts)"];
    infoStr = [infoStr; "Описание метода: mathworks.com/matlabcentral/fileexchange/24813-mybinomtest-s-n-p-sided"];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "p-значение: " + num2str(p)];
end

end

