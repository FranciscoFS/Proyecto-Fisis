function V_seg = Mirror(V_seg)
% Preguntar si hay que girar
porte = size(V_seg.vol.orig,3);
for i = 1:porte
    nueva_im = flip(V_seg.vol.orig(:,:,i),2);
    V_seg.vol.orig(:,:,i) = nueva_im;
end
plot_MRI(V_seg.vol.orig)
end