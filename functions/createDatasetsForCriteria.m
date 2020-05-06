function datasets = createDatasetsForCriteria( dataFrame, dataFrameNamesAndTypes, dataYNames )

datasets = struct('dataset',{},'type',{});

for x = 1:length(dataYNames)
    
    colNum = find(dataFrameNamesAndTypes(1,:) == dataYNames(x));
    data = retrieveData(dataFrame, dataFrameNamesAndTypes, dataYNames(x));
%     data = replaceNaN(data);
    
    if isempty(data)        
        datasets = [];
        return;
    end
    
    datasets(x).dataset = data;
    datasets(x).name = dataFrameNamesAndTypes(1,colNum);
    datasets(x).type = dataFrameNamesAndTypes(2,colNum);
    
end


end

