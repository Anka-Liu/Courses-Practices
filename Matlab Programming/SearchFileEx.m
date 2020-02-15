function  [linenum,lines] = SearchFileEx(text,str,outFile)
file=fopen(text);
linenum=[];
lines={};
i=0;
while ~feof(file)
    i=i+1;
    line=fgetl(file);
    if contains(line,str)
        linenum(end+1)=i;
        lines{end+1}=strrep(line,str,upper(str));
    end
end
fclose(file);
file=fopen(outFile,"w+");
for i=1:length(linenum)
    fprintf(file,"%d : %s\n",linenum(i),lines{i});
end
fclose(file);
