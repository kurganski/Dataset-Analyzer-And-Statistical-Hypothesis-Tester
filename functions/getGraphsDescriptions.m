function graphsDescriptions = getGraphsDescriptions( graphs )


graphsFields = fieldnames(graphs);
graphsDescriptions = cell(size(graphsFields));

for x = 1:size(graphsFields,1)
    graphsDescriptions(x) = {getfield(getfield(graphs, graphsFields{x}), 'description')};
end

end

