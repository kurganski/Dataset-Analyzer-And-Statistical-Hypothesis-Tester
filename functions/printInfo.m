function printInfo(figureHandle, infoStr)

figureHandle.Position = [50 50 800 400];
setFigureInCenter(figureHandle);
uicontrol(figureHandle,'Style','listbox','Position',[10 10 780 380],...
    'String',infoStr,'FontSize',10);

end

