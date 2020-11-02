function [porc,pixeles_ya_sumados] = Crear_cilindro_3D_fx(hueso_usar,fisis_usar,V_seg,alpha,gamma,d,p)
%Direccion y distancia

coordenada = single(V_seg.info{12});

dx = single(V_seg.info{1,1});

[~,~,v1] = ind2sub(size(hueso_usar),find(hueso_usar > 0));
Mid = round((max(v1)+min(v1))/2);
vol = hueso_usar(1:size(hueso_usar,1),1:size(hueso_usar,1),Mid: size(hueso_usar,3));

encontrado = 0;
contador = 1;
while (contador <= size(vol,3) && encontrado ==0)
    if vol(Aproximar(coordenada(2)),Aproximar(coordenada(1)),contador)>0
        coord_3D = [(coordenada(1)),(coordenada(2)),Mid + contador];
        encontrado =1;
    end
    contador = contador+1;
end

coordenada = round(coord_3D);

%%
a1 = -gamma;% azimut (+ hacia proximal)
a2 = -alpha;% Elevacion (+ hacia anterior)
mm = p;%Profundidad
diametro = d;

[z,x,y] = sph2cart(deg2rad(a1),deg2rad(a2),mm);

%dif_x
pixeles_x = single(x/dx);

%dif_y
pixeles_y = single(y/dx);

%dif_z
pixeles_z = single(z/dx);


%Crear el círculo
% vector_normal = [];
% vector_normal(1) = sind(-gamma);
% vector_normal(2) = sind(-alpha)*cosd(-gamma);
% vector_normal(3) = cosd(-alpha)*cosd(-gamma);

vector_normal = [single(x),single(y),single(z)];

%X sería ant-post
%Y sería distal-prox
%Z sería medial-lat

radio = diametro/2;
radio_pix = round(radio/dx);

%%

pixeles_ya_sumados = single(zeros(size(hueso_usar)));
[maxX,maxY,maxZ] = size(hueso_usar);

fisis_usar = fisis_usar > 0.5;
total_de_1s = sum(fisis_usar(:));
contador = 1;
porc = zeros(1,length(radio));
se = strel('cube',2);



for r = 1:radio_pix(end)
    puntos = plotCircle3D([coordenada(1),coordenada(2),coordenada(3)],vector_normal,r); % falta saber si es 3,2,1 o 3,1,2

    P1 = [];
    P2 = [];
    
    
    for i  = 1:size(puntos,2)
        
        P1(i,:) = [puntos(2,i),puntos(1,i),puntos(3,i)];
        P2(i,:) = [puntos(2,i)+pixeles_y, puntos(1,i) + pixeles_x, puntos(3,i) + pixeles_z];
        P2(i,:) = round(P2(i,:));
        
        [X, Y, Z] = bresenham_line3d(P1(i,:), P2(i,:));
        Pos = find((round(X) <=  maxX) & (round(Y) <= maxY) & (round(Z) <= maxZ) == 1);
        
        for j  = Pos
            pixeles_ya_sumados(round(X(j)),round(Y(j)),round(Z(j))) = 1;
        end

    end
    
    if r ==radio_pix(contador)
        
        pixeles_ya_sumados = imclose(pixeles_ya_sumados,se);
        pixeles_ya_sumados = pixeles_ya_sumados > 0;

        delta = (fisis_usar - pixeles_ya_sumados) == 1;
        total_1s_resta = sum(delta(:));
        porc(contador) = ((total_de_1s - total_1s_resta)/total_de_1s)*100;
        contador = contador +1;
        
%         figure
%         imshow(pixeles_ya_sumados(:,:,coordenada(3)+20))
        
    end
    
end

% 
% figure
% p1 = patch(isosurface(single(fisis_usar)),'FaceColor','red','EdgeColor','none');
% p2 = patch(isosurface(single(hueso_usar)),'FaceColor','none','EdgeColor','black','LineWidth',0.1,'EdgeAlpha','0.4');
% reducepatch(p2,0.01)
% p3 = patch(isosurface(single(pixeles_ya_sumados), 0.7),'FaceColor','green','EdgeColor','none');
% cam = camlight('headlight');
% lighting gouraud
% material dull
% axis equal


end

