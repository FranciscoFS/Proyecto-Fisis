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
    
    AP_F1(k,:) = {Datos{1}.rsquare,Datos{1}.adjrsquare,Datos{1}.rmse};
    AP_F2(k,:) = {Datos{2}.rsquare,Datos{2}.adjrsquare,Datos{2}.rmse};
    SG_P2(k,:) = {Datos{3}.rsquare,Datos{3}.adjrsquare,Datos{3}.rmse};
    SG_P4(k,:) = {Datos{4}.rsquare,Datos{4}.adjrsquare,Datos{4}.rmse};
    
end
Var_names = {'Ajuste_Proyeccion_AP_Fourier_1','Ajuste_Proyeccion_AP_Fourier_2',...
    'Ajuste_Proyeccion_SG_Pol_orden_2','Ajuste_Proyeccion_SG_Pol_orden_4'};
Tabla = table(AP_F1,AP_F2,SG_P2,SG_P4);
Tabla.Properties.VariableNames= Var_names;


%%

[Fit_AP_Fourier2,GOF_AP_F2] = fit(Columnas_AP,Fisis_AP_mean,'fourier1');
[Fit_AP_Lineal,GOF_AP_Lineal] = fit(Columnas_AP,Fisis_AP_mean,'poly1');
[Fit_SG_Pol_2, GOF_P2] = fit(Columnas_SG,Fisis_SG_mean,'poly2');
[Fit_SG_Pol_4, GOF_P4] = fit(Columnas_SG,Fisis_SG_mean,'poly4');


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
p3 = plot(Fit_SG_Pol_4,'b--',Columnas_SG,Fisis_SG_mean,'m:');axis equal;title('AP');

%% Hacer los fit


