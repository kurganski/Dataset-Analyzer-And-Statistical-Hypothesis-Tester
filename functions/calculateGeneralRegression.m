function [infoTable, testTable] = calculateGeneralRegression( predictors, response, modelspec, ...
                                                distribution, linkFunction, varNames, trialsNum )

if distribution == "binomial" 
    mdl = fitglm(predictors, response, modelspec, 'BinomialSize', trialsNum, ...
                    'Distribution', distribution, 'Link', linkFunction);
else
    mdl = fitglm(predictors, response, modelspec, 'Distribution', distribution, 'Link', linkFunction);    
end

try
    testTable = mdl.devianceTest;
catch    
    testTable = [];
end

infoTable = mdl.Coefficients;

oldRowNames = string(infoTable.Properties.RowNames);
newRowNames = setNewNames(oldRowNames, "x", varNames);
infoTable.Properties.RowNames = cellstr(newRowNames);


end

