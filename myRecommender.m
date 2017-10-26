function [ U, V ] = myRecommender( rateMatrix, lowRank )
% Please type your name here:
name = 'Roy, Ananya';
disp(name); % Do not delete this line.

% Parameters
maxIter = 1000; % Choose your own.
learningRate = 0.0002; % Choose your own.
regularizer = 1.0; % Choose your own.

% Random initialization:
[n1, n2] = size(rateMatrix);
U = rand(n1, lowRank) / lowRank;
V = rand(n2, lowRank) / lowRank;

% Gradient Descent:

Sparse = ones(size(rateMatrix)) & rateMatrix;
for iter=1:maxIter
    
    UV_transpose = U * V';
    MUV_t = Sparse.*(rateMatrix - UV_transpose);
    
    %U
    prod1 = MUV_t * V;
    sum1 = (2*learningRate) * prod1;
    sum2 = (2*learningRate * regularizer) * U ;
    U_new = U + sum1 - sum2;
    
    %V
    prod2 = MUV_t' * U;
    sum3 = (2*learningRate) * prod2;
    sum4 = (2*learningRate * regularizer) * V ;
    V_new = V + sum3 - sum4;
    
    %breaking condition
    compare = abs(U_new - U);
    compare = sum(compare(:)< 0.000001);
    
    compare2 = abs(V_new - V);
    compare2 = sum(compare2(:)< 0.000001);
    
    if compare >= (0.99 * n1 * lowRank) && compare2 >= (0.99 * n2 * lowRank)
        break;
    end
    
    %updating variables
    U = U_new;
    V = V_new;
end
end