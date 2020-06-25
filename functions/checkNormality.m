function dataNames = checkNormality(data, dataNames)

for x = 1:size(data,2)    
        
    % добавим данных по статистике распределения
    [h,p] = adtest(data(:,x));
    
    if ~h
        [mu, sko] = normfit(data(:,x));
        dataNames(x) = dataNames(x) + sprintf(": нормальное распр-е (p = %3.3g, МО = %3.3g, СКО = %3.3g;  95%%)", mu, sko, p);
    else
        dataNames(x) = dataNames(x) + ": не нормальное распределение (95%)";
    end
    
end

end

