function isosurf(fisis,cortical,info)

%Cargar fisis promedio
message = sprintf('De donde cargar la fisis?');
reply = questdlg(message,'Fisis', 'Workspace', 'Desde un archivo', 'No');

if strcmpi(reply, 'Desde un archivo')
        [filename, pathname] = uigetfile({'*.mat';'*.m';'*.slx';'*.*'},'Seleccione las fisis a analizar');
        load(filename)
end

%Cargar cortical promedio
message = sprintf('De donde cargar la cortical?');
reply = questdlg(message,'Cortical', 'Workspace', 'Desde un archivo', 'No');

if strcmpi(reply, 'Desde un archivo')
        [filename, pathname] = uigetfile({'*.mat';'*.m';'*.slx';'*.*'},'Seleccione las fisis a analizar');
        load(filename)
end

%Proporciones RM
if exist('info') == 1
    dxdy = info.PixelSpacing{1};
    dz = info.SliceThickness;
else
    dxdy = inputdlg('Ingrese dxdy');
    dxdy = str2double(dxdy);
    dz = inputdlg('Ingrese dz');
    dz = str2double(dz);
    
%Partch fisis
pace = (1/(dz/dxdy));
[m,n,k] = size(fisis);
[Xq,Yq,Zq] = meshgrid(1:m,1:n,1:pace:k);
W =interp3(fisis,Xq,Yq,Zq,'cubic');
W = smooth3(W);
p1= patch(isosurface(W),'FaceColor','red','EdgeColor','none','FaceAlpha','0.95');

%Partch Cortical
pace = (1/(dz/dxdy));
[m,n,k] = size(cortical);
[Xq,Yq,Zq] = meshgrid(1:m,1:n,1:pace:k);
W =interp3(cortical,Xq,Yq,Zq,'cubic');
W = smooth3(W);
p2= patch(isosurface(W),'FaceColor','none','EdgeColor','blue','Marker','*','LineWidth',0.1,'EdgeAlpha','0.4','MarkerSize',0.5);
reducepatch(p2,0.01)

%Vista y Luz
view(3)
axis tight
l = camlight('headlight');
lighting gouraud
material dull
title('Fisis')

%Para que la luz siempre apunte del frente al girarlo
while true
camlight(l,'headlight')
pause(0.05);
end
end

