function [ A ] = heap( A )
A=build_max_heap(A);
[~,n]=size(A);
for i=n:-1:2
    temp=A(1);
    A(1)=A(i);
    A(i)=temp;
    n=n-1;
    A=max_heapify(A,n,1);
end
end

function [ A ] = build_max_heap( A )
[~,n]=size(A);
for i=floor(n/2):-1:1
    A=max_heapify(A,n,i);
end
end

function [ A ] = max_heapify( A,n,i )
l=left(i);
r=right(i);
if l<=n&&A(l)>A(i)
    largest=l;
else
    largest=i;
end
if r<=n&&A(r)>A(largest)
    largest=r;
end
if largest~=i
    temp=A(i);
    A(i)=A(largest);
    A(largest)=temp;
    A=max_heapify(A,n,largest);
end
end

function [ lIndex ] = left( i )
lIndex=2*i;
end

function [ rIndex ] = right( i )
rIndex=2*i+1;
end
