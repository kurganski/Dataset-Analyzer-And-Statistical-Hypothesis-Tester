function categoricalPredictors = findCategorical( dataFrameNamesAndTypes, predictorsNames )

categoricalPredictors = zeros(size(predictorsNames));

for x = 1:size(predictorsNames,1)
    
    if dataFrameNamesAndTypes(2,dataFrameNamesAndTypes(1,:) == predictorsNames(x)) == "������������"
        categoricalPredictors(x) = x;
    end
    
end

categoricalPredictors(categoricalPredictors == 0) = [];

end

