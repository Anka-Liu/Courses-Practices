function varargout = AirplaneQuery(varargin)
% AIRPLANEQUERY MATLAB code for AirplaneQuery.fig
%      AIRPLANEQUERY, by itself, creates a new AIRPLANEQUERY or raises the existing
%      singleton*.
%
%      H = AIRPLANEQUERY returns the handle to a new AIRPLANEQUERY or the handle to
%      the existing singleton*.
%
%      AIRPLANEQUERY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AIRPLANEQUERY.M with the given input arguments.
%
%      AIRPLANEQUERY('Property','Value',...) creates a new AIRPLANEQUERY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AirplaneQuery_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AirplaneQuery_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AirplaneQuery

% Last Modified by GUIDE v2.5 07-Jul-2018 17:17:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AirplaneQuery_OpeningFcn, ...
                   'gui_OutputFcn',  @AirplaneQuery_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before AirplaneQuery is made visible.
function AirplaneQuery_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AirplaneQuery (see VARARGIN)

% Choose default c

% command line output for AirplaneQuery

%part of opening the gui 
Main=Loading(); %load Loading gui to show loading state before main gui is loaded.

handles.output = hObject; 
% Update handles structure
guidata(hObject, handles);

handles.tabManager = TabManager( hObject );  % we apply tab objects in gui, where it doesn't have such object
%we refer to TabManager, which offers such function of designing tabs.
%More information, please refer to project-introduction txt within gui package

% UIWAIT makes AirplaneQuery wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%loading main page picture
a=imread('AirportImage.jpg'); % reading the main page picture
image(handles.axes2,a); %loading picture into Introduction axes
axis(handles.axes2,'off'); %hide off axis

%loading globe in Route Tracking page
cla reset; %clear axes of Route Tracking
load topo; %loading globe colormap
ax1=handles.axes1; 
[x,y,z] = sphere(45); %create sphere mesh
surface(handles.axes1,x,y,z,'FaceColor','texturemap','CData',topo,'EdgeColor','none'); %plot globe
ax1.Colormap=topomap1; %set globe colormap on sphere
brighten(ax1,.1); %brighten light
campos(ax1,[10  10  10]); %set camera and lighting
camlight(ax1); %shed camera light 
lighting(ax1,'gouraud'); %set reflection type
axis(ax1,'off','vis3d'); %hide axis and 3d visualized

%loading airport struct database
ax4=handles.axes4;
fid = fopen('airports.dat','r');  %open data file
if fid<0
error('File failed to open.') %make warnings if not open
end
Header1 = fgetl(fid);  %skip first header
Header2 = fgetl(fid);  %skip second header
global S; %S, as data base, should be globalized and utilized by other functions
S = struct('Airport_ID',{},'Name',{},'City',{},'Country',{},'IATA_FAA',{},...
    'ICAO',{},'Latitude',{},'Longitude',{},'Altitude',{},'Timezone',{},'DST',...
    {},'Tz_timezone',{}); %build struct structure
NumEntries = 0;  %counting number of records
FieldNames = fields(S); %read fieldname
stripquote=@(x)(strip(x,'"')); %function handle to strip " from string
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
};  %store handles to convert data type
while ~feof(fid) %while not reaching end of the file
    line = fgetl(fid); %read one line
    splitline = strsplit(line,','); %split data
    if length(splitline) == length(fields(S)) % if the line in right stored format
        NumEntries = NumEntries + 1;  %count +1
        for i = 1:length(fields(S)) 
            S(NumEntries).(FieldNames{i}) = FieldFormats{i}(splitline{i}); %store converted data into struct
        end
    end
end
fclose(fid); %close file
dup=cellfun(@(x) strcmp(x,'All Airports'),{S.Name}); %search for strange data
S(dup)=[]; %delete strange data
global jp; %the 2d world map may be utilized later, so globalize it
jp=imread('worldmap.jpg'); %read world map
handles.picture1=image(ax4,[-180,180],[-90,90],jp); %loading map into Overview axes
hold(ax4,'on'); %hold axes on
plot(ax4,[S.Longitude],-[S.Latitude],'.r'); %plot airports 
Overview(handles); %Overview's first function: to set the callback function of axes

