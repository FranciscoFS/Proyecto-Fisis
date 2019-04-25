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
P = 30;

%% Test 1
% D = 5
% Profundidad = 30 mm
tic;
D = 5;
[Xx,Yy,Dest_test1_30] = plot_fcn(Limit_alpha,Limit_beta,pace_alpha,pace_beta,Base_datos,D,P);

%

% Test 2
% D = 6 mm
% P = 30 mm
%%
tic;

D = 6;

[~,~,Dest_test2] = plot_fcn(Limit_alpha,Limit_beta,pace_alpha,pace_beta,Base_datos,D,P);

% Test 3
% D = 7 mm
% P = 30 mm

D = 7;

[Xx,Yy,Dest_test3] = plot_fcn(Limit_alpha,Limit_beta,pace_alpha,pace_beta,Base_datos,D,P);
toc;

%[~,~,Dest_test4] = plot_fcn(Limit_alpha,Limit_beta,pace_alpha,pace_beta,Base_datos,D,P);

%% Interpolacion

Pace = 1;
[Xeq,Yeq] = meshgrid(-Limit_alpha:Pace:Limit_alpha,-Limit_beta:Pace:Limit_beta);
Test1_interp = interp2(Xx,Yy,Dest_test1{4},Xeq,Yeq,'cubic');
Test2_interp = interp2(Xx,Yy,Dest_test2{4},Xeq,Yeq,'cubic');
Test3_interp = interp2(Xx,Yy,Dest_test3{4},Xeq,Yeq,'cubic');
%Test4_interp = interp2(Xx,Yy,Dest_test4{4},Xeq,Yeq);
Test_hombres_interp = interp2(Xx,Yy,Dest_test_hombres{4},Xeq,Yeq);
Test_mujeres_interp = interp2(Xx,Yy,Dest_test_mujeres{4},Xeq,Yeq);


%% Test para comparar Hombres vs Mujeres
% Hombres

Hombres = strcmp(Edad_sexo.Sexo, 'M');
Mujeres = strcmp(Edad_sexo.Sexo, 'F');

D = 6;
P = 20;

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

subplot(2,2,1); surf(Xx,Yy,Dest_test1{2}); title(' D=5mm y P=20 mm');
subplot(2,2,2); surf(Xx,Yy,Dest_test2{2}); title(' D=6mm y P=20 mm');
subplot(2,2,3); surf(Xx,Yy,Dest_test3{2}); title(' D=7mm y P=20 mm');
%subplot(2,2,4); surf(Xx,Yy,Dest_test4{4}); title(' D=7mm y P=25 mm');

%%
f1 = figure;surf(Xeq,Yeq,Test1_interp,'LineStyle','none'); 
title(' D=5mm y P=30 mm');hold on; f1.Color = 'white'; grid off;
scatter3(beta_1,alpha_1,Test1_interp(row_1,col_1),50,'red','filled'); 
scatter3(Beta_1_min,0,Test1_interp(46,row_1_min),50,'red','filled');
colorbar
axis tight
axis off
%%
f2 = figure; surf(Xeq,Yeq,Test2_interp,'LineStyle','none');
title(' D=6mm y P=30 mm'); hold on; f2.Color = 'white'; grid off;
scatter3(beta_2,alpha_2,Test2_interp(row_2,col_1),50,'red','filled'); 
scatter3(Beta_2_min,0,Test2_interp(46,col_2_min),50,'red','filled');
colorbar
axis tight
axis off
%%
f3 = figure; surf(Xeq,Yeq,Test3_interp,'LineStyle','none');
%title(' D=7mm y P=30 mm'); 
hold on; f3.Color = 'white'; grid off;
scatter3(beta_3,alpha_1,Test3_interp(row_3,col_1),50,'red','filled'); 
scatter3(Beta_3_min,0,Test3_interp(46,col_3_min),50,'red','filled');
colorbar
axis tight
axis off
%subplot(2,2,4); surf(Xeq,Yeq,Test4_interp./max(Test4_interp(:))); title(' D=7mm y P=25 mm');view([0 90])
%% Hombres
f4 = figure; surf(Xeq,Yeq,Test_hombres_interp,'LineStyle','none');
title(' D=7mm y P=30 mm'); hold on; f4.Color = 'white'; grid off;
scatter3(beta_3,alpha_1,Test_hombres_interp(row_3,col_1),50,'red','filled'); 
scatter3(Beta_3_min,0,Test_hombres(46,col_3_min),50,'red','filled');
colorbar
axis tight
axis off
%%
f4 = figure; surf(Xeq,Yeq,Test3_interp,'LineStyle','none');
title(' D=7mm y P=30 mm'); hold on; f4.Color = 'white'; grid off;
scatter3(beta_3,alpha_1,Test3_interp(row_3,col_1),50,'red','filled'); 
scatter3(Beta_3_min,0,Test3_interp(46,col_3_min),50,'red','filled');
colorbar
axis tight
axis off
%%

