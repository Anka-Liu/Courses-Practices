
function z=DescendingSort(z,x,y)
if x<y
    [z,q]=partition(z,x,y);
    z=DescendingSort(z,x,q-1);
    z=DescendingSort(z,q+1,y);
end
end

function [z,q] = partition(z,x,y)
m=z(y);
i=x-1;
for j=x:y-1
    if z(j)>=m
        i=i+1;
        temp=z(j);
        z(j)=z(i);
        z(i)=temp;
    end
end
 temp=z(i+1);
 z(i+1)=z(y);
 z(y)=temp;
q=i+1;
end
