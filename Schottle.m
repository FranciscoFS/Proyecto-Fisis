%0 Seleccionar rodilla
clear all
close all
uiwait(msgbox('Seleccione la Rodilla a anlizar'));

[filename, pathname, filterindex] = uigetfile();
addpath(pathname)
load(filename)

fisis_usar = V_seg.femur.fisis;
hueso_usar = V_seg.femur.bones;

%%
%1. Poner los puntos
uiwait(msgbox('Seleccione la slide para elegir los puntos correspondientes. Haga click con el mouse para la siguiente. Presione una tecla para la anterior'));
i = 1;
f = figure;
V = V_seg.vol.orig;
elegida = 0;
btn1 = uicontrol('Style', 'pushbutton', 'String', 'Esta',...
        'Position', [20 20 50 20],...
        'Callback', 'elegida = 1');
linea = 1;
mensaje = {'Ponga los dos puntos para crear la linea 1', 'Ponga el punto 1 para crear la linea 2', 'Ponga el punto 2 para crear la linea 3'};

while linea <= 3
    
while (i > 0 && elegida == 0)
imshow(V(:,:,i),[])
k = waitforbuttonpress;
if elegida == 1
    i= i-1;
    if i < 1
        i = 1;
    end
    imshow(V(:,:,i),[])
    hold on
    uiwait(msgbox(mensaje(linea)));
    [y,x]= getpts(); %Por que los da "al reves"
    
    if linea ==1
        syms p q
        m1 = (y(2)-y(1))/(x(2)-x(1));
        q = symfun(m1*(p-x(1))+y(1),[p]);

        P1 = [x(1),y(1)];
        P2 = [x(2),y(2)];
        [X1, Y1, Z1] = bresenham_line3d([x(1),y(1),i],[x(2),y(2),i]);
        plot([y(1),y(2)],[x(1),x(2)],'LineWidth',3)

        uiwait(msgbox('Linea almacenada'));
        %hold off
        
    elseif linea ==2
        
        m_perp = -1/m1;
        syms q2
        q2 = symfun(m_perp*(p-x(1))+y(1),[p]);       
        
        x2=solve(q==q2);
        y2=q2(x2);
        
        plot([P1(2),y2],[P1(1),x2],'LineWidth',3)
        plot([y,y2],[x,x2],'LineWidth',3);

        P3 = [x(1),y(1)];
        P4 = [eval(x2),eval(y2)];
        
        [X2, Y2, Z1] = bresenham_line3d([x(1),y(1),i],[eval(x2),eval(y2),i]);
        uiwait(msgbox('Linea almacenada'));
        
    elseif linea ==3

        syms q3
        q3 = symfun(m_perp*(p-x(1))+y(1),[p]);       
        
        x3=solve(q==q3);
        y3=q3(x3);
        
        plot([P1(2),y2],[P1(1),x2],'LineWidth',3)
        plot([P3(2),y2],[P3(1),x2],'LineWidth',3);
        plot([y,y3],[x,x3],'LineWidth',3);
        
        P5 = [x(1),y(1)];
        P6 = [eval(x3),eval(y3)];
        
        [X3, Y3, Z1] = bresenham_line3d([x(1),y(1),i],[eval(x3),eval(y3),i]);
        uiwait(msgbox('Linea almacenada'));

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
hold off
end
linea = linea +1;
elegida = 0;
end

close all

%% Punto de Schottle

dz = V_seg.info{2,1};
dx = V_seg.info{1,1};

pix_dx1 = 1.3/dx;
pix_dx2 = 2.5/dx;
pix_dx3 = 3/dx;

%Nueva recta1
alph = atand(m_perp);
mm_x = (cosd(alph)*pix_dx1);
mm_y = (sind(alph)*pix_dx1);

syms q4
q4 = symfun(m1*(p-(P1(1)-mm_x))+y(1)-mm_y,[p]);
P1n = [P1(1)-mm_x,P1(2)-mm_y];
P2n = [P2(1)-mm_x,P2(2)-mm_y];
plot([P1n(2),P2n(2)],[P1n(1),P2n(1)],'LineWidth',3);

%Nueva recta2
alph = atand(m);
mm_x = (cosd(alph)*pix_dx2);
mm_y = (sind(alph)*pix_dx2);

syms q5
q5 = symfun(m1*(p-(P(1)-mm_x))+y(1)-mm_y,[p]);
P3n = [P3(1)-mm_x,P3(2)-mm_y];
P4n = [P4(1)-mm_x,P4(2)-mm_y];
plot([P3n(2),P4n(2)],[P3n(1),P4n(1)],'LineWidth',3);

schottle_1_x =solve(q4==q5);
schottle_1_y = q4(schottle_1_x);

%Nueva recta3
alph = atand(m_);
mm_x = (cosd(alph)*pix_dx3);
mm_y = (sind(alph)*pix_dx3);
syms q6
q6 = symfun(m1*(p-(P(1)-mm_x))+y(1)-mm_y,[p]);
P5n = [P5(1)-mm_x,P5(2)-mm_y];
P6n = [P6(1)-mm_x,P6(2)-mm_y];
plot([P3n(2),P4n(2)],[P3n(1),P4n(1)],'LineWidth',3);

schottle_2_x =solve(q4==q6);
schottle_2_y = q4(schottle_2_x);

schottle_final = [(schottle_2_x+schottle_1_x)/2,(schottle_2_y+schottle_1_y)/2];
plot(schottle_final(1),schottle_final(2));


