function V_seg = Stephen_final(V_seg)
%V_seg.info{7,1} es el angulo del eje largo
%V_seg.info{8,1} es la coordenada


%Primero se gira
V_seg = Rotar_3D(V_seg);

%Luego se crea la rx
rx = crear_rx(V_seg);
V_seg.rx = rx;

%Ahora se ponen los puntos. El caso de linea == 1 es intercambiable por
%algo automatico siempre que la pendiente sea distinta de infinito

%1. Poner los puntos

f = figure;
linea = 1;
mensaje = {'Primero crearemos el eje mecanico', 'Ponga el punto 1(mas anterior) para crear la linea 1', 'Ponga el punto 2 (mas posterior) para crear la linea 2', 'Ponga el punto 3 (mas distal) para crear la linea 3'};
lineas = {};

while linea <= 4 
imshow(rx);
uiwait(msgbox(mensaje(linea)));
hold on
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
    V_seg.info{7,1} = atand(m1);
    
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
       



linea = linea +1;
elegida = 0;
end

% Encontrar coordenada punto

v_usar = V_seg.femur.fisis + V_seg.femur.bones;
encontrado = 0;
contador = 1;
while (contador <= size(v_usar,3) && encontrado ==0)
    if v_usar(Aproximar(coordenada(1)),Aproximar(coordenada(2)),contador)>0
        coord_3D = [Aproximar(coordenada(1)),Aproximar(coordenada(2)),contador];
        coord_3D = double(coord_3D);
        uiwait(msgbox('PUNTO ENCONTRADO'));
        encontrado =1;
        contador = contador-1;
    end
    contador = contador+1;    
end
V_seg.info{8,1} = coord_3D;

end