figure;
subplot(1,2,1); surf(Xx,Yy,Dest_test_hombres{4}); title('Hombres -- D=7mm y P=30 mm');
subplot(1,2,2); surf(Xx,Yy,Dest_test_mujeres{4}); title('Mujeres -- D=7mm y P=30 mm');

%% Cáclulo de máximos X corresponde a Beta (columnas),

[row_1,col_1] = find(Test1_interp == max(Test1_interp(:)));
alpha_1_max = Yeq(row_1,1); beta_1_max = Xeq(1,col_1) ;

[row_2,col_2] = find(Test2_interp == max(Test2_interp(:)));
alpha_2_max = Yeq(row_2,1); beta_2_max = Xeq(1,col_2) ;

[row_3,col_3] = find(Test3_interp == max(Test3_interp(:)));
alpha_3_max = Yeq(row_3,1); beta_3_max = Xeq(1,col_3) ;

% [row_4,col_4] = find(Test4_interp == max(Test4_interp(:)));
% alpha_4 = Yeq(row_4,1); beta_4 = Xeq(1,col_4) ;
% 
[row_hombre,col_hombre] = find(Test_hombres_interp == max(Test_hombres_interp(:)));
alpha_hombre_max = Yeq(row_hombre,1); beta_hombre_max = Xeq(1,col_hombre) ;

[row_mujer,col_mujer] = find(Test_mujeres_interp == max(Test_mujeres_interp(:)));
alpha_mujer_max = Yeq(row_mujer,1); beta_mujer_max = Xeq(1,col_mujer) ;



%% Cáclulo por cada par de ángulo
% Caso 1

Caso_1 = zeros(numel(Base_datos),1);
Caso_2 = zeros(numel(Base_datos),1);
Caso_3 = zeros(numel(Base_datos),1);
Caso_4 = zeros(numel(Base_datos),1);


for k = 1:numel(Base_datos)
    
    Rodilla = Base_datos(k).Rodilla;
    Caso_1(k) = Cilindro_fx_final(Rodilla,alpha_1_max,beta_1_max,5,20);
    Caso_2(k) = Cilindro_fx_final(Rodilla,alpha_2_max,beta_2_max,6,20);
    Caso_3(k) = Cilindro_fx_final(Rodilla,alpha_3_max,beta_3_max,7,20);
    %Caso_4(k) = Cilindro_fx_final(Rodilla,alpha_4,beta_4,7,25);

end

%%

Caso_hombres = zeros(sum(strcmp(Sexo,'M')),1);
Caso_mujeres = zeros(sum(strcmp(Sexo,'F')),1);

Base_datos_H = Base_datos(strcmp(Sexo,'M'));
Base_datos_M = Base_datos(strcmp(Sexo,'F'));

for k=1:numel(Base_datos_H)
    
    Rodilla = Base_datos_H(k).Rodilla;
    Caso_hombres(k) = Cilindro_fx_final(Rodilla,alpha_hombre_max,beta_hombre_max,6,20);
end

