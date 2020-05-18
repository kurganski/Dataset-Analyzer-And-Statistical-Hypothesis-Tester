function number = getNumberFromEdit(handle)

number = handle.String;
number = strrep(number,',','.');
number = str2double(number);

end

