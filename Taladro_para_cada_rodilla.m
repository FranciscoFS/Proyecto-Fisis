<<<<<<< HEAD:Taladro_para _cada_rodilla.m
%Asumiendo que v.rodilla es la suma total de rodilla (femur, perone, tibia con sus respectivas fisis).

%0 Seleccionar quï¿½ hueso serï¿½ el que se analizarï¿½
=======
%0 Seleccionar qué hueso será el que se analizará
>>>>>>> f1c1213c016b63a9b7f277b5733df88a850b6f44:Taladro_para_cada_rodilla.m
clear all
close all
uiwait(msgbox('Seleccione la Rodilla a anlizar'));

[filename, pathname, filterindex] = uigetfile();
load(filename)

str = {"Femur","Tibia", "Perone"};
v = 0;


while v == 0
[s,v] = listdlg('PromptString','Seleccione un hueso:',...
                'SelectionMode','single',...
                'ListSize', [300,300],...
                'ListString',str);
end

lista = [V_seg.femur.fisis,V_seg.femur.bones,V_seg.tibia.fisis,V_seg.tibia.bones,V_seg.perone.fisis,V_seg.perone.bones];
fisis_usar = lista(2*s-1);
hueso_usar = lista(2*s);

%%
%1. Elegir un punto desde donde "perforar"
uiwait(msgbox('Seleccione la slide para elegir el punto a perforar. Haga click con el mouse para la siguiente. Presione una tecla para la anterior'));
i = 1;
f = figure;
X = V_seg.vol.orig;
elegida = 0;
coordenada = []
btn1 = uicontrol('Style', 'pushbutton', 'String', 'Esta',...
        'Position', [20 20 50 20],...
        'Callback', 'elegida = 1');
while (i > 0 & elegida == 0)
imshow(X(:,:,i),[]) 
k = waitforbuttonpress;

if elegida == 1
    uiwait(msgbox('Ponga UN punto en el borde del hueso donde desea hacer la perforacion.'));
    [x,y]= getpts();
    coordenada = [x,y,i]
    elegida = 0
    close all
    break
end
if k == 0
    i = i+1;
    if i > size(X,3)
        i =size(X,3);
    end
elseif k == 1
    i= i-1;
    if i < 1
        i = 1;
    end
end
end

<<<<<<< HEAD:Taladro_para _cada_rodilla.m

%2. Elegir una direcciï¿½n y distancia (por ahora solo "derecho hacia adentro")
=======
%%
%2. Elegir una dirección y distancia (por ahora solo "derecho hacia adentro")
slice = V_seg.info{2,1};
pixel = V_seg.info{1,1};
>>>>>>> f1c1213c016b63a9b7f277b5733df88a850b6f44:Taladro_para_cada_rodilla.m
bien = 0

while bien == 0;
prompt = {'Ingrese angulo con respecto a z:','Ingrese angulo con respecto a x:', 'Ingrese profundidad en mm:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'90','90','10'};
answer1 = inputdlg(prompt,dlg_title,num_lines,defaultans);
answer1 = str2double(answer1)
if (answer1(3)/slice) > size(V_seg.vol.orig,3)
    bien = 0
    uiwait(msgbox('Las medidas sobrepasan las de la rodilla'));
else
    bien = 1
end

end


mm = answer1(3)/slice;
if (mm - fix(mm)) >= 0.5
    mm = ceil(mm);
else
    mm = floor(mm);
end

%Entonces mm es cuantas slice perforar


%3. Elegir el % de datos a los que se le quiere "no achuntar" (Esto es para
%taladro de la suma
% prompt = {'ï¿½Sobre que % de los datos quiere trabajar?'};
% dlg_title = 'Input';
% num_lines = 1;
% defaultans = {100};
% answer2 = inputdlg(prompt,dlg_title,num_lines,defaultans);
% 
% hueso_usar <= answer2;
% fisis_usar <= answer2;

%%
%4. funcion perforar
input = [answer1(1), answer1(2), mm, hueso_usar, fisis_usar, V_seg, coordenada];
dist_a_fisis = Perforar(input);

%5. Graficar
str = {"Arriba","Abajo","Izquierda","Derecha"};
v = 0;
while v == 0
[s,v] = listdlg('PromptString','Seleccione la distancia en que direccion hacia la fisis',...
                'SelectionMode','single',...
                'ListSize', [300,300],...
                'ListString',str);
end

dist_a_fisis.(s)


%x = size(hoyo);
x = 0:answer1(3);
y = 0:0.1:dist_a_fisis.(s);

plot(x,y)
