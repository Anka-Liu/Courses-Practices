
tic;
for i=1:10
    merging(randperm(10000));
end
x=toc;
x=x/10;
tic ;
for i=1:10
heap(randperm(10000));
end
y=toc;
y=y/10;
tic ;
for i=1:10
quick(randperm(100),1,100);
end
z=toc;
z=z/10;