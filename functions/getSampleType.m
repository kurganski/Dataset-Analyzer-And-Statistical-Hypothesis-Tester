function sampleType = getSampleType( dataSample )

% пустые меняю на бесконечноть, чтобы отделить числовые потом
dataSample(dataSample=="") = "Inf";

dataSample = str2double(dataSample);

% если строчный тип, то появятся NaN, тогда просто вставляем исходный столбец
if any(isnan(dataSample))
    sampleType = "номинативный";
    return
end

% проверяем на логический массив
if all(ismember(unique(dataSample), [0,1,Inf]))
    sampleType = "дихотомический";
else
    sampleType = "непрерывный";
end

end

