function outputDatasets = insertMissing( inputDatasets )

outputDatasets = inputDatasets;

for x = 1:size(inputDatasets,2)
    outputDatasets(x).dataset( outputDatasets(x).dataset == "") = missing;
end

end

