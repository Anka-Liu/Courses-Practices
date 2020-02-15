function dataOut = merging(data)
lenD = size(data,2);
if(lenD<2)
  dataOut = data;
else
  middle = floor(lenD/2);
  L = data(1:middle);
  R = data(middle+1:end);
  L = merging(L);
  R = merging(R);
  dataOut = merge(L, R);
end
end

function dataOut = merge(L,R)
lenL = size(L,2);
lenR = size(R,2);
i = 0;
j = 0;
merged = zeros(1,lenL+lenR);
while(i<lenL||j<lenR)
  if (i<lenL && j<lenR)
    if(L(i+1)<=R(j+1))
      merged(i+j+1) = L(i+1);
      i = i+1;
    else
      merged(i+j+1) = R(j+1);
      j = j+1;
    end
  elseif(i<lenL)
    merged(i+j+1) = L(i+1);
    i = i+1;
  elseif(j<lenR)
    merged(i+j+1) = R(j+1);
    j = j+1;
  end
end
dataOut = merged;
end