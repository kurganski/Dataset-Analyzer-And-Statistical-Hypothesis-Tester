function dataNames = checkNormality(data, dataNames)

for x = 1:size(data,2)    
        
    % добавим данных по статистике распределения
    h = adtest(data(:,x));
    
    if ~h
        [mu, sko] = normfit(data(:,x));
        dataNames(x) = dataNames(x) + sprintf(": нормальное распр-е (МО = %3.3g, СКО = %3.3g;  95%%)", mu, sko);
    else
        dataNames(x) = dataNames(x) + ": не нормальное распределение (95%)";
    end
    
end

end

