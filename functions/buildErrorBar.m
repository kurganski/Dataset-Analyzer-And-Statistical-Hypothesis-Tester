function buildErrorBar( dataY, dataX, axesHandle)

if nargin == 2
    axesHandle = gca;
end

uniqueXdata = unique(dataX);
for x = 1:length(uniqueXdata)
    
    category = dataY(dataX == uniqueXdata(x));
    
    plot(axesHandle, x, prctile(category, 1), 'o', 'Color','black', 'MarkerSize',5);
    
    line(axesHandle, [x-0.1 x+0.1], [prctile(category, 3) prctile(category, 3)], 'Color','black');
    line(axesHandle, [x-0.2 x+0.2], [prctile(category, 5) prctile(category, 5)], 'Color','black', 'LineStyle','--');
    line(axesHandle, [x-0.3 x+0.3], [prctile(category, 10) prctile(category, 10)], 'Color','black', 'LineStyle','-.');
    line(axesHandle, [x-0.4 x+0.4], [prctile(category, 25) prctile(category, 25)], 'Color','black', 'LineStyle',':');
    
    plot(axesHandle, x, prctile(category, 50), 's','Color','black', 'MarkerSize',10);
    
    line(axesHandle, [x-0.4 x+0.4], [prctile(category, 75) prctile(category, 75)], 'Color','black', 'LineStyle',':');
    line(axesHandle, [x-0.3 x+0.3], [prctile(category, 90) prctile(category, 90)], 'Color','black', 'LineStyle','-.');
    line(axesHandle, [x-0.2 x+0.2], [prctile(category, 95) prctile(category, 95)], 'Color','black', 'LineStyle','--');
    line(axesHandle, [x-0.1 x+0.1], [prctile(category, 97) prctile(category, 97)], 'Color','black');
    
    plot(axesHandle, x, prctile(category, 100), 'o', 'Color','black', 'MarkerSize',5);
    
    line(axesHandle, [x x],[prctile(category,3) prctile(category,97)], 'LineWidth',1, 'Color','black');
end

xlim(axesHandle,[0 length(uniqueXdata)+1]);
set(axesHandle, 'XTick', 0:length(uniqueXdata)+1, 'XTickLabel', [" "; uniqueXdata; " "]);
legend('1% и 99% перцентили', '3% и 97% перцентили', '5% и 95% перцентили', ...
    '10% и 90% перцентили', '25% и 75% перцентили','медиана');

end

