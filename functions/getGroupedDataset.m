function [datasets, isNanColExists, isZeroColExists] = getGroupedDataset( dataset, groupData, groupName )

isNanColExists = false;
isZeroColExists = false;

if size(dataset.dataset) ~= size(groupData)
    assert(0,'������� ������������ � ������� ������� �� ���������');
end

groups = replaceNaN(unique(groupData));
datasets = dataset;

for x = 1:length(groups)
    
    group = dataset.dataset;
    
    if dataset.type == "��������������"
        
        group(groupData ~= groups(x)) = 0;
        
        if all(group == 0) && x < 3 
           isZeroColExists = true; 
        end
                
    elseif dataset.type == "�����������"        
        
        group(groupData ~= groups(x)) = NaN;
        
        if all(isnan(group))
           isNanColExists = true; 
        end
    
    elseif dataset.type == "������������"        
        
        group(groupData ~= groups(x)) = ""; 
        
        if all(group == "")
           isNanColExists = true; 
        end
        
    else
        assert(0,"����������� ��� ������")
    end
    
    datasets(x).dataset = group;    
    datasets(x).name = dataset.name + ": " + string(groupName) + " = " +string(groups(x)) + "";
    datasets(x).type = dataset.type;
end


end

