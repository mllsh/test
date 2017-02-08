p=1;
T = 3000;
ra = zeros(T+2000,1);
seed=123;
rng(seed);
ra = randn(T+2000,1); 
epsi=zeros(T+2000,1);
simsig=zeros(T+2000,1);
a0=0.1; a1=0.4;
unvar = a0/(1-a1);
for i = 1:T+2000
if (i==1) 
simsig(i) = a0+a1*((a0)/(1-a1));
s=(simsig(i))^0.5;
epsi(i) = ra(i) * s;
else                     
simsig(i) = a0+ a1*(epsi(i-1))^2;
s=(simsig(i))^0.5;
epsi(i) = ra(i)* s;
end
end
yt = epsi(2001:T+2000);
theta0 = [1;1];
A=[0 1];
b=0.99999;
[theta, opt] = fmincon(@(theta)...
lach(theta,yt),theta0,A,b,[],[],0,1);