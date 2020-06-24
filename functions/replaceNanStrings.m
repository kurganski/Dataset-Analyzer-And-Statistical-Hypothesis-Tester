function [replacedNanData, emptyFlag] = replaceNanStrings( data )

replacedNanData = data;
emptyFlag = false;

if isstruct(data)
    
    if isnumeric(data(1).dataset)
        
        unitedData = zeros(length(data(1).dataset), size(data,2));
        
        for x = 1:size(data,2)
            unitedData(:,x) = data(x).dataset;
        end
        
        unitedData( any(isnan(unitedData),2), :) = [];
        
        if isempty(unitedData)
            emptyFlag = true;
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
        
        unitedData( any(ismissing(unitedData),2) | any(unitedData == "",2), :) = [];
        
        if isempty(unitedData)
            emptyFlag = true;
            return
        end
        
        for x = 1:size(replacedNanData,2)            
            replacedNanData(x).dataset = string(unitedData(:,x));
        end
    end
    
elseif isnumeric(data)
    
    replacedNanData( any(isnan(replacedNanData),2), :) = [];
else
    
    replacedNanData( any(replacedNanData == "",2), :) = [];
end

end

