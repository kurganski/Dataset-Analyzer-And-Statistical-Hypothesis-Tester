function changedColumn = applyNewValueToSample(handles, newColumn, filteredCol, sampleType, newValue)

changedColumn = [];
filterEquation = getMenuString(handles.EquationPopupMenu);

if sampleType == "�����������"
    
    filterValue = handles.ValueMenuEdit.String;
    
    if filterValue == ""
        return
    end    
    
    filterValue = strrep(filterValue,',','.');
    filterValue = str2double(filterValue);
    
    if isnan(filterValue)
        errordlg('��� ������ ������� �������� ������� ������ ���� ��������','������ ������','modal');
        return
    end
    
elseif sampleType == "��������������"
    filterValue = str2double(getMenuString(handles.ValueMenuEdit));
    
elseif sampleType == "������������"
    filterValue = getMenuString(handles.ValueMenuEdit);
    
else
    assert(0,"�������������� ��� ������")
end

changedColumn = newColumn;
changedColumn(eval("filteredCol" + filterEquation + "filterValue")) = newValue;


end

