% Prueba rotacion Tibia

n = 28;
Rodilla = Base_datos(n).Rodilla;
Omega = Angulo_Z_tibia(Rodilla);
eje = 'Z';
Mascara_rot = imrotate3_fast(Rodilla.mascara,{-1*Omega eje});
figure;plot_MRI(Mascara_rot)
figure;plot_MRI(Rodilla.mascara)