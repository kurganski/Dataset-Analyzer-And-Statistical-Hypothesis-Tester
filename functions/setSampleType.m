function typedDataSample = setSampleType( dataSample, sampleType )

switch sampleType
    
    case "������������"
        
        typedDataSample = dataSample;
        
    case  {"��������������","�����������"}
        
        typedDataSample = str2double(dataSample);      
        
    otherwise
        assert(0, "����������� ��� ������� ������");
end

end

