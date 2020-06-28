function value = getDictValue(key)

switch key
    
    case "�������"
        value = 'mean';
        
    case "�������"        
        value = 'median';
        
    case "�����"
        value = 'sum';
        
    case "�������"
        value = 'Pearson';
        
    case "��������"
        value = 'Kendall';
        
    case "��������"
        value = 'Spearman';
        
    case '������������ �������������� ��������'
        value = 'both';
        
    case '������������� �������������� ��������'
        value = 'left';
        
    case '�������������� �������������� ��������'
        value = 'right';        
        
    case "������� �����������"
         value = 1;
         
    case "������� �� �����������"
         value = 0;
         
    case "������� �����������"
         value = 1;
         
    case "������� �� �����������"
         value = 0;
         
    case "������� �������"
         value = 1;
         
    case "������� �����"
         value = 0;
         
    case "������� ����������"
         value = 1;
         
    case "������� ��������"
         value = 0;
         
    case "���������: �����-�������"
         value = 'tukey-kramer';
         
    case "���������: ����������"
         value = 'bonferroni';
         
    case "���������: �����-������"
         value = 'dunn-sidak';
         
    case "���������: ������ (LSD)"
         value = 'lsd';
         
    case "���������: �����"
         value = 'scheffe';
         
    case "��� ����� ���������: I"
        value = 1;
         
    case "��� ����� ���������: II"
        value = 2;
         
    case "��� ����� ���������: III"
        value = 3;
         
    case "��� ����� ���������: h"
        value = 'h';
        
    case "������������ ��������������"
        value = 'on';
        
    case "�� ������������ ��������������"
        value = 'off';
    
%     case ""
%         value = ;
        
        
    otherwise
        assert(0,'������������ �������� ����� �������');
end

end

