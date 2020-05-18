function lengthArray = getNoEmptyDataLengths( dataFrame )

if istable(dataFrame)

    lengthArray = zeros(size(dataFrame,2),1);
    
    for x = 1:size(dataFrame, 2)
        
        lengthArray(x) = length(replaceNaN(dataFrame{:,x}));
        
    end

elseif isstring
    
    

end

