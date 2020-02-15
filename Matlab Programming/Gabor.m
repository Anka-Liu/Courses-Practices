[X,Y]=meshgrid(linspace(-4,4,101)); %build up meshgrid of coordinates
%first scene
%input parameters
lambda=2; 
theta=pi/2;
sigma=1 ;
%create function handle of targeted formula
gabor1=@(x,y) exp(-(x^2+y^2)/(2*sigma^2))*cos(2*pi/lambda*(x*cos(theta)+y*sin(theta)));
Z=arrayfun(gabor1,X,Y); %apply arrayfun to calculate Z
figure1=figure; %pop out figure
surf(X,Y,Z) %plot surface
%second scene
%input parameters
lambda=1;
theta=-pi/4;
sigma=2 ;
%create function handle of targeted formula
gabor2=@(x,y) exp(-(x^2+y^2)/(2*sigma^2))*cos(2*pi/lambda*(x*cos(theta)+y*sin(theta)));
Z=arrayfun(gabor2,X,Y);%apply arrayfun to calculate Z
figure2=figure;%pop out figure
surf(X,Y,Z)%plot surface
