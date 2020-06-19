function infoStr = calulateCriteriaForMultipleSamplesDichotomousData(...
                    datasets, significanceLevel, isDatasetsIndependent)
                

infoStr = "Анализ выборок:";                

for x = 1:size(datasets,2)
    infoStr = [infoStr; " - " + datasets(x).name + " [ тип данных: " + datasets(x).type + "]"];
end

infoStr = [infoStr; ""];
infoStr = [infoStr; "Уровень значимости: " + num2str(significanceLevel)];
infoStr = [infoStr; ""];

if isDatasetsIndependent   
    
    infoStr = [infoStr; "Выборки независимы"];
    infoStr = [infoStr; ""]; 
    
    switch size(datasets,2)
        
        case 3
            [tbl,chi2,p,labels] = crosstab(...
                                            datasets(1).dataset,...
                                            datasets(2).dataset, ...
                                            datasets(3).dataset);
        case 4
            [tbl,chi2,p,labels] = crosstab(...
                                            datasets(1).dataset,...
                                            datasets(2).dataset, ...
                                            datasets(3).dataset, ...
                                            datasets(4).dataset);
        case 5
            [tbl,chi2,p,labels] = crosstab(...
                                            datasets(1).dataset,...
                                            datasets(2).dataset, ...
                                            datasets(3).dataset,...
                                            datasets(4).dataset, ...
                                            datasets(5).dataset);
        case 6
            [tbl,chi2,p,labels] = crosstab(...
                                            datasets(1).dataset,...
                                            datasets(2).dataset, ...
                                            datasets(3).dataset,...
                                            datasets(4).dataset, ...
                                            datasets(5).dataset, ...
                                            datasets(6).dataset);
            
        otherwise
            assert(0, "Неверное количество выборок для критерия");
    end
    
    showCrossTab( tbl, labels );
    
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
        
    infoStr = [infoStr; "Выборки зависимы"];
    infoStr = [infoStr; ""];
    
end
                
                
                
end