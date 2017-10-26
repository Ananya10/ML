function [ B C A ] = mycluster2( T, Z )
% A = p(z) , B=p(w|z) , C =p(d|z) 
% YOUR IMPLEMENTATION SHOULD START HERE!

[maxX maxY] = size(T);

A = rand(Z,1);
A = A ./ (sum(A));

B = rand(maxY,Z);
B = B ./ (sum(sum(B)));

prev = zeros(maxY,Z);

C = rand(maxX,Z);
C = C ./ (sum(sum(C)));

answer = zeros(maxX,maxY,Z);

bsxResult = zeros(maxX,maxY,Z);

%for iter=1:30
while true
    
    for d=1:maxX
        temp1 = bsxfun(@times,A',B);
        numerTerm = bsxfun(@times,C(d,:),temp1);
        answer(d,:,:) = bsxfun(@rdivide,numerTerm,sum(numerTerm,2));
    end
    
    for z=1:Z
        temp = bsxfun(@times,T,answer(:,:,z));
        bsxResult(:,:,z) = temp;
        numer = sum(temp);
        B(:,z) = numer';
        
        numer2 = sum(temp,2);
        C(:,z) = numer2;
    end
    B = bsxfun(@rdivide,B,sum(B,1));
    C = bsxfun(@rdivide,C,sum(C,1));
        
    for z=1:Z
        A(z) = sum(sum (bsxResult(:,:,z) ));
    end
    A = bsxfun(@rdivide,A,sum(A));
    
    compare = abs(B - prev);
    compare = sum(compare(:)< 0.0001);
    
    prev = B;
    if compare >= (0.99 * maxY * Z)
        break;
    end
end
end