function result = isDichotomousDatasetsLarge( datasets )

result = 1;

for x = 1:size(datasets,2)
    data = datasets(x).dataset;
    if sum(data) < 5 || length(data) * sum( ~(data) / length(data)) < 5
        result = 0;
        return        
    end
end

end

