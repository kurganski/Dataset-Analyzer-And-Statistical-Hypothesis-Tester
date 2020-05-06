function setFigureInCenter(figureHandle)
    
scrRes = get(0, 'ScreenSize');
fig = get(figureHandle,'Position');

% отцентрировали окно
figureHandle.Position = [(scrRes(3)-fig(3))/2 (scrRes(4)-fig(4))/2 fig(3) fig(4)];

