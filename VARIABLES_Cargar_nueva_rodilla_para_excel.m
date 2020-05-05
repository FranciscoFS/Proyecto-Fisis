%% Partir
[filename, pathname] = uigetfile( ...
{ %%'*.mat','MAT-files (*.mat)'; ...
   %%'*.slx;*.mdl','Models (*.slx, *.mdl)'; ...
   '*.*',  'All Files (*.*)'}, ...
  'Seleccione las slides a analizar', ...
   'MultiSelect', 'on');

for i = 1:size(filename,2)
load([pathname char(filename(1,i))])

Nombre = [Nombre; char(filename(1,i))];

Altura_condilo_X = [Altura_condilo_X;V_seg_1.info{11,1}(1,1)]; 
Altura_condilo_Y = [Altura_condilo_Y;V_seg_1.info{11,1}(2,1)];
Altura_condilo_Z = [Altura_condilo_Z;V_seg_1.info{11,1}(3,1)];
Profundidad_troclear = [Profundidad_troclear;V_seg_1.info{11,1}(4,1)];


BPD_dist_f1 = [BPD_dist_f1;V_seg_1.info{15,1}(3,1)];
BPD_dist_f2 = [BPD_dist_f2;V_seg_1.info{15,1}(4,1)];
BPD_dist_g1 = [BPD_dist_g1;V_seg_1.info{15,1}(5,1)];
BPD_dist_g2 = [BPD_dist_g2;V_seg_1.info{15,1}(6,1)];
BPD_dist_tibia =[BPD_dist_tibia;V_seg_1.info{15,1}(7,1)];
%cell2mat
end
