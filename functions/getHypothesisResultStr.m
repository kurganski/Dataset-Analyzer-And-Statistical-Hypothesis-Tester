function HypothesisResultStr = getHypothesisResultStr(h)

if isnan(h)
    HypothesisResultStr = "�� ������� ��������� ��������";    
else
    if h
        HypothesisResultStr = "���������";
    else
        HypothesisResultStr = "������������";
    end
end
