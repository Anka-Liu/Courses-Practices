function z=HanoiComputeSolution(x,y,n)
if n<1
    z=[];
else
    tower=[1,2,3];
    bridge=tower(tower~=x & tower~=y);
    z=HanoiComputeSolution(x,bridge,n-1);
    z=[z;[x,y]];
    z=[z;HanoiComputeSolution(bridge,y,n-1)];
end

