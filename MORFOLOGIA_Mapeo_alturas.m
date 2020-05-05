function V_seg = MORFOLOGIA_Mapeo_alturas(V_seg)

[V_seg] = Rotar2(V_seg,V_seg.info{25,1}(1,1),'Z');

vol = double(V_seg.mascara ==2); %fisis
tam1 = size(V_seg.mascara,3);
tam2 = size(V_seg.mascara,2);
mapeo = zeros(tam1,tam2);


for i=1:tam1
    im = vol(:,:,i);
    for j=1:tam2
        columna = im(:,j);
        primero = find(columna,1,'first');
        if isempty(primero)
            primero = 0;
        end
        mapeo(i,j) = primero;
    end
end

ceros = ~mapeo;
menor = min(mapeo(mapeo>0));
mayor = max(mapeo(mapeo>0));
mapeo(ceros) = menor;

mapeo = mapeo*(-1);
mapeo = mapeo+mayor;
mapeo(ceros) = 0;
%menor = min(mapeo(:));
%mapeo = mapeo-menor;

dz = V_seg.info{2,1};
dx = V_seg.info{1,1};
pace = (dx/dz);
[Xq,Zq] = meshgrid(1:tam2,1:pace:tam1);
nuevo_mapeo = interp2(mapeo,Xq,Zq);
nuevo_mapeo = nuevo_mapeo*dx;
dif_en_mm = (max(nuevo_mapeo(:))- min(nuevo_mapeo(:)));
%nuevo_mapeo = rescale(nuevo_mapeo,0,dif_en_mm);

figure
[X,Y] = meshgrid(1:size(nuevo_mapeo,2),1:size(nuevo_mapeo,1));
s = surf(X,Y,nuevo_mapeo);
hold on
ax = gca;
ax.DataAspectRatio= [1,1,dx];

colorbar
%legend ('mm desde linea media-lateral')
s.LineStyle = 'none';
%cameratoolbar
contour(nuevo_mapeo,7,'LineColor', 'black')


figure
contour3(nuevo_mapeo,7,'LineWidth',1.5)
colorbar
ax = gca;
ax.DataAspectRatio= [1,1,dx];
%montage(vol)

%% Maximos
% 
% regmax = imregionalmax(nuevo_mapeo);
% mayor10 = imhmax(nuevo_mapeo,19);
% 
% % figure
% % imshow(regmax)
% figure
% imshow(mayor10)


%% Dividir en 3 lateral medial
figure
imshow(nuevo_mapeo,[])
colormap(jet(256));
colorbar;
bw = nuevo_mapeo>1; %
bw = bwareaopen(bw, 300);
%imshow(bw,[])
hold on
centro = regionprops(bw,'centroid');
centro = cat(1,centro.Centroid);
%scatter(centro(1),centro(2),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'r')

%[labeledImage, numberOfRegions] = bwlabel(nuevo_mapeo)
% [left, top, width, height].
%Just be aware that the left and top are 0.5 pixels to the left and above
bb = regionprops(bw,'BoundingBox');
bb = cat(1,bb.BoundingBox);

%%Dividir en 4
% medio_ancho = Aproximar(bb(3)/2);
% medio_altura = Aproximar(bb(4)/2);
% rectangle('Position',bb,'EdgeColor','b','LineWidth',1 );
% x = Aproximar(bb(1));
% y = Aproximar(bb(2));
% rectangle('Position',[bb(1),bb(2),medio_ancho,medio_altura],'EdgeColor','g','LineWidth',1 );

%Tamaño fisis:
distancia_LM = bb(4)*dx;
distancia_AP = bb(3)*dx;
volumen_fisis = sum(vol(:))*dx*dx*dz ; %(en mm3)

V_seg.info{16,1} = {centro;bb};
V_seg.info{17,1} = [distancia_LM;distancia_AP;dif_en_mm];
V_seg.info{18,1} =  [volumen_fisis];

%Dividir en 3

tercio_ancho = Aproximar(bb(4)/3); %lateral-medial
tercio_AP = Aproximar(bb(3)/3); %AP
rectangle('Position',bb,'EdgeColor','b','LineWidth',1 );
x = Aproximar(bb(1));
y = Aproximar(bb(2));
x2 = Aproximar(bb(3));
y2 = Aproximar(bb(4));

%Dibujar 3 rectangulos LM
rectangle('Position',[bb(1),bb(2),bb(3),tercio_ancho],'EdgeColor','y','LineWidth',1.5 );
rectangle('Position',[bb(1),bb(2)+tercio_ancho,bb(3),tercio_ancho],'EdgeColor','y','LineWidth',1.5 );
rectangle('Position',[bb(1),bb(2)+2*tercio_ancho,bb(3),tercio_ancho],'EdgeColor','y','LineWidth',1.5 );

