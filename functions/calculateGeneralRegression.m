function [infoTable, testTable] = calculateGeneralRegression( predictors, response, modelspec, ...
                                                distribution, linkFunction, varNames, trialsNum )

if distribution == "binomial" 
    
    min_predictors = min(predictors);
    max_predictors = max(predictors);
    
    normalizedPredictors = (predictors - min_predictors) ./ max_predictors;
    
    mdl = fitglm(normalizedPredictors, response, modelspec, 'BinomialSize', trialsNum, ...
                    'Distribution', distribution, 'Link', linkFunction);
else
    mdl = fitglm(predictors, response, modelspec, 'Distribution', distribution, 'Link', linkFunction);    
end

try
    testTable = mdl.devianceTest;
catch    
    testTable = [];
end

infoTable = table2cell(mdl.Coefficients);
infoTable(:,end+1:end+2) = num2cell(coefCI(mdl));

if ~isequal(modelspec,'constant')
    infoTable(:,end+1:end+2) = num2cell(zeros(mdl.NumCoefficients,2));
    infoTable(2:2+length(min_predictors)-1, end-1:end) = num2cell([min_predictors; max_predictors]');
end

infoTable = cell2table(infoTable, 'VariableNames', [fieldnames(summary(mdl.Coefficients)); ...
                            'low_CI'; 'high_CI'; 'Min_norm_value'; 'Max_norm_value']', ...
                                    'RowNames', mdl.CoefficientNames);
                                

oldRowNames = string(infoTable.Properties.RowNames);
newRowNames = setNewNames(oldRowNames, "x", varNames);
infoTable.Properties.RowNames = cellstr(newRowNames);


end