%set contents of menus
set(handles.popupmenu1,'String',unique({S.Country})); %load countries into country menu
fun=cellfun(@(x) strcmp(x,handles.popupmenu1.String{handles.popupmenu1.Value}),{S.Country}); %read the cities of corresponding country
set(handles.popupmenu2,'String',unique({'All',S(fun).City})); %set content of city menu, with all cities option
if strcmp(handles.popupmenu2.String{handles.popupmenu2.Value},'All') %if opt to show all cities
    fun=cellfun(@(x) strcmp(x,handles.popupmenu1.String{handles.popupmenu1.Value}),{S.Country}); %read all airports of country
    set(handles.popupmenu3,'String',unique({'All',S(fun).Name})); %load airports into menu
else   
    fun=cellfun(@(x) strcmp(x,handles.popupmenu2.String{handles.popupmenu2.Value}),{S.City})&...
        cellfun(@(x) strcmp(x,handles.popupmenu1.String{handles.popupmenu1.Value}),{S.Country}); %if city specified, search corresponding airports
    set(handles.popupmenu3,'String',unique({'All',S(fun).Name})); %load airports into menu
end

%it is the same idea to set the menus in Route Tracking page
%the starting airport menu set
set(handles.popupmenu4,'String',unique({S.Country})); 
fun=cellfun(@(x) strcmp(x,handles.popupmenu4.String{handles.popupmenu4.Value}),{S.Country});
set(handles.popupmenu5,'String',unique({S(fun).City}));
fun=cellfun(@(x) strcmp(x,handles.popupmenu5.String{handles.popupmenu5.Value}),{S.City})&...
    cellfun(@(x) strcmp(x,handles.popupmenu4.String{handles.popupmenu4.Value}),{S.Country});
set(handles.popupmenu6,'String',unique({S(fun).Name}));
%the destination airport menu set
set(handles.popupmenu7,'String',unique({S.Country}));
fun=cellfun(@(x) strcmp(x,handles.popupmenu7.String{handles.popupmenu7.Value}),{S.Country});
set(handles.popupmenu8,'String',unique({S(fun).City}));
fun=cellfun(@(x) strcmp(x,handles.popupmenu8.String{handles.popupmenu8.Value}),{S.City})&...
    cellfun(@(x) strcmp(x,handles.popupmenu7.String{handles.popupmenu7.Value}),{S.Country});
set(handles.popupmenu9,'String',unique({S(fun).Name}));

%Loading globe in Searching page, the same as that in Route Tracking.
cla(handles.axes5,'reset');
load topo;
ax5=handles.axes5;
[x,y,z] = sphere(45);
surface(handles.axes5,x,y,z,'FaceColor','texturemap','CData',topo,'EdgeColor','none');
ax5.Colormap=topomap1;
%Brighten the colormap for better annotation visibility:
brighten(ax5,.1);
%Create and arrange the camera and lighting for better visibility:
campos(ax5,[10  10  10]);
lighting(ax5,'gouraud');
camlight(ax5);
axis(ax5,'vis3d','off');

%close Loading gui to start main gui.
close(Main);

%we do not use output function
% --- Outputs from this function are returned to the command line.
function varargout = AirplaneQuery_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles) %the Track button in Route Tracking page
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

%the button is to plot the route between airports
ax1=handles.axes1;
set(handles.text36,'String','Loading...') %loading reminder
pause(1); %show loading text
global S; %use database
cla(ax1,'reset'); %clear axes
load topo; %load globe colormap
[x,y,z] = sphere(45); %get sphere mesh
surface(handles.axes1,x,y,z,'FaceColor','texturemap','CData',topo,'EdgeColor','none'); %draw earth
ax1.Colormap=topomap1; %use earth colormap
brighten(ax1,.1); %brighten light
campos(ax1,[10  10  10]); %camera position
camlight(ax1); %open camera light
lighting(ax1,'gouraud'); %type of reflection
axis(ax1,'off','vis3d'); %hide axis and 3d visualized
selectS=cellfun(@(x) strcmp(x,handles.popupmenu6.String(handles.popupmenu6.Value)),{S.Name})&...
    cellfun(@(x) strcmp(x,handles.popupmenu4.String(handles.popupmenu4.Value)),{S.Country}); %search data of departure
