function isOneColSelected = CheckColsNumberSelected( indices )

isOneColSelected = false;

if length(unique(indices(:,2))) == 1    
    isOneColSelected = true;
end

end

