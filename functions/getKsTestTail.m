function [ksTestTail, ksTestTailStr] = getKsTestTail( tail )

switch tail
    
    case 'both'
        ksTestTail = 'unequal';
        ksTestTailStr = "������������ ������� ��������������� ��������.";
        
    case 'left'
        ksTestTail = 'smaller';
        ksTestTailStr = "������������ ������� ��������������� 1� ������� ������ 2�";
        
    case 'right'
        ksTestTail = 'larger';
        ksTestTailStr = "������������ ������� ��������������� 1� ������� ������� 2�";
        
    otherwise
end

end

