function infoStr = calulateCriteriaForTwoSamplesDichotomousData( ...
                            datasets, significanceLevel, isDatasetsIndependent, tailStr )

infoStr = "Анализ выборок:";

for x = 1:size(datasets,2)
    infoStr = [infoStr; " - " + datasets(x).name + " [ тип данных: " + datasets(x).type + "]"];
end


infoStr = [infoStr; ""];
infoStr = [infoStr; "Уровень значимости: " + num2str(significanceLevel)];
infoStr = [infoStr; ""];

tail = getDictValue(tailStr);


if isDatasetsIndependent
    
    infoStr = [infoStr; "Выборки независимы"];
    infoStr = [infoStr; ""];
    
    if isDichotomousIndependentDatasetsLarge(datasets)    
        
        infoStr = [infoStr; "Выборки большие"];
        infoStr = [infoStr; ""];
        
        [h,p,ci,zval] = ztest2(datasets, significanceLevel, tail);
        
        infoStr = [infoStr; "Примененный критерий: двухвыборочный z-критерий с поправкой Йейтса (two-sample z-Test)"];
        infoStr = [infoStr; "Нулевая гипотеза: выборки не имеют неслучайных зависимостей: " + getHypothesisResultStr(h)];
        infoStr = [infoStr; "Тип альтернативной гипотезы: " + tailStr];
        infoStr = [infoStr; "Описание метода см. в Медико-биологическая статистика. С.Гланц. Практика, М. 1998 - 459 с."];
        infoStr = [infoStr; ""];
        
        infoStr = [infoStr; "p-значение: " + num2str(p)];
        infoStr = [infoStr; "Значение критерия: " + num2str(zval)];
        infoStr = [infoStr; "Доверительный интервал: " + num2str(ci(1)) + "..." + num2str(ci(2))];
        infoStr = [infoStr; "Среднее значение для доверительного интервала = (m1 + m2)/(n1 + n2),"];
        infoStr = [infoStr; "где m1 и m2 - количество '1' в выборках, n1 и n2 - размеры выборок"];
    
    else
        
        infoStr = [infoStr; "Одна или более выборок малы"];        
        
        [h,p,stats] = fishertest(crosstab(datasets(1).dataset,datasets(2).dataset), 'Alpha', significanceLevel, 'Tail',tail);
        
        infoStr = [infoStr; "Примененный критерий: двухвыборочный точный критерий Фишера (two-sample Fisher's exact Test)"];
        infoStr = [infoStr; "Нулевая гипотеза: выборки не имеют неслучайных зависимостей: " + getHypothesisResultStr(h)];
        infoStr = [infoStr; "Тип альтернативной гипотезы: " + tailStr];
        infoStr = [infoStr; "Описание метода: https://www.mathworks.com/help/stats/fishertest.html"];
        infoStr = [infoStr; ""];
        
        infoStr = [infoStr; "p-значение: " + num2str(p)];
        infoStr = [infoStr; "Величина связи выборок: " + num2str(stats.OddsRatio)];
        infoStr = [infoStr; "Асимптотические доверительный интервал для отношения шансов: " ...
            + num2str(stats.ConfidenceInterval(1)) + "..." + num2str(stats.ConfidenceInterval(2))];
    end  
    
else
    
    datasets = replaceNanStrings(datasets);
                
    infoStr = [infoStr; "Выборки зависимы"];
    infoStr = [infoStr; ""];
    
    [h,p,chi2] = mcnemar2(datasets, significanceLevel, 'Edwards');
    
    infoStr = [infoStr; "Примененный критерий: критерий МакНимара с поправкой Эдвардса (McNiemar’s test)"];
    infoStr = [infoStr; "Нулевая гипотеза: выборки не имеют неслучайных зависимостей: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "p-значение: " + num2str(p)];
    infoStr = [infoStr; "Хи-квадрат: " + num2str(chi2)];
    
    infoStr = [infoStr; ""];
    [h,p,chi2] = mcnemar2(datasets, significanceLevel, 'Yates');
    
    infoStr = [infoStr; "Примененный критерий: критерий МакНимара с поправкой Йейтса (McNiemar’s test)"];
    infoStr = [infoStr; "Нулевая гипотеза: выборки не имеют неслучайных зависимостей: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "p-значение: " + num2str(p)];
    infoStr = [infoStr; "Хи-квадрат: " + num2str(chi2)];
    infoStr = [infoStr; ""];
    infoStr = [infoStr;...
        "Если критерий не вышло рассчитать, то возможно необходимо применять точный критерий Макнемара, который пока не реализован" ];
    
end


end