LoS=[S(selectS).Longitude]; %take its longitude
LaS=[S(selectS).Latitude]; %take its latitude
selectD=cellfun(@(x) strcmp(x,handles.popupmenu9.String(handles.popupmenu9.Value)),{S.Name})&...
    cellfun(@(x) strcmp(x,handles.popupmenu7.String(handles.popupmenu7.Value)),{S.Country}); %search data of destination
LoD=[S(selectD).Longitude]; %take its longitude
LaD=[S(selectD).Latitude]; %take its latitude
XS=-(cos(LaS./180.*pi).*cos(LoS./180.*pi)); %calculate x-coordination of departure
YS=-(cos(LaS./180.*pi).*sin(LoS./180.*pi));%calculate y-coordination of departure
ZS=sin(LaS./180.*pi);%calculate z-coordination of departure
XD=-(cos(LaD./180.*pi).*cos(LoD./180.*pi)); %calculate x-coordination of destination
YD=-(cos(LaD./180.*pi).*sin(LoD./180.*pi)); %calculate y-coordination of destination
ZD=sin(LaD./180.*pi); %calculate z-coordination of destination

%calculate the straight between two airports, which with zero point
%determine the surface(plane) the flight route is on.
Xlin=linspace(XS,XD,101); 
Ylin=linspace(YS,YD,101);
Zlin=linspace(ZS,ZD,101);

% calculate the ratio to stretch the points on straight line to fit the
% globe surface.
ratio=1./((Xlin.*Xlin+Ylin.*Ylin+Zlin.*Zlin).^(1/2)); 

hold(ax1,'on');% hold axes on
plot3(handles.axes1,Xlin.*ratio,Ylin.*ratio,Zlin.*ratio,'r'); % plot flight route

set(handles.text36,'String','Done.') %change text from Loading to Done

while handles.togglebutton3.Value==0 %while the stop button is not pushed down
    %by frequently changing the position of camera, we make earth rotate.
        for i=linspace(0,2*pi,501)
            handles.axes1.CameraPosition=[10*sqrt(3)*cos(i) 10*sqrt(3)*sin(i) 0];
            drawnow; %draw changed camera position
        end
end



% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles) % the 'showoff' button in main page  
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of togglebutton2
ax2=handles.axes2;
while get(hObject,'Value')==get(hObject,'Max') % while the button is not turned off
    %draw the earth like steps above
    cla(ax2,'reset'); 
    load topo;
    [x,y,z] = sphere(90);
    surface(handles.axes2,x,y,z,'FaceColor','texturemap','CData',topo,'EdgeColor','none')
    handles.axes2.CameraPosition=[10*sqrt(2)*cos(0) 10*sqrt(2)*sin(0) 10];
    brighten(ax2,.1);
    camlight(ax2);
    lighting(ax2,'gouraud');
    axis(ax2,'off','vis3d');
    %we frequently change the colormaps of the earth
    ax2.Colormap=topomap1; %the first earth colormap 
    drawnow; 
    pause(1)
    ax2.Colormap=topomap2; %the second earth colormap
    drawnow;
    pause(1);
    colormap(ax2,spring); %spring colormap
    drawnow;
    pause(1);
    colormap(ax2,summer); %summer colormap
    drawnow;
    pause(1);
    colormap(ax2,autumn); %autumn colormap
    drawnow;
    pause(1);
    colormap(ax2,winter); %winter colormap
    drawnow;
    pause(1);
end
%if button is turned off, conduct the following steps
cla(ax2,'reset'); %reset axes
a=imread('AirportImage.jpg'); %read airport image
image(ax2,a); %load into axes
axis(ax2,'off'); %turn off axis

