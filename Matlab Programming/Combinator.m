apply = @(f,x) f(x); %f is function handle, while x is variable
ifthenelse = @(b,varargin) varargin{2-(b>0)}(); %if b>0, take first element of varargin,else take the second
Y = @(f) apply(@(g)g(g), @(g)f(@(x) apply(g(g),x))); % Y created on nested apply 
h = Y(@(f)@(x)ifthenelse(x(2)<=0,@()0,@()x(1)+f([x(1),x(2)-1])));% if starting from 0 and below, fix the result to be 0, else follow arithmetic progression
m = @(x,y) h([x,y]); %require input coordinate
%what the fuck of the nested handles...
[X,Y]=meshgrid(0:10); %create meshgrid
Z=arrayfun(m,X,Y) %apply handle m on meshgrid
surf(X,Y,Z) %plot surface
%it is presented that any row or column is arithmetic progression, interval
%decided by its row or column coordinate
%z=x*y for natural numbers, while z is forced to be 0 for negative
%coordinates.