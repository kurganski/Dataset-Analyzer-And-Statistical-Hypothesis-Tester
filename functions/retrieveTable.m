function retrievedData = retrieveTable( dataFrame, dataFrameNamesAndTypes, dataNames )

retrievedData = table();

for x = 1:length(dataNames)    
    
    currentColumn = dataFrame{:,find(dataFrameNamesAndTypes(1,:) == dataNames(x)) };    
    retrievedData = [retrievedData table(currentColumn, 'VariableNames',{['Var' num2str(x)]})];    

end

end

