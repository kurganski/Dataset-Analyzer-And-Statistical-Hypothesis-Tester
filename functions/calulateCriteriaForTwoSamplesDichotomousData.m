function infoStr = calulateCriteriaForTwoSamplesDichotomousData( ...
                            datasets, significanceLevel, isDatasetsIndependent, tailStr )

infoStr = "Анализ выборок:";

for x = 1:size(datasets,2)
    infoStr = [infoStr; " - " + datasets(x).name + " [ тип данных: " + datasets(x).type + "]"];
end


infoStr = [infoStr; ""];
infoStr = [infoStr; "Уровень значимости: " + num2str(significanceLevel)];
infoStr = [infoStr; "Тип гипотезы: " + tailStr];
infoStr = [infoStr; ""];

tail = getDictValue(tailStr);


if isDatasetsIndependent
    
    if isDichotomousDatasetsLarge(datasets)    
        
        infoStr = [infoStr; "Выборки большие"];
        
        [h,p,ci,zval] = ztest2(datasets, significanceLevel, tailStr);
        
        infoStr = [infoStr; "Примененный критерий: двухвыборочный z-критерий с поправкой Йейтса (two-sample z-Test)"];
        infoStr = [infoStr; "Нулевая гипотеза: выборки имеют независимые нормальные распределения с одинаковыми МО и одинаковыми неизвестными дисперсиями: " + getHypothesisResultStr(h)];
        infoStr = [infoStr; "Описание метода см. в Медико-биологическая статистика. С.Гланц. Практика, М. 1998 - 459 с."];
        infoStr = [infoStr; ""];
        
        infoStr = [infoStr; "p-значение: " + num2str(p)];
        infoStr = [infoStr; "Значение критерия: " + num2str(zval)];
        infoStr = [infoStr; "Доверительный интервал: " + num2str(ci(1)) + "..." + num2str(ci(2))];
        infoStr = [infoStr; "Среднее значение для доверительного интервала = (m1 + m2)/(n1 + n2),"];
        infoStr = [infoStr; "где m1 и m2 - количество '1' в выборках, n1 и n2 - размеры выборок"];
    
    else
        
        infoStr = [infoStr; "Одна или более выборок малы"];
        
        [h,p,ci,stats] = fisherExactTest(datasets, significanceLevel, tailStr);
        
        infoStr = [infoStr; "Примененный критерий: двухвыборочный точный критерий Фишера (two-sample Fisher's exact Test)"];
        infoStr = [infoStr; "Нулевая гипотеза: выборки имеют независимые нормальные распределения с одинаковыми МО и одинаковыми неизвестными дисперсиями: " + getHypothesisResultStr(h)];
        infoStr = [infoStr; "Описание метода см. в Медико-биологическая статистика. С.Гланц. Практика, М. 1998 - 459 с."];
        infoStr = [infoStr; ""];
        
        infoStr = [infoStr; "p-значение: " + num2str(p)];
        infoStr = [infoStr; "Значение критерия: " + num2str(stats.tstat)];
        infoStr = [infoStr; "Число степеней свободы: " + num2str(stats.df)];
        infoStr = [infoStr; "Расчетное ско разности выборок: " + num2str(stats.sd)];
        infoStr = [infoStr; "Доверительный интервал: " + num2str(ci(1)) + "..." + num2str(ci(2))];
    end  
    
else
        
    infoStr = [infoStr; "Выборки зависимы"];
    infoStr = [infoStr; ""];
    
    [h,p,ci,stats] = macnimar2(datasets, 'Alpha', significanceLevel, 'Tail', tail);
    
    infoStr = [infoStr; "Примененный критерий: двухвыборочный критерий Стьюдента (two-sample t-Test)"];
    infoStr = [infoStr; "Нулевая гипотеза: выборки имеют независимые нормальные распределения с одинаковыми МО и одинаковыми неизвестными дисперсиями: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; "Функция в Matlab R2017a: ttest2(x, y, alpha)"];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "p-значение: " + num2str(p)];
    infoStr = [infoStr; "Значение критерия: " + num2str(stats.tstat)];
    infoStr = [infoStr; "Число степеней свободы: " + num2str(stats.df)];
    infoStr = [infoStr; "Расчетное ско разности выборок: " + num2str(stats.sd)];
    infoStr = [infoStr; "Доверительный интервал: " + num2str(ci(1)) + "..." + num2str(ci(2))];
    
end


end

