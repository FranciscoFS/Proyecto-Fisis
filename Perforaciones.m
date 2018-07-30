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

