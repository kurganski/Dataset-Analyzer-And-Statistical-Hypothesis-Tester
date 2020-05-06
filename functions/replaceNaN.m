function modifiedData = replaceNaN(data)

if isnumeric(data)
    modifiedData = data(~isnan(data));
else
    modifiedData = data;
    modifiedData(modifiedData == "") = [];
end