function typedDataSample = setSampleType( dataSample, sampleType )

switch sampleType
    
    case "категориальный"
        
        typedDataSample = dataSample;
        
    case {"логический", "числовой"}
        
        typedDataSample = str2double(dataSample);      
        
    otherwise
        assert(0, "неизвестный тип выборки данных");
end

end