function Overview(handles,x) %the function to set callback function of Overview axes and design callback of click to axes
global S jp; %using world map and database
ax4=handles.axes4;
cla(ax4,'reset'); %clear axes
handles.picture1=image(ax4,[-180,180],[-90,90],jp); %plot world map on it
callback = @(o,e) Overview(handles,e.IntersectionPoint); %loading itself as callback function, with click input
set(handles.picture1,'ButtonDownFcn',callback); %set callback function
Lo=[S.Longitude]; %pick longitude of airports 
La=[S.Latitude]; %pick latitude of airports
hold(ax4,'on');
if nargin>1 %if click received 
    %the lines in if-else block mainly conduct two steps:
    %1.plot the points of airports in corresponding region
    %2. Print the name of displayed region
    
    if x(2)>60 %Antarctica part
        plot(ax4,Lo(La<-60),-La(La<-60),'.r','HitTest','off'); 
        set(handles.text6,'String','Region: Antartica'); 
    elseif x(1)<-30 && x(1)>-90 && x(2)>-15 && x(2)<60 %South America part
        plot(ax4,Lo(Lo<-30 & Lo>-90 & -La>-15 & -La<60),-La(Lo<-30 & Lo>-90 & -La>-15 & -La<60),'.r','HitTest','off');
        set(handles.text6,'String','Region: South America');
    elseif x(1)<-30 && x(1)>-175 && x(2)<-15 %North America part
        plot(ax4,Lo(Lo<-30 & Lo>-175 & -La<-15),-La(Lo<-30 & Lo>-175 & -La<-15),'.r','HitTest','off');
        set(handles.text6,'String','Region: North America');
    elseif x(1)>-30 && x(1)<50 && x(2)<-37 %Europe part
        plot(ax4,Lo(Lo>-30 & Lo<50 & -La<-37),-La(Lo>-30 & Lo<50 & -La<-37),'.r','HitTest','off');
        set(handles.text6,'String','Region: Europe');
    elseif x(1)>-30 && x(1)<60 && x(2)>-37 && x(2)<60 %Africa & Middle East part
        plot(ax4,Lo(Lo>-30 & Lo<60 & -La>-37 & -La<60),-La(Lo>-30 & Lo<60 & -La>-37 & -La<60),'.r','HitTest','off');
        set(handles.text6,'String','Region: Africa & Middle East');
    elseif (x(1)<135 && x(1)>60 && x(2)>10 && x(2)<60) || (x(1)>135 && x(2)>-30 && x(2)<60) || (x(1)<-90 && x(2)>-15 && x(2)<60) %Oceania part
        Select=(Lo<135 & Lo>60 & -La>10 & -La<60) | (Lo>135 & -La>-30 & -La<60) | (Lo<-90 & -La>-15 & -La<60);
        plot(ax4,Lo(Select),-La(Select),'.r','HitTest','off');
        set(handles.text6,'String','Region: Oceania');
    else%Asia Part
        Select=(Lo<135 & Lo>60 & -La<10) | (Lo>135 & -La<-30) | (Lo<-175 & -La<-15);
        plot(ax4,Lo(Select),-La(Select),'.r','HitTest','off'); 
        set(handles.text6,'String','Region: Asia');
    end
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles) %this is the country menu in Search Page
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

set(handles.text23,'String','Loading...')
pause(0.1);
global S;% use database
fun=cellfun(@(x) strcmp(x,hObject.String{hObject.Value}),{S.Country}); %search cities of corresponding country
set(handles.popupmenu2,'Value',1); %set option back to first of the list
set(handles.popupmenu2,'String',unique({'All',S(fun).City})); %load names of cities of corresponding country
fun=cellfun(@(x) strcmp(x,handles.popupmenu2.String{handles.popupmenu2.Value}),{S.City})&...
    cellfun(@(x) strcmp(x,handles.popupmenu1.String{handles.popupmenu1.Value}),{S.Country}); %search airports of corresponding city
