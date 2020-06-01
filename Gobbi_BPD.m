function Gobbi_BPD()
% Cargar
uiwait(msgbox('Seleccione la secuencia SAGITAL del paciente','Cargar','modal'));
[filename, pathname] = uigetfile();
V_seg = importdata([pathname filename]);

% uiwait(msgbox('Seleccione la secuencia AXIAL del paciente','Cargar','modal'));
% [filename, pathname] = uigetfile();
% V_seg_1 = importdata([pathname filename]);

%BPD distancia fisis bumb
V_seg = Elegir_puntos_BPD(V_seg);
V_seg = Calculos_BPD(V_seg);

%Guardar
save([pathname filename],'V_seg')
close all
end