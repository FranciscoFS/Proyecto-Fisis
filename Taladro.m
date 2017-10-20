%Asumiendo que v.rodilla es la suma total de rodilla (femur, perone, tibia con sus respectivas fisis).

%0 Seleccionar qué hueso será el que se analizará
clear all
close all
uiwait(msgbox('Seleccione la Rodilla sumada'));

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

lista = [ff_suma,fh_suma,tf_suma,th_suma,pf_suma,ph_suma];
fisis_usar = lista(2s-1);
hueso_usar = lista(2s);

%1. Elegir un punto desde donde "perforar"
clickA3DPoint(fisis_usar);

%2. Elegir una dirección y distancia
prompt = {'Ingrese angulo con respecto a z:','Ingrese angulo con respecto a x:', 'Ingrese profundidad en mm:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'90','90','10'};
answer1 = inputdlg(prompt,dlg_title,num_lines,defaultans);

%3. Elegir el % de datos a los que se le quiere "no achuntar"
prompt = {'¿Sobre que % de los datos quiere trabajar?'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {100};
answer2 = inputdlg(prompt,dlg_title,num_lines,defaultans);

hueso_usar <= answer2;
fisis_usar <= answer2;

%4. funcion perforar

input = [answer1(1), answer1(2), answer1(3), hueso_usar, fisis_usar];
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

x = 0:0.1:dist_a_fisis.(s);
y = size(hoyo);
plot(x,y)
