function z=quicksort(x)
l=length(x);
if l<=1
    z=x;
else
[z,i]=partition(x);
z=[quicksort(z(1:i-1)) quicksort(z(i:end))];
end

function [x,i]=partition(x)
i=0;
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
i=i+1;
