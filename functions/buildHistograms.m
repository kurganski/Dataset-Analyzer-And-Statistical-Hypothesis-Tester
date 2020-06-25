function buildHistograms(data, axesHandle, graphProperty, dataNames)

if nargin == 1
    axesHandle = gca;
end

if nargin == 2
    graphProperty = "����������";    
end

if graphProperty == "����������"    
    hist3(axesHandle, data, 'CdataMode','auto','FaceColor','interp');
    xlabel(dataNames(1,1));
    ylabel(dataNames(2,1));
    view([-45 30]);
    return;
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

