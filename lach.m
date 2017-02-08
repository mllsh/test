
% function lach
function L = lach(theta,y)
w     =  theta(1); 
alpha =  theta(2);
y2   = y.^2;
[T1,K] = size(y2); 
ht    = zeros(T1,1);
ht(1) = sum(y2)/T1;
for i=2:T1
    ht(i)=w + alpha*y2(i-1);
end
sqrtht  = sqrt(ht);
x       = y./sqrtht;
l = -0.5*log(2*pi) - log(sqrtht) - 0.5*(x.^2);
l=-l;
L = sum(l);