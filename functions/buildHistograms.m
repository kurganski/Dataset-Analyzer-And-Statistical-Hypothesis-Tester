function buildHistograms(data, axesHandle, graphProperty)

if nargin == 1
    axesHandle = gca;
end

if nargin == 2
    graphProperty = "����������";    
end

for x = 1:size(data,2)    
    
    noNaNdata = replaceNaN(data(:,x));
    
    if graphProperty == "����������"
        
        histogram(axesHandle,noNaNdata);
        
    elseif graphProperty == "�������������"
        
        histogram(axesHandle,noNaNdata,'Normalization','probability');
        
    else
        assert(0,'������������ �������� ��������������� �������� �������');
    end
    
end

end

