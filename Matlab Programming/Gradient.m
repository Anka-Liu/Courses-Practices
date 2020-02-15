function Gradient(Q,C) %function of two parameters 
syms x y; %symbolize the two variables
f=1/2*(Q(1,1)*x^2+2*Q(1,2)*x*y+Q(2,2)*y^2)+C(1,1)*x+C(2,1)*y;%write formula in symbols
grad=[diff(f,x),diff(f,y)]; %give gradient comprised of derivatives on x and y
func=matlabFunction(f); %convert symbolized formula into handle
[X,Y]=meshgrid(linspace(-5,5,101)); %meshgrid of coordinates
Z=arrayfun(func,X,Y); %give Z calculation
contour(X,Y,Z); %plot contour
gradx=subs(grad(1),{x,y},{X,Y}); %calculate x-derivatives
grady=subs(grad(2),{x,y},{X,Y}); %calculate y-derivatives
hold on; %hold on to pile quiver
quiver(X,Y,gradx,grady); %plot gradients



