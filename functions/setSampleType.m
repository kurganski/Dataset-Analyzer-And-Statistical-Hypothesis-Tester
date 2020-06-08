function typedDataSample = setSampleType( dataSample, sampleType )

switch sampleType
    
    case "номинативный"
        
        typedDataSample = dataSample;
        
    case  {"дихотомический","непрерывный"}
        
        typedDataSample = str2double(dataSample);      
        
    otherwise
        assert(0, "неизвестный тип выборки данных");
end

end

