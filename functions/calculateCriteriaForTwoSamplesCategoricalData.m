function infoStr = calculateCriteriaForTwoSamplesCategoricalData( ...
                                datasets, significanceLevel, isDatasetsIndependent )

infoStr = "Анализ выборок:";
datasetsNames = strings(1,size(datasets,2));

for x = 1:size(datasets,2)
    infoStr = [infoStr; " - " + datasets(x).name + " [ тип данных: " + datasets(x).type + "]"];
    datasetsNames(x) = datasets(x).name;
end

infoStr = [infoStr; ""];
infoStr = [infoStr; "Уровень значимости: " + num2str(significanceLevel)];
infoStr = [infoStr; ""];

if isDatasetsIndependent   
    
    infoStr = [infoStr; "Выборки независимы"];
    infoStr = [infoStr; ""]; 
            
    [tbl,chi2,p,labels] = callCrosstab(datasets); 
    
    showCrossTab(tbl,chi2,p,labels, datasetsNames);
    
    if isnan(p)
        h = NaN;
    else
        h = cast(p <= significanceLevel, 'like', p);        
    end    
    
    infoStr = [infoStr; "Примененный критерий: критерий Хи-квадрат (Chi-square test)"];
    infoStr = [infoStr; "Нулевая гипотеза: выборки имеют одинаковые распределения: " + getHypothesisResultStr(h)];
    infoStr = [infoStr; ""];
    
    infoStr = [infoStr; "Хи-квадрат: " + num2str(chi2)];
    infoStr = [infoStr; "p-значение: " + num2str(p)];
    
else
    
    datasets = replaceNanStrings(datasets);
    infoStr = [infoStr; "Выборки зависимы"];
    infoStr = [infoStr; ""];
    
end



end

