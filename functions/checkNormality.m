function dataNames = checkNormality(data, dataNames)

for x = 1:size(data,2)    
        
    % ������� ������ �� ���������� �������������
    h = adtest(data(:,x));
    
    if ~h
        [mu, sko] = normfit(data(:,x));
        dataNames(x) = dataNames(x) + sprintf(": ���������� �����-� (�� = %3.3g, ��� = %3.3g;  95%%)", mu, sko);
    else
        dataNames(x) = dataNames(x) + ": �� ���������� ������������� (95%)";
    end
    
end

end

