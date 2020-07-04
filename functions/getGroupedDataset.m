function [datasets, isFailed] = getGroupedDataset( dataset, groupData, groupName )

isFailed = false;

if size(dataset.dataset) ~= size(groupData)
    assert(0,'–азмеры группирующей и целевой выборки не совпадают');
end

groups = replaceNaN(unique(groupData));
datasets = dataset;

for x = 1:length(groups)
    
    if dataset.type == "дихотомический"
        
        group = dataset.dataset;
        group(groupData ~= groups(x)) = 0;
        
        if ~any(group)
            isFailed = true;
        end
        
    elseif dataset.type == "непрерывный"        
        
        group = dataset.dataset;
        group(groupData ~= groups(x)) = NaN;
    
    elseif dataset.type == "номинативный"        
        
        group = dataset.dataset;
        group(groupData ~= groups(x)) = "";
        
        if ~any(group == "")
            isFailed = true;
        end        
        
    else
        assert(0,"неизвестный тип данных")
    end
    
    datasets(x).dataset = group;    
    datasets(x).name = dataset.name + ": " + string(groupName) + " = " +string(groups(x)) + "";
    datasets(x).type = dataset.type;
end

end

