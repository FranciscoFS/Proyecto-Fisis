function V_seg = Schottle_auto_prueba(V_seg)

vol = V_seg.mascara ==1;
%Cortar por la mitad el femur (solo 1/2 medial)
vol2 = vol(1:size(vol,1),1:size(vol,1),1:(size(vol,3)/2));

% Luego se crea la rx
rx_femur = squeeze(sum(vol2,3));

%Linea 1
uiwait(msgbox('Ponga dos puntos en la cortical posterior para crear la linea 1'));
imshow(rx_femur);
[x,y] = getpts();
%Punto de la linea 1
m1 = (y(2)-y(1))/(x(2)-x(1));
angulo_rotacion = atand(-1/m1);

Eje = 'Z';
V_seg = Rotar(V_seg,angulo_rotacion,Eje);

vol = V_seg.mascara ==1;
vol2 = vol(1:size(vol,1),1:size(vol,1),1:(size(vol,3)/2));
rx_femur = squeeze(sum(vol2,3));
imshow(rx_femur);
P0 = [x(1);y(1)];
i = atan(-1/m1);
matriz_rotacion = [cos(i) -sin(i); sin(i) cos(i)];
P0 = matriz_rotacion*P0;

imshow(rx_femur,[]);
uiwait(msgbox('Ponga el punto 1 para crear la linea 2'));
%Puntos de la linea 2
[x,y] = getpts();
P1 = [x(1),y(1)];%Punto 1 de schottle
I1 = [P0(1),y(1)]; %Interseccion 1
uiwait(msgbox('Linea almacenada'));

uiwait(msgbox('Ponga el punto 2 para crear la linea 3'));
%Puntos de la linea 3
[x,y] = getpts();
P2 = [x(1),y(1)];%Punto 2 de schottle
I2 = [P0(1),y(1)];%Interseccion 2
uiwait(msgbox('Linea almacenada'));


%Matematica

dz = V_seg.info{2,1};
dx = V_seg.info{1,1};

pix_ant = 1.3/dx;
pix_distal = 2.5/dx;
pix_dx3 = 3/dx;
pix_radio = 2.5/dx;
area = pi*pix_radio^2;

P_schottle = [P0(1) - pix_ant,P1(2) + pix_distal];

%Plotear
imshow(rx_femur,[]);
hold on

%     scatter(P0(1),P0(2),100,'o','filled')
%     scatter(P1(1),P1(2),100,'o','filled')
%     scatter(P2(1),P2(2),100,'o','filled')
scatter(P_schottle(1),P_schottle(2),area,'o','filled')
plot([P0(1),P0(1)],[P0(2)-500,P0(2)+500],'LineWidth',1)
plot([P1(1)-500,P1(1)+500],[P1(2),P1(2)],'LineWidth',1);
plot([P2(1)-500,P2(1)+500],[P2(2),P2(2)],'LineWidth',1);


v.usar = (V_seg.mascara == 2)+(V_seg.mascara ==1)>0;
encontrado = 0;
contador = 1;

while (contador <= size(v_usar,3) && encontrado ==0)
    if v_usar(Aproximar(coordenada(2)),Aproximar(coordenada(1)),contador)>0
        coord_3D = [Aproximar(coordenada(2)),Aproximar(coordenada(1)),contador];
        coord_3D = double(coord_3D);
        uiwait(msgbox('PUNTO ENCONTRADO'));
        encontrado =1;
        contador = contador-1;
    end
    contador = contador+1;
end

V_seg.info{10} = coord_3D;

end