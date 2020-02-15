function y=heapsort(x)
z=buildheap(x);
y=zeros(1,length(x));
for i=length(x):-1:2
    y(i)=z(1);
    z(1)=z(i);
    z=maxheap(z(1:i-1),1);
end

function x=buildheap(x)
for i=floor(length(x)/2):-1:1
    x=maxheap(x,i);
end

function x=maxheap(x,m)
if 2*m<=length(x) && x(2*m)>x(m)
    large=2*m;
else
    large=m;
end
if (2*m+1)<=length(x) && x(2*m+1)>x(large)
    large=2*m+1;
end
if large~=m 
    y=x(m);
    x(m)=x(large);
    x(large)=y;
    x=maxheap(x,large);
end
