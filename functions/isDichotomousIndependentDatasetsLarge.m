function result = isDichotomousIndependentDatasetsLarge( datasets )

result = 1;

datasets = replaceNanStrings(datasets);

for x = 1:size(datasets,2)
    data = datasets(x).dataset;
    if sum(data) < 5 || sum(~data) < 5
        result = 0;
        return        
    end
end

end

