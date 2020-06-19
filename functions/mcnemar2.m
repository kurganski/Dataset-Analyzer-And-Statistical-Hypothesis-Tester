function [h,p,chi2] = mcnemar2( datasets, significanceLevel, correction )

alpha = significanceLevel;
df = 1;
x = crosstab(datasets(1).dataset, datasets(2).dataset);

% observed subjects with only one reaction
ob = diag(fliplr(x));

% check if datasets are large
if sum(datasets(1).dataset ~= datasets(2).dataset) > 25
    
    % perform chi-square
    if correction == "Edwards"
        chi2 = ( abs( diff(ob)) - 1)^2 / sum(ob);
        
    elseif correction == "Yates"
        chi2 = ( abs(diff(ob)) - 0.5)^2 / sum(ob);
    else
        assert(0, 'Неизвестная поправка');
    end
    
else
    
    p = NaN;
    h = NaN;
    chi2 = NaN;
    return
    
end

p = chi2pval(chi2, df);

if isnan(p)
    h = NaN; 
else
    h = cast(p <= alpha, 'like', p);    
end

end
