function changedColumn = applyNewValueToSample(handles, newColumn, filteredCol, sampleType, newValue)

changedColumn = [];
filterEquation = getMenuString(handles.EquationPopupMenu);

if sampleType == "числовой"
    
    filterValue = handles.ValueMenuEdit.String;
    
    if filterValue == ""
        return
    end    
    
    filterValue = strrep(filterValue,',','.');
    filterValue = str2double(filterValue);
    
    if isnan(filterValue)
        errordlg('Для данной выборки значение условия должно быть числовым','Ошибка данных','modal');
        return
    end
    
elseif sampleType == "логический"
    filterValue = str2double(getMenuString(handles.ValueMenuEdit));
    
elseif sampleType == "категориальный"
    filterValue = getMenuString(handles.ValueMenuEdit);
    
else
    assert(0,"Неопределенный тип данных")
end

changedColumn = newColumn;
changedColumn(eval("filteredCol" + filterEquation + "filterValue")) = newValue;


end

