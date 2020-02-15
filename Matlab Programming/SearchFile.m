function  [linenum,lines] = SearchFile(text,str)
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
    