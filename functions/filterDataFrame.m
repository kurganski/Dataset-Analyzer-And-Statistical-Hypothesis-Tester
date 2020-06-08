function dataFrame = filterDataFrame(originDataFrame, dataFrameNamesAndTypes, handles)

dataFrame = originDataFrame;

for x = ['1', '2', '3', '4', '5']    
    
    filterName = getMenuString(eval("handles.FilterPopupMenu" + x));        
    filterEquation = getMenuString(eval("handles.EquationPopupMenu" + x));   
    
    if filterName == "" 
        continue
    end
    
    if dataFrameNamesAndTypes(2,(find(dataFrameNamesAndTypes(1,:) == filterName))) == "непрерывный"
        
        filterValue = eval("handles.FilterValuePopupMenu" + x + ".String");        
        
        if filterValue == ' '
            continue
        end
        
        filterValue = strrep(filterValue,',','.');
        filterValue = str2double(filterValue);
        
        if isnan(filterValue)
            errordlg('Значения для исключения строк должны быть числовыми','Ошибка данных','modal');
            continue
        end
        
    elseif dataFrameNamesAndTypes(2,(find(dataFrameNamesAndTypes(1,:) == filterName))) == "дихотомический"
        filterValue = str2double(getMenuString(eval("handles.FilterValuePopupMenu" + x)));
        
    elseif dataFrameNamesAndTypes(2,(find(dataFrameNamesAndTypes(1,:) == filterName))) == "номинативный"
        filterValue = getMenuString(eval("handles.FilterValuePopupMenu" + x));
        
    else
        assert(0,"Неопределенный тип данных")   
    end
    
    filteredCol = dataFrame{:,find(dataFrameNamesAndTypes(1,:) == filterName)};    
    
    dataFrame( eval("filteredCol" + filterEquation + "filterValue"), :) = [];  

end

if isempty(dataFrame)
    dataFrame = table(NaN);
end