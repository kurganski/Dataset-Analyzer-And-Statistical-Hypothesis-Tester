function cellData = prepareDataForTable( dataFrame )

cellData = cell(size(dataFrame));

for x = 1:size(dataFrame,2)
    
    currentCol = dataFrame{:,x};
    
    if isstring(currentCol)
        
        currentCol(ismissing(currentCol)) = '';
        
        currentCol = char(currentCol);
        currentCol = table(currentCol);
        cellData(:,x) = table2cell(currentCol);
        
    else
        cellData(:,x) = num2cell(currentCol);
    end      
    
end

end

