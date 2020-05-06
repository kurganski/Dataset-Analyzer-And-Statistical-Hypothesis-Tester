function retrievedData = retrieveData(dataFrame, dataFrameNamesAndTypes, dataNames)

if length(dataNames) == 1
    
    retrievedData = dataFrame{:,find(dataFrameNamesAndTypes(1,:) == dataNames) };
else        
    retrievedData = zeros( size(dataFrame,1), length(dataNames) );
    
    for x = 1:length(dataNames)
        
        retrievedData(:,x) = dataFrame{:,find(dataFrameNamesAndTypes(1,:) == dataNames(x)) };
        
    end
end

end

