function [p,anovatab,stats] = ranova1(x)
%RANOVA1 One-way repeated analysis of variance (RANOVA).
%   RANOVA1 performs a repeated one-way ANOVA for comparing the means of two or more
%   groups of data. It returns the p-value for the null hypothesis that the
%   means of the groups are equal.


[r,c] = size(x);

% save uncentered version for boxplot
xorig = x;                
mu = mean(x(:));

xm = mean(x);             % column means
rowMeans = mean(x,2);
gm = mean(xm);             % grand mean

df1 = c-1;                 % Column degrees of freedom
df2 = (c-1)*(r-1);

% Regression Sum of Squares
RSS = r*(xm - gm)*(xm-gm)'; 

% Total Sum of Squares for repeated
x_str_centered = x - rowMeans;
TSS = sum(x_str_centered(:).*x_str_centered(:));

SSE = TSS - RSS;                   % Error Sum of Squares

if (df2 > 0)
    mse = SSE/df2;
else
    mse = NaN;
end

if (SSE~=0)
    
    F = (RSS/df1) / mse;
    p = fpval(F,df1,df2);        % Probability of F given equal means.

elseif (RSS==0)                 % Constant Matrix case.
    
    F = NaN;
    p = NaN;
else                            % Perfect fit case.
    
    F = Inf;
    p = 0;
end


Table=zeros(3,5);               %Formatting for ANOVA Table printout
Table(:,1)=[ RSS SSE TSS]';
Table(:,2)=[df1 df2 df1+df2]';
Table(:,3)=[ RSS/df1 mse Inf ]';
Table(:,4)=[ F Inf Inf ]';
Table(:,5)=[ p Inf Inf ]';

colheads = {getString(message('stats:anova1:ColHeadSource')), getString(message('stats:anova1:ColHeadSS')), getString(message('stats:anova1:ColHeadDf')), getString(message('stats:anova1:ColHeadMS')), getString(message('stats:anova1:ColHeadF')), getString(message('stats:anova1:ColHeadProbGtF'))};

rowheads = {getString(message('stats:anova1:RowHeadColumns')), getString(message('stats:anova1:RowHeadError')), getString(message('stats:anova1:RowHeadTotal'))};


% Create cell array version of table
atab = num2cell(Table);
for i=1:size(atab,1)
    for j=1:size(atab,2)
        if (isinf(atab{i,j}))
            atab{i,j} = [];
        end
    end
end
atab = [rowheads' atab];
atab = [colheads; atab];
if (nargout > 1)
    anovatab = atab;
end

% Create output stats structure if requested, used by MULTCOMPARE
if (nargout > 2)
    
    stats.gnames = strjust(num2str((1:length(xm))'),'left');
    
    stats.n = repmat(r, 1, c);
    
    stats.source = 'anova1';
    stats.means = xm + mu;
    stats.df = df2;
    stats.s = sqrt(mse);
    
end


digits = [-1 -1 0 -1 2 4];

wtitle = 'One-way Repeated ANOVA';
ttitle = getString(message('stats:anova1:ANOVATable'));

tblfig = statdisptable(atab, wtitle, ttitle, '', digits);
set(tblfig,'tag','table');

f1 = figure('pos',get(gcf,'pos') + [0,-200,0,0],'tag','boxplot');
ax = axes('Parent',f1);

boxplot(ax,xorig,'notch','on');
