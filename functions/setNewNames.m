function newRowNames = setNewNames( oldRowNames, rplSymbol, varNames )

newRowNames = oldRowNames;
for x = 1:size(varNames,1)
    newRowNames = strrep(newRowNames, rplSymbol + num2str(x), varNames(x));
end

end

