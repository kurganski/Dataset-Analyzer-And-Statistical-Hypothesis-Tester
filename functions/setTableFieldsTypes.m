function [outputTable, outputTableNames] = setTableFieldsTypes(inputTable)

outputTable = table();

outputTableNames = inputTable{1,:};
inputTable(1,:) = [];

for x = 1:size(inputTable,2)
   
    currentColumn = inputTable{:,x};
    currentColumnType = getSampleType(currentColumn);
    outputTableNames(2,x) = currentColumnType;
    currentColumn = setSampleType(currentColumn, currentColumnType); 
    
    outputTable = [outputTable table(currentColumn,'VariableNames',{['Var' num2str(x)]})];       
    
end

