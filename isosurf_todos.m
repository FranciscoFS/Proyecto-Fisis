function isosurf_todos(V)

info = V.info;

%Proporciones RM
if exist('info') == 1
    dxdy = info{1,1}
    dz = info{2,1}
else
    dxdy = inputdlg('Ingrese dxdy');
    dxdy = str2double(dxdy);
    dz = inputdlg('Ingrese dz');
    dz = str2double(dz);
end   

pace = (1/(dz/dxdy));
[m,n,k] = size(V.femur.fisis);
[Xq,Yq,Zq] = meshgrid(1:m,1:n,1:pace:k);
Box_size = [3 3 3];

%Patch femur fisis
ff =interp3(V.femur.fisis,Xq,Yq,Zq,'cubic');
ff = smooth3(ff,'box',Box_size);
%Patch femur hueso
fh =interp3(V.femur.bones,Xq,Yq,Zq,'cubic');
fh = smooth3(fh>0,'box',Box_size);
%Patch tibia fisis
tf =interp3(V.tibia.fisis,Xq,Yq,Zq,'cubic');
tf = smooth3(tf,'box',Box_size);
%Patch tibia hueso
th =interp3(V.tibia.bones,Xq,Yq,Zq,'cubic');
th = smooth3(th>0,'box',Box_size);
%Patch perone fisis
pf =interp3(V.perone.fisis,Xq,Yq,Zq,'cubic');
pf = smooth3(pf,'box',Box_size);
%Patch perone hueso
ph =interp3(V.perone.bones,Xq,Yq,Zq,'cubic');
ph = smooth3(ph>0,'box',Box_size);
%Patch rotula
% r =interp3(V.rotula,Xq,Yq,Zq,'cubic');
% r = smooth3(r>0,'box',Box_size);

%Vista y Luz

%Patch femur
p1= patch(isosurface(ff),'FaceColor','red','EdgeColor','none');
p2= patch(isosurface(fh),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
reducepatch(p2,0.01)
%Patch tibia
p3= patch(isosurface(tf),'FaceColor','red','EdgeColor','none');
p4= patch(isosurface(th),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
reducepatch(p4,0.01)
%Patch perone
p5= patch(isosurface(pf),'FaceColor','red','EdgeColor','none');
p6= patch(isosurface(ph),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
reducepatch(p6,0.01)
%Patch rotula
% p7= patch(isosurface(r),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
% reducepatch(p7,0.01)

view(3)
axis tight
daspect([1 1 1])
l = camlight('headlight');
lighting gouraud
material dull
title('Fisis')

while true
camlight(l,'headlight')
pause(0.05);
end

end

