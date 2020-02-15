function z=Split(x)
if isa(x,'string')==1
    y=[x{1},' '];
else
    y=[x,' '];
end
z={};
i=1;
for m=1:(length(y)-1)
   if y(m)==' '&& y(m+1)~=' '
       i=m+1;
   elseif y(m)~=' '&& y(m+1)==' '
       z{end+1}=string(y(i:m));
   end
end