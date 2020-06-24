function infoStr = calulateCriteriaForMultipleSamplesNumericData( ...
               datasets, significanceLevel, isDatasetsIndependentStr, ...
               isDatasetsRangedStr, cmprTypeStr, groupData)

infoStr = "Анализ выборок:";

for x = 1:size(datasets,2)
    infoStr = [infoStr;  " - " + datasets(x).name + " [ тип данных: " + datasets(x).type + "]"];
end

if ~isempty(groupData)
    infoStr = [infoStr; "при разбиении на группы по выборке: "];
    infoStr = [infoStr; " - " + groupData.name + " [ тип данных: " + groupData.type + "]"];
end

cmprType = getDictValue(cmprTypeStr);
isDatasetsIndependent = getDictValue(isDatasetsIndependentStr);
isDatasetsRanged = getDictValue(isDatasetsRangedStr);

infoStr = [infoStr; ""];
infoStr = [infoStr; isDatasetsIndependentStr];
infoStr = [infoStr; "Уровень значимости: " + num2str(significanceLevel)];

% узнаю распределения, если не ранжированы выборки
isAllNormalDistribution = false;
if ~isDatasetsRanged
    for x = 1:size(datasets,2)
        % если adtest == 0, то нормальное
        isAllNormalDistribution = ~adtest(datasets(x).dataset, 'Alpha', significanceLevel);
        if ~isAllNormalDistribution
            break;
        end        
    end
    
    
end

isAllVarianceEqual = false;
if ~isDatasetsRanged
    for x = 1:size(datasets,2)
        % если adtest == 0, то нормальное
        isAllVarianceEqual = ~vartest2(datasets(x).dataset, 'Alpha', significanceLevel);
        if ~isAllNormalDistribution
            break;
        end        
    end 
end

dataForAnova = groupDataForAnova(datasets);
handle = figure('Position',[50 50 850 550], 'Visible','off');
setFigureInCenter(handle);

%%% TEST - remove later
% isAllNormalDistribution = true;
%%% TEST - remove later

if isDatasetsIndependent
      
    infoStr = [infoStr; "Выборки независимы"];
    infoStr = [infoStr; ""];   
                
    
    if isAllNormalDistribution && isAllVarianceEqual
        
        infoStr = [infoStr; "Все выборки распределены нормально и дисперсии одинаковы " ;...
                        "(по критерию Андерсона-Дарлинга и F-критерию соответственно)"];  
        infoStr = [infoStr; ""];
        
        if isempty(groupData)
            [~,~,stats] = anova1(replaceNanStrings(dataForAnova));
            stats.gnames = {datasets(:).name}';
        else
            dataForAnova(groupData.dataset == "") = [];
            groupData.dataset(groupData.dataset == "") = [];            
            [~,~,stats] = anova1(dataForAnova, groupData.dataset);            
        end
        
        figure(handle);
        multcompare(stats, 'Alpha', significanceLevel, 'CType', cmprType);        
        
        infoStr = [infoStr; "Примененный критерий: Анализ дисперсий (ANOVA)"];
        infoStr = [infoStr; cmprTypeStr];       
        infoStr = [infoStr; "Функции в Matlab R2017a: anova1(y) и multcompare(stats)"];
        infoStr = [infoStr; "Справка по функции и расшифровка характеристик: https://www.mathworks.com/help/stats/anova1.html"]; 
        infoStr = [infoStr; "Справка по методу сравнения: https://www.mathworks.com/help/stats/multcompare.html"];
        infoStr = [infoStr; ""];        
        infoStr = [infoStr; "SS - сумма квадратов;"];
        infoStr = [infoStr; "df - степени свободы;"];
        infoStr = [infoStr; "MS - средние значения квадратов;"];
        infoStr = [infoStr; "F - F-статистика;"];
        infoStr = [infoStr; "Prob>F - p-значение (для F-распределения);"];
        infoStr = [infoStr; "Groups - вариативность между группами;"];
        infoStr = [infoStr; "Error - вариативность внутри группы;"];
        infoStr = [infoStr; "Total - итоговая вариативность."];
        
    else
        infoStr = [infoStr; "Не все выборки распределены нормально или дисперсии не равны " ;...
            "(по критерию Андерсона-Дарлинга и F-критерию соответственно)"];
        infoStr = [infoStr; ""];
        
        if isempty(groupData)
            [~,~,stats] = kruskalwallis(replaceNanStrings(dataForAnova));
            stats.gnames = {datasets(:).name}';
        else
            dataForAnova(groupData.dataset == "") = [];
            groupData.dataset(groupData.dataset == "") = [];     
            [~,~,stats] = kruskalwallis(dataForAnova, groupData.dataset);            
        end
                            
        figure(handle);      
        multcompare(stats, 'Alpha', significanceLevel, 'CType', cmprType);         
        
        infoStr = [infoStr; "Примененный критерий: Анализ дисперсий Крускала-Уоллиса (Kruskal-Wallis ANOVA)"];
        infoStr = [infoStr; cmprTypeStr];       
        infoStr = [infoStr; "Функция в Matlab R2017a: kruskalwallis(y) и multcompare(stats)"];
        infoStr = [infoStr; "Справка по функции и расшифровка характеристик: https://www.mathworks.com/help/stats/kruskalwallis.html"];
        infoStr = [infoStr; "Справка по методу сравнения: https://www.mathworks.com/help/stats/multcompare.html"];
        infoStr = [infoStr; ""];
        infoStr = [infoStr; "SS - сумма квадратов;"];
        infoStr = [infoStr; "df - степени свободы;"];
        infoStr = [infoStr; "MS - средние значения квадратов;"];
        infoStr = [infoStr; "Chi-sq - Хи-квадрат-статистика;"];
        infoStr = [infoStr; "Prob>Chi-sq - p-значение (для Хи-квадрат-распределения);"];
        infoStr = [infoStr; "Groups - вариативность между группами;"];
        infoStr = [infoStr; "Error - вариативность внутри группы;"];
        infoStr = [infoStr; "Total - итоговая вариативность."];
        
    end
    
