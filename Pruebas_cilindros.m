
fisis = im2double(V_out.mascara == 2);
cortical = im2double(V_out.mascara == 1);
info = V_out.info;
dxdy = info{1};
dz = info{2};
pace = (dxdy)/(dz);
Pto = info{8};

[m,n,k] = size(fisis);
[Xq,Yq,Zq] = meshgrid(1:m,1:n,1:pace:k);
Box_size = 3;


Y =interp3(fisis,Xq,Yq,Zq,'cubic');
Y = smooth3(Y,'box',Box_size);

%Patch Cortical
W =interp3(cortical,Xq,Yq,Zq,'cubic');
W = smooth3(W,'box',Box_size);
%%

alpha = 45;
Beta = 0;
p = 30 ;
D =  5;

Taladro = Crear_solo_cilindro(V_out,alpha,Beta,p,D);
Z =interp3(Taladro,Xq,Yq,Zq,'cubic');
Z = smooth3(Z,'box',5);

%%
figure; hold on;
p1= patch(isosurface(Y,0.1),'FaceColor','red','EdgeColor','none');
p2= patch(isosurface(W,0.9),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
p3 = patch(isosurface(Z,0.1));
reducepatch(p2,0.01);
scatter3(Pto(1),Pto(2),Pto(3),'green','filled');
scatter3(Pto(2),Pto(1),Pto(3),'y','filled');
axis off; daspect([1 1 1]);
Cilindro_fx_final(V_out,alpha,Beta,D,p)