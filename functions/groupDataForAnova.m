function dataForAnova = groupDataForAnova( datasets )

dataForAnova = zeros(length(datasets(1).dataset), size(datasets,2));

for x = 1:size(datasets,2)
   
    dataForAnova(:,x) = datasets(x).dataset;
    
end

end

