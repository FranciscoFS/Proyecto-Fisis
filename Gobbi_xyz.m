function Gobbi_xyz()
[filename, pathname] = uigetfile();
V_seg_1 = importdata([pathname filename]);

V_seg_1 = Elegir_puntos_xyz(V_seg_1);
V_seg_1 = Calculos_xyz(V_seg_1);

save([pathname filename],'V_seg_1')

close all
end