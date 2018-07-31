% Pruebas de Perforaci�n
% Angulos, ambos entre -45 a 45+
% Diametros, de 5 a 7 mm
% Se fija la profundidad en 30 mm y 25 mm

uiload();

%% Sexo y edad

Edad = zeros(numel(Base_datos),1);
Sexo = cell(numel(Base_datos),1);

for k=1:numel(Base_datos)
    
    info = Base_datos(k).Rodilla.info;
    Edad(k) = str2num(info{5}(2:3));
    Sexo{k} = info{6};
    
end

Edad_sexo = table(Edad,Sexo);
names = {'Edad','Sexo'};
Edad_sexo.Properties.VariableNames= names;
    

%% Parametros fijos para todos los test

Limit_alpha = 45;
pace_alpha = 5;
Limit_beta = 45;
pace_beta = 5;

%% Test 1
% D = 5
% Profundidad = 30 mm
tic;
D = 5;
P = 30;
[Xx,Yy,Dest_test1] = plot_fcn(Limit_alpha,Limit_beta,pace_alpha,pace_beta,Base_datos,D,P);
toc;

%% Test 2
% D = 6 mm
% P = 30 mm

D = 6;
P = 30;
[~,~,Dest_test2] = plot_fcn(Limit_alpha,Limit_beta,pace_alpha,pace_beta,Base_datos,D,P);

%% Test 3
% D = 7 mm
% P = 30 mm

D = 7;
P = 30;
[~,~,Dest_test3] = plot_fcn(Limit_alpha,Limit_beta,pace_alpha,pace_beta,Base_datos,D,P);

P = 25;
[~,~,Dest_test4] = plot_fcn(Limit_alpha,Limit_beta,pace_alpha,pace_beta,Base_datos,D,P);

%% Interpolacion

Pace = 1;
[Xeq,Yeq] = meshgrid(-Limit_alpha:Pace:Limit_alpha,-Limit_beta:Pace:Limit_beta);
Test1_interp = interp2(Xx,Yy,Dest_test1{4},Xeq,Yeq);
Test2_interp = interp2(Xx,Yy,Dest_test2{4},Xeq,Yeq);
Test3_interp = interp2(Xx,Yy,Dest_test3{4},Xeq,Yeq);
Test4_interp = interp2(Xx,Yy,Dest_test4{4},Xeq,Yeq);
Test_hombres_interp = interp2(Xx,Yy,Dest_test_hombres{4},Xeq,Yeq);
Test_mujeres_interp = interp2(Xx,Yy,Dest_test_mujeres{4},Xeq,Yeq);


%% Test para comparar Hombres vs Mujeres
% Hombres

Hombres = strcmp(Edad_sexo.Sexo, 'M');
Mujeres = strcmp(Edad_sexo.Sexo, 'F');

D = 7;
P = 30;

[~,~,Dest_test_hombres] = plot_fcn(Limit_alpha,Limit_beta,pace_alpha,pace_beta,Base_datos(Hombres),D,P);
[~,~,Dest_test_mujeres] = plot_fcn(Limit_alpha,Limit_beta,pace_alpha,pace_beta,Base_datos(Mujeres),D,P);

%%
figure; plot(-Limit_alpha:pace_alpha:Limit_alpha,sum(Dest_test_mujeres{4},2));
figure; plot(-Limit_alpha:pace_alpha:Limit_alpha,sum(Dest_test_hombres{4},2));
figure;surf(Xx,Yy,Dest_test_hombres{4});
figure;surf(Xx,Yy,Dest_test_mujeres{4})

%%
figure;

subplot(2,2,1); surf(Xx,Yy,Dest_test3{1}); title('Mean + Var -- D=7mm y P=30 mm');
subplot(2,2,2); surf(Xx,Yy,Dest_test3{2}); title('Mean + 0.5*Var -- y P=30 mm');
subplot(2,2,3); surf(Xx,Yy,Dest_test3{3}); title('Norm -- D=7mm y P=30 mm');
subplot(2,2,4); surf(Xx,Yy,Dest_test3{4}); title('Mean -- D=7mm y P=30 mm');


%%

figure;

subplot(2,2,1); surf(Xx,Yy,Dest_test1{4}); title(' D=5mm y P=30 mm');
subplot(2,2,2); surf(Xx,Yy,Dest_test2{4}); title(' D=6mm y P=30 mm');
subplot(2,2,3); surf(Xx,Yy,Dest_test3{4}); title(' D=7mm y P=30 mm');
subplot(2,2,4); surf(Xx,Yy,Dest_test4{4}); title(' D=7mm y P=25 mm');

