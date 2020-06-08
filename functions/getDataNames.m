function dataNames = getDataNames(handles, menuShortNames)

dataNames = strings(length(menuShortNames),1); 

for x = 1:length(menuShortNames)

    switch menuShortNames(x)
        case "Y1"
            handle = handles.Y1popupmenu;
        case "Y2"
            handle = handles.Y2popupmenu;
        case "Y3"
            handle = handles.Y3popupmenu;
        case "Y4"
            handle = handles.Y4popupmenu;
        case "Y5"
            handle = handles.Y5popupmenu;
        case "Y6"
            handle = handles.Y6popupmenu;
        case "X1"
            handle = handles.X1popupmenu;
        case "X2"
            handle = handles.X2popupmenu;
        case "X3"
            handle = handles.X3popupmenu;
        case "X4"
            handle = handles.X4popupmenu;
        case "X5"
            handle = handles.X5popupmenu;
        case "X6"
            handle = handles.X6popupmenu;
        
        otherwise
            assert(0, "Неизвестный выпадающий список");
    end
   
    if ~isempty(handle.String)
        dataNames(x) = getMenuString(handle);
    end
    
end

dataNames(dataNames == "") = [];
dataNames = unique(dataNames);