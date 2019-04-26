function V_seg = Schottle_final(V_seg)

V_seg.mascara = (V_seg.mascara < 8).*(V_seg.mascara);

% Primero se gira

%V_seg = Rotar_3D(V_seg);
%     Az = Angulo_Z(V_seg);
%     Eje = 'Z';
%     V_seg = Rotar(V_seg,Az,Eje);

% Luego se crea la rx
[rx_femur] = crear_rx(V_seg);

%imshow(rx_femur,[])

linea = 1;
mensaje = {'Ponga dos puntos en la cortical posterior para crear la linea 1','Ponga el punto 1 para crear la linea 2', 'Ponga el punto 2 para crear la linea 3'};

while linea <= 3
    imshow(rx_femur,[]);
    uiwait(msgbox(mensaje(linea)));
    if linea ==1
        imshow(rx_femur);
        [y,x] = getpts();
        syms p q
        m1 = (y(2)-y(1))/(x(2)-x(1)); %Da negativo si es "positivo" en plot
        q = symfun(m1*(p-x(1))+y(1),[p]);
        
        %Puntos de la linea 1
        P1 = [x(1),y(1)];
        P2 = [x(2),y(2)];
        
        uiwait(msgbox('Linea almacenada'));
        
    elseif linea ==2
        m_perp = -1/m1;
        [y,x] = getpts();
        
        syms q2
        q2 = symfun(m_perp*(p-x(1))+y(1),[p]);
        
        x2=solve(q==q2);
        y2=q2(x2);
        
        %Puntos de la linea 2
        P3 = [x(1),y(1)];%Punto 1 de schottle
        P4 = [eval(x2),eval(y2)]; %Interseccion 1
        
        uiwait(msgbox('Linea almacenada'));
        
    elseif linea ==3
        [y,x] = getpts();
        syms q3
        q3 = symfun(m_perp*(p-x(1))+y(1),[p]);
        
        x3=solve(q==q3);
        y3=q3(x3);
        
        %Puntos de la linea 3
        P5 = [x(1),y(1)];%Punto 2 de schottle
        P6 = [eval(x3),eval(y3)];%Interseccion 2
        
        uiwait(msgbox('Linea almacenada'));
        
      
    end
    linea = linea +1;
end

%Plotear
imshow(rx_femur,[]);
hold on
plot([P1(2),P2(2)],[P1(1),P2(1)],'LineWidth',3)
plot([P3(2),P4(2)],[P3(1),P4(1)],'LineWidth',3);
plot([P5(2),P6(2)],[P5(1),P6(1)],'LineWidth',3);

%Matematica

dz = V_seg.info{2,1};
dx = V_seg.info{1,1};

pix_dx1 = 1.3/dx;
pix_dx2 = 2.5/dx;
pix_dx3 = 3/dx;

alph = atand(m_perp);
pix_x = (cosd(alph)*pix_dx1);
pix_y = (sind(alph)*pix_dx1);

alph2 = atand(m1);
pix_x2 = (cosd(alph2)*pix_dx1);
pix_y2 = (sind(alph2)*pix_dx1);

%Punto anterior de linea 2
P7 = [P4(1)-pix_x,P4(2)-pix_y];
P8 = [P7(1)-pix_x2,P7(2)-pix_y2];


v.usar = (V_seg.mascara == 2)+(V_seg.mascara ==1)>0;
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

V_seg.info{9} = coord_3D;

end