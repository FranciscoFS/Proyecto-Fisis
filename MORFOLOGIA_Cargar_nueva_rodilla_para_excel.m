%% Partir
[filename, pathname] = uigetfile( ...
{ %%'*.mat','MAT-files (*.mat)'; ...
   %%'*.slx;*.mdl','Models (*.slx, *.mdl)'; ...
   '*.*',  'All Files (*.*)'}, ...
  'Seleccione las slides a analizar', ...
   'MultiSelect', 'on');
for i = 1:size(filename,2)
load([pathname char(filename(1,i))])
V_seg = MORFOLOGIA_Mapeo_alturas(V_seg);
%Centro = [];
%Bounding_box = [];
Nombre = [Nombre; char(filename(1,i))];
Distancia_LM = [Distancia_LM; V_seg.info{17,1}(1,1)];
Distancia_AP = [Distancia_AP; V_seg.info{17,1}(2,1)];
Distancia_PD = [Distancia_PD; V_seg.info{17,1}(3,1)];
Volumen_fisis = [Volumen_fisis; V_seg.info{18,1}];
Promedio_Altura_LM1 = [Promedio_Altura_LM1; V_seg.info{19,1}(1,1)];
Promedio_Altura_LM2 = [Promedio_Altura_LM2; V_seg.info{19,1}(2,1)];
Promedio_Altura_LM3 = [Promedio_Altura_LM3; V_seg.info{19,1}(3,1)];
Min_Altura_LM1 = [Min_Altura_LM1; V_seg.info{20,1}(1,1)];
Min_Altura_LM2 = [Min_Altura_LM2; V_seg.info{20,1}(2,1)];
Min_Altura_LM3 = [Min_Altura_LM3; V_seg.info{20,1}(3,1)];
Max_Altura_LM1 = [Max_Altura_LM1; V_seg.info{21,1}(1,1)];
Max_Altura_LM2 = [Max_Altura_LM2; V_seg.info{21,1}(2,1)];
Max_Altura_LM3 = [Max_Altura_LM3; V_seg.info{21,1}(3,1)];
Promedio_Altura_AP1 = [Promedio_Altura_AP1; V_seg.info{22,1}(1,1)];
Promedio_Altura_AP2 = [Promedio_Altura_AP2; V_seg.info{22,1}(2,1)];
Promedio_Altura_AP3 = [Promedio_Altura_AP3; V_seg.info{22,1}(3,1)];
Min_Altura_AP1 = [Min_Altura_AP1; V_seg.info{23,1}(1,1)];
Min_Altura_AP2 = [Min_Altura_AP2; V_seg.info{23,1}(2,1)];
Min_Altura_AP3 = [Min_Altura_AP3; V_seg.info{23,1}(3,1)];
Max_Altura_AP1 = [Max_Altura_AP1; V_seg.info{24,1}(1,1)];
Max_Altura_AP2 = [Max_Altura_AP2; V_seg.info{24,1}(2,1)];
Max_Altura_AP3 = [Max_Altura_AP3; V_seg.info{24,1}(3,1)];
end
