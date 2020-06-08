function [ h,p,ci,zval ] = ztest1( dataset, alpha, supposedProbability, tailStr )

data1 = replaceNaN(dataset);

n1 = length(data1);
n2 = length(data1);

m1 = sum(data1);
p1 = m1 / n1;
p2 = supposedProbability;
m2 = round(p2 * n2);

pmean = (m1 + m2) / (n1 + n2);

ser = sqrt( pmean*(1 - pmean)*(1/n1 + 1/n2) );
zval = (abs(p1 - p2) - 0.5*(1/n1 + 1/n2) ) / ser;

% Compute the correct p-value for the test, and confidence intervals
% if requested.

tail = getDictValue(tailStr);

if tail == "both" % two-tailed test
    p = 2 * normcdf(-abs(zval),0,1);
        crit = norminv(1 - alpha/2, 0, 1) .* ser;
        ci = cat(1, pmean-crit, pmean+crit);
        
elseif tail == "right" % right one-tailed test
    p = normcdf(-zval,0,1);
        crit = norminv(1 - alpha, 0, 1) .* ser;
        ci = cat(1, pmean-crit, Inf(size(p)));
        
elseif tail == "left" % left one-tailed test  
    p = normcdf(zval,0,1);
        crit = norminv(1 - alpha, 0, 1) .* ser;
        ci = cat(1, -Inf(size(p)), pmean+crit);
end

% Determine if the actual significance exceeds the desired significance
h = cast(p <= alpha, 'like', p);
h(isnan(p)) = NaN; % p==NaN => neither <= alpha nor > alpha


end