set(handles.popupmenu3,'Value',1); %set option back to first of the list
set(handles.popupmenu3,'String',unique({'All',S(fun).Name})); %load corresponding airport names
set(handles.text23,'String','Ready.')


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles) %this is the city menu in Search Page
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
set(handles.text23,'String','Loading...')
pause(0.1);
global S;
if strcmp(handles.popupmenu2.String{handles.popupmenu2.Value},'All') %if select "All"
    fun=cellfun(@(x) strcmp(x,handles.popupmenu1.String{handles.popupmenu1.Value}),{S.Country}); %search the names of all airports of the country
    set(handles.popupmenu3,'Value',1); %set option index back to first of the list
    set(handles.popupmenu3,'String',unique({'All',S(fun).Name})); %load names into third popupmenu
else   
    fun=cellfun(@(x) strcmp(x,handles.popupmenu2.String{handles.popupmenu2.Value}),{S.City})&...
        cellfun(@(x) strcmp(x,handles.popupmenu1.String{handles.popupmenu1.Value}),{S.Country}); %search the names of airports of corresponding city
    set(handles.popupmenu3,'Value',1); %set option index back to first of the list
    set(handles.popupmenu3,'String',unique({'All',S(fun).Name})); %load names into third popupmenu
end
set(handles.text23,'String','Ready.')


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles) %this is the airport name menu in Search Page
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3



% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)  % it executes search airport specified by country, city and name
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text23,'String','Loading...') %updata loading message
pause(1); %show message
global S; %use database
cla(handles.axes5,'reset'); %clear axes
load topo; %load world colormap
ax5=handles.axes5;
[x,y,z] = sphere(45); %create globe mesh
surface(handles.axes5,x,y,z,'FaceColor','texturemap','CData',topo,'EdgeColor','none'); %plot globe
ax5.Colormap=topomap1; %use world colormap
%Brighten the colormap for better annotation visibility:
brighten(ax5,.1);
%Create and arrange the camera and lighting for better visibility:
lighting(ax5,'gouraud');
axis(ax5,'vis3d','off');

%plot the positions of airports
if strcmp(handles.popupmenu3.String{handles.popupmenu3.Value},'All') && ...
        strcmp(handles.popupmenu2.String{handles.popupmenu2.Value},'All') %City:All Airport: All, show all airports of a country
    select=cellfun(@(x) strcmp(x,handles.popupmenu1.String{handles.popupmenu1.Value}),{S.Country}); %search for all airports of a country
    Lo=[S(select).Longitude]; %extract Longitude 
    La=[S(select).Latitude]; %extract Latitude
    %convert Longitude/Latitude into 3d coordinates
    X=-(cos(La./180.*pi).*cos(Lo./180.*pi)); 
    Y=-(cos(La./180.*pi).*sin(Lo./180.*pi));
    Z=sin(La./180.*pi);
    
    hold(ax5,'on');%hold axes on
    plot3(ax5,X,Y,Z,'.r'); %plot the positions of airports
    campos(ax5,[10*sqrt(3)*X(1)  10*sqrt(3)*Y(1)  10*sqrt(3)*Z(1)]); %adjust camera position to see points
    camlight(ax5,'headlight'); %headlight from camera position
    
elseif strcmp(handles.popupmenu3.String{handles.popupmenu3.Value},'All') && ...
        strcmp(handles.popupmenu2.String{handles.popupmenu2.Value},'All')~=1 %Airports: All , plot all airports of a city
    select=cellfun(@(x) strcmp(x,handles.popupmenu2.String{handles.popupmenu2.Value}),{S.City})&...
        cellfun(@(x) strcmp(x,handles.popupmenu1.String{handles.popupmenu1.Value}),{S.Country}); %search all airports of selected city
    %the same as above, convert coordinates of airports and plot them
    Lo=[S(select).Longitude];
    La=[S(select).Latitude];
    X=-(cos(La./180.*pi).*cos(Lo./180.*pi));
    Y=-(cos(La./180.*pi).*sin(Lo./180.*pi));
    Z=sin(La./180.*pi);
    hold(ax5,'on');
    plot3(ax5,X,Y,Z,'.r');
    campos(ax5,[10*sqrt(3)*X(1)  10*sqrt(3)*Y(1)  10*sqrt(3)*Z(1)]);
    camlight(ax5,'headlight');
    
