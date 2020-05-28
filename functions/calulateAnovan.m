function infoStr = calulateAnovan( dataY, datasets, sstypeStr, significanceLevel, cmprTypeStr )

infoStr = "Анализ выборки: '" + dataY.name + "' при разбиении на группы по выборкам: ";

for x = 1:size(datasets,2)
    infoStr = [infoStr;  " - " + datasets(x).name + " [ тип данных: " + datasets(x).type + "]"];
end

infoStr = [infoStr; ""];
infoStr = [infoStr; "Уровень значимости: " + num2str(significanceLevel)];

sstype = getDictValue(sstypeStr);
cmprType = getDictValue(cmprTypeStr);

group = {datasets(:).dataset};

continuousVars = zeros(1, size(datasets,2));
groupingVarsNames = cell(1, size(datasets,2)); 

for x = 1:size(datasets,2)
    
    if datasets(x).type == 'числовой' 
        continuousVars(x) = x;   
    end
    
    groupingVarsNames(x) = {char(datasets(x).name)};
    
end

continuousVars(continuousVars == 0) = [];

handle = figure('Position',[50 50 850 550], 'Visible','off');
setFigureInCenter(handle);

[~, ~, stats] = anovan( dataY.dataset, ...
        group, ...
        'alpha', significanceLevel ,...
        'sstype', sstype ,...
        'varnames', groupingVarsNames ,...
        'continuous', continuousVars ,...
        'model', 'full');

DIM = 1:length(stats.nlevels);
DIM(stats.nlevels < 2) = [];

infoStr = [infoStr; "Примененный критерий: Многофакторный анализ дисперсий (ANOVA)"];
infoStr = [infoStr; cmprTypeStr];
infoStr = [infoStr; "Функции в Matlab R2017a: anovan(y, group) и multcompare(stats, 'model', 'full')"];
infoStr = [infoStr; "Справка по функции и расшифровка характеристик: https://www.mathworks.com/help/stats/anovan.html"];
infoStr = [infoStr; "Справка по методу сравнения: https://www.mathworks.com/help/stats/multcompare.html"];
infoStr = [infoStr; ""];
infoStr = [infoStr; "source - источник вариативности;"];
infoStr = [infoStr; "Error - вариативность внутри группы;"];
infoStr = [infoStr; "Total - итоговая вариативность;"];
infoStr = [infoStr; ""];
infoStr = [infoStr; "SS - сумма квадратов;"];
infoStr = [infoStr; "df - степени свободы;"];
infoStr = [infoStr; "MS - средние значения квадратов;"];
infoStr = [infoStr; "Singular? - указание того, является ли условие вырожденным;"];
infoStr = [infoStr; "F - F-статистика (отношение средних квадратов);"];
infoStr = [infoStr; "Prob>F - p-значение (для F-распределения)."];

figure(handle);
multcompare(stats, 'Alpha', significanceLevel, 'CType', cmprType, 'Dimension', DIM);
handle.Visible = 'on';

end