suma1 = 0;
contador = 0;
max1 = 0;
min1 = 50;
for i = x:x+x2
    for j = y:y+tercio_ancho
        if nuevo_mapeo(j,i)> max1
            max1 =nuevo_mapeo(j,i);
        end
        if nuevo_mapeo(j,i)< min1
            min1 = nuevo_mapeo(j,i);
        end
        suma1 = suma1 + nuevo_mapeo(j,i);
        contador = contador +1;
        if nuevo_mapeo(j,i) == 0
            contador = contador -1;
        end
    end
end
promedio1 = (suma1/contador);

suma2 = 0;
contador = 0;
max2 = 0;
min2 = 50;
for i = x:x+x2
    for j = y+tercio_ancho:y+(2*tercio_ancho)
        if nuevo_mapeo(j,i)> max2
            max2 =nuevo_mapeo(j,i);
        end
        if nuevo_mapeo(j,i)< min2
            min2 = nuevo_mapeo(j,i);
        end
        suma2 = suma2 + nuevo_mapeo(j,i);
        contador = contador +1;
        if nuevo_mapeo(j,i) == 0
            contador = contador -1;
        end
    end
end
promedio2 = (suma2/contador);

suma3 = 0;
contador = 0;
max3 = 0;
min3 = 50;
for i = x:x+x2
    for j = y+(2*tercio_ancho):y+y2
        if nuevo_mapeo(j,i)> max3
            max3 =nuevo_mapeo(j,i);
        end
        if nuevo_mapeo(j,i)< min3
            min3 = nuevo_mapeo(j,i);
        end
        suma3 = suma3 + nuevo_mapeo(j,i);
        contador = contador +1;
        if nuevo_mapeo(j,i) == 0
            contador = contador -1;
        end
    end
end
promedio3 = (suma3/contador);

V_seg.info{19,1} = [promedio1;promedio2;promedio3];
V_seg.info{20,1} = [min1;min2;min3];
V_seg.info{21,1} = [max1;max2;max3];

%% Dividir en 3 anterior posterior

figure
imshow(nuevo_mapeo,[])
colormap(jet(256));
colorbar;

%Dibujar 3 rectangulos
rectangle('Position',[bb(1),bb(2),tercio_AP,bb(4)],'EdgeColor','y','LineWidth',1.5 );
rectangle('Position',[bb(1)+tercio_AP,bb(2),tercio_AP,bb(4)],'EdgeColor','y','LineWidth',1.5 );
rectangle('Position',[bb(1)+2*tercio_AP,bb(2),tercio_AP,bb(4)],'EdgeColor','y','LineWidth',1.5 );

suma1 = 0;
contador = 0;
max1 = 0;
min1 = 50;
for i = x:x+tercio_AP
    for j = y:y+y2
        if nuevo_mapeo(j,i)> max1
            max1 =nuevo_mapeo(j,i);
        end
        if nuevo_mapeo(j,i)< min1
            min1 = nuevo_mapeo(j,i);
        end
        suma1 = suma1 + nuevo_mapeo(j,i);
        contador = contador +1;
        if nuevo_mapeo(j,i) == 0
            contador = contador -1;
        end
    end
end
promedio1 = (suma1/contador);

suma2 = 0;
contador = 0;
max2 = 0;
min2 = 50;
for i = x+tercio_AP:x+(2*tercio_AP)
    for j = y:y+y2
        if nuevo_mapeo(j,i)> max2
            max2 =nuevo_mapeo(j,i);
        end
        if nuevo_mapeo(j,i)< min2
            min2 = nuevo_mapeo(j,i);
        end
        suma2 = suma2 + nuevo_mapeo(j,i);
        contador = contador +1;
        if nuevo_mapeo(j,i) == 0
            contador = contador -1;
        end
    end
end
promedio2 = (suma2/contador);

suma3 = 0;
contador = 0;
max3 = 0;
min3 = 50;
for i = x+(2*tercio_AP):x+x2
    for j = y:y+y2
        if nuevo_mapeo(j,i)> max3
            max3 =nuevo_mapeo(j,i);
        end
        if nuevo_mapeo(j,i)< min3
            min3 = nuevo_mapeo(j,i);
        end
        suma3 = suma3 + nuevo_mapeo(j,i);
        contador = contador +1;
        if nuevo_mapeo(j,i) == 0
            contador = contador -1;
        end
    end
end
promedio3 = (suma3/contador);

V_seg.info{22,1} = [promedio1;promedio2;promedio3];
V_seg.info{23,1} = [min1;min2;min3];
V_seg.info{24,1} = [max1;max2;max3];

%% Cerrar todo
close all
end