elseif strcmp(handles.popupmenu2.String{handles.popupmenu2.Value},'All') && ...
        strcmp(handles.popupmenu3.String{handles.popupmenu3.Value},'All')~=1 %City:All but not for Airport, specify one airport
    
    select=cellfun(@(x) strcmp(x,handles.popupmenu3.String{handles.popupmenu3.Value}),{S.Name}) &...
         cellfun(@(x) strcmp(x,handles.popupmenu1.String{handles.popupmenu1.Value}),{S.Country}); %specify the airport by filtering through country and airport name
     %the same as above, convert coordinates of airports and plot them
    Lo=[S(select).Longitude];
    La=[S(select).Latitude];
    X=-(cos(La./180.*pi).*cos(Lo./180.*pi));
    Y=-(cos(La./180.*pi).*sin(Lo./180.*pi));
    Z=sin(La./180.*pi);
    hold(ax5,'on');
    plot3(ax5,X,Y,Z,'.r');
    campos(ax5,[10*sqrt(3)*X(1)  10*sqrt(3)*Y(1)  10*sqrt(3)*Z(1)]);
    camlight(ax5,'headlight');
else   %country, city and name of airport all specified
    select=cellfun(@(x) strcmp(x,handles.popupmenu3.String{handles.popupmenu3.Value}),{S.Name}) & ...
    cellfun(@(x) strcmp(x,handles.popupmenu2.String{handles.popupmenu2.Value}),{S.City}); %search by city and airport name
    %the same as above, convert coordinates of airports and plot them
    Lo=[S(select).Longitude];
    La=[S(select).Latitude];
    X=-(cos(La./180.*pi).*cos(Lo./180.*pi));
    Y=-(cos(La./180.*pi).*sin(Lo./180.*pi));
    Z=sin(La./180.*pi);
    hold(ax5,'on');
    plot3(ax5,X,Y,Z,'.r');
    campos(ax5,[10*sqrt(3)*X(1)  10*sqrt(3)*Y(1)  10*sqrt(3)*Z(1)]);
    camlight(ax5,'headlight');
end
set(handles.text23,'String','Done.');%update state message

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles) %the button executes search by Latitude, Longitude and Altitude
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text24,'String','Loading...') %update Loading message
pause(1); %show message
global S; %use database
cla(handles.axes5,'reset'); %clear axes
load topo; %load world colormap
ax5=handles.axes5;

% plot the earth 
[x,y,z] = sphere(45); 
surface(handles.axes5,x,y,z,'FaceColor','texturemap','CData',topo,'EdgeColor','none');
ax5.Colormap=topomap1;
brighten(ax5,.1);
lighting(ax5,'gouraud');
axis(ax5,'vis3d','off');
%select data of airports by Longitude, Latitude and Altitude
select=[S.Longitude]>=handles.slider1.Value&[S.Longitude]<=handles.slider2.Value...
    &[S.Latitude]>=handles.slider4.Value&[S.Longitude]<=handles.slider5.Value...
    &[S.Altitude]>=handles.slider6.Value&[S.Altitude]<=handles.slider7.Value;
%Extract Latitude and Longitude of selected airports
Lo=[S(select).Longitude];
La=[S(select).Latitude];
%convert to 3d coordinates
X=-(cos(La./180.*pi).*cos(Lo./180.*pi));
Y=-(cos(La./180.*pi).*sin(Lo./180.*pi));
Z=sin(La./180.*pi);

hold(ax5,'on');%hold earth on

if isempty(X) % if nothing searched 
    %return earth itself and adjust camera position
    camlight(ax5); 
    campos(ax5,[10  10  10]);
else
    %else plot the positions of airports and adjust camera position
    plot3(ax5,X,Y,Z,'.r');
    campos(ax5,[10*sqrt(3)*X(1)  10*sqrt(3)*Y(1)  10*sqrt(3)*Z(1)]);
    camlight(ax5,'headlight');
end
set(handles.text24,'String','Done.') %update state message as Done

