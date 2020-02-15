fid = fopen('airports.dat','r'); 
if fid<0
error('File failed to open.')
end
Header1 = fgetl(fid); 
Header2 = fgetl(fid); 
S = struct('Airport_ID',{},'Name',{},'City',{},'Country',{},'IATA_FAA',{},'ICAO',{},'Latitude',{},'Longitude',{},'Altitude',{},'Timezone',{},'DST',{},'Tz_timezone',{});
NumEntries = 0; 
FieldNames = fields(S); 
stripquote=@(x)(strip(x,'"'));
FieldFormats = {@str2num;
stripquote; 
stripquote; 
stripquote; 
stripquote; 
stripquote;
@str2num;
@str2num;
@str2num;
@str2num;
stripquote;
stripquote;
};
while ~feof(fid)
    line = fgetl(fid);
    splitline = strsplit(line,',');
    if length(splitline) == length(fields(S))
        NumEntries = NumEntries + 1; 
        for i = 1:length(fields(S))
            S(NumEntries).(FieldNames{i}) = FieldFormats{i}(splitline{i}); 
        end
    end
end
fclose(fid);
jp=imread('worldmap.jpg');
world=image([-180,180],[-90,90],jp)
hold on;
plot([S.Longitude],-[S.Latitude],'.r')