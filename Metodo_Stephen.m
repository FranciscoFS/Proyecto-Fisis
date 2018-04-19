%%
%0 Seleccionar rodilla
clear all
close all
uiwait(msgbox('Seleccione la Rodilla a anlizar'));

[filename, pathname, filterindex] = uigetfile();
addpath(pathname)
load(filename)

fisis_usar = V_seg.femur.fisis;
hueso_usar = V_seg.femur.bones;
info = V_seg.info;
%% Rotar para que queden como ideales
% syms t
% Rx = [1 0 0; 0 cos(t) -sin(t); 0 sin(t) cos(t)];
% Ry = [cos(t) 0 sin(t); 0 1 0; -sin(t) 0 cos(t)];
% Rz = [cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1];
% R = Rx*Ry*Rz;

%
%dos puntos para pendiente, los otros dos para crear anterior posterior, el
%3 para distal. Calcular la distancia de anterior posterior: buscar formula
%o crear una recta perpendicular a L1, hacer interseccion con L2 y esos
%puntos medir distancia. Luego multiplicar por los porcentajes y asi se
%tienen las distancias
% ahora crear rectas que esten a esa distancia de las otras
%%
%1. Poner los puntos
i = 1;
f = figure;
V = V_seg.vol.orig;
elegida = 0;
btn1 = uicontrol('Style', 'pushbutton', 'String', 'Esta Slide',...
        'Position', [20 20 50 20],...
        'Callback', 'elegida = 1');
linea = 1;
mensaje = {'Primero crearemos el eje mecanico', 'Ponga el punto 1(mas anterior) para crear la linea 1', 'Ponga el punto 2 (mas posterior) para crear la linea 2', 'Ponga el punto 3 (mas distal) para crear la linea 3'};
lineas = {};

