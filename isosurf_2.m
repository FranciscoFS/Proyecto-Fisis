function isosurf_2(fisis,cortical,info)

% %Cargar fisis promedio
% message = sprintf('De donde cargar la fisis?');
% reply = questdlg(message,'Fisis', 'Workspace', 'Desde un archivo', 'No');
% 
% if strcmpi(reply, 'Desde un archivo')
%         [filename, pathname] = uigetfile({'*.mat';'*.m';'*.slx';'*.*'},'Seleccione las fisis a analizar');
%         load(filename)
% end
% 
% %Cargar cortical promedio
% message = sprintf('De donde cargar la cortical?');
% reply = questdlg(message,'Cortical', 'Workspace', 'Desde un archivo', 'No');
% 
% if strcmpi(reply, 'Desde un archivo')
%         [filename, pathname] = uigetfile({'*.mat';'*.m';'*.slx';'*.*'},'Seleccione las fisis a analizar');
%         load(filename)
% end

%Proporciones RM

if exist('info') == 1
<<<<<<< HEAD
    
    dxdy = info{1};
    dz = info{2};

=======
<<<<<<< HEAD
    dxdy = info{1};
    dz = info{2};
=======
    dxdy = info{1,1};
    dz = info{2,1};
>>>>>>> ddc1ba3e1ff306ed5d5c316058a24474d32b9113
>>>>>>> e966550a6949bd06d48b9302159300cdc8fee4bd
else
    dxdy = inputdlg('Ingrese dxdy');
    dxdy = str2double(dxdy);
    dz = inputdlg('Ingrese dz');
    dz = str2double(dz);
end    

%Patch fisis
<<<<<<< HEAD
% Ej
%Ej dx = 0.4688 y dz = 3
% Ej 2 dxdy=0.293; dz =3.5;
%dxdy=0.4688; dz =3;

pace = (1/(dz/dxdy));
[m,n,k] = size(fisis);
[Xq,Yq,Zq] = meshgrid(1:m,1:n,1.5:pace:k);
Box_size = [9 9 9];
=======
%Ej dx = 0.4688 y dz = 3
% Ej 2 dxdy=0.293; dz =3.5;
<<<<<<< HEAD

pace = (1/(dz/dxdy));
[m,n,k] = size(fisis);
[Xq,Yq,Zq] = meshgrid(1:m,1:n,1.5:pace:k);
Box_size = [9 9 9];
=======
%dxdy=0.4688; dz =3;
pace = (1/(dz/dxdy));
[m,n,k] = size(fisis);
[Xq,Yq,Zq] = meshgrid(1:m,1:n,1.5:pace:k);
Box_size = [3 3 3];
>>>>>>> ddc1ba3e1ff306ed5d5c316058a24474d32b9113
>>>>>>> e966550a6949bd06d48b9302159300cdc8fee4bd

fprintf('Working in Fisis ..... \n');

fprintf('Working in Fisis ..... \n');

Y =interp3(fisis,Xq,Yq,Zq,'cubic',0);
Y = smooth3(Y,'box',Box_size);

%Patch Cortical

fprintf('Working in Bone ..... \n');
W =interp3(cortical,Xq,Yq,Zq,'cubic',0);
W = smooth3(W,'box',Box_size);


%Vista y Luz

<<<<<<< HEAD
<<<<<<< HEAD
%isosurface(smooth3(W))

close all

p1= patch(isosurface(W , 0.2),'FaceColor','green','EdgeColor','none','FaceAlpha','0.95');
p2= patch(isosurface(Y , 0.2),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4','MarkerSize',0.5);
=======
close all
p1= patch(isosurface(Y , 0.3),'FaceColor','red','EdgeColor','none','FaceAlpha','0.95');
p2= patch(isosurface(W , 0.5),'FaceColor','none','EdgeColor','blue','Marker','*','LineWidth',0.1,'EdgeAlpha','0.4','MarkerSize',0.5);
>>>>>>> e966550a6949bd06d48b9302159300cdc8fee4bd
reducepatch(p2,0.01)

view(3)
axis equal
daspect([1 1 0.8])
l = camlight('headlight');
lighting gouraud
material dull
title('Fisis')

%Para que la luz siempre apunte del frente al girarlo
%
while true
camlight(l,'headlight')
pause(0.05);
end

end

