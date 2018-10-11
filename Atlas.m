% Pruebas de Atlas
% Sobre el input target, le hago imregistration (Deformable), para calzar
% el atlas con el input, y luego aplica la misma transformación para la
% mascara labeled.

Rodillas = load('/Users/franciscofernandezschlein/Google Drive/Uc/LPFM/Rodillas_Fisis.mat');
Base_datos = Rodillas.Base_datos;

%%

%% Hacer una imregistration de Entre las fotos originales.

Volumen_referencia = Rodilla_1.vol.orig;
info_ref = Rodilla_1.info;
[~,~,v1] = ind2sub(size(Rodilla_1.mascara),find(Rodilla_1.mascara > 1));
Mid1 = round((max(v1)+min(v1))/2);
Ref_Ref = imref3d(size(Volumen_referencia),info_ref{1,1},info_ref{1,1},info_ref{2,1});



Volumen_movible = Rodilla_2.vol.orig;
info_mov = Rodilla_2.info;
[~,~,v2] = ind2sub(size(Rodilla_2.mascara),find(Rodilla_2.mascara > 1));
Mid2 = round((max(v2)+min(v2))/2);
Ref_mov = imref3d(size(Volumen_movible),info_mov{1,1},info_mov{1,1},info_mov{2,1});

%%
Im_ref = Volumen_referencia(:,:,14);
Im_mov = Volumen_movible(:,:,13);
imshowpair(Im_ref,Im_mov,'montage');