%those sliders are selecting Longitude, Latitude and Altitude in Searching
%Page.

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles) %this sets the minimum of Longitude
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.text17,'String',hObject.Value); %show the corresponding value at top of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles) %this sets the maximum of Longitude
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.text18,'String',hObject.Value);%show the corresponding value at top of slider

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles) %this sets the minimum of Latitude
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.text19,'String',hObject.Value);%show the corresponding value at top of slider

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles) %this sets the maximum of Latitude
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.text20,'String',hObject.Value);%show the corresponding value at top of slider

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles) %this sets the minimum of Altitude
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.text21,'String',hObject.Value);%show the corresponding value at top of slider

% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)  %this sets the maximum of Altitude
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.text22,'String',hObject.Value);%show the corresponding value at top of slider

% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%those popupmenus are selecting country, city and name of departure and
%destination airport in Route Tracking Page, actually function like the popupmenus in Searching
%Page.

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles) %this is the country list of starting airport in Route Tracking page
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
set(handles.text36,'String','Loading...')
pause(0.1);
global S; %use database
fun=cellfun(@(x) strcmp(x,hObject.String{hObject.Value}),{S.Country}); 
set(handles.popupmenu5,'Value',1);
set(handles.popupmenu5,'String',unique({S(fun).City}));
fun=cellfun(@(x) strcmp(x,handles.popupmenu5.String{handles.popupmenu5.Value}),{S.City})&...
    cellfun(@(x) strcmp(x,handles.popupmenu4.String{handles.popupmenu4.Value}),{S.Country});
set(handles.popupmenu6,'Value',1);
set(handles.popupmenu6,'String',unique({S(fun).Name}));
set(handles.text36,'String','Ready.')


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles) %this is the city list of starting airport in Route Tracking page
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
set(handles.text36,'String','Loading...')
pause(0.1);
global S;
fun=cellfun(@(x) strcmp(x,handles.popupmenu5.String{handles.popupmenu5.Value}),{S.City})&...
    cellfun(@(x) strcmp(x,handles.popupmenu4.String{handles.popupmenu4.Value}),{S.Country});
set(handles.popupmenu6,'Value',1);
set(handles.popupmenu6,'String',unique({S(fun).Name}));
set(handles.text36,'String','Ready.')




% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)  %this is the name list of starting airport in Route Tracking page
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)   %this is the country list of destination airport in Route Tracking page
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7
set(handles.text36,'String','Loading...')
pause(0.1)
global S;
fun=cellfun(@(x) strcmp(x,hObject.String{hObject.Value}),{S.Country});
set(handles.popupmenu8,'Value',1);
set(handles.popupmenu8,'String',unique({S(fun).City}));
fun=cellfun(@(x) strcmp(x,handles.popupmenu8.String{handles.popupmenu8.Value}),{S.City})&...
    cellfun(@(x) strcmp(x,handles.popupmenu7.String{handles.popupmenu7.Value}),{S.Country});
set(handles.popupmenu9,'Value',1);
set(handles.popupmenu9,'String',unique({S(fun).Name}));
set(handles.text36,'String','Ready.')


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)  %this is the city list of destination airport in Route Tracking page
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8
set(handles.text36,'String','Loading...')
pause(0.1)
global S;
fun=cellfun(@(x) strcmp(x,handles.popupmenu8.String{handles.popupmenu8.Value}),{S.City})&...
    cellfun(@(x) strcmp(x,handles.popupmenu7.String{handles.popupmenu7.Value}),{S.Country});
set(handles.popupmenu9,'Value',1);
set(handles.popupmenu9,'String',unique({S(fun).Name}));
set(handles.text36,'String','Ready.')



% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles) %this is the name list of destination airport in Route Tracking page
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles) %the toggle button in Route Tracking Page controls the rotation of earth
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3
while handles.togglebutton3.Value==0 %if not pressed stop
        for i=linspace(0,2*pi,501) 
            handles.axes1.CameraPosition=[10*sqrt(3)*cos(i) 10*sqrt(3)*sin(i) 0]; %roll position of earth
            drawnow; %show rotation
        end
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
