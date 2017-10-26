function [ class ] = mycluster( bow, K )
%
% Your goal of this assignment is implementing your own text clustering algo.
%
% Input:
%     bow: data set. Bag of words representation of text document as
%     described in the assignment.
%
%     K: the number of desired topics/clusters.
%
% Output:
%     class: the assignment of each topic. The
%     assignment should be 1, 2, 3, etc.
%
% For submission, you need to code your own implementation without using
% any existing libraries

% YOUR IMPLEMENTATION SHOULD START HERE!

T = bow;

[max_X, max_Y] = size(T);
denomSize = max_X;
denom = zeros(denomSize, 1);

%mew = ones(max_Y, K);
%mew = mew./(max_Y * K);

mew = rand(max_Y, K);
total = sum(sum(mew));
mew = mew./total;

%pi = ones(K,1);
pi = rand(K,1);
%pi = pi./(K);
pi = pi./sum(pi);

gamma = zeros(max_X, K);

prev = zeros(max_Y,K);

while true
    
    for i=1:denomSize
        t_Trans = (T(i,:))';
        t_Trans = repmat(t_Trans,1,K);
        mew_T = mew.^t_Trans;
        mew_T_prod = (prod(mew_T))';
        mew_T_prod = pi.*mew_T_prod;
        denom(i) = sum(mew_T_prod);
        
        gamma(i,:) = (mew_T_prod)'./denom(i);
    end
    
    mew_Numer = zeros(max_Y,K);
    mew_Denom = zeros(max_Y,K);
    
    for j=1:max_Y
        for c=1:K
            product_Numer = gamma(:,c).*T(:,j);
            mew_Numer(j,c) = sum(product_Numer);
            
            %denominator
            sum_denom = gamma(:,c).*sum(T,2);
            mew_Denom(j,c) = sum(sum_denom);
            
        end
    end
    
    mew = mew_Numer./mew_Denom;
    pi = (sum(gamma,1)./max_X)';
    
    [maxval maxindex] = max(gamma,[],2);
    
    compare = abs(mew - prev);
    compare = sum(compare(:)<0.00000001);
    
    prev = mew;
    
    if compare == (max_Y * K)     
        class = maxindex;
        break;
    end
        
end

end

