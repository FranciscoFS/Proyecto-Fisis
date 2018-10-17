
fisis = im2double(V_out.mascara == 2);
cortical = im2double(V_out.mascara == 1);
info = V_out.info;
dxdy = info{1};
dz = info{2};
pace = (dxdy)/(dz);
Pto = info{8};

[m,n,k] = size(fisis);
[Xq,Yq,Zq] = meshgrid(1:m,1:n,1:pace:k);
Box_size = 9;


Y =interp3(fisis,Xq,Yq,Zq,'cubic');
Y = smooth3(Y,'box',Box_size);

%Patch Cortical
W =interp3(cortical,Xq,Yq,Zq,'cubic');
W = smooth3(W,'box',Box_size);

[~,~,z] = ind2sub(size(W),find(W>0.2));
New_Pto = [Pto(1),Pto(2),min(z(:))];



%%

alpha = 0;
Beta = 0';
p = 20 ;
D =  6;

% Taladro2 = Crear_solo_cilindro2(V_out,alpha,Beta,D,p);
% Z2 =interp3(Taladro2,Xq,Yq,Zq,'cubic');
% Z2 = smooth3(Z2,'box',Box_size);

Z3 = Crear_solo_cilindro_test(V_out,Y,alpha,Beta,D,p,New_Pto);
Z3 = smooth3(Z3,'box',Box_size);

% figure; hold on;
% p3 = patch(isosurface(Z3,0.5),'FaceColor','green','EdgeColor','none');
% %axis off;
% daspect([1 1 1]);
% lighting gouraud
% material dull
% title('Rodilla')
% l = camlight('headlight');

%
%
figure; hold on;
p1= patch(isosurface(Y,0.5),'FaceColor','red','EdgeColor','none');
isonormals(Y,p1);
p2= patch(isosurface(W,0.5),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
p3 = patch(isosurface(Z3,0.5),'FaceColor','green','EdgeColor','none');
isonormals(Z3,p3);
reducepatch(p2,0.01);
scatter3(Pto(1),Pto(2),(Pto(3)-pace)/pace,'black','filled');
axis off; daspect([1 1 1]);
lighting gouraud
material dull
title('Rodilla')
l = camlight('headlight');
%Cilindro_fx_final(V_out,alpha,Beta,D,p)

while true
camlight(l,'headlight')
pause(0.05);
end

%% 

alpha = 0;
Beta = 0';
D =  6;

figure; hold on;
p1= patch(isosurface(Y,0.5),'FaceColor','red','EdgeColor','none');
%isonormals(Y,p1);
p2= patch(isosurface(W,0.5),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
reducepatch(p2,0.01);
p3 = patch(isosurface(Z3,0.5),'FaceColor','green','EdgeColor','none');
%isonormals(Z3,p3);
axis off; daspect([1 1 1]);
lighting gouraud
material dull
title('Rodilla')
l = camlight('headlight');

%%
for p=2:20
    delete(p3)
    Z3 = Crear_solo_cilindro_test(V_out,Y,alpha,Beta,D,p);
    p3 = patch(isosurface(Z3,0.5),'FaceColor','green','EdgeColor','none');
    
end