%%
figure;
subplot(2,2,1); surf(Xeq,Yeq,Test1_interp./max(Test1_interp(:))); title(' D=5mm y P=30 mm');view([0 45])
subplot(2,2,2); surf(Xeq,Yeq,Test2_interp./max(Test2_interp(:))); title(' D=6mm y P=30 mm');view([0 90])
subplot(2,2,3); surf(Xeq,Yeq,Test3_interp./max(Test3_interp(:))); title(' D=7mm y P=30 mm');view([0 90])
subplot(2,2,4); surf(Xeq,Yeq,Test4_interp./max(Test4_interp(:))); title(' D=7mm y P=25 mm');view([0 90])
%%
figure;
subplot(1,2,1); surf(Xx,Yy,Dest_test_hombres{4}); title('Hombres -- D=7mm y P=30 mm');
subplot(1,2,2); surf(Xx,Yy,Dest_test_mujeres{4}); title('Mujeres -- D=7mm y P=30 mm');

%% Cáclulo de máximos

[row_1,col_1] = find(Test1_interp == max(Test1_interp(:)));
alpha_1 = Yeq(row_1,1); beta_1 = Xeq(1,col_1) ;

[row_2,col_2] = find(Test2_interp == max(Test2_interp(:)));
alpha_2 = Yeq(row_2,1); beta_2 = Xeq(1,col_2) ;

[row_3,col_3] = find(Test3_interp == max(Test3_interp(:)));
alpha_3 = Yeq(row_3,1); beta_3 = Xeq(1,col_3) ;

[row_4,col_4] = find(Test4_interp == max(Test4_interp(:)));
alpha_4 = Yeq(row_4,1); beta_4 = Xeq(1,col_4) ;

[row_hombre,col_hombre] = find(Test_hombres_interp == max(Test_hombres_interp(:)));
alpha_hombre = Yeq(row_hombre,1); beta_hombre = Xeq(1,col_hombre) ;

[row_mujer,col_mujer] = find(Test_mujeres_interp == max(Test_mujeres_interp(:)));
alpha_mujer = Yeq(row_mujer,1); beta_mujer = Xeq(1,col_mujer) ;



%% Cáclulo por cada par de ángulo
% Caso 1

Caso_1 = zeros(numel(Base_datos),1);
Caso_2 = zeros(numel(Base_datos),1);
Caso_3 = zeros(numel(Base_datos),1);
Caso_4 = zeros(numel(Base_datos),1);


for k = 1:numel(Base_datos)
    
    Rodilla = Base_datos(k).Rodilla;
    Caso_1(k) = Cilindro_fx_final(Rodilla,alpha_1,beta_1,5,30);
    Caso_2(k) = Cilindro_fx_final(Rodilla,alpha_2,beta_2,6,30);
    Caso_3(k) = Cilindro_fx_final(Rodilla,alpha_3,beta_3,7,30);
    Caso_4(k) = Cilindro_fx_final(Rodilla,alpha_4,beta_4,7,25);

end

%%

Caso_hombres = zeros(sum(strcmp(Sexo,'M')),1);
Caso_mujeres = zeros(sum(strcmp(Sexo,'F')),1);

Base_datos_H = Base_datos(strcmp(Sexo,'M'));
Base_datos_M = Base_datos(strcmp(Sexo,'F'));

for k=1:numel(Base_datos_H)
    
    Rodilla = Base_datos_H(k).Rodilla;
    Caso_hombres(k) = Cilindro_fx_final(Rodilla,alpha_hombre,beta_hombre,7,30);
end

for k=1:numel(Base_datos_M)
    
    Rodilla = Base_datos_M(k).Rodilla;
    Caso_mujeres(k) = Cilindro_fx_final(Rodilla,alpha_mujer,beta_mujer,7,30);
end
%%

[muHat_1,~,muCI_1,~] = normfit(Caso_1);
[muHat_2,~,muCI_2,~] = normfit(Caso_2);
[muHat_3,~,muCI_3,~] = normfit(Caso_3);
[muHat_4,~,muCI_4,~] = normfit(Caso_4);
[muHat_hombres,~,muCI_hombres,~] = normfit(Caso_hombres);
[muHat_mujeres,~,muCI_mujeres,~] = normfit(Caso_mujeres);

Caso_1_CI = {[num2str(muHat_1) '- [' num2str(muCI_1(1)) ' -' num2str(muCI_1(2)) ']']};
Caso_2_CI = {[num2str(muHat_2) '- [' num2str(muCI_2(1)) ' -' num2str(muCI_2(2)) ']']};
Caso_3_CI = {[num2str(muHat_3) '- [' num2str(muCI_3(1)) ' -' num2str(muCI_3(2)) ']']};
Caso_4_CI = {[num2str(muHat_4) '- [' num2str(muCI_4(1)) ' -' num2str(muCI_4(2)) ']']};
Caso_hombres_CI = {[num2str(muHat_hombres) '- [' num2str(muCI_hombres(1)) ' -' num2str(muCI_hombres(2)) ']']};
Caso_mujeres_CI = {[num2str(muHat_mujeres) '- [' num2str(muCI_mujeres(1)) ' -' num2str(muCI_mujeres(2)) ']']};

