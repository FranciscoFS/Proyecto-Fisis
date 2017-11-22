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
%1. Elegir un punto desde donde "perforar"
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
    
    uiwait(msgbox(mensaje(linea)));
    [y,x]= getpts(); %Por que los da "al reves"
    
    if linea ==1
        syms p q
        m1 = (y(2)-y(1))/(x(2)-x(1));
        q = symfun(m1*(p-x(1))+y(1),[p]);
 
        hold on
        [X1, Y1, Z1] = bresenham_line3d([x(1),y(1),i],[x(2),y(2),i]);
        plot([y(1),y(2)],[x(1),x(2)],'LineWidth',3);

        uiwait(msgbox('Linea almacenada'));
        hold off
        
    elseif linea ==2
        
        m_perp = -1/m1;
        syms q2
        q2 = symfun(m_perp*(p-x(1))+y(1),[p]);       
        
        x2=solve(q==q2);
        y2=q2(x2);
        hold on
        plot([y,y2],[x,x2],'LineWidth',3);
        [X2, Y2, Z1] = bresenham_line3d([x(1),y(1),i],[eval(x2),eval(y2),i]);
        uiwait(msgbox('Linea almacenada'));
        
        hold off
        
    elseif linea ==3

        syms q3
        q3 = symfun(m_perp*(p-x(1))+y(1),[p]);       
        
        x3=solve(q==q3);
        y3=q3(x3);
        hold on
        plot([y,y3],[x,x3],'LineWidth',3);
        [X3, Y3, Z1] = bresenham_line3d([x(1),y(1),i],[eval(x3),eval(y3),i]);
        uiwait(msgbox('Linea almacenada'));
        
        hold off
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

close all


