function value = getDictValue(key)

switch key
    
    case "Среднее"
        value = 'mean';
        
    case "Медиана"        
        value = 'median';
        
    case "Сумма"
        value = 'sum';
        
    case "Пирсона"
        value = 'Pearson';
        
    case "Кендалла"
        value = 'Kendall';
        
    case "Спирмена"
        value = 'Spearman';
        
    case 'Двусторонняя альтернативная гипотеза'
        value = 'both';
        
    case 'Левосторонняя альтернативная гипотеза'
        value = 'left';
        
    case 'Правосторонняя альтернативная гипотеза'
        value = 'right';        
        
    case "Выборка ранжирована"
         value = 1;
         
    case "Выборка не ранжирована"
         value = 0;
         
    case "Выборки ранжированы"
         value = 1;
         
    case "Выборки не ранжированы"
         value = 0;
         
    case "Выборка большая"
         value = 1;
         
    case "Выборка малая"
         value = 0;
         
    case "Выборки независимы"
         value = 1;
         
    case "Выборки зависимы"
         value = 0;
         
    case "Сравнение: Тьюки-Крамера"
         value = 'tukey-kramer';
         
    case "Сравнение: Бонферрони"
         value = 'bonferroni';
         
    case "Сравнение: Данна-Сидака"
         value = 'dunn-sidak';
         
    case "Сравнение: Фишера (LSD)"
         value = 'lsd';
         
    case "Сравнение: Шеффи"
         value = 'scheffe';
         
    case "Тип суммы квадратов: I"
        value = 1;
         
    case "Тип суммы квадратов: II"
        value = 2;
         
    case "Тип суммы квадратов: III"
        value = 3;
         
    case "Тип суммы квадратов: h"
        value = 'h';
        
    case "Использовать взаимодействия"
        value = 'on';
        
    case "Не использовать взаимодействия"
        value = 'off';
    
    case "Только Intercept"
        value = 'constant';
    
    case "Intercept и линейные составляющие"
        value = 'linear';
    
    case "Intercept, линейные составляющие и взаимодействия"
        value = 'interactions';
    
    case "Intercept, линейные и квадратичные составляющие"
        value = 'purequadratic';
    
    case "Intercept, линейные и квадратичные составляющие и взаимодействия"
        value = 'quadratic';
    
    case "Нормальное распределение зависимой выборки"
        value = 'normal';
    
    case "Биномиальное распределение зависимой выборки"
        value = 'binomial';
    
    case "Пуассоновское распределение зависимой выборки"
        value = 'poisson';
    
    case "Гамма-распределение зависимой выборки"
        value = 'gamma';
    
    case "Обратное Гауссовское распределение зависимой выборки"
        value = 'inverse gaussian';
    
    case "Связующая функция: единичная"
        value = 'identity';
    
    case "Связующая функция: логарифмическая"
        value = 'log';
    
    case "Связующая функция: логит"
        value = 'logit';
    
    case "Связующая функция: пробит"
        value = 'probit';
    
    case "Связующая функция: общая дважды логарифмируемая"
        value = 'comploglog';
    
    case "Связующая функция: обратная"
        value = 'reciprocal';
    
    case "Связующая функция: квадратичная"
        value = 2;
    
    case "Связующая функция: кубическая"
        value = 3;
        
        
    otherwise
        assert(0,'некорректное значение ключа словаря');
end

end

