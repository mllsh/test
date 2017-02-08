function[] = inverse2()

a = [150;250;75;0;0;0];
ah = [90;0;90;-90;90;0];
d = [0;0;0;290;0;80];
al3 = sqrt(75^2+290^2);
T = zeros(4,4,6);
radius = 450;
pause(1.5);

for i=1:1000
C = [-1 0 2; -0.5 0 0];
px = C(1,1);
pz = C(1,2);

if  px > radius
px = radius;
elseif px < -radius
px = -radius;
end

if px >= 0 && px <= radius
py = (sqrt(radius^2-px^2));
elseif px < 0 && px >= -radius
py = (sqrt(radius^2-px^2));
end       
pause(0.001); 
row = 0;
pitch = 0;
yaw = 0;
  
Ra = [cosd(row) -sind(row) 0 ; sind(row) cosd(row) 0 ; 0 0 1];
Rb = [cosd(yaw) 0 sind(yaw) ; 0 1 0 ; -sind(yaw) 0 cosd(yaw)];
Rc = [cosd(pitch) -sind(pitch) 0 ; sind(pitch) cosd(pitch) 0 ; 0 0 1];
R60 = Ra*Rb*Rc;
pcx = px - d(6)*R60(1,3);
pcy = py - d(6)*R60(2,3);
pcz = pz - d(6)*R60(3,3);
    
r=(sqrt(pcx^2+pcy^2))-150;
P61 = sqrt(pcz^2+r^2);
t3i=acosd(( (a(2)^2) + (al3^2) - (P61^2) )/(2*a(2)*al3));
t3(1,i) = t3i - 104.5002;
t1(1,i)=(atan2(pcy,pcx)) * 180/pi;

gamma=acosd(( (P61^2) + (a(2)^2) - (al3^2) )/(2*a(2)*P61));
beta=atan2(pcz,r)*180/pi;
t2(1,i) = 90 - (beta + gamma);


th = [t1(1,i);-t2(1,i)+90;t3(1,i)];
th = real(th);


for j=1:3
T(:,:,j) = [cosd(th(j)) -sind(th(j))*cosd(ah(j)) sind(th(j))*sind(ah(j)) a(j)*cosd(th(j)); ...
sind(th(j)) cosd(th(j))*cosd(ah(j)) -cosd(th(j))*sind(ah(j)) a(j)*sind(th(j)); ...
0 sind(ah(j)) cosd(ah(j)) d(j) ; ...
0 0 0 1];
end

T30 = T(:,:,1)*T(:,:,2)*T(:,:,3);
R30 = T30(1:3,1:3);
R63 = R30.' * R60;

if R63(3,3) == 1
type = 1;  
t5(1,i) = 0;
t4(1,i) = 0;
t6(1,i) = atan2(R63(2,1),R63(1,1))*(180/pi);
elseif R63(3,3) == -1
type = 2;   
t5(1,i) = 180;
t4(1,i) = 0;
t6(1,i) = -atan2(-R63(2,1),-R63(1,1))*(180/pi);
else
type = 3;
t5(1,i) = atan2(sqrt(1-(R63(3,3)^2)),R63(3,3))*(180/pi);
t4(1,i) = atan2(R63(2,3),R63(1,3))*(180/pi);
t6(1,i) = atan2(R63(3,2),-R63(3,1))*(180/pi);              
end

th = [t1(1,i);-t2(1,i)+90;t3(1,i);-t4(1,i);t5(1,i);-t6(1,i)];

for j=4:6
T(:,:,j) = [cosd(th(j)) -sind(th(j))*cosd(ah(j)) sind(th(j))*sind(ah(j)) a(j)*cosd(th(j)); ...
sind(th(j)) cosd(th(j))*cosd(ah(j)) -cosd(th(j))*sind(ah(j)) a(j)*sind(th(j)); ...
0 sind(ah(j)) cosd(ah(j)) d(j) ; ...
0 0 0 1];
end
P_org = [0 0 0 1]';
P_temp = zeros(4,6);
T60 = eye(4);
for j=1:6
T60 = T60 * T(:,:,j);
P_temp(:,j) = T60 * P_org;
end

P = zeros(3,7);
P(:,2:7) = P_temp(1:3,:);
x = P(1,:);
y = P(2,:);
z = P(3,:);
nonlcon=[];
theta = @(angle)100*(angle(1)+angle(2)+ angle(3)) ;
x0 = [0,0,0];
A = [1,1,1];
b = 10;
angle = fmincon(theta,x0,A,b)
plot3([0;0],[0;0],[0;-350],'w','LineWidth',0.2);
hold on;
plot3(x,y,z,'-k*','LineWidth',4,...
'MarkerEdgeColor','b',...
'MarkerSize',8);

xlabel('x')
ylabel('y')
zlabel('z')
title('inverse kinematics')
axis([-800 800 -800 800 -800 800]);
hold off;
pause(0.1);

end
end
