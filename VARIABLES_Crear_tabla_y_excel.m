% Crear Tabla y Excel
%Crear Tabla
T = table(Nombre,Altura_condilo_X,Altura_condilo_Y,Altura_condilo_Z,Profundidad_troclear,BPD_dist_f1,BPD_dist_f2,BPD_dist_g1,BPD_dist_g2,BPD_dist_tibia);
%Write
writetable(T,'Variables2.xls')