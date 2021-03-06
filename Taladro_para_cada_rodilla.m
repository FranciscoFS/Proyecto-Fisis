%0 Seleccionar qu� hueso ser� el que se analizar�
clear all
close all
uiwait(msgbox('Seleccione la Rodilla a anlizar'));

[filename, pathname, filterindex] = uigetfile();
cd;
cd(pathname);
load(filename)


str = {"Femur","Tibia", "Perone"};
v = 0;

while v == 0
[s,v] = listdlg('PromptString','Seleccione un hueso:',...
                'SelectionMode','single',...
                'ListSize', [300,300],...
                'ListString',str);
end

lista = {V_seg.femur.fisis; V_seg.femur.bones; V_seg.tibia.fisis;V_seg.tibia.bones; V_seg.perone.fisis; V_seg.perone.bones};
fisis_usar = lista{2*s-1,1};
hueso_usar = lista{2*s,1};

%%
%1. Elegir un punto desde donde "perforar"
uiwait(msgbox('Seleccione la slide para elegir el punto a perforar. Haga click con el mouse para la siguiente. Presione una tecla para la anterior'));
i = 1;
f = figure;
X = V_seg.vol.orig;
elegida = 0;
coordenada = [];
btn1 = uicontrol('Style', 'pushbutton', 'String', 'Esta',...
        'Position', [20 20 50 20],...
        'Callback', 'elegida = 1');
while (i > 0 && elegida == 0)
imshow(X(:,:,i),[]) 
k = waitforbuttonpress;

if elegida == 1
    uiwait(msgbox('Ponga UN punto en el borde del hueso donde desea hacer la perforacion.'));
    [x,y]= getpts();
    coordenada = [x,y,i];
    close all
elseif (k == 0 && elegida == 0)
    i = i+1;
    if i > size(X,3)
        i =size(X,3);
    end
elseif (k == 1 && elegida == 0)
    i= i-1;
    if i < 1
        i = 1;
    end
end

end

%%
%2. Elegir una direcci�n y distancia (por ahora solo "derecho hacia adentro")
slice = V_seg.info{2,1};
pixel = V_seg.info{1,1};
bien = 0;

while bien == 0
prompt = {'Ingrese angulo con respecto a z:','Ingrese angulo con respecto a x:', 'Ingrese profundidad en mm:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'90','90','10'};
answer1 = inputdlg(prompt,dlg_title,num_lines,defaultans);
answer1 = str2double(answer1);
if (answer1(3)/slice) > size(V_seg.vol.orig,3)
    bien = 0;
    uiwait(msgbox('Las medidas sobrepasan las de la rodilla'));
else
    bien = 1;
end

end


mm = answer1(3)/slice;
if (mm - fix(mm)) >= 0.5
    mm = ceil(mm);
else
    mm = floor(mm);
end

if (coordenada(1) - fix(coordenada(1))) >= 0.5
    coordenada(1) = ceil(coordenada(1));
else
    coordenada(1) = floor(coordenada(1));
end

if (coordenada(2) - fix(coordenada(2))) >= 0.5
    coordenada(2) = ceil(coordenada(2));
else
    coordenada(2) = floor(coordenada(2));
end
%Entonces mm es cuantas slice perforar


%3. Elegir el % de datos a los que se le quiere "no achuntar" (Esto es para
%taladro de la suma
% prompt = {'�Sobre que % de los datos quiere trabajar?'};
% dlg_title = 'Input';
% num_lines = 1;
% defaultans = {100};
% answer2 = inputdlg(prompt,dlg_title,num_lines,defaultans);
% 
% hueso_usar <= answer2;
% fisis_usar <= answer2;

%%
%4. funcion perforar

dist_a_fisis = Perforar(answer1(1), answer1(2), mm, hueso_usar, fisis_usar, V_seg, coordenada)

%%
%5. Graficar
% str = {"Arriba","Abajo","Izquierda","Derecha"};
% v = 0;
% while v == 0
% [s,v] = listdlg('PromptString','Seleccione la distancia en que direccion hacia la fisis',...
%                 'SelectionMode','single',...
%                 'ListSize', [300,300],...
%                 'ListString',str);
% end

x = 0:mm;
y = dist_a_fisis.arriba;
subplot(2,2,1)
plot(x,y)

y = dist_a_fisis.abajo;
subplot(2,2,2)
plot(x,y)

y = dist_a_fisis.der;
subplot(2,2,3)
plot(x,y)

y = dist_a_fisis.izq;
subplot(2,2,4)
plot(x,y)