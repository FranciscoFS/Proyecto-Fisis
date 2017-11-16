%0 Seleccionar rodilla
clear all
close all
uiwait(msgbox('Seleccione la Rodilla a anlizar'));

[filename, pathname, filterindex] = uigetfile();
cd;
cd(pathname);
load(filename)

fisis_usar = V_seg.femur.fisis;
hueso_usar = V_seg.femur.bones;

%%
%1. Elegir un punto desde donde "perforar"
uiwait(msgbox('Seleccione la slide para elegir el punto a perforar. Haga click con el mouse para la siguiente. Presione una tecla para la anterior'));
i = 1;
f = figure;
V = V_seg.vol.orig;
elegida = 0;
coordenada = [];
btn1 = uicontrol('Style', 'pushbutton', 'String', 'Esta',...
        'Position', [20 20 50 20],...
        'Callback', 'elegida = 1');
while (i > 0 && elegida == 0)
imshow(V(:,:,i),[]) 
k = waitforbuttonpress;

if elegida == 1
    uiwait(msgbox('Ponga UN punto en el borde del hueso donde desea hacer la perforacion.'));
    [x,y]= getpts();
    coordenada = [x,y,i];
    close all
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

%%
%2. Elegir una dirección y distancia

% [9:16, 15/11/2017] Sebastian Irarrazaval: Hola Tomás: hay que probar diámetros 5, 6 y 7 mm. Si solo se pudiera elegir uno: 6
% [9:18, 15/11/2017] Sebastian Irarrazaval: Profundidad: entre 20 y 30 mm. Si hay que elegir uno: 30. Sería ideal evaluar también el brocado completo hasta la otra cortical
% [9:18, 15/11/2017] Sebastian Irarrazaval: Perdona la variabilidad, pero hay varias técnicas quirúrgicas



slice = V_seg.info{2,1};
pixel = V_seg.info{1,1};
bien = 0;

while bien == 0
prompt = {'Ingrese angulo con respecto a z:','Ingrese angulo con respecto a x:', 'Ingrese profundidad en mm:', 'Ingrese el diametro de la perforacion'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'0','0','30','6'};
answer1 = inputdlg(prompt,dlg_title,num_lines,defaultans);
answer1 = str2double(answer1);
if (answer1(3)/slice) > size(V_seg.vol.orig,3)
    message = sprintf('Las medidas de profundidad sobrepasan las de la rodilla. Seguro quiere continuar?');
	reply = questdlg(message, 'Profundidad', 'Si', 'No', 'Si');
    if strcmpi(reply, 'No')
        bien = 1;
    end
else
    bien = 1;
end    
end

coordenada(1) = Aproximar(coordenada(1));
coordenada(2) = Aproximar(coordenada(2));
coordenada(3) = Aproximar(coordenada(3));

%%
%3. Elegir el % de datos a los que se le quiere "no achuntar"
% 
% prompt = {'¿Sobre que % de los datos quiere trabajar?'};
% dlg_title = 'Input';
% num_lines = 1;
% defaultans = {100};
% answer2 = inputdlg(prompt,dlg_title,num_lines,defaultans);
% answer2 = str2double(answer2);
% 
% hueso_usar < answer2;
% fisis_usar < answer2;


%% Crear Cilindro
%[X,Y,Z] = cylinder(r,lados);

dz = V_seg.info{2,1};
dx = V_seg.info{1,1};

a1 = answer1(1);
a2 = answer1(2);

mm = answer1(3);

%traslacion
d1 = cos(a2)*mm;
tras = sin(a1)*d1;
pixeles_x = tras/dx;

%elevacion
elevacion = sin(a2)*mm;
pixeles_y = elevacion/dx;

%profundidad
prof = cos(a1)*d1;
pixeles_z = prof/dz;

P1 = coordenada;
P2 = [P1(1)+pixeles_x, P1(2) + pixeles_y, P1(3) + pixeles_z];

[X Y Z] = bresenham_line3d(P1, P2);

radio = answer1(4);
radio_pix = radio/dx;

contador = 0;

total_de_1s = sum(fisis_usar(:) == 1);

f = figure;
hold on

for i = 1:size(Z,2)
    im = fisis_usar(:,:,Z(i));

    x = X(i);
    y = Y(i);
        
    p = x - radio_pix : x + radio_pix;
    q = y - radio_pix : y + radio_pix;
    
    p = Aproximar(p);
    q = Aproximar(q);
    
    for j = 1:size(p,2)
    for t = 1:size(p,2)
    if (x-p(j)).^2 + (y-q(t)).^2 <= radio_pix.^2
        plot3(p(j),q(t),Z(i),'s','markerface','b')
        if im(p(j),q(t)) == 1  
            contador = contador + 1;
        end        
    end 
    end
    end

end


isosurface(fisis_usar)
plot3(X,Y,Z,'s','markerface','b');


