function z=insertsort(x)
for j=2:length(x)
    element=x(j);
    i=j-1;
    while i>0 && x(i)>element
        x(i+1)=x(i);
        i=i-1;
    end
    x(i+1)=element;
end
z=x;

