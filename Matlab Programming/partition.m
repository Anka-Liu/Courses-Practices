function [z,i]=partition(x)
i=0;
if length(x)<=1
    z=x;
    i=1;
else
    for j=1:(length(x)-1)
        if x(j)<=x(end)
            i=i+1;
            y=x(i);
        	x(i)=x(j);
            x(j)=y;
        end
    end
    y=x(i+1);
    x(i+1)=x(end);
    x(end)=y;
    z=x;
    i=i+1;
end
