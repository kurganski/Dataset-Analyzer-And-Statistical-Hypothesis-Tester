function [outputTable, outputTableNames] = setTableFieldsTypes(inputTable)

outputTable = table();

outputTableNames = inputTable{1,:};
inputTable(1,:) = [];

for x = 1:size(inputTable,2)
   
    currentColumn = inputTable{:,x};
    
    % пустые меняю на бесконечноть, чтобы отделить числовые потом
    currentColumn(currentColumn=="") = "Inf";
    
    currentColumn = str2double(currentColumn);
    
    % если строчный тип, то появятся NaN, тогда просто вставляем исходный столбец
    if any(isnan(currentColumn))
        outputTable = [outputTable inputTable(:,x)];
        outputTableNames(2,x) = "категориальный";
        continue 
    end 
    
    % проверяем на логический массив
    if all(ismember(unique(currentColumn), [0,1,Inf]))
        outputTableNames(2,x) = "логический";
    else
        outputTableNames(2,x) = "числовой";        
    end   
    
    % возвращаем NaN
    currentColumn(currentColumn==Inf) = NaN;    
          
    outputTable = [outputTable table(currentColumn,'VariableNames',{['Var' num2str(x)]})];   
    
end

