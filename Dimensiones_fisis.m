function Dimensiones_fisis(V_seg)
vol = double(V_seg.mascara ==2); %fisis
aplastado = squeeze(sum(vol_nuevo,3));
[y,x] = find(aplastado);
l1 = min(x);
l2 = max(x);
dz = V_seg.info{2,1};
dx = V_seg.info{1,1};
Width = (l2-l1)*dx;

Length = 
Height = 
Volumen = 

end