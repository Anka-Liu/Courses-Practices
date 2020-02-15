[X,Y]=meshgrid(0:10); % to create meshgrid of 0:10*0:10 in natural numbers
Z=arrayfun(@(x,y) 0.5*(x+y+1)*(x+y)+y, X, Y); %apply arrayfun to calculate based on mesh of X and Y
mesh(X,Y,Z) %plot the mesh of Z on figure
Z %show results of calculation
% Cantor pairing function gives a way of realizing bijection between N*N pair and N series 
%from upright to downleft the natural number series are lined, proving the bijection.