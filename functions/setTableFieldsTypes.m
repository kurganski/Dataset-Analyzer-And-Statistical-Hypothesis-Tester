function [outputTable, outputTableNames] = setTableFieldsTypes(inputTable)

outputTable = table();

outputTableNames = inputTable{1,:};
inputTable(1,:) = [];

for x = 1:size(inputTable,2)
   
    currentColumn = inputTable{:,x};
    
    % ������ ����� �� ������������, ����� �������� �������� �����
    currentColumn(currentColumn=="") = "Inf";
    
    currentColumn = str2double(currentColumn);
    
    % ���� �������� ���, �� �������� NaN, ����� ������ ��������� �������� �������
    if any(isnan(currentColumn))
        outputTable = [outputTable inputTable(:,x)];
        outputTableNames(2,x) = "��������������";
        continue 
    end 
    
    % ��������� �� ���������� ������
    if all(ismember(unique(currentColumn), [0,1,Inf]))
        outputTableNames(2,x) = "����������";
    else
        outputTableNames(2,x) = "��������";        
    end   
    
    % ���������� NaN
    currentColumn(currentColumn==Inf) = NaN;    
          
    outputTable = [outputTable table(currentColumn,'VariableNames',{['Var' num2str(x)]})];   
    
end