while linea <= 4
uiwait(msgbox('Seleccione la slide para elegir los puntos correspondientes. Haga click con el mouse para la siguiente. Presione una tecla para la anterior'));
uiwait(msgbox(mensaje(linea)));  
while (i > 0 && elegida == 0)
imshow(V(:,:,i),[])
hold on
k = waitforbuttonpress;
if elegida == 1
    i= i-1;
    if i < 1
        i = 1;
    end
    imshow(V(:,:,i),[])
    
    
    if linea ==1
        uiwait(msgbox('Ingrese dos puntos para el primer circulo, con el ultimo haga doble click'));
        [Y1,X1] = getpts();
        uiwait(msgbox('Ingrese dos puntos para el segundo circulo, con el ultimo haga doble click'));
        [Y2,X2] = getpts();
        %Punto medio
        centro1 = [(X1(1)+X1(2))/2,(Y1(1)+Y1(2))/2];
        centro2 = [(X2(1)+X2(2))/2,(Y2(1)+Y2(2))/2];
        x = [centro1(1),centro2(1)];
        y = [centro1(2),centro2(2)];
        
        syms p
        m1 = (y(2)-y(1))/(x(2)-x(1));
        q = symfun(m1*(p-x(1))+y(1),[p]);
        
        P1 = [x(1),y(1)];
        P2 = [x(2),y(2)];
        x(2) = x(1) + 500;
        x(1) = x(1) - 500;
        y(1) = q(x(1));
        y(2) = q(x(2));
        plot([y(1),y(2)],[x(1),x(2)],'LineWidth',3)
        lineas{1,1} = y;
        lineas{1,2} = x;
        uiwait(msgbox('Linea almacenada'));
        
    elseif linea ==2
        [y,x]= getpts(); %Por que los da "al reves"
        q2 = symfun(m1*(p-x(1))+y(1),[p]);
        P3 = [x(1),y(1)];
        x(2) = x(1) + 500;
        x(1) = x(1) - 500;
        y(1) = q2(x(1));
        y(2) = q2(x(2));
        plot([y(1),y(2)],[x(1),x(2)],'LineWidth',3)
        lineas{2,1} = y;
        lineas{2,2} = x;
        
        uiwait(msgbox('Linea almacenada'));
        
    elseif linea ==3
        [y,x]= getpts(); %Por que los da "al reves"
        q3 = symfun(m1*(p-x(1))+y(1),[p]);
        P4 = [x(1),y(1)];
        x(2) = x(1) + 500;
        x(1) = x(1) - 500;
        y(1) = q3(x(1));
        y(2) = q3(x(2));
        plot([y(1),y(2)],[x(1),x(2)],'LineWidth',3)
        lineas{3,1} = y;
        lineas{3,2} = x;
        uiwait(msgbox('Linea almacenada'));
        
    elseif linea ==4
        [y,x]= getpts(); %Por que los da "al reves"
        m_perp = -1/m1;
        q4 = symfun(m_perp*(p-x(1))+y(1),[p]);
        
        P5 = [x(1),y(1)];
        x(2) = x(1) + 500;
        x(1) = x(1) - 500;
        y(1) = q4(x(1));
        y(2) = q4(x(2));
        plot([y(1),y(2)],[x(1),x(2)],'LineWidth',3)
        lineas{4,1} = y;
        lineas{4,2} = x;
        
        %linea 5
        hold on
        x2=solve(q2==q4);
        y2=q2(x2);        
        x3=solve(q3==q4);
        y3=q3(x3);

        xy = [x2,y2;x3,y3];
        d_ant = pdist(xy,'euclidean')*0.59;
        d_distal= pdist(xy,'euclidean')*0.51;
        
        syms xx yy
        eqn1 = (xx-x2)^2 + (yy-y2)^2 == d_ant^2;
        eqn2 = m_perp*(xx-x2)== yy-y2;
        sol = solve([eqn1, eqn2], [xx, yy]);
        
        xSol = sol.xx;
        ySol = sol.yy;
        
        scatter(ySol(1),xSol(1),100,'d','filled')
        scatter(ySol(2),xSol(2),100,'s','filled')
        
        message = sprintf('Cual de las dos soluciones es la correcta?');
        reply = questdlg(message,...
            'Forma',...
            'Diamante', 'Cuadrado', 'No','No');

        if strcmpi(reply,'Diamante')
            resp = 1;
        else
            resp = 2;
        end

        xSol = sol.xx(resp);
        ySol = sol.yy(resp);
       
        q5 = symfun(m1*(p-xSol)+ySol,[p]);
        
        P6 = [xSol,ySol];
        
        x(2) = xSol + 500;
        x(1) = xSol - 500;
        y(1) = q5(x(1));
        y(2) = q5(x(2));
        plot([y(1),y(2)],[x(1),x(2)],'LineWidth',3)
        
        lineas{5,1} = y;
        lineas{5,2} = x;
        
        %Linea 6 e interseccion
        syms xx2 yy2
        eqn3 = (xx2-xSol)^2 + (yy2-ySol)^2 == d_distal^2;
        eqn4 = m1*(xx2-xSol)== yy2-ySol;
        sol = solve([eqn3, eqn4], [xx2, yy2]);
        xSol2 = sol.xx2;
        ySol2 = sol.yy2;
        
        scatter(ySol2(1),xSol2(1),100,'d','filled')
        scatter(ySol2(2),xSol2(2),100,'s','filled')
        message = sprintf('Cual de las dos soluciones es la correcta?');
        reply = questdlg(message,...
            'Forma',...
            'Diamante', 'Cuadrado', 'No','No');
        
        if strcmpi(reply, 'Diamante')
            resp = 1;
        else
            resp = 2;
        end
        
        coordenada = [xSol2(resp),ySol2(resp)];
        uiwait(msgbox('Punto encontrado!'));

    end
    elegida = 1;    
elseif (k == 0 && elegida == 0)
    i = i+1;
    if i > size(V,3)
        i =size(V,3);
    end
elseif (k == 1 && elegida == 0)
    i= i-1;
    if i < 1
        i = 1;
    end
end

end
linea = linea +1;
elegida = 0;
end



%% Punto

v_usar = V_seg.femur.fisis + V_seg.femur.bones;
encontrado = 0;
contador = 1;
while (contador <= size(v_usar,3) && encontrado ==0)
    if v_usar(Aproximar(coordenada(1)),Aproximar(coordenada(2)),contador)==1
        uiwait(msgbox('PUNTO ENCONTRADO'));
        encontrado =1;
        imshow(V(:,:,contador),[])
        hold on
        scatter(coordenada(2),coordenada(1),80,'s','filled')
        for n = 1:5
        plot([lineas{n,1}(1),lineas{n,1}(2)],[lineas{n,2}(1),lineas{n,2}(2)],'LineWidth',3);
        end
    end
    contador = contador+1;    
end


%% 3D
isosurf_2(fisis_usar,hueso_usar,info);
hold on
[x,y,z] = sphere;
surf(x+coordenada(2),y+coordenada(1),z+contador)
plot3(coordenada(2),coordenada(1),i,'s','markerface','b','MarkerSize', 100)
        
        
    

