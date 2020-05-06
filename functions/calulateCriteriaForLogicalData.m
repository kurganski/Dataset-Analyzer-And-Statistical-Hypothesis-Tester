function infoStr = calulateCriteriaForLogicalData(datasets, valueLevel, isDatasetsSmall, isDatasetsIndependent, s, tailStr)

infoStr = "Анализ выборок:";

for x = 1:size(datasets,2)       
    infoStr = [infoStr; " - " + datasets(x).name + " [ тип данных: " + datasets(x).type + "]"];
end

infoStr = [infoStr; ""];
infoStr = [infoStr; "Уровень значимости: " + num2str(valueLevel)];

numOfDatasets = size(datasets,2);

switch tailStr
    case 'Двусторонняя альтернативная гипотеза'
        tail = 'both';
    case 'Левосторонняя альтернативная гипотеза'
        tail = 'left';
    case 'Правосторонняя альтернативная гипотеза'
        tail = 'right';
    otherwise
        assert(0, 'Нет такого метода альтернативы');
end

if numOfDatasets == 1
    
    if isDatasetsSmall
        infoStr = [infoStr; "Малый размер выборки"];
        
        data = logical(datasets(1).dataset);
        h = binomTest(data, s, valueLevel, tail);
        
        
    else
        infoStr = [infoStr; "Большой размер выборки"];
        
    end
        
    
elseif numOfDatasets == 2
    
    if isDatasetsIndependent
        
        infoStr = [infoStr; "Выборки зависимы"];
        
        if isDatasetsSmall
            infoStr = [infoStr; "Малый размер выборки"];
            
        else
            infoStr = [infoStr; "Большой размер выборки"];
            
        end
        
    elseif isDatasetsIndependent
        
        infoStr = [infoStr; "Выборки независимы"];
        
        if isDatasetsSmall
            infoStr = [infoStr; "Малый размер выборки"];
            
        else
            infoStr = [infoStr; "Большой размер выборки"];
            
        end
    end
else    
    assert(0,"больше 2х датасетов оказалось");
end
