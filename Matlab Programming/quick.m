function [ A ] = quick( A,p,r )
if p<r
    [A,q]=partition(A,p,r);
    A=quick(A,p,q-1);
    A=quick(A,q+1,r);
end
end

function [ A,q ] = partition( A,p,r )
x=A(r);
i=p-1;
for j=p:r-1
    if A(j)<=x
        i=i+1;
        temp=A(j);
        A(j)=A(i);
        A(i)=temp;
    end
end
 temp=A(i+1);
 A(i+1)=A(r);
 A(r)=temp;
q=i+1;
end
