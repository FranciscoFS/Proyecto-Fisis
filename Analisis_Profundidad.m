%% Analizis de Contenido vs Distancia Para hacerlo con MESHGRID para ver 
% pequeños cambios

info = V_out.info;
dxdy = info{1};
dz = info{2};
pace = (dxdy/dz);
[m,n,k] = size(V_out.mascara);
[Xq,Yq,Zq] = meshgrid(1:n,1:m,1:pace:k);
Rodilla = interp3(im2double(V_out.mascara ==1),Xq,Yq,Zq);
Fisis = interp3(im2double(V_out.mascara ==2),Xq,Yq,Zq);

alfa = 0;
beta = 45;
D = 5;
p = 25;

Taladro = Crear_solo_cilindro_test(V_out,V_out.mascara==1,alfa,beta,D,p);

Fuera_femur(V_out, Taladro)

%%

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

%% Edad< 13;
% Indice = Edad_sexo.Edad >=13;
 Indice = Edad_sexo.Edad < 20;
% Indice = Edad_sexo.Sexo == 'F';
%Indice = strcmp(Edad_sexo.Sexo, 'F');

%%

tic;
p=10:30;
alfa = 0;
beta = 45;
D = 6;
Union = zeros(1,length(p));
Base_datos_usar = Base_datos(Indice);

for i=1:length(p)
    Contenido = zeros(1,numel(Base_datos_usar));
    Profundidad = p((end + 1) - i);
    
    for k=1:numel(Base_datos_usar)
        
        Rodilla = Base_datos_usar(k).Rodilla;
        Taladro = Crear_solo_cilindro_test(Rodilla, Rodilla.mascara==1,alfa,beta,D,Profundidad);
        Contenido(k) = Fuera_femur(Rodilla,Taladro);
        
    end
    
    [muHat_1,~,muCI_1,~] = normfit(Contenido);
    Union(1,i) = mean(Contenido);
    Union(2,i) = muCI_1(1);
    Union(3,i) = muCI_1(2);

end
toc;  

plot(flip(10:30),Union(1,:));hold on;scatter(flip(10:30),Union(2,:),'red');scatter(flip(10:30),Union(3,:),'red');
%%

subplot(2,2,1);plot(flip(10:30),Hombres(1,:));hold on;scatter(flip(10:30),Hombres(2,:),'red');scatter(flip(10:30),Hombres(3,:),'red'); title('Hombres');
subplot(2,2,2);plot(flip(10:30),Mujeres(1,:));hold on;scatter(flip(10:30),Mujeres(2,:),'red');scatter(flip(10:30),Mujeres(3,:),'red');title('Mujeres');
subplot(2,2,3);plot(flip(10:30),Edad_13(1,:));hold on;scatter(flip(10:30),Edad_13(2,:),'red');scatter(flip(10:30),Edad_13(3,:),'red');title('Edad<13');
subplot(2,2,4);plot(flip(10:30),Edad_14(1,:));hold on;scatter(flip(10:30),Edad_14(2,:),'red');scatter(flip(10:30),Edad_14(3,:),'red');title('Edad>=13');

%% Errores

Err_Todos = Todos(1,:) - Todos(2,:);
Err_Hombres = Hombres(1,:) - Hombres(2,:);
Err_Mujeres = Mujeres(1,:) - Mujeres(2,:);
Err_Edad13 = Edad_13(1,:) - Edad_13(2,:);
Err_Edad14 = Edad_14(1,:) - Edad_14(2,:);

%% Configuración de Plots

Data_usar = Todos;
Err_usar = Err_Todos;

Figure_1 = figure();
set(Figure_1,'color','white')
Fig_err = errorbar(flip(10:30),Data_usar(1,:), Err_usar);
Fig_err.LineStyle = '--';
Fig_err.Marker = 'o';
Fig_err.MarkerSize = 14;
Fig_err.Color = 'blue';
Fig_err.CapSize = 5;
xlabel('Profundidad [mm]','FontSize',24,'FontWeight','bold');
ylabel('% Broca afuera [%]','FontSize',24,'FontWeight','bold');
title('Todos','FontSize',24,'FontWeight','bold');
box off
grid off
