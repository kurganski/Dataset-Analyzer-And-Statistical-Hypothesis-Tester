function [data, rowNames, colNames] = generateMnrfitInfoTable( stats )

beta = stats.beta;
SE = stats.se;
tStat = stats.t;
pValue = stats.p;

data = zeros(size(beta,1), size(beta,2)*4);
colNames = strings(1, size(beta,2)*4);

for x = 1:size(beta,2)

   data(:,4*x - 3) = beta(:,x);
   data(:,4*x - 2) = SE(:,x);
   data(:,4*x - 1) = tStat(:,x);
   data(:,4*x) = pValue(:,x);
   
   colNames(:,4*x - 3) = "Estimate (y" + num2str(x) + " vs y" + num2str( size(beta,2) + 1) + ")";
   colNames(:,4*x - 2) = "SE (y" + num2str(x) + " vs y" + num2str( size(beta,2) + 1) + ")";
   colNames(:,4*x - 1) = "tStat (y" + num2str(x) + " vs y" + num2str( size(beta,2) + 1) + ")";
   colNames(:,4*x) = "pValue (y" + num2str(x) + " vs y" + num2str( size(beta,2) + 1) + ")";

end

rowNames = strings(1,size(beta,1));
rowNames(1) = "Intercept";

for x = 2:size(beta,1)
    rowNames(x) = "x" + num2str(x-1);
end




end


