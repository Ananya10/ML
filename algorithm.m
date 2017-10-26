function prob = algorithm(q)

% plot and return the probability

a = [ 0.8 0.2; 0.2 0.8 ] ;
b = [ q 1-q; 1-q q ] ;
pi= [0.2 0.8];
load sp500;
x = price_move; 

beta = zeros(2,size(x,1));

beta(1,size(x,1)) = 1;
beta(2,size(x,1)) = 1;


% Calculate beta
for i= size(x,1)-1 :-1: 1
    b_index = 2;
    if x(i+1,1) == 1
        b_index = 1;
    end
    
    beta(1,i) = beta(1,i+1)* a(1,1) * b(1, b_index) + beta(2,i+1)* a(1,2) * b(2, b_index);
    beta(2,i) = beta(1,i+1)* a(2,1) * b(1, b_index) + beta(2,i+1)* a(2,2) * b(2, b_index);
end

alpha = zeros(2,size(x,1));

a_index = 2;
    if x(1,1) == 1
        a_index = 1;
    end
alpha(1,1) = pi(1,1)* b(1, a_index);
alpha(2,1) = pi(1,2)* b(2, a_index);
% Calculate alpha
for i= 2: size(x,1)
    a_index = 2;
    if x(i,1) == 1
        a_index = 1;
    end
    
    alpha(1,i) = b(1, a_index)*((alpha(1,i-1) * a(1,1)) + (alpha(2,i-1) * a(2,1)));
    alpha(2,i) = b(2, a_index)*((alpha(1,i-1) * a(1,2)) + (alpha(2,i-1) * a(2,2)));
end

P = zeros(size(x,1),1);
for i= 1: size(x,1)
    P(i,1) = (alpha(1,i)*beta(1,i))/((alpha(1,1)*beta(1,1))+ (alpha(2,1)*beta(2,1)));
end


t = zeros(size(x,1),1);

for i=1:size(x,1)
    t(i,1) = i;
end

prob = P(39,1);

figure
s = strcat('Q=',num2str(q));
plot(t,P);
title(s);
xlabel('Time(t)'); % x-axis label
ylabel('P(x(t) = good|y)'); % y-axis label

end
