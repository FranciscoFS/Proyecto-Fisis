%% Hacer el fit para toda la base de datos

Largo = numel(Base_datos);

AP_F1 = cell(Largo,3);
AP_F2 = cell(Largo,3);
SG_P2 = cell(Largo,3);
SG_P4 = cell(Largo,3);

for k = 1 : Largo
    
    [AP,SG] = Proyecciones(Base_datos(k).Rodilla);
    Datos = Fit_fisis(AP,SG);
    
    % Campos de Datos: sse, rsquare, dfe, adjrsquared, rmse(Serian pixeles)
    % Datos: 1_ AP-F1, 2_AP-F2, 3_ SG_P2, 4_ SG-P4
    
%     AP_F1_R2(k,1) = Datos{1}.rsquare;
%     AP_F1_R2_adj(k,1) = Datos{1}.adjrsquare;
%     AP_F1_RMSE(k,1) = Datos{1}.rmse;
%     
%     AP_F2_R2(k,1) = Datos{2}.rsquare;
%     AP_F2_R2_adj(k,1) = Datos{2}.adjrsquare;
%     AP_F2_RMSE(k,1) = Datos{2}.rmse;   
%     
%     SG_P2_R2(k,1) = Datos{3}.rsquare;
%     SG_P2_R2_adj(k,1) = Datos{3}.adjrsquare;
%     SG_P2_RMSE(k,1) = Datos{3}.rmse;
%     
%     SG_P4_R2(k,1) = Datos{4}.rsquare;
%     SG_P4_R2_adj(k,1) = Datos{4}.adjrsquare;
%     SG_P4_RMSE(k,1) = Datos{4}.rmse;
    
    AP_F1(k,:) = {Datos{1}.rsquare,Datos{1}.adjrsquare,Datos{1}.rmse};
    AP_F2(k,:) = {Datos{2}.rsquare,Datos{2}.adjrsquare,Datos{2}.rmse};
    SG_P2(k,:) = {Datos{3}.rsquare,Datos{3}.adjrsquare,Datos{3}.rmse};
    SG_P4(k,:) = {Datos{4}.rsquare,Datos{4}.adjrsquare,Datos{4}.rmse};
    
end

% varNames = {'R2','R2_adj','RMSE'};
% 
% AP_F1 = table(AP_F1_R2, AP_F1_R2_adj, AP_F1_RMSE,'VariableNames',varNames);
% AP_F2 = table(AP_F2_R2, AP_F2_R2_adj, AP_F2_RMSE,'VariableNames',varNames);
% SG_P2 = table(SG_P2_R2, SG_P2_R2_adj, SG_P2_RMSE,'VariableNames',varNames);
% SG_P4 = table(SG_P4_R2, SG_P4_R2_adj, SG_P4_RMSE,'VariableNames',varNames);

Var_names = {'Ajuste_Proyeccion_AP_Fourier_1','Ajuste_Proyeccion_AP_Fourier_2',...
    'Ajuste_Proyeccion_SG_Pol_orden_2','Ajuste_Proyeccion_SG_Pol_orden_4'};
Tabla = table(AP_F1,AP_F2,SG_P2,SG_P4);
Tabla.Properties.VariableNames= Var_names;

%%

[muHat_F1,sigmaHat_F1,muCI_F1,sigmaCI_F1] = normfit(cell2mat(AP_F1));
[muHat_F2,sigmaHat_F2,muCI_F2,sigmaCI_F2] = normfit(cell2mat(AP_F2));
[muHat_P2,sigmaHat_P2,muCI_P2,sigmaCI_P2] = normfit(cell2mat(SG_P2));
[muHat_P4,sigmaHat_P4,muCI_P4,sigmaCI_P4] = normfit(cell2mat(SG_P4));

F1 = {[num2str(muHat_F1(1)) '- [' num2str(muCI_F1(1,1)) ' -' num2str(muCI_F1(2,1)) ']'],...
    [num2str(muHat_F1(2)) '- [' num2str(muCI_F1(1,2)) ' -' num2str(muCI_F1(2,2)) ']'],...
    [num2str(muHat_F1(3)) '- [' num2str(muCI_F1(1,3)) ' -' num2str(muCI_F1(2,3)) ']']};

F2 = {[num2str(muHat_F2(1)) '- [' num2str(muCI_F2(1,1)) ' -' num2str(muCI_F2(2,1)) ']'],...
    [num2str(muHat_F2(2)) '- [' num2str(muCI_F2(1,2)) ' -' num2str(muCI_F2(2,2)) ']'],...
    [num2str(muHat_F2(3)) '- [' num2str(muCI_F2(1,3)) ' -' num2str(muCI_F2(2,3)) ']']};

