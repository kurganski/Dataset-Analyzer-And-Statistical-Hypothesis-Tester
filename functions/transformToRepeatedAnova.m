function dataForRepeatedAnova = transformToRepeatedAnova( dataForAnova )

dataForRepeatedAnova = dataForAnova;
dataForRepeatedAnova = replaceNanStrings(dataForRepeatedAnova);
dataForRepeatedAnova = dataForRepeatedAnova - mean(dataForRepeatedAnova);

end

