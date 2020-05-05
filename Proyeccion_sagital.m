function Proyeccion_sagital(V_seg)
%----------COMUN:
%V_seg = Rotar(V_seg,90,'Y');
%a = double(V_seg.mascara ==1); %hueso
b = double(V_seg.mascara ==2); %fisis
vol = b;

%vol = a+2.*b;

aplastado = squeeze(sum(vol,3));

%----------------------------------------

f1 = figure;
imshow(aplastado,[])
maximize(f1);

f2 = figure;
imshow(aplastado,[])
colormap(jet(256));
colorbar;
maximize(f2);
colorbar