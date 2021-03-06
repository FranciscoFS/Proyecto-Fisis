%% Ejemplo con PCA

% Carfa una fisis

%load('fisis_Medina_Leighton_Adrian_Gabriel_20030205_04482726.mat')
load('Datos3.mat');
Bone = V_bones_final_BW;
%plot_MRI(Bone);



[n,m,k] = size(Bone);
[Xx, Yy, Zz] = meshgrid(1:n,1:m,1:k);

% Obtenemos los valores (x,y,z) para cada pixel con algun valor

Xx_f = Xx(Bone>0);
Yy_f = Yy(Bone>0);
Zz_f = Zz(Bone>0);

%Plotea los puntos para que veas que se ven igual que la fisis
figure;
scatter3(Xx_f,Yy_f,Zz_f);

[Coef,Score,~] = pca([Xx_f Yy_f Zz_f]);
    
figure;
scatter3(Score(:,1),Score(:,2),Score(:,3));
%% Ejemplo 2D

[Xx,Yy] = meshgrid(1:100,1:100);
a= 20;
b= 15;
theta = 60;

Elipse = ((((Xx-50)/a).^2 + ((Yy-50)./b).^2 <= 1));
Elipse = imrotate(Elipse,theta,'crop');
figure;
imshow(Elipse);

%Saco los valores (x,y) de los que tienen pixeles

Xx_f = Xx(Elipse>0);
Yy_f = Yy(Elipse>0);
figure;
scatter(Xx_f,Yy_f);

%Con pca

[Coeff, Score] = pca([Xx_f,Yy_f]);
figure;
scatter(Score(:,1),Score(:,2));
