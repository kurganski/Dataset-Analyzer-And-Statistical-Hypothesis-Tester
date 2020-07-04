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
    
    case "������ Intercept"
        value = 'constant';
    
    case "Intercept � �������� ������������"
        value = 'linear';
    
    case "Intercept, �������� ������������ � ��������������"
        value = 'interactions';
    
    case "Intercept, �������� � ������������ ������������"
        value = 'purequadratic';
    
    case "Intercept, �������� � ������������ ������������ � ��������������"
        value = 'quadratic';
    
    case "���������� ������������� ��������� �������"
        value = 'normal';
    
    case "������������ ������������� ��������� �������"
        value = 'binomial';
    
    case "������������� ������������� ��������� �������"
        value = 'poisson';
    
    case "�����-������������� ��������� �������"
        value = 'gamma';
    
    case "�������� ����������� ������������� ��������� �������"
        value = 'inverse gaussian';
    
    case "��������� �������: ���������"
        value = 'identity';
    
    case "��������� �������: ���������������"
        value = 'log';
    
    case "��������� �������: �����"
        value = 'logit';
    
    case "��������� �������: ������"
        value = 'probit';
    
    case "��������� �������: ����� ������ ���������������"
        value = 'comploglog';
    
    case "��������� �������: ��������"
        value = 'reciprocal';
    
    case "��������� �������: ������������"
        value = 2;
    
    case "��������� �������: ����������"
        value = 3;
        
        
    otherwise
        assert(0,'������������ �������� ����� �������');
end

end

