%% Hacer el fit para toda la base de datos

Largo = numel(Base_datos);

contador = 1;
for k = 1: Largo
 prueba = Base_datos(k).Rodilla;
 prueba2 = prueba.mascara == 4;
 if sum(prueba2(:))>0
    Base_datos_2(contador).Rodilla = prueba;
    contador = contador + 1;
 end
end

Largo = numel(Base_datos_2);

AP_F1 = cell(Largo,3);
AP_F2 = cell(Largo,3);
SG_P2 = cell(Largo,3);  
SG_E2 = cell(Largo,3);
Distribucion = struct();
Datos_fit = struct();
Coeficientes = table();

%%
for k = 1 : Largo
    
    [AP,SG] = Proyecciones_tibia(Base_datos_2(k).Rodilla);
    
    Distribucion(k).AP = AP;
    Distribucion(k).SG = SG;
    
    dx = Base_datos(k).Rodilla.info{1};
    
    AP_norm.Columnas = Normalizar(AP.Columnas,dx);
    AP_norm.Filas = -1*Normalizar(AP.Filas,dx);
    SG_norm.Columnas = Normalizar(SG.Columnas,dx);
    SG_norm.Filas = -1*Normalizar(SG.Filas,dx);
    
    Distribucion(k).AP_norm = AP_norm;
    Distribucion(k).SG_norm = SG_norm;
    
%     Datos = Fit_fisis_tibia(AP_norm,SG_norm);
%     Datos_fit(k).Datos = Datos;
%     
%     Coeficientes{k,1} = coeffvalues(Datos{2,1});
%     Coeficientes{k,2} = coeffvalues(Datos{2,2});
%     Coeficientes{k,3} = coeffvalues(Datos{2,3});
%     Coeficientes{k,4} = coeffvalues(Datos{2,4});
%     
%     % Campos de Datos: sse, rsquare, dfe, adjrsquared, rmse(Serian pixeles)
%     % Datos: 1_ AP-F1, 2_AP-F2, 3_ SG_P2, 4_ SG-E2
%     
%     AP_F1(k,:) = {Datos{1,1}.rsquare,Datos{1,1}.adjrsquare,Datos{1,1}.rmse};
%     AP_F2(k,:) = {Datos{1,2}.rsquare,Datos{1,2}.adjrsquare,Datos{1,2}.rmse};
%     SG_P2(k,:) = {Datos{1,3}.rsquare,Datos{1,3}.adjrsquare,Datos{1,3}.rmse};
%     SG_E2(k,:) = {Datos{1,4}.rsquare,Datos{1,4}.adjrsquare,Datos{1,4}.rmse};
end

%%
Var_names = {'Ajuste_Proyeccion_AP_Fourier_1','Ajuste_Proyeccion_AP_Fourier_2',...
    'Ajuste_Proyeccion_SG_Pol_orden_2','Ajuste_Proyeccion_SG_Exp_2'};
Tabla = table(AP_F1,AP_F2,SG_P2,SG_E2);
Tabla.Properties.VariableNames= Var_names;

%%

[muHat_F1,sigmaHat_F1,muCI_F1,sigmaCI_F1] = normfit(cell2mat(AP_F1));
[muHat_F2,sigmaHat_F2,muCI_F2,sigmaCI_F2] = normfit(cell2mat(AP_F2));
[muHat_P2,sigmaHat_P2,muCI_P2,sigmaCI_P2] = normfit(cell2mat(SG_P2));
[muHat_E2,sigmaHat_E2,muCI_E2,sigmaCI_E2] = normfit(cell2mat(SG_E2));

F1 = {[num2str(muHat_F1(1)) '- [' num2str(muCI_F1(1,1)) ' -' num2str(muCI_F1(2,1)) ']'],...
    [num2str(muHat_F1(2)) '- [' num2str(muCI_F1(1,2)) ' -' num2str(muCI_F1(2,2)) ']'],...
    [num2str(muHat_F1(3)) '- [' num2str(muCI_F1(1,3)) ' -' num2str(muCI_F1(2,3)) ']']};

F2 = {[num2str(muHat_F2(1)) '- [' num2str(muCI_F2(1,1)) ' -' num2str(muCI_F2(2,1)) ']'],...
    [num2str(muHat_F2(2)) '- [' num2str(muCI_F2(1,2)) ' -' num2str(muCI_F2(2,2)) ']'],...
    [num2str(muHat_F2(3)) '- [' num2str(muCI_F2(1,3)) ' -' num2str(muCI_F2(2,3)) ']']};

P2 = {[num2str(muHat_P2(1)) '- [' num2str(muCI_P2(1,1)) ' -' num2str(muCI_P2(2,1)) ']'],...
    [num2str(muHat_P2(2)) '- [' num2str(muCI_P2(1,2)) ' -' num2str(muCI_P2(2,2)) ']'],...
    [num2str(muHat_P2(3)) '- [' num2str(muCI_P2(1,3)) ' -' num2str(muCI_P2(2,3)) ']']};

E2 = {[num2str(muHat_E2(1)) '- [' num2str(muCI_E2(1,1)) ' -' num2str(muCI_E2(2,1)) ']'],...
    [num2str(muHat_E2(2)) '- [' num2str(muCI_E2(1,2)) ' -' num2str(muCI_E2(2,2)) ']'],...
    [num2str(muHat_E2(3)) '- [' num2str(muCI_E2(1,3)) ' -' num2str(muCI_E2(2,3)) ']']};

Tabla_2 = table(F1,F2,P2,E2);
Var_names = {'Ajuste_Proyeccion_AP_Fourier_1','Ajuste_Proyeccion_AP_Fourier_2',...
    'Ajuste_Proyeccion_SG_Pol_orden_2','Ajuste_Proyeccion_SG_Exp_2'};
Tabla_2.Properties.VariableNames= Var_names;

%%
xlswrite('Medias_datos_fit_tibia.xlsx',Tabla_2)
%%

[Fit_AP_Fourier2,GOF_AP_F2] = fit(Columnas_AP,Fisis_AP_mean,'fourier1');
[Fit_AP_Lineal,GOF_AP_Lineal] = fit(Columnas_AP,Fisis_AP_mean,'poly1');
[Fit_SG_Pol_2, GOF_P2] = fit(Columnas_SG,Fisis_SG_mean,'poly2');
[Fit_SG_Pol_4, GOF_E2] = fit(Columnas_SG,Fisis_SG_mean,'poly4');


%subplot(2,2,1);scatter(Columnas_AP,Fisis_AP_mean);axis equal; title('Proyeecion Antero-Posterior');
subplot(2,1,1);hold on;
imshow(Proyeccion_AP,[]);
%scatter(Columnas_AP,Fisis_AP_mean,8,'red');axis equal;title('AP');
p1 = plot(Fit_AP_Fourier2,Columnas_AP,Fisis_AP_mean,8,'y');axis equal;title('AP');

%subplot(2,2,3);scatter(Columnas_SG,Fisis_SG_mean);axis equal;title('Proyeccion Sagital');
subplot(2,1,2);hold on; 
imshow(Proyeccion_SG,[]);
%scatter(Columnas_SG,Fisis_SG_mean,5,'red');axis equal;title('SG mean');
p2 = plot(Fit_SG_Pol_2,'r--',Columnas_SG,Fisis_SG_mean,'m:');axis equal;title('AP');