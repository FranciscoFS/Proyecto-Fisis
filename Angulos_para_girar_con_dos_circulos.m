function Angulos_para_girar_con_dos_circulos()
% Cargar
uiwait(msgbox('Seleccione la secuencia SAGITAL del paciente','Cargar','modal'));
[filename, pathname] = uigetfile();
V_seg = importdata([pathname filename]);

f1= figure;
imshow(V_seg.vol.orig(:,:,Aproximar(size(V_seg.vol.orig,3)/2)),[]);
maximize(f1)

%Dibujar "circulos"

uiwait(msgbox('Ingrese DOS puntos para el primer circulo y DOS para el segundo circulo. Con el ultimo haga doble click o ENTER'));
[X1,Y1] = getpts();


%Punto medio
centro1 = [(X1(1)+X1(2))/2,(Y1(1)+Y1(2))/2];
centro2 = [(X1(3)+X1(4))/2,(Y1(3)+Y1(4))/2];

angulo_rotar = atand(abs(centro1(1)-centro2(1))/abs(centro1(2)-centro2(2)));

V_seg.info{25,1} = [angulo_rotar,centro1(1)-centro2(1)];

%Guardar
save([pathname filename],'V_seg')

close all
end