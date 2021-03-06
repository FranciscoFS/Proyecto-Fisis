function V_seg = Punto_LCA_femur_manual(V_seg)
%Rodillas: 0 medial y terminan en lateral

vol_1 = single(V_seg.mascara ==1); %hueso femur
vol_2 = single(V_seg.mascara ==2); %fisis femur
vol = single(vol_1 + vol_2);

%Cortar por la mitad el femur (solo 1/2 lateral)

[~,~,v1] = ind2sub(size(vol),find(vol > 0));
Mid = round((max(v1)+min(v1))/2);

vol = vol(1:size(vol,1),1:size(vol,1),Mid: size(vol,3));
%vol3 = V_seg.vol.orig(1:size(vol,1),1:size(vol,1),(size(vol,3)/2): size(vol,3));

%LM: lateral medial
aplastado_LM = squeeze(sum(vol,3));

%Crear linea de Blumensaat
figure
imshow(aplastado_LM,[])
maximize
hold on
uiwait(msgbox('Poner dos puntos a lo largo de la linea de Blumensaat (poner primero el punto m�s anterior/distal)'));
[x,y] = getpts();
syms p q
if x(2) == x(1)
    x(2) = x(2) +1;
end
m1 = (y(2)-y(1))/(x(2)-x(1));
q = symfun(m1*(p-x(1))+y(1),[p]);

%Punto m�s adelante de la linea
y_ant = Aproximar(y(1));
x_ant = Aproximar(x(1));

i = x_ant;
while i>1
    x_prueba = i;
    y_prueba = Aproximar(q(x_prueba));
    if aplastado_LM(y_prueba,x_prueba) ==0
        y_ant = y_prueba;
        x_ant = x_prueba;
        break
    end
    i = i-1;
end
plot([x_ant,x(2)],[y_ant,y(2)],'LineWidth',2)

%Crear linea paralela
uiwait(msgbox('Poner punto mas distal/paralelo'));
[x,y] = getpts();
q2 = symfun(m1*(p-x(1))+y(1),[p]);
x(2) = x(1) + 50;
x(1) = x(1) - 50;
y(1) = q2(x(1));
y(2) = q2(x(2));
plot([x(1),x(2)],[y(1),y(2)],'LineWidth',2)
%Crear linea perpendicular
uiwait(msgbox('Poner punto mas posterior/perpendicular'));
[x,y] = getpts();
m_perp = -1/m1;
q3 = symfun(m_perp*(p-x(1))+y(1),[p]);
x(2) = x(1) + 50;
x(1) = x(1) - 50;
y(1) = q3(x(1));
y(2) = q3(x(2));
plot([x(1),x(2)],[y(1),y(2)],'LineWidth',2)

%Interseccion
x2=solve(q==q3);
y2=q(x2);

x3=solve(q2==q3);
y3=q2(x3);


scatter(x2,y2,100,'o','filled')
scatter(x3,y3,100,'o','filled')

%t=21.7%�2.5% h=33.2%�5.6% t=35.1%�3.5% h=55.3%�5.3%
%Quadrant method

t =(0.217+0.351)/2;
h = (0.332+0.553)/2;

xy = [x2,y2;x3,y3];
d_ant = pdist(xy,'euclidean')*h;

xy2 = [x2,y2;x_ant,y_ant];
d_distal= pdist(xy2,'euclidean')*t;

syms xx yy
eqn1 = (xx-x2)^2 + (yy-y2)^2 == d_ant^2;
eqn2 = m_perp*(xx-x2)== yy-y2;
sol = solve([eqn1, eqn2], [xx, yy]);

xSol = sol.xx;
ySol = sol.yy;

%Que la solucion sea la de al medio
for i = 1:2
    if ySol(i)>y2 && ySol(i)<y3
        if xSol(i)>x2 && xSol(i)<x3
            resp = i;
        elseif xSol(i)<x2 && xSol(i)>x3
            resp = i;
        end
    elseif ySol(i)<y2 && ySol(i)>y3
        if xSol(i)>x2 && xSol(i)<x3
            resp = i;
        elseif xSol(i)<x2 && xSol(i)>x3
            resp = i;
        end
    end
end

%scatter(xSol(resp),ySol(resp),100,'o','filled')

xSol = sol.xx(resp);
ySol = sol.yy(resp);

q5 = symfun(m1*(p-xSol)+ySol,[p]);

x(2) = xSol + 50;
x(1) = xSol - 50;
y(1) = q5(x(1));
y(2) = q5(x(2));
%plot([x(1),x(2)],[y(1),y(2)],'LineWidth',3)

%Linea 6 e interseccion
syms xx2 yy2
eqn3 = (xx2-xSol)^2 + (yy2-ySol)^2 == d_distal^2;
eqn4 = m1*(xx2-xSol)== yy2-ySol;
sol = solve([eqn3, eqn4], [xx2, yy2]);
xSol2 = sol.xx2;
ySol2 = sol.yy2;


for i = 1:2
    if ySol2(i)>y2 && ySol2(i)<y_ant
        if xSol2(i)>x2 && xSol2(i)<x_ant
            resp = i;
        elseif xSol2(i)<x2 && xSol2(i)>x_ant
            resp = i;
        end
    elseif ySol2(i)<y2 && ySol2(i)>y_ant
        if xSol2(i)>x2 && xSol2(i)<x_ant
            resp = i;
        elseif xSol2(i)<x2 && xSol2(i)>x_ant
            resp = i;
        end
    end
end

scatter(xSol2(resp),ySol2(resp),200,'o','filled')


%Encontrar coordenada 3D
coordenada = [xSol2(resp),ySol2(resp)];

encontrado = 0;
contador = 1;
while (contador <= size(vol,3) && encontrado ==0)
    if vol(Aproximar(coordenada(2)),Aproximar(coordenada(1)),contador)>0
        coord_3D = [Aproximar(coordenada(1)),Aproximar(coordenada(2)),Mid + contador-1];
        coord_3D = double(coord_3D);
        uiwait(msgbox('PUNTO ENCONTRADO'));
        encontrado =1;
    end
    contador = contador+1;
end
V_seg.info{12} = coord_3D;

close(gcf)


end