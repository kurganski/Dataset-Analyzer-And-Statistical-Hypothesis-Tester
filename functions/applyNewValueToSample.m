function changedColumn = applyNewValueToSample(handles, newColumn, filteredCol, sampleType, newValue)

changedColumn = [];
filterEquation = getMenuString(handles.EquationPopupMenu);

if sampleType == "непрерывный"
    
    filterValue = handles.ValueMenuEdit.String;
    
    if filterValue == ""
        return
    end    
    
    filterValue = strrep(filterValue,',','.');
    filterValue = str2double(filterValue);
    
    if isnan(filterValue)
        errordlg('ƒл€ данной выборки значение услови€ должно быть числовым','ќшибка данных','modal');
        return
    end
    
elseif sampleType == "дихотомический"
    filterValue = str2double(getMenuString(handles.ValueMenuEdit));
    
elseif sampleType == "номинативный"
    filterValue = getMenuString(handles.ValueMenuEdit);
    
else
    assert(0,"Ќеопределенный тип данных")
end

changedColumn = newColumn;
changedColumn(eval("filteredCol" + filterEquation + "filterValue")) = newValue;


end

