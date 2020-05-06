function dataNames = getDataNames(handles, menuShortNames)

dataNames = "";    
for x = 1:length(menuShortNames)
    handle = strcat("handles.", menuShortNames(x), "popupmenu");
    eval(strcat("dataNames(end+1)=getMenuString(",handle,");"));    
end

dataNames(dataNames == "") = [];
dataNames = unique(dataNames);