P2 = {[num2str(muHat_P2(1)) '- [' num2str(muCI_P2(1,1)) ' -' num2str(muCI_P2(2,1)) ']'],...
    [num2str(muHat_P2(2)) '- [' num2str(muCI_P2(1,2)) ' -' num2str(muCI_P2(2,2)) ']'],...
    [num2str(muHat_P2(3)) '- [' num2str(muCI_P2(1,3)) ' -' num2str(muCI_P2(2,3)) ']']};

P4 = {[num2str(muHat_P4(1)) '- [' num2str(muCI_P4(1,1)) ' -' num2str(muCI_P4(2,1)) ']'],...
    [num2str(muHat_P4(2)) '- [' num2str(muCI_P4(1,2)) ' -' num2str(muCI_P4(2,2)) ']'],...
    [num2str(muHat_P4(3)) '- [' num2str(muCI_P4(1,3)) ' -' num2str(muCI_P4(2,3)) ']']};

Tabla_2 = table(F1,F2,P2,P4);
Var_names = {'Ajuste_Proyeccion_AP_Fourier_1','Ajuste_Proyeccion_AP_Fourier_2',...
    'Ajuste_Proyeccion_SG_Pol_orden_2','Ajuste_Proyeccion_SG_Pol_orden_4'};
Tabla_2.Properties.VariableNames= Var_names;

%% Graficar algunos ejemplos Femur

%V_seg = Base_datos(45).Rodilla;

[AP,SG] = Proyecciones(V_seg);

dx = V_seg.info{1}; 
dz = V_seg.info{2};
pace = dx/dz;
Fisis = V_seg.mascara == 2;
Proyeccion_SG = sum(Fisis > 0,3);
Proyeccion_AP = squeeze(sum(Fisis > 0,2));
[n,z] = size(Proyeccion_AP);
[Xq,Zq] = meshgrid(1:pace:z,1:n);
Proyeccion_AP = interp2(Proyeccion_AP,Xq,Zq);

[Fit_AP_Fourier1,GOF_AP_F1] = fit(AP.Columnas,AP.Filas,'fourier1');
[Fit_AP_Lineal,GOF_AP_Lineal] = fit(AP.Columnas,AP.Filas,'poly1');
[Fit_SG_Pol_2, GOF_P2] = fit(SG.Columnas,SG.Filas,'poly2');
[Fit_SG_Pol_3, GOF_P2] = fit(SG.Columnas,SG.Filas,'poly3');
[Fit_SG_Pol_1, GOF_P4] = fit(SG.Columnas,SG.Filas,'poly1');

Femur = 0.8*(V_seg.mascara==1) + 7*(V_seg.mascara==2);


Proyeccion_SG_Femur = sum(Femur,3);
Proyeccion_AP_Femur = squeeze(sum(Femur,2));
[n,z] = size(Proyeccion_AP_Femur);
[Xq,Zq] = meshgrid(1:pace:z,1:n);
Proyeccion_AP_Femur = interp2(Proyeccion_AP_Femur,Xq,Zq);

%%
%subplot(2,2,1);scatter(Columnas_AP,Fisis_AP_mean);axis equal; title('Proyeecion Antero-Posterior');
F1 = figure;
F1.Color = 'white';
%imshow(Proyeccion_AP,[]);
imshow(1-Proyeccion_AP_Femur,[]);hold on;
p1 = plot(Fit_AP_Lineal,'r-');axis equal; title('AP');

F2 = figure;
F2.Color = 'white';
imshow(1-Proyeccion_AP_Femur,[]);hold on;
p4 = plot(Fit_AP_Fourier1,'r-');axis equal; title('AP');
%%
F3 = figure;
F3.Color = 'white';
%imshow(Proyeccion_SG,[]);
imshow(1-Proyeccion_SG_Femur,[]);hold on;
%scatter(Columnas_SG,Fisis_SG_mean,5,'red');axis equal;title('SG mean');
p2 = plot(Fit_SG_Pol_2,'r',SG.Columnas,SG.Filas,'black');axis equal;
title('Fit Polinomial n=2 Proyeccion Sagital','FontSize',16);

F4 = figure;
F4.Color = 'white';
imshow(1-Proyeccion_SG_Femur,[]);hold on;
p3 = plot(Fit_SG_Pol_1,'r',SG.Columnas,SG.Filas,'black');axis equal;
title('Fit Polinomial n=1 Proyeccion Sagital','FontSize',16);