for k=1:numel(Base_datos_M)
    
    Rodilla = Base_datos_M(k).Rodilla;
    Caso_mujeres(k) = Cilindro_fx_final(Rodilla,alpha_mujer_max,beta_mujer_max,6,20);
end
%%

[muHat_1,~,muCI_1,~] = normfit(squeeze(Caso_1(row_1,col_1,:)));
[muHat_2,~,muCI_2,~] = normfit(squeeze(Caso_2(row_2,col_2,:)));
[muHat_3,~,muCI_3,~] = normfit(squeeze(Caso_3(row_3,col_3,:)));
% [muHat_4,~,muCI_4,~] = normfit(Caso_4);
[muHat_hombres,~,muCI_hombres,~] = normfit(squeeze(Caso_H(row_1,col_hombre,:)));
[muHat_mujeres,~,muCI_mujeres,~] = normfit(squeeze(Caso_M(row_1,col_mujer,:)));

Caso_1_CI = {[num2str(muHat_1) '- [' num2str(muCI_1(1)) ' -' num2str(muCI_1(2)) ']']};
Caso_2_CI = {[num2str(muHat_2) '- [' num2str(muCI_2(1)) ' -' num2str(muCI_2(2)) ']']};
Caso_3_CI = {[num2str(muHat_3) '- [' num2str(muCI_3(1)) ' -' num2str(muCI_3(2)) ']']};
% Caso_4_CI = {[num2str(muHat_4) '- [' num2str(muCI_4(1)) ' -' num2str(muCI_4(2)) ']']};
Caso_hombres_CI = {[num2str(muHat_hombres) '- [' num2str(muCI_hombres(1)) ' -' num2str(muCI_hombres(2)) ']']};
Caso_mujeres_CI = {[num2str(muHat_mujeres) '- [' num2str(muCI_mujeres(1)) ' -' num2str(muCI_mujeres(2)) ']']};

% Tabla = table(Caso_1_CI,Caso_2_CI,Caso_3_CI,Caso_4_CI,Caso_hombres_CI,Caso_mujeres_CI);
% Var_names = {'Caso1','Caso2','Caso3','Caso4','Caso_hombres','Caso_mujeres'};
% Tabla.Properties.VariableNames= Var_names;

Tabla = table(Caso_1_CI,Caso_2_CI,Caso_3_CI,Caso_hombres_CI,Caso_mujeres_CI);
Var_names = {'Caso1','Caso2','Caso3','Caso_hombres','Caso_mujeres'};
Tabla.Properties.VariableNames= Var_names;

% [p,tbl,stats] = anova1([Caso_1 Caso_2 Caso_3]);
% c = multcompare(stats);
[p,tbl,stats_max] = anova1([squeeze(Caso_1(row_1,col_1,:)) squeeze(Caso_2(row_2,col_2,:)) squeeze(Caso_3(row_3,col_3,:))]);
c = multcompare(stats_max);
%% Comparacion entre hombres y mujeres

[h,p] = ttest2(Caso_hombres,Caso_mujeres);

%% Cálculo Minimo pero proyectando (asumiendo alpha = 0)
%  X corresponde a Beta (columnas),

[col_1_min] = find(Test1_interp(45,:) == min(Test1_interp(45,:)));
Beta_1_min = Xeq(1,col_1_min);

[col_2_min] = find(Test2_interp(45,:) == min(Test2_interp(45,:)));
Beta_2_min = Xeq(1,col_2_min);

[col_3_min] = find(Test3_interp(45,:) == min(Test3_interp(45,:)));
Beta_3_min = Xeq(1,col_3_min);

% [row_4_min] = find(sum(Test4_interp,2) == min(sum(Test4_interp,2)));
% alpha_4_min = Yeq(row_4_min,1);
% 
[col_H_min] = find(sum(Test_hombres_interp,2) == min(sum(Test_hombres_interp,2)));
alpha_hombre_min = Yeq(col_H_min,1);

[col_M_min] = find(sum(Test_mujeres_interp,2) == min(sum(Test_mujeres_interp,2)));
alpha_mujer_min = Yeq(col_M_min,1);

