function V_seg = Schottle_final_manual(V_seg)

vol = V_seg.mascara ==1;
%Cortar por la mitad el femur (solo 1/2 medial)

[~,~,v1] = ind2sub(size(vol),find(vol > 0));
Mid = round((max(v1)+min(v1))/2);

vol = vol(1:size(vol,1),1:size(vol,1),1:Mid);

% Luego se crea la rx
rx_femur = squeeze(sum(vol,3));
imshow(rx_femur);
hold on

%Linea 1
uiwait(msgbox('Ponga dos puntos en la cortical posterior para crear la linea 1'));
[x,y] = getpts();
syms p q
m1 = (y(2)-y(1))/(x(2)-x(1)); %Da negativo si es "positivo" en plot
q = symfun(m1*(p-x(1))+y(1),[p]);

%Puntos de la linea 1
P1 = [x(1),y(1)];
P2 = [x(2),y(2)];
if P1(1) == P2(1)
    P1(1) = P1(1) +1;
end

imshow(rx_femur,[]);
hold on

%Plot linea 1
x(2) = x(1) + 100;
x(1) = x(1) - 100;
y(1) = q(x(1));
y(2) = q(x(2));
plot([x(1),x(2)],[y(1),y(2)],'LineWidth',2)

%Linea 2
uiwait(msgbox('Ponga el punto 1 para crear la linea 2'));
m_perp = -1/m1;
[x,y] = getpts();
syms q2
q2 = symfun(m_perp*(p-x(1))+y(1),[p]);
x2=solve(q==q2);
y2=q2(x2);

%Puntos de la linea 2
P3 = [x(1),y(1)];%Punto 1 de schottle
P4 = [eval(x2),eval(y2)]; %Interseccion 1
scatter(P3(1),P3(2),50,'o','filled')
scatter(P4(1),P4(2),50,'o','filled')

%Plot linea 2
x(2) = x(1) + 100;
x(1) = x(1) - 100;
y(1) = q2(x(1));
y(2) = q2(x(2));
plot([x(1),x(2)],[y(1),y(2)],'LineWidth',2)

%Linea 3
uiwait(msgbox('Ponga el punto 2 para crear la linea 3'));
[x,y] = getpts();
syms q3
q3 = symfun(m_perp*(p-x(1))+y(1),[p]);
x3=solve(q==q3);
y3=q3(x3);

%Puntos de la linea 3
P5 = [x(1),y(1)];%Punto 2 de schottle
P6 = [eval(x3),eval(y3)];%Interseccion 2
scatter(P5(1),P5(2),50,'o','filled')
scatter(P6(1),P6(2),50,'o','filled')

%Plot linea 3
x(2) = x(1) +100;
x(1) = x(1) - 100;
y(1) = q3(x(1));
y(2) = q3(x(2));
plot([x(1),x(2)],[y(1),y(2)],'LineWidth',2)


%Matematica

dz = V_seg.info{2,1};
dx = V_seg.info{1,1};

pix_dx1 = 1.3/dx; %anterior a L1
pix_dx2 = 2.5/dx; %distal a L2
pix_dx3 = 3/dx; %prox a L3

alph = atand(m_perp);
pix_x = (cosd(alph)*pix_dx1);
pix_y = (sind(alph)*pix_dx1);

alph2 = atand(m1);


if alph < 0
    pix_y2 = (cosd(alph)*pix_dx2);
    pix_x2 = (sind(alph)*pix_dx2);
else
    pix_x2 = (cosd(alph2)*pix_dx2);
    pix_y2 = (sind(alph2)*pix_dx2);
end

pix_x3 = (cosd(alph2)*pix_dx3);
pix_y3 = (sind(alph2)*pix_dx3);



%Punto desde linea 2
P7 = [P4(1)-pix_x,P4(2)-pix_y];%punto anterior colineal a L2
if alph < 0
    P8 = [P7(1)-pix_x2,P7(2)+pix_y2]; %Punto Schottle desde L2
else
    P8 = [P7(1)-pix_x2,P7(2)-pix_y2]; %Punto Schottle desde L2
end
scatter(P7(1),P7(2),100,'o','filled')
scatter(P8(1),P8(2),100,'o','filled')

%Punto desde linea 3
P9 = [P6(1)-pix_x,P6(2)-pix_y];%punto anterior colineal a L3
if alph < 0
    P10 = [P9(1)-pix_x3,P9(2)-pix_y3]; %Punto Schottle desde L3
else
    P10 = [P9(1)+pix_x3,P9(2)+pix_y3]; %Punto Schottle desde L3
end

scatter(P9(1),P9(2),150,'o','filled')
scatter(P10(1),P10(2),100,'o','filled')
plot([P9(1),P7(1)],[P9(2),P7(2)],'LineWidth',2)

%Punto medio:
p_medio = [(P8(1)+P10(1))/2;(P8(2)+P10(2))/2];
scatter(p_medio(1),p_medio(2),100,'o','filled')


%Encontrar punto schottle en rodilla 3D
vol2 = (V_seg.mascara == 2)+(V_seg.mascara ==1)>0;
encontrado = 0;
contador = 1;

while (contador <= size(vol2,3) && encontrado ==0)
    if vol2(Aproximar(p_medio(2)),Aproximar(p_medio(1)),contador)>0
        coord_3D_punto = [Aproximar(p_medio(1)),Aproximar(p_medio(2)),contador];
        coord_3D_punto = double(coord_3D_punto);
        uiwait(msgbox('PUNTO ENCONTRADO'));
        encontrado =1;
    end
    contador = contador+1;
end



%Guardar
% puntos_shottle = [P8(1),P8(2);P10(1),P10(2)];
% dist_pixeles = pdist(puntos_shottle,'euclidean');
% dist_mm = dist_pixeles*dx;

V_seg.info{13} = [coord_3D_punto];%Puntos schottle
V_seg.info{14} = [P8];
V_seg.info{15} = [P10];
end