F5 = figure;
F5.Color = 'white';
imshow(1-Proyeccion_SG_Femur,[]);hold on;
p4 = plot(Fit_SG_Pol_3,'r',SG.Columnas,SG.Filas,'black');axis equal;
title('Fit Polinomial n=3 Proyeccion Sagital','FontSize',16);
%% Tibia

[AP,SG] = Proyecciones_tibia(V_seg);

dx = V_seg.info{1}; 
dz = V_seg.info{2};
pace = dx/dz;

Fisis = V_seg.mascara == 4;
Tibia = 0.7*(V_seg.mascara==3) + 6*(V_seg.mascara==4);

Proyeccion_SG_Fisis = sum(Fisis,3);
Proyeccion_AP_Fisis = squeeze(sum(Fisis,2));
[n,z] = size(Proyeccion_AP_Fisis);
[Xq,Zq] = meshgrid(1:pace:z,1:n);
Proyeccion_AP_Fisis = interp2(Proyeccion_AP_Fisis,Xq,Zq);

Proyeccion_SG_Tibia = sum(Tibia,3);
Proyeccion_AP_Tibia = squeeze(sum(Tibia,2));
[n,z] = size(Proyeccion_AP_Tibia);
[Xq,Zq] = meshgrid(1:pace:z,1:n);
Proyeccion_AP_Tibia = interp2(Proyeccion_AP_Tibia,Xq,Zq);

[Fit_AP_Fourier1,GOF_AP_F1] = fit(AP.Columnas,AP.Filas,'fourier1');
[Fit_AP_Lineal,GOF_AP_Lineal] = fit(AP.Columnas,AP.Filas,'poly1');

[Fit_SG_Pol_2, GOF_SG_P2] = fit(SG.Columnas,SG.Filas,'poly2');
[Fit_SG_Pol_1, GOF_P4] = fit(SG.Columnas,SG.Filas,'poly1');
[Fit_SG_Exp2, GOF_SG_E2] = fit(SG.Columnas,SG.Filas,'exp2');


F1 = figure;
F1.Color = 'white';
%imshow(Proyeccion_AP,[]);
imshow(1-Proyeccion_AP_Tibia,[]);hold on;
%scatter(Columnas_AP,Fisis_AP_mean,8,'red');axis equal;title('AP');
p1 = plot(Fit_AP_Fourier1,AP.Columnas,AP.Filas,'black');axis equal;
title('Proyeccion AP con fit Sinusal orden 1','FontSize',16);
saveas(F1,'Proyeccion AP con fit Sinusal orden 1','jpg')

F2 = figure;
F2.Color = 'white';
imshow(1-Proyeccion_AP_Tibia,[]);hold on;
p4 = plot(Fit_AP_Lineal,AP.Columnas,AP.Filas,'black');axis equal;
title('Proyeccion AP con fit Polinomial n=1','FontSize',16);
saveas(F2,'Proyeccion AP con fit Polinomial n=1','jpg')

%subplot(2,2,3);scatter(Columnas_SG,Fisis_SG_mean);axis equal;title('Proyeccion Sagital');
F3 = figure;
F3.Color = 'white';
%imshow(Proyeccion_SG,[]);
imshow(1-Proyeccion_SG_Tibia,[]);hold on;
p2 = plot(Fit_SG_Pol_2,'r-',SG.Columnas,SG.Filas,'black');axis equal;
title('Proyeccion SG con fit Polinomial n=2','FontSize',16);
saveas(F3,'Proyeccion AP con fit Polinomial n=2','jpg')

F4 = figure;
F4.Color = 'white';
imshow(1-Proyeccion_SG_Tibia,[]);hold on;
p3 = plot(Fit_SG_Pol_1,'r-',SG.Columnas,SG.Filas,'black');axis equal;
title('Proyeccion SG con fit Polinomial n=1','FontSize',16);
saveas(F4,'Proyeccion SG con fit Polinomial n=1','jpg')

F5 = figure;
F5.Color = 'white';
%imshow(Proyeccion_SG,[]);
imshow(1-Proyeccion_SG_Tibia,[]);hold on;
p3 = plot(Fit_SG_Exp2,'r-',SG.Columnas,SG.Filas,'black');axis equal;
title('Proyeccion SG con Exponencial','FontSize',16);
saveas(F5,'Proyeccion SG con fit Exponencial','jpg')



