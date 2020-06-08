function menuString = getMenuString(menuHandle) 

if isempty(menuHandle.String)
    menuString = [];
else
    menuString = string(menuHandle.String(menuHandle.Value));    
end

