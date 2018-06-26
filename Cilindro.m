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
imshow(V_seg.femur.bones(:,:,i),[])
k = waitforbuttonpress;

if elegida == 1
    i= i-1;
    if i < 1
        i = 1;
    end
    imshow(V(:,:,i),[]) 
    uiwait(msgbox('Ponga UN punto en el borde del hueso donde desea hacer la perforacion.'));
    [x,y]= getpts();
    coordenada = [y,x,i];
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
close all
coordenada(1) = Aproximar(coordenada(1));
coordenada(2) = Aproximar(coordenada(2));

%%
%2. Elegir una dirección y distancia
%coordenada = coord_3D
slice = V_seg.info{2,1};
pixel = V_seg.info{1,1};
bien = 0;

while bien == 0
prompt = {'Ingrese angulo con respecto a x:','Ingrese angulo con respecto a z:', 'Ingrese profundidad [mm]:', 'Ingrese el diametro de la perforacion [mm]:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'0','0','30','2'};
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


%% Crear Linea

dz = V_seg.info{2,1};
dx = V_seg.info{1,1};

a1 = answer1(1);
a2 = answer1(2);
mm = answer1(3);

%profundidad
prof = cosd((a2))*mm;
pixeles_z = prof/dz;

%elevacion
elevacion = sind((a2))*mm;
pixeles_y = elevacion/dx;

%traslacion
tras = tand((a1))*prof;
pixeles_x = tras/dx;


P1 = coordenada;
P2 = [P1(1)+pixeles_x, P1(2) + pixeles_y, P1(3) + pixeles_z];
P2 = Aproximar(P2);

[X, Y, Z] = bresenham_line3d(P1, P2);

% Cilindro
radio = answer1(4)/2;
radio_pix = Aproximar(radio/dx);

contador = 0;
total_de_1s = sum(fisis_usar(:) == 1);
pixeles_ya_sumados = zeros(size(fisis_usar));

f = figure;
hold on
fu= smooth3(fisis_usar);
hu = smooth3(hueso_usar);
p1= patch(isosurface(fu),'FaceColor','red','EdgeColor','none');
p2= patch(isosurface(hu),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
reducepatch(p2,0.01)
ax = gca;
c = ax.DataAspectRatio;
ax.DataAspectRatio= [dz,dz,dx];

%[X, Y, Z] = cylinder2P(radio_pix, 50,P1,P2);
%surf(X, Y, Z);

for i = 1:size(Z,2)
    im = fisis_usar(:,:,Z(i));

    x = Aproximar(X(i));
    y = Aproximar(Y(i));
   
    p = x - radio_pix : x + radio_pix;
    q = y - radio_pix : y + radio_pix;

    for j = 1:size(p,2)
    for t = 1:size(p,2)
    if (x-p(j)).^2 + (y-q(t)).^2 <= radio_pix.^2
        if (pixeles_ya_sumados(p(j),q(t),Z(i)) == 0)
            plot3(q(t),p(j),Z(i),'s','markerface','b','MarkerSize', 10)
            pixeles_ya_sumados(p(j),q(t),Z(i)) = 1;
            if (im(p(j),q(t)) == 1)
                contador = contador + 1;
            end 
        end
               
    end 
    end
    end
end




view(3)
axis tight
l = camlight('headlight');
lighting gouraud
material dull
title('Fisis')

porc = (contador/total_de_1s)*100;
uiwait(msgbox({'Se ha perforado un' num2str(porc) '% de la fisis'}));





