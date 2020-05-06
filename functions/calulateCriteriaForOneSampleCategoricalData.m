function infoStr = calulateCriteriaForOneSampleCategoricalData( ...
                    datasets, significanceLevel, supposedProbability, tailStr )

infoStr = "Анализ выборок:";              
infoStr = [infoStr; " - " + datasets.name + " [ тип данных: " + datasets.type + "]"];  

infoStr = [infoStr; ""];
infoStr = [infoStr; "Уровень значимости: " + num2str(significanceLevel)];
infoStr = [infoStr; "Тип гипотезы: " + tailStr];

tail = getDictValue(tailStr);

if datasets.type == "логический"
   isLogical = true; 
end

if isLogical
    
    [h,p,stats] = signtest(datasets.dataset, 'Alpha', significanceLevel, 'Tail', tail);
    
    infoStr = [infoStr; ""];
    infoStr = [infoStr; "Примененный критерий: одновыборочный критерий знаков (one-sample signtest)"];
    infoStr = [infoStr; "Нулевая гипотеза: выборка имеет непрерывное распределение с  нулевой медианой: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; "Функция в Matlab R2017a: signtest(x, alpha)"];
    infoStr = [infoStr; ""];    
    
    infoStr = [infoStr; "p-значение: " + num2str(p)];
    infoStr = [infoStr; "Значение критерия: " + num2str(stats.sign)];
    infoStr = [infoStr; "Значение z-критерия: " + num2str(stats.zval)];
    infoStr = addPvalueReference(infoStr, p);
    
else
    
    [h,p,ci,stats] = vartest(datasets.dataset, 'Alpha', significanceLevel, 'Tail', tail);
    
end

end

