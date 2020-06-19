function [ksTestTail, ksTestTailStr] = getKsTestTail( tail )

switch tail
    
    case 'both'
        ksTestTail = 'unequal';
        ksTestTailStr = "Эмпирические функции распределеления различны.";
        
    case 'left'
        ksTestTail = 'smaller';
        ksTestTailStr = "Эмпирическая функция распределеления 1й выборки короче 2й";
        
    case 'right'
        ksTestTail = 'larger';
        ksTestTailStr = "Эмпирическая функция распределеления 1й выборки длиннее 2й";
        
    otherwise
end

end

