%% Creacion Volumen Cilindro

[Xx,Yy,Zz] = meshgrid(0:0.1:10,0:0.1:10,0:0.1:10);
r = 2;
Po = [5 5 0];

Cilindro = ((Xx-Po(1)).^2 + (Yy-Po(2)).^2 <= r^2);
Cilindro_rot = imrotate3(single(Cilindro),45,[0 1 1],'nearest','crop');

isosurface(Cilindro,0.9);
isosurface(Cilindro_rot,0.9);
axis equal



%% Test

tic;
coordenada = Rodilla.info{12};

dz = Rodilla.info{2,1}*2;
dx = Rodilla.info{1,1}*2;
pace = dx/dz;

Femur = Rodilla.mascara==1;
Fisis = Rodilla.mascara == 2;
[m,n,k] = size(Femur);
[Xx,Yy,Zz] = meshgrid(1:2:m,1:2:n,1:2*pace:k);  % Reducir dimension a la mitad
Femur = interp3(Femur,Xx,Yy,Zz,'nearest');
Fisis = interp3(Fisis,Xx,Yy,Zz,'nearest');

[~,~,v1] = ind2sub(size(Femur),find(Femur > 0));
Mid = round((max(v1)+min(v1))/2);
vol = Femur(1:size(Femur,1),1:size(Femur,1),Mid: size(Femur,3));

encontrado = 0;
contador = 1;

    while (contador <= size(vol,3) && encontrado ==0)
        if vol(Aproximar(coordenada(2)/2),Aproximar(coordenada(1)/2),contador)>0
            coord_3D = [Aproximar(coordenada(1)),Aproximar(coordenada(2)),Mid + contador];
            encontrado =1;
            
        end
        contador = contador+1;
    end

coordenada = coord_3D;
%%
% [Xx_o,Yy_o,Zz_o] = meshgrid((1:2:m)-coordenada(1),(1:2:n)-coordenada(2),(1:2*pace:k));
% Cilindro = ((Xx_o).^2 + (Yy_o).^2 <= radio^2);
% %Cilindro = imresize3(single(Cilindro), size(Femur));

Diametro = 10;
radio = round((2/dx)*(Diametro/2)); 
Cilindro = ((Xx - m/2).^2 + (Yy -n/2).^2 <= radio^2);

gamma = 65; %EJe Y
Alpha = 15; %Eje X, negativo hacia ariiba
% 
% Matriz = [1 0 0 0;0 1 0 0; 0 0 1 0; 0 200 0 1];
% Tfx = affine3d(Matriz);

tic;
CilindroR = imrotate3(single(Cilindro),gamma,[0 1 0],'nearest','crop'); 
CilindroR = imrotate3(single(CilindroR),Alpha,[-1 0 0],'nearest','crop'); 

Traslacion = [coordenada(1)/2-(m/4), coordenada(2)/2-(n/4),coordenada(3)-size(Cilindro,3)/2];
CilindroR = imtranslate(CilindroR,Traslacion);

%CilindroR = imwarp(CilindroR,Tfx);

%[X (Cefalico -caudal,negativo hacia arriba) Y (Anterior)

toc;

fisis_usar = Fisis > 0.5;
total_de_1s = sum(fisis_usar(:));
delta = (fisis_usar - CilindroR) == 1;
total_1s_resta = sum(delta(:));
porc = ((total_de_1s - total_1s_resta)/total_de_1s)*100

%%
p1= patch(isosurface(Femur),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
reducepatch(p1,0.01)
p2 = patch(isosurface(Cilindro,0.1),'FaceColor','green','EdgeColor','none');
%p5 = patch(isosurface(Cilindro2),'FaceColor','green','EdgeColor','none');
%p3 = patch(isosurface(smooth3(CilindroR,'bbox',9),0.1),'FaceColor','red','EdgeColor','none');
p3 = patch(isosurface(CilindroR,0.1),'FaceColor','red','EdgeColor','none');
p4 = patch(isosurface(Fisis),'FaceColor','yellow','EdgeColor','none');
hold on;
scatter3(coordenada(1)/2,coordenada(2)/2, coordenada(3));

axis on
l = camlight('headlight');
daspect([1 1 1])
lighting gouraud

material dull
title(['Destruccion' ' ' num2str(porc) ' '])
view(0,0)

