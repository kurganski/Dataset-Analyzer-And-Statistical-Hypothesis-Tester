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
    
%     case ""
%         value = ;
        
        
    otherwise
        assert(0,'некорректное значение ключа словаря');
end

end

