function sampleType = getSampleType( dataSample )

% ������ ����� �� ������������, ����� �������� �������� �����
dataSample(dataSample=="") = "Inf";

dataSample = str2double(dataSample);

% ���� �������� ���, �� �������� NaN, ����� ������ ��������� �������� �������
if any(isnan(dataSample))
    sampleType = "��������������";
    return
end

% ��������� �� ���������� ������
if all(ismember(unique(dataSample), [0,1,Inf]))
    sampleType = "����������";
else
    sampleType = "��������";
end

end

