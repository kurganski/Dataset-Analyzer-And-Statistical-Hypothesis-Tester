function graphsNames = getGraphsNames( graphs )

graphsFields = fieldnames(graphs);
graphsNames = strings(size(graphsFields));

for x = 1:size(graphsFields,1)
    graphsNames(x) = getfield(getfield(graphs, graphsFields{x}), 'name');
end

end