Tabla = table(Caso_1_CI,Caso_2_CI,Caso_3_CI,Caso_4_CI,Caso_hombres_CI,Caso_mujeres_CI);
Var_names = {'Caso1','Caso2','Caso3','Caso4','Caso_hombres','Caso_mujeres'};
Tabla.Properties.VariableNames= Var_names;

%% Comparacion entre hombres y mujeres

[h,p] = ttest2(Caso_hombres,Caso_mujeres);

%% Cálculo mínimos pero proyectando (asumiendo Beta = 0)

[row_1_min] = find(sum(Test1_interp,2) == min(sum(Test1_interp,2)));
alpha_1_min = Yeq(row_1_min,1);

[row_2_min] = find(sum(Test2_interp,2) == min(sum(Test2_interp,2)));
alpha_2_min = Yeq(row_2_min,1);

[row_3_min] = find(sum(Test3_interp,2) == min(sum(Test3_interp,2)));
alpha_3_min = Yeq(row_3_min,1);

[row_4_min] = find(sum(Test4_interp,2) == min(sum(Test4_interp,2)));
alpha_4_min = Yeq(row_4_min,1);

[row_hombre_min] = find(sum(Test_hombres_interp,2) == min(sum(Test_hombres_interp,2)));
alpha_hombre_min = Yeq(row_hombre_min,1);

[row_mujer_min] = find(sum(Test_mujeres_interp,2) == min(sum(Test_mujeres_interp,2)));
alpha_mujer_min = Yeq(row_mujer_min,1);

%% Cálculo de destrucción para los ángulos mínimo

alpha_min = 45;
Beta_min = 0;

Caso_1_min = zeros(numel(Base_datos),1);
Caso_2_min = zeros(numel(Base_datos),1);
Caso_3_min = zeros(numel(Base_datos),1);
Caso_4_min = zeros(numel(Base_datos),1);

for k = 1:numel(Base_datos)
    
    Rodilla = Base_datos(k).Rodilla;
    Caso_1_min(k) = Cilindro_fx_final(Rodilla,alpha_min,Beta_min,5,30);
    Caso_2_min(k) = Cilindro_fx_final(Rodilla,alpha_min,Beta_min,6,30);
    Caso_3_min(k) = Cilindro_fx_final(Rodilla,alpha_min,Beta_min,7,30);
    Caso_4_min(k) = Cilindro_fx_final(Rodilla,alpha_min,Beta_min,7,25);
end

%%
Caso_hombres_min = zeros(sum(strcmp(Sexo,'M')),1);
Caso_mujeres_min = zeros(sum(strcmp(Sexo,'F')),1);


for k=1:numel(Base_datos_H)
    
    Rodilla = Base_datos_H(k).Rodilla;
    Caso_hombres_min(k) = Cilindro_fx_final(Rodilla,alpha_min,Beta_min,7,30);
end

for k=1:numel(Base_datos_M)
    
    Rodilla = Base_datos_M(k).Rodilla;
    Caso_mujeres_min(k) = Cilindro_fx_final(Rodilla,alpha_min,Beta_min,7,30);
end

%%
[muHat_1,~,muCI_1,~] = normfit(Caso_1_min);
[muHat_2,~,muCI_2,~] = normfit(Caso_2_min);
[muHat_3,~,muCI_3,~] = normfit(Caso_3_min);
[muHat_4,~,muCI_4,~] = normfit(Caso_4_min);
[muHat_hombres,~,muCI_hombres,~] = normfit(Caso_hombres_min);
[muHat_mujeres,~,muCI_mujeres,~] = normfit(Caso_mujeres_min);

Caso_1_CI = {[num2str(muHat_1) '- [' num2str(muCI_1(1)) ' -' num2str(muCI_1(2)) ']']};
Caso_2_CI = {[num2str(muHat_2) '- [' num2str(muCI_2(1)) ' -' num2str(muCI_2(2)) ']']};
Caso_3_CI = {[num2str(muHat_3) '- [' num2str(muCI_3(1)) ' -' num2str(muCI_3(2)) ']']};
Caso_4_CI = {[num2str(muHat_4) '- [' num2str(muCI_4(1)) ' -' num2str(muCI_4(2)) ']']};
Caso_hombres_CI = {[num2str(muHat_hombres) '- [' num2str(muCI_hombres(1)) ' -' num2str(muCI_hombres(2)) ']']};
Caso_mujeres_CI = {[num2str(muHat_mujeres) '- [' num2str(muCI_mujeres(1)) ' -' num2str(muCI_mujeres(2)) ']']};

Tabla_min = table(Caso_1_CI,Caso_2_CI,Caso_3_CI,Caso_4_CI,Caso_hombres_CI,Caso_mujeres_CI);
Var_names = {'Caso1','Caso2','Caso3','Caso4','Caso_hombres','Caso_mujeres'};
Tabla_min.Properties.VariableNames= Var_names;