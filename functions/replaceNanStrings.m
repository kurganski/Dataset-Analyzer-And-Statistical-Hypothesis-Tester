function [replacedNanData, emptyFlag] = replaceNanStrings( data )

emptyFlag = false;

if isstruct(data)
    
    replacedNanData = data;
    if isnumeric(data(1).dataset)
        
        unitedData = zeros(length(data(1).dataset), size(data,2));
        
        for x = 1:size(data,2)
            unitedData(:,x) = data(x).dataset;
        end
        
        unitedData = rmmissing(unitedData);
        
        if isempty(unitedData)
            emptyFlag = true;            
            replacedNanData = [];
            return
        end
        
        for x = 1:size(replacedNanData,2)
            replacedNanData(x).dataset = unitedData(:,x);
        end    
        
    else  
        
        unitedData = strings(length(data(1).dataset), size(data,2));
        
        for x = 1:size(data,2)
            unitedData(:,x) = string(data(x).dataset);
        end
        
        unitedData = rmmissing(unitedData);
        
        if isempty(unitedData)
            emptyFlag = true;        
            replacedNanData = [];
            return
        end
        
        for x = 1:size(replacedNanData,2)            
            replacedNanData(x).dataset = string(unitedData(:,x));
        end
    end
    
else
    
    replacedNanData = rmmissing(data);
end


if isempty(replacedNanData)
    emptyFlag = true;        
    replacedNanData = [];
end

end

