cla reset;
load topo;
[x,y,z] = sphere(90);
surface(x,y,z,'FaceColor','texturemap','CData',topo,'EdgeColor','none');
colormap(topomap1);
%Brighten the colormap for better annotation visibility:
brighten(.1)
%Create and arrange the camera and lighting for better visibility:

camlight;
lighting gouraud;
axis off vis3d;
%while true
    for i=linspace(0,2*pi,501)
    campos([10*sqrt(2)*cos(i) 10*sqrt(2)*sin(i) 10]);
    drawnow;
    end
%end