%% Cálculo de destrucción para los ángulos mínimo

alpha_min = 0;
Beta_min = 45;

Caso_1_min = zeros(numel(Base_datos),1);
Caso_2_min = zeros(numel(Base_datos),1);
Caso_3_min = zeros(numel(Base_datos),1);
%Caso_4_min = zeros(numel(Base_datos),1);

for k = 1:numel(Base_datos)
    
    Rodilla = Base_datos(k).Rodilla;
    Caso_1_min(k) = Cilindro_fx_final(Rodilla,alpha_min,Beta_min,5,30);
    Caso_2_min(k) = Cilindro_fx_final(Rodilla,alpha_min,Beta_min,6,30);
    Caso_3_min(k) = Cilindro_fx_final(Rodilla,alpha_min,Beta_min,7,30);
    %Caso_4_min(k) = Cilindro_fx_final(Rodilla,alpha_min,Beta_min,7,25);
end

%%

Caso_hombres_min = zeros(sum(strcmp(Sexo,'M')),1);
Caso_mujeres_min = zeros(sum(strcmp(Sexo,'F')),1);


for k=1:numel(Base_datos_H)
    
    Rodilla = Base_datos_H(k).Rodilla;
    Caso_hombres_min(k) = Cilindro_fx_final(Rodilla,0,45,6,20);
end

for k=1:numel(Base_datos_M)
    
    Rodilla = Base_datos_M(k).Rodilla;
    Caso_mujeres_min(k) = Cilindro_fx_final(Rodilla,0,45,6,20);
end

%%
[muHat_1,~,muCI_1,~] = normfit(squeeze(Caso_1(45,col_1_min,:)));
[muHat_2,~,muCI_2,~] = normfit(squeeze(Caso_2(45,col_2_min,:)));
[muHat_3,~,muCI_3,~] = normfit(squeeze(Caso_3(45,col_3_min,:)));
% [muHat_4,~,muCI_4,~] = normfit(Caso_4_min);
[muHat_hombres,~,muCI_hombres,~] = normfit(squeeze(Caso_H(45,col_H_min,:)));
[muHat_mujeres,~,muCI_mujeres,~] = normfit(squeeze(Caso_M(45,col_M_min,:)));

Caso_1_CI = {[num2str(muHat_1) '- [' num2str(muCI_1(1)) ' -' num2str(muCI_1(2)) ']']};
Caso_2_CI = {[num2str(muHat_2) '- [' num2str(muCI_2(1)) ' -' num2str(muCI_2(2)) ']']};
Caso_3_CI = {[num2str(muHat_3) '- [' num2str(muCI_3(1)) ' -' num2str(muCI_3(2)) ']']};
% Caso_4_CI = {[num2str(muHat_4) '- [' num2str(muCI_4(1)) ' -' num2str(muCI_4(2)) ']']};
Caso_hombres_CI = {[num2str(muHat_hombres) '- [' num2str(muCI_hombres(1)) ' -' num2str(muCI_hombres(2)) ']']};
Caso_mujeres_CI = {[num2str(muHat_mujeres) '- [' num2str(muCI_mujeres(1)) ' -' num2str(muCI_mujeres(2)) ']']};

Tabla_min = table(Caso_1_CI,Caso_2_CI,Caso_3_CI,Caso_hombres_CI,Caso_mujeres_CI);
Var_names = {'Caso1','Caso2','Caso3','Caso_hombres','Caso_mujeres'};
Tabla_min.Properties.VariableNames= Var_names;

% Tabla = table(Caso_1_CI,Caso_2_CI,Caso_3_CI,Caso_hombres_CI,Caso_mujeres_CI);
% Var_names = {'Caso1','Caso2','Caso3','Caso_hombres','Caso_mujeres'};
% Tabla.Properties.VariableNames= Var_names;

%[p,tbl,stats] = anova1([Caso_1_min Caso_2_min Caso_3_min])
%c = multcompare(stats)
%%

Alpha = -Limit_alpha:pace_alpha:Limit_alpha;
Beta = -Limit_beta:pace_beta:Limit_beta;

[Xx,Yy] = meshgrid(Alpha,Beta);
Is_in_1 = zeros(size(Xx));
Is_in_2 = zeros(size(Xx));
Is_in_3 = zeros(size(Xx));


for k=1:length(Alpha)

    for i = 1:length(Beta)
        
        Cilindro1 = Crear_solo_cilindro2(V_out,Alpha(k),Beta(i),D,P);
        Cilindro2 = Crear_solo_cilindro2(V_out,Alpha(k),Beta(i),D,P);
        Cilindro3 = Crear_solo_cilindro2(V_out,Alpha(k),Beta(i),D,P);

        Is_in(k,i) = Fuera_femur(V_out,Cilindro1);
    end 

    fprintf('Angulo actual %d \n',k)

end

%% Cálculo de Todas las perforacions para Beta = 45 Alpha = 0 D=7 y P = 30mm

Beta_min = 45; Beta_max = 0;
alpha_min = 0; alpha_max = -25;


Caso_todos_max = zeros(numel(Base_datos),1);
Caso_todos_min = zeros(numel(Base_datos),1);

for k=1:numel(Base_datos)
    
        fprintf('Trabajando en %d \n',k)
        Rodilla = Base_datos(k).Rodilla;
        Caso_todos_max(k) = Cilindro_fx_final(Rodilla,alpha_max,Beta_max,7,30);
        Caso_todos_min(k) = Cilindro_fx_final(Rodilla,alpha_min,Beta_min,7,30);
        
end

%% Por edades Max vs Min

Edades = unique(Edad_sexo.Edad);
Dest_edad_max = zeros(size(Edades));
Error_edad_max = zeros(size(Edades));

Dest_edad_min = zeros(size(Edades));
Error_edad_min = zeros(size(Edades));
N_xEdad = zeros(size(Error_edad_min));


for i=1:length(Edades)
    
    Indice = Edad_sexo.Edad == Edades(i);
    N_xEdad(i) = sum(Indice);    
    Dest_edad_max(i) = mean(Caso_todos_max(Indice));
    x_max = Caso_todos_max(Indice);                      % Create Data
    SEM_max = std(x_max)/sqrt(length(x_max));               % Standard Error
    ts_max = tinv([0.05  0.95],length(x_max)-1);      % T-Score 
    Error_edad_max(i) = abs(ts_max(1)*SEM_max);
    
    Dest_edad_min(i) = mean(Caso_todos_min(Indice));
    x_min = Caso_todos_min(Indice);                      % Create Data
    SEM_min = std(x_min)/sqrt(length(x_min));               % Standard Error
    ts_min = tinv([0.05  0.95],length(x_min)-1);      % T-Score   
    Error_edad_min(i) = abs(ts_min(1)*SEM_min);

end

ax1=figure;
hold on
ax1.Color = 'white';
bar(Edades,Dest_edad_max)
errorbar(Edades,Dest_edad_max,zeros(size(Edades)),Error_edad_max,'.')

ax2=figure;
hold on
ax2.Color = 'white';
bar(Edades,Dest_edad_min)
errorbar(Edades,Dest_edad_min,zeros(size(Edades)),Error_edad_min,'.')

%% Para sexo

Sexos = unique(Edad_sexo.Sexo);
Dest_sexo_max = zeros(size(Sexos));
Error_sexo_max = zeros(size(Sexos));

Dest_sexo_min = zeros(size(Sexos));
Error_sexo_min = zeros(size(Sexos));
N_xEdad = zeros(size(Error_sexo_min));

for i=1:length(Sexos)
    
    Indice = strcmp(Edad_sexo.Sexo, Sexos{i});
    N_xEdad(i) = sum(Indice);
    Dest_sexo_max(i) = mean(Caso_todos_max(Indice));
    x_max = Caso_todos_max(Indice);                      % Create Data
    SEM_max = std(x_max)/sqrt(length(x_max));               % Standard Error
    ts_max = tinv([0.05  0.95],length(x_max)-1);      % T-Score
    Error_sexo_max(i) = abs(ts_max(1)*SEM_max);
    
    Dest_sexo_min(i) = mean(Caso_todos_min(Indice));
    x_min = Caso_todos_min(Indice);                      % Create Data
    SEM_min = std(x_min)/sqrt(length(x_min));               % Standard Error
    ts_min = tinv([0.05  0.95],length(x_min)-1);      % T-Score   
    Error_sexo_min(i) = abs(ts_min(1)*SEM_min);
    
end
%%
ax = figure;
hold on
ax.Color = 'white';
bar(1:2,Dest_sexo_max)
errorbar(1:2,Dest_sexo_max,zeros(size(Sexos)),Error_sexo_max,'.','CapSize',40)
[h,p] = ttest2(Caso_todos_max(strcmp(Edad_sexo.Sexo, Sexos{2})),Caso_todos_max(strcmp(Edad_sexo.Sexo, Sexos{1})))
xticks([1 2])
xticklabels({'Mujeres','Hombres'})

ax2 = figure;
hold on
ax2.Color = 'white';
bar(1:2,Dest_sexo_min)
errorbar(1:2,Dest_sexo_min,zeros(size(Sexos)),Error_sexo_min,'.','CapSize',40)
[h2,p2] = ttest2(Caso_todos_min(strcmp(Edad_sexo.Sexo, Sexos{2})),Caso_todos_min(strcmp(Edad_sexo.Sexo, Sexos{1})))
xticks([1 2])
xticklabels({'Mujeres','Hombres'})

%% ANOVASN

[p,tbl,stats_max] = anovan(squeeze(Caso_3(row_3,col_3,:)),{Edad_sexo.Edad})
c = multcompare(stats_max)
%%
[p,tbl,stats_min] = anovan(Caso_todos_min,{Edad_sexo.Edad});
%c = multcompare(stats_min)

%%

Edades = unique(Edad);
Datos_edad = table();
Caso_usar = Caso_1;

for k=1:length(Edades)+1
     
    if k <= length(Edades)
        Indice = Edad == Edades(k);
        Caso_edad = Caso_usar(:,:,Indice);
        [alpha,beta,muHat,muCI] = Calculo_angulo(Caso_edad,Xeq,Yeq);

        Datos_edad{k,1} = alpha.max;
        Datos_edad{k,2} = beta.max;
        Datos_edad{k,3} = {[num2str(muHat.max) '- [' num2str(muCI.max(1)) ' -' num2str(muCI.max(2)) ']']};

        Datos_edad{k,4} = alpha.min;
        Datos_edad{k,5} = beta.min;
        Datos_edad{k,6} = {[num2str(muHat.min) '- [' num2str(muCI.min(1)) ' -' num2str(muCI.min(2)) ']']};
        Datos_edad{k,7} = {Edades(k)};
        
    else
        
        Caso_edad = Caso_usar;
        [alpha,beta,muHat,muCI] = Calculo_angulo(Caso_edad,Xeq,Yeq);

        Datos_edad{k,1} = alpha.max;
        Datos_edad{k,2} = beta.max;
        Datos_edad{k,3} = {[num2str(muHat.max) '- [' num2str(muCI.max(1)) ' -' num2str(muCI.max(2)) ']']};

        Datos_edad{k,4} = alpha.min;
        Datos_edad{k,5} = beta.min;
        Datos_edad{k,6} = {[num2str(muHat.min) '- [' num2str(muCI.min(1)) ' -' num2str(muCI.min(2)) ']']};
        Datos_edad{k,7} = {'Todos'};
    end
end

Var_names = {'Alpha_max','Beta_max','Mean_Max','Alpha_min','Beta_min','Mean_Min','Edad'};
Datos_edad.Properties.VariableNames= Var_names;
Tabla_5mm_Edad = Datos_edad;

writetable(Datos_edad,'Tabla_5mm.xlsx');