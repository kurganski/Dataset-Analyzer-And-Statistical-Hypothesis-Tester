function infoTable = calculateLogit( predictors, response, interactionsMode, isBinaryResponse, varNames )


if isBinaryResponse
    
    if interactionsMode == "on"
        mdl = fitglm(predictors, response,'interactions', 'Distribution','binomial');
    else
        mdl = fitglm(predictors, response,'linear', 'Distribution','binomial');
    end
    
    mdl.CoefficientNames;
    infoTable = mdl.Coefficients;
    
    oldRowNames = string(infoTable.Properties.RowNames);
    newRowNames = setNewNames(oldRowNames, "x", varNames);
    infoTable.Properties.RowNames = cellstr(newRowNames);
    
else
    
    [~,~,stats] = mnrfit(predictors, categorical(response));    
    [data, rowNames, colNames] = generateMnrfitInfoTable(stats);
    
    newRowNames = setNewNames(rowNames, "y", unique(response,'stable'));
    
    infoTable = struct();
    infoTable.data = data;
    infoTable.rowNames = newRowNames;
    infoTable.colNames = colNames;
    
end
    
end

