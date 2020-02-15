function z=mergesort(x)
l=length(x);
if l<=1
    z=x;
else
    f=floor(l/2);
    
    c=mergesort(x(1:f));
    c(end+1)=inf;
    d=mergesort(x((f+1):end));
    d(end+1)=inf;
    i=1;
    j=1;
    z=zeros(1,l);
    for k=1:l
        if c(i)<d(j)
            z(k)=c(i);
            i=i+1;
        else
            z(k)=d(j);
            j=j+1;
        end
    end
end   
end