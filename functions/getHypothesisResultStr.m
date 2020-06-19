function HypothesisResultStr = getHypothesisResultStr(h)

if isnan(h)
    HypothesisResultStr = "не удалось вычислить критерий";    
else
    if h
        HypothesisResultStr = "отклонена";
    else
        HypothesisResultStr = "подтверждена";
    end
end
