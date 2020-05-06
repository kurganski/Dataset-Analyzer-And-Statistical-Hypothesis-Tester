function h = binomTest(data, proposedProbability, alpha, tail)
%function h = binomTest(data, p, tail)
%
% Performs a binomial test of the number of successes given a total number 
% of outcomes and a probability of success. Can be one or two-sided.
%
% Inputs:
%       data -   logical array
%       proposedProbability  - proposed probability of a successful outcome: (0 1)
%       tail -  (String) can be 'both','right' or 'left'. A value of
%               'both' will perform a two-sided test, that the actual number
%               of success is different from the expected number of
%               successes in any direction. 'right' or 'left' will
%               perform a 1-sided test to examine if the observed number of 
%               successes are either significantly greter than or less than
%               (respectively) the expected number of successes.
%
% Outputs:
%       h-  returns a test decision for the null hypothesis that the data comes from , 
%           binominal distribution with proposedProbability
%       using the binominal test..               
%
%
% For example, the signtest is a special case of this where the value of p
% is equal to 0.5 (and a 'success' is dfeined by whether or not a given
% sample is of a particular sign.), but the binomial test and this code is 
% more general allowing the value of p to be any value between 0 and 1.
%

if nargin<4 || isempty(tail)
    tail='both';
end

if nargin<3 || isempty(proposedProbability)
    proposedProbability = 0.5;      
end
    
assert(islogical(data), 'data must be logical');

numOfSuccessfulOutcomes = length(data(data == true));
numOfOutcomes = length(data);
h = 0;

s = numOfSuccessfulOutcomes;
E = proposedProbability.*numOfOutcomes;

GreaterInds = s >= E;
pout = zeros(size(GreaterInds));

% there are some rounding errors in matlab's binopdf, such that we need to specify a level
% of tolerance when using the 'two' test     
Prec=1e-14;  

switch lower(tail)
    
    case 'both'
        
        E = proposedProbability .* numOfOutcomes;        

        GreaterInds = numOfSuccessfulOutcomes >= E;
        p = zeros(size(GreaterInds));
        dE = p;

        %note that matlab's binocdf(s,numOfOutcomes,p) gives the prob. of getting up to 
        % AND INCLUDING s # of successes...
        %Calc p for GreaterInds first
        %start with the prob of getting >= numOfSuccessfulOutcomes # of successes
        p(GreaterInds)= 1 - binocdf( numOfSuccessfulOutcomes(GreaterInds)-1, ...
                                    numOfOutcomes(GreaterInds),...
                                    proposedProbability(GreaterInds));  

        %now figure the difference from the expected value, and figure the prob of getting
        % lower than that difference from the expected value # of successes
        dE(GreaterInds) = numOfSuccessfulOutcomes(GreaterInds)- E(GreaterInds);
        
        %the binonmial is a discrete dist. ... so it's value over non-integer args has
        % no menaing... this flooring of E-dE actually doesn't affect the outcome
        %(the result is teh same if the floor was removed) but it's included here as 
        % a reminder of the discrete nature of the binomial
        p(GreaterInds) = p(GreaterInds)+ binocdf(floor(E(GreaterInds) - dE(GreaterInds)),...
                            numOfOutcomes(GreaterInds),proposedProbability(GreaterInds));    

        %If the expected value is exactly equaled, the above code would have added the 
        %probability at that discrete value twice, so we need to adjust 
        % (in this case, p will always = 1 anyways)    
        if dE == 0        
            p(GreaterInds) = p(GreaterInds) - binopdf( E(GreaterInds),...
                numOfOutcomes(GreaterInds),...
                proposedProbability(GreaterInds) );       
        end
        
        %Calc p for LesserInds second
        %start with the prob of getting <= numOfSuccessfulOutcomes # of successes
        p(~GreaterInds) = binocdf(numOfSuccessfulOutcomes(~GreaterInds),...
            numOfOutcomes(~GreaterInds),proposedProbability(~GreaterInds));  

        %now figure the difference from the expected value, and figure the prob of getting 
        % greater than that difference from teh expected value # of successes
        %Here teh ceiling is needed b/c of teh -1 following it, so that integer and 
        % non-integer vals of E+dE will bothe give teh correct value with teh same line of code
        dE(~GreaterInds) = E(~GreaterInds)-numOfSuccessfulOutcomes(~GreaterInds);
        p(~GreaterInds) = p(~GreaterInds) + 1-binocdf(ceil(E(~GreaterInds)+dE(~GreaterInds))-1,...
            numOfOutcomes(~GreaterInds),proposedProbability(~GreaterInds));    
    
    case 'right'  %one-sided
        
        %just report the prob of getting >= numOfSuccessfulOutcomes # of successes
        p = 1 - binocdf(numOfSuccessfulOutcomes-1, numOfOutcomes, proposedProbability);  
    
    case 'left'   %one-sided
        
        %just report the prob of getting <= numOfSuccessfulOutcomes # of successes
        p = binocdf(numOfSuccessfulOutcomes, numOfOutcomes, proposedProbability);  
    
    otherwise
        error(['In myBinomTest, Sided variable is: ' tail '. Unkown sided value.'])       
end

if p > alpha
    h = 1;
end