else
    
    infoStr = [infoStr; "Выборки зависимы"];
    infoStr = [infoStr; ""];   
    
    if isAllNormalDistribution
        
        infoStr = [infoStr; "Все выборки распределены нормально (по критерию Андерсона-Дарлинга)"];
        infoStr = [infoStr; ""];
                    
        [~,~,stats] = ranova1(replaceNanStrings(dataForAnova)); 
        
        stats.gnames = {datasets(:).name}';   
        figure(handle);                     
        multcompare(stats, 'Alpha', significanceLevel, 'CType', cmprType);                  
        
        infoStr = [infoStr; "Примененный критерий: Анализ дисперсий повторных измерений (Repeated measures ANOVA)"];
        infoStr = [infoStr; cmprTypeStr];       
        infoStr = [infoStr; "Описание метода см. в Медико-биологическая статистика. С.Гланц. Практика, М. 1998 - 459 с."];
        infoStr = [infoStr; "Справка по функции и расшифровка характеристик: https://www.mathworks.com/help/stats/ranova.html"]; 
        infoStr = [infoStr; ""];        
        infoStr = [infoStr; "SS - сумма квадратов;"];
        infoStr = [infoStr; "df - степени свободы;"];
        infoStr = [infoStr; "MS - средние значения квадратов;"];
        infoStr = [infoStr; "F - F-статистика;"];
        infoStr = [infoStr; "Prob>F - p-значение (для F-распределения);"];
        infoStr = [infoStr; "Columns - вариативность между группами;"];
        infoStr = [infoStr; "Error - вариативность внутри группы;"];
        infoStr = [infoStr; "Total - итоговая вариативность."];  
        
    else
        infoStr = [infoStr; "Не все выборки распределены нормально"]; 
                
        [~,~,stats] = friedman(replaceNanStrings(dataForAnova));
        stats.gnames = {datasets(:).name}';   
        figure(handle);                     
        multcompare(stats, 'Alpha', significanceLevel, 'CType', cmprType);              
        
        infoStr = [infoStr; "Примененный критерий: Анализ дисперсий Фридмана (Friedman’s ANOVA)"];
        infoStr = [infoStr; cmprTypeStr];       
        infoStr = [infoStr; "Функция в Matlab R2017a: friedman(y) и multcompare(stats)"];
        infoStr = [infoStr; "Справка по функции и расшифровка характеристик: https://www.mathworks.com/help/stats/friedman.html"];
        infoStr = [infoStr; "Справка по методу сравнения: https://www.mathworks.com/help/stats/multcompare.html"];
        infoStr = [infoStr; ""];
        infoStr = [infoStr; "SS - сумма квадратов;"];
        infoStr = [infoStr; "df - степени свободы;"];
        infoStr = [infoStr; "MS - средние значения квадратов;"];
        infoStr = [infoStr; "Chi-sq - Хи-квадрат-статистика;"];
        infoStr = [infoStr; "Prob>Chi-sq - p-значение (для Хи-квадрат-распределения);"];
        infoStr = [infoStr; "Columns - вариативность между группами;"];
        infoStr = [infoStr; "Interaction - вариативность при взаимодействии;"];
        infoStr = [infoStr; "Error - вариативность внутри группы;"];
        infoStr = [infoStr; "Total - итоговая вариативность."];
        
    end   
end

handle.Visible = 'on';

end

