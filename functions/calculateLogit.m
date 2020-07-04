function regTable = calculateLogit( predictors, response, predictorsNames )

[~,~,stats] = mnrfit(predictors, categorical(response));
[data, rowNames, colNames] = generateMnrfitInfoTable(stats);

newColNames = setNewNames(colNames, "y", replaceNaN(unique(response)));
newRowNames = setNewNames(rowNames, "x", predictorsNames);


regTable = struct();
regTable.Variables = data;
regTable.Properties.RowNames = newRowNames;
regTable.Properties.VariableNames = newColNames;

    
end

