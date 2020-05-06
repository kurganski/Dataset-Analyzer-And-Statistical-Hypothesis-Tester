function infoStr = calulateCriteriaForLogicalData(datasets, valueLevel, isDatasetsSmall, isDatasetsIndependent, s, tailStr)

infoStr = "������ �������:";

for x = 1:size(datasets,2)       
    infoStr = [infoStr; " - " + datasets(x).name + " [ ��� ������: " + datasets(x).type + "]"];
end

infoStr = [infoStr; ""];
infoStr = [infoStr; "������� ����������: " + num2str(valueLevel)];

numOfDatasets = size(datasets,2);

switch tailStr
    case '������������ �������������� ��������'
        tail = 'both';
    case '������������� �������������� ��������'
        tail = 'left';
    case '�������������� �������������� ��������'
        tail = 'right';
    otherwise
        assert(0, '��� ������ ������ ������������');
end

if numOfDatasets == 1
    
    if isDatasetsSmall
        infoStr = [infoStr; "����� ������ �������"];
        
        data = logical(datasets(1).dataset);
        h = binomTest(data, s, valueLevel, tail);
        
        
    else
        infoStr = [infoStr; "������� ������ �������"];
        
    end
        
    
elseif numOfDatasets == 2
    
    if isDatasetsIndependent
        
        infoStr = [infoStr; "������� ��������"];
        
        if isDatasetsSmall
            infoStr = [infoStr; "����� ������ �������"];
            
        else
            infoStr = [infoStr; "������� ������ �������"];
            
        end
        
    elseif isDatasetsIndependent
        
        infoStr = [infoStr; "������� ����������"];
        
        if isDatasetsSmall
            infoStr = [infoStr; "����� ������ �������"];
            
        else
            infoStr = [infoStr; "������� ������ �������"];
            
        end
    end
else    
    assert(0,"������ 2� ��������� ���������");
end
