function result = isDichotomousIndependentDatasetsLarge( datasets )

result = 1;

for x = 1:size(datasets,2)
    data = rmmissing(datasets(x).dataset);
    if sum(data) < 5 || sum(~data) < 5
        result = 0;
        return        
    end
end

end

