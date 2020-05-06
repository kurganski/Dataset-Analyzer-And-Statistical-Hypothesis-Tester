function significanceLevel = getNumberFromEdit(handle)

significanceLevel = handle.String;
significanceLevel = strrep(significanceLevel,',','.');
significanceLevel = str2double(significanceLevel);

end

