% Script para Hacer Puntos Schottle

[file,path] = uigetfile();
load([path file])
Base_datos_2 = Base_datos;
%%

%Cantidad_rodillas = 58;
Contador = 0;

for k=1:20
    
    
    BD_F_2(k).Rodilla =  Schottle_final_manual( BD_F_2(k).Rodilla);
%     BD_F_LCA(k).Rodilla =  Punto_LCA_femur_manual( BD_F(k).Rodilla);
%     BD_F_LCA(k).Rodilla =  Punto_LCA_tibia_2( BD_F_LCA(k).Rodilla);
%     
%     Contador = k;
end

%%

save('Rodillas_TodasIncluidas_FF_1.mat','Base_datos_2')

%% Comparacion Schottle vs Stephen  (X_SCH,Y_SCH,X_St,Y_St) Distancia(X,Y)
% La distancia se medir� Stephen respecto a Schottle

BD_F = Base_datos_completa;
Cantidad_rodillas = numel(BD_F);
Posiciones = zeros(Cantidad_rodillas,4);
Distancia = zeros(Cantidad_rodillas,2);
Nombres = {};

for k=1:Cantidad_rodillas
    
    dx = BD_F(k).Rodilla.info{1};
    Nombres{k} = BD_F(k).Rodilla.filename  
    pto_Schottle = BD_F(k).Rodilla.info{13};
    pto_Stephen = BD_F(k).Rodilla.info{8};
    Posiciones(k,1) = pto_Schottle(1);
    Posiciones(k,2) = pto_Schottle(2);
    Posiciones(k,3) = pto_Stephen(1);
    Posiciones(k,4) = pto_Stephen(2);
    Dxs(k) = dx;
    
    Distancia(k,1) =  (pto_Stephen(1) - pto_Schottle(1))*dx;  
    Distancia(k,2) =  (pto_Stephen(2) - pto_Schottle(2))*dx; 
    Distancia(k,3) = pdist([pto_Schottle; pto_Stephen],'euclidean')*dx;    
    
    %Distancia(k,1) = pdist([pto_Schottle; pto_Stephen],'euclidean');    
end

T_distancia = array2table(Distancia,'VariableNames',{'X_Dist','Y_Dist','Dist_T'});
[muHat,~,muCI,~] = normfit(Distancia);

X_Dist = {[num2str(muHat(1)) '- [' num2str(muCI(1,1)) ' -' num2str(muCI(2,1)) ']']};
Y_Dist = {[num2str(muHat(2)) '- [' num2str(muCI(1,2)) ' -' num2str(muCI(2,2)) ']']};
Dist_T = {[num2str(muHat(3)) '- [' num2str(muCI(1,3)) ' -' num2str(muCI(2,3)) ']']};

T_Dist_CI = table(X_Dist,Y_Dist,Dist_T);
T_Dist_CI.Properties.VariableNames= {'X_Dist','Y_Dist','Dist_T'};

T_Posiciones = array2table(Posiciones,'VariableNames',{'X_Sc','Y_Sc','X_St','Y_St'});
[muHat,~,muCI,~] = normfit(Posiciones);

X_Sc = {[num2str(muHat(1)) '- [' num2str(muCI(1,1)) ' -' num2str(muCI(2,1)) ']']};
Y_Sc = {[num2str(muHat(2)) '- [' num2str(muCI(1,2)) ' -' num2str(muCI(2,2)) ']']};
X_St = {[num2str(muHat(3)) '- [' num2str(muCI(1,3)) ' -' num2str(muCI(2,3)) ']']};
Y_St = {[num2str(muHat(4)) '- [' num2str(muCI(1,4)) ' -' num2str(muCI(2,4)) ']']};

T_MU_CI = table(X_Sc,Y_Sc,X_St,Y_St);
T_MU_CI.Properties.VariableNames= {'X_Sc','Y_Sc','X_St','Y_St'};

%% Calculo por Edad y Sexo

[muHat_M,~,muCI_M,~] = normfit(Distancia(Sexo(not(Adultos)) ==1,:));

X_Dist_M = {[num2str(muHat_M(1)) '- [' num2str(muCI_M(1,1)) ' -' num2str(muCI_M(2,1)) ']']};
Y_Dist_M = {[num2str(muHat_M(2)) '- [' num2str(muCI_M(1,2)) ' -' num2str(muCI_M(2,2)) ']']};
Dist_T_M = {[num2str(muHat_M(3)) '- [' num2str(muCI_M(1,3)) ' -' num2str(muCI_M(2,3)) ']']};

T_Dist_CI_M = table(X_Dist_M,Y_Dist_M,Dist_T_M);
T_Dist_CI_M.Properties.VariableNames= {'X_Dist_M','Y_Dist_M','Dist_T_M'};

[muHat_F,~,muCI_F,~] = normfit(Distancia(Sexo(not(Adultos))  ==2,:));

X_Dist_F = {[num2str(muHat_F(1)) '- [' num2str(muCI_F(1,1)) ' -' num2str(muCI_F(2,1)) ']']};
Y_Dist_F = {[num2str(muHat_F(2)) '- [' num2str(muCI_F(1,2)) ' -' num2str(muCI_F(2,2)) ']']};
Dist_T_F = {[num2str(muHat_F(3)) '- [' num2str(muCI_F(1,3)) ' -' num2str(muCI_F(2,3)) ']']};

T_Dist_CI_F = table(X_Dist_F,Y_Dist_F,Dist_T_F);
T_Dist_CI_F.Properties.VariableNames= {'X_Dist_F','Y_Dist_F','Dist_T_F'};

%% Edad

Edades = uniquetol(Edad);
T_Dist_CI_Edad = table();

for k=1:length(Edades)
    
    [muHat_M,~,muCI_M,~] = normfit(Distancia(Edad ==Edades(k),:));
    X_Dist_M = {num2str(muHat_M(1)), [ '- [' num2str(muCI_M(1,1)) ' -' num2str(muCI_M(2,1)) ']']};
    Y_Dist_M = {num2str(muHat_M(2)), [ '- [' num2str(muCI_M(1,2)) ' -' num2str(muCI_M(2,2)) ']']};
    Dist_T_M = {num2str(muHat_M(3)), [ '- [' num2str(muCI_M(1,3)) ' -' num2str(muCI_M(2,3)) ']']};
    
    T_Dist_CI_Edad(k,:) = [X_Dist_M,Y_Dist_M,Dist_T_M];
end



%%
[h_1,p_1] = ttest2(Posiciones(:,1),Posiciones(:,3))
[h_2,p_2] = ttest2(Posiciones(:,2),Posiciones(:,4))

[p1,tbl1,stats1,terms1] = anovan([Posiciones(:,1);Posiciones(:,3)],[ones(58,1);2*ones(58,1)]);
[p2,tbl2,stats2,terms2] = anovan([Posiciones(:,2);Posiciones(:,4)],[ones(58,1);2*ones(58,1)]);

%% Gr�ficos

figure;
set(gcf,'color','w')
Pto = BD_F(1).Rodilla.info;
imshow(sum(BD_F(1).Rodilla.mascara ==1,3),[]);
hold on; scatter(Pto{13}(1),Pto{13}(2),'red','filled');
hold on; scatter(Pto{8}(1),Pto{8}(2),'blue','filled');
axis on

%% Comparaciones

Edad = cell2mat(t_usar.Edad);
Hombres = strcmp(t_usar.Sexo,'M');
Mujeres = strcmp(t_usar.Sexo,'F');
Sexo = Hombres + Mujeres*2;

%%

%X
[p_X,tbl1_X,stats1_X,terms1_X] = anovan(Distancia(:,1),{Edad,Sexo});
[results_X,means_X] = multcompare(stats1_X)
%Y
[p_Y,tbl1_Y,stats_Y,terms1_Y] = anovan(Distancia(:,2),{Edad,Sexo});
[results_Y,means_Y] = multcompare(stats_Y)
%% Comparacion TF vs FF  (TF Columna 1 y 2 (X,Y) FF (3,X,4,Y), estos son Schottle)
% Orden para Stephen ( TF stephen (X,Y) es (5,6)

Cantidad_rodillas = 20;
Posiciones = zeros(Cantidad_rodillas,4);
Distancia = zeros(Cantidad_rodillas,2);
for k=1:Cantidad_rodillas
    
    pto_TF = BD_T(k).Rodilla.info{13};
    %pto_TF_St = BD_T(k).Rodilla.info{8};
    Posiciones(k,1) = pto_TF(1);
    Posiciones(k,2) = pto_TF(2);
    %Posiciones(k,5) = pto_TF_St(1);
    %Posiciones(k,6) = pto_TF_St(2);
    
    pto_FF = BD_F(k).Rodilla.info{13};
    Posiciones(k,3) = pto_FF(1);
    Posiciones(k,4) = pto_FF(2);
   
    Distancia(k,1) = pdist([pto_TF(1);pto_FF(1)],'euclidean');
    Distancia(k,2) = pdist([pto_TF(2);pto_FF(2)],'euclidean');
     
end

T_2 = array2table(Posiciones,'VariableNames',{'X_ScTF','Y_ScTF','X_ScFF','Y_ScFF'});
[muHat,~,muCI,~] = normfit(Posiciones);

X_ScT = {[num2str(muHat(1)) '- [' num2str(muCI(1,1)) ' -' num2str(muCI(2,1)) ']']};
Y_ScT = {[num2str(muHat(2)) '- [' num2str(muCI(1,2)) ' -' num2str(muCI(2,2)) ']']};
X_ScF = {[num2str(muHat(3)) '- [' num2str(muCI(1,3)) ' -' num2str(muCI(2,3)) ']']};
Y_ScF = {[num2str(muHat(4)) '- [' num2str(muCI(1,4)) ' -' num2str(muCI(2,4)) ']']};

T_MU_CI_2 = table(X_ScT,Y_ScT,X_ScF,Y_ScF);
T_MU_CI_2.Properties.VariableNames= {'X_ScTF','Y_ScTF','X_ScFF','Y_ScFF'};

%% Graficar Datos Interclass

Pto_F = BD_F(1).Rodilla.info;Pto_T = BD_T(1).Rodilla.in;
imshow(sum(BD_F(1).Rodilla.Mascara ==1,3),[]);
hold on; scatter(Pto_F{13}(1),Pto_F{13}(2),'red','filled');
hold on; scatter(Pto_T{13}(1),Pto_T{13}(2),'blue','filled');

figure;
set(gcf,'color','w')
subplot(1,2,1); boxplot([Posiciones(:,3),Posiciones(:,1)],{'Obs1 (F)','Obs2_(T)'})
title('Comparaci�n Eje AP');
subplot(1,2,2); boxplot([Posiciones(:,4),Posiciones(:,2)],{'Obs1 (F)','Obs2_(T)'})
title('Comparaci�n Eje CC');



%% Comparacion

% Comparacion en X

[h_1,p_1] = ttest2(Posiciones(:,1),Posiciones(:,3))
[h_2,p_2] = ttest2(Posiciones(:,1),Posiciones(:,5))
[h_3,p_3] = ttest2(Posiciones(:,3),Posiciones(:,5))

%Comparacion en Y

[h_4,p_4] = ttest2(Posiciones(:,2),Posiciones(:,4))
[h_5,p_5] = ttest2(Posiciones(:,2),Posiciones(:,6))
[h_6,p_6] = ttest2(Posiciones(:,4),Posiciones(:,6))

% ICC
[r, LB, UB, F, df1, df2, p] = ICC([Posiciones(:,1) Posiciones(:,3)],'C-1',0.05,0.5);
[r, LB, UB, F, df1, df2, p] = ICC([Posiciones(:,2) Posiciones(:,4)],'C-1',0.05,0.5);

%%

X_TF = {[num2str(muHat(1)) '- [' num2str(muCI(1,1)) ' -' num2str(muCI(2,1)) ']']};
Y_TF = {[num2str(muHat(2)) '- [' num2str(muCI(1,2)) ' -' num2str(muCI(2,2)) ']']};
X_FF = {[num2str(muHat(3)) '- [' num2str(muCI(1,3)) ' -' num2str(muCI(2,3)) ']']};
Y_FF = {[num2str(muHat(4)) '- [' num2str(muCI(1,4)) ' -' num2str(muCI(2,4)) ']']};
X_Sch = {[num2str(muHat(5)) '- [' num2str(muCI(1,5)) ' -' num2str(muCI(2,5)) ']']};
Y_Sch = {[num2str(muHat(6)) '- [' num2str(muCI(1,6)) ' -' num2str(muCI(2,6)) ']']};

T_MU_CI_2 = table(X_TF,Y_TF,X_FF,Y_FF,X_Sch,Y_Sch);
T_MU_CI_2.Properties.VariableNames= {'X_TF','Y_TF','X_FF','Y_FF','X_ref','Y_ref'};

%% Anovas

[p,tbl,stats,terms] = anovan([Posiciones(:,1);Posiciones(:,3);Posiciones(:,5)],[ones(20,1);2*ones(20,1);3*ones(20,1)]);

%% Comparacion TF vs FF LCA  (TF Columna 1 y 2 (X,Y) FF (3,X,4,Y), estos son LCA_Tibia)
% (5,6,7,8 Femur X,Y TF y FF respectivamente)
% Orden para Stephen ( TF stephen (X,Y) es (5,6)

Cantidad_rodillas = 20;
Posiciones = zeros(Cantidad_rodillas,8);
angulos = [];

for k=1:Cantidad_rodillas
    
    pto_TF_T = BD_T_LCA(k).Rodilla.info{11};
    pto_TF_F = BD_T_LCA(k).Rodilla.info{12};
    Posiciones(k,1) = pto_TF_T(1);
    Posiciones(k,2) = pto_TF_T(2);
    Posiciones(k,5) = pto_TF_F(1);
    Posiciones(k,6) = pto_TF_F(2);
    angulos(k,1) = BD_T_LCA(k).Rodilla.info{10};
    
    pto_FF_T = BD_F_LCA(k).Rodilla.info{11};
    pto_FF_F = BD_F_LCA(k).Rodilla.info{12};
    Posiciones(k,3) = pto_FF_T(1);
    Posiciones(k,4) = pto_FF_T(2);
    Posiciones(k,7) = pto_FF_F(1);
    Posiciones(k,8) = pto_FF_F(2);
    angulos(k,2) = BD_F_LCA(k).Rodilla.info{10};

end

Angulos_T = array2table(angulos,'VariableNames',{'TF','FF'});
[muHat,~,muCI,~] = normfit(angulos);
TF = {num2str(muHat(1)), ['[' num2str(muCI(1,1)) ' -' num2str(muCI(2,1)) ']']};
FF = {num2str(muHat(2)), ['[' num2str(muCI(1,2)) ' -' num2str(muCI(2,2)) ']']};
Angulos_CI = table(TF,FF);
Angulos_CI.Properties.VariableNames= {'TF','FF'};


T_Tibia = array2table(Posiciones(:,1:4),'VariableNames',{'Xt_TF','Yt_TF','Xt_FF','Yt_tFF'});
[muHat,~,muCI,~] = normfit(Posiciones(:,1:4));

Xt_T = {num2str(muHat(1)), ['[' num2str(muCI(1,1)) ' -' num2str(muCI(2,1)) ']']};
Yt_T = {num2str(muHat(2)), ['[' num2str(muCI(1,2)) ' -' num2str(muCI(2,2)) ']']};
Xt_F = {num2str(muHat(3)), ['[' num2str(muCI(1,3)) ' -' num2str(muCI(2,3)) ']']};
Yt_F = {num2str(muHat(4)), ['[' num2str(muCI(1,4)) ' -' num2str(muCI(2,4)) ']']};

Tt_CI= table(Xt_T,Yt_T,Xt_F,Yt_F);
Tt_CI.Properties.VariableNames= {'Xt_TF','Yt_TF','Xt_FF','Yt_tFF'};

T_Femur = array2table(Posiciones(:,5:8),'VariableNames',{'Xf_TF','Yf_TF','Xf_FF','Yf_tFF'});
[muHat,~,muCI,~] = normfit(Posiciones(:,5:8));

Xf_T = {num2str(muHat(1)), ['[' num2str(muCI(1,1)) ' -' num2str(muCI(2,1)) ']']};
Yf_T = {num2str(muHat(2)), ['[' num2str(muCI(1,2)) ' -' num2str(muCI(2,2)) ']']};
Xf_F = {num2str(muHat(3)), ['[' num2str(muCI(1,3)) ' -' num2str(muCI(2,3)) ']']};
Yf_F = {num2str(muHat(4)), ['[' num2str(muCI(1,4)) ' -' num2str(muCI(2,4)) ']']};

Tf_CI = table(Xf_T,Yf_T,Xf_F,Yf_F);
Tf_CI.Properties.VariableNames= {'Xf_TF','Yf_TF','Xf_FF','Yf_tFF'};

%% X
[h_1,p_1] = ttest2(Posiciones(:,1),Posiciones(:,3))
[h_2,p_2] = ttest2(Posiciones(:,5),Posiciones(:,7))
[r, LB, UB, F, df1, df2, p] = ICC([Posiciones(:,1) Posiciones(:,3)],'C-1',0.05,0.5)
[R,P,RLO,RUP]= corrcoef(Posiciones(:,1) ,Posiciones(:,3), 'alpha', 0.05)
%Comparacion en Y

[h_4,p_4] = ttest2(Posiciones(:,2),Posiciones(:,4))
[r, LB, UB, F, df1, df2, p] = ICC([Posiciones(:,2) Posiciones(:,4)],'C-1',0.05,0.5)

[h_5,p_5] = ttest2(Posiciones(:,6),Posiciones(:,8))

% ICC

%% Comparacion en SUB grupo ADULTO

Adulto = zeros(80,1);

for k =1:numel(Base_datos_completa)
    
    if sum(Base_datos_completa(k).Rodilla.mascara == 2,'all') == 0
        Adulto(k) = 1;
    end
end
%%
BD_F = Base_datos_completa(not(Adulto));

Cantidad_rodillas = numel((BD_F));
Posiciones = zeros(Cantidad_rodillas,4);
Distancia = zeros(Cantidad_rodillas,2);

for k=1:Cantidad_rodillas
    
    dx = BD_F(k).Rodilla.info{1};
    pto_Schottle = BD_F(k).Rodilla.info{13};
    pto_Stephen = BD_F(k).Rodilla.info{8};
    Posiciones(k,1) = pto_Schottle(1);
    Posiciones(k,2) = pto_Schottle(2);
    Posiciones(k,3) = pto_Stephen(1);
    Posiciones(k,4) = pto_Stephen(2);
    
    Distancia(k,1) =  (pto_Stephen(1) - pto_Schottle(1))*dx;  
    Distancia(k,2) =  (pto_Stephen(2) - pto_Schottle(2))*dx; 
    Distancia(k,3) = pdist([pto_Schottle; pto_Stephen],'euclidean')*dx;    

    %Distancia(k,1) = pdist([pto_Schottle; pto_Stephen],'euclidean');    
end

T_distancia = array2table(Distancia,'VariableNames',{'X_Dist','Y_Dist','Dist_T'});
[muHat,~,muCI,~] = normfit(Distancia);

X_Dist = {[num2str(muHat(1)) '- [' num2str(muCI(1,1)) ' -' num2str(muCI(2,1)) ']']};
Y_Dist = {[num2str(muHat(2)) '- [' num2str(muCI(1,2)) ' -' num2str(muCI(2,2)) ']']};
Dist_T = {[num2str(muHat(3)) '- [' num2str(muCI(1,3)) ' -' num2str(muCI(2,3)) ']']};

T_Dist_CI = table(X_Dist,Y_Dist,Dist_T);
T_Dist_CI.Properties.VariableNames= {'X_Dist','Y_Dist','Dist_T'};

T_Posiciones = array2table(Posiciones,'VariableNames',{'X_Sc','Y_Sc','X_St','Y_St'});
[muHat,~,muCI,~] = normfit(Posiciones);

X_Sc = {[num2str(muHat(1)) '- [' num2str(muCI(1,1)) ' -' num2str(muCI(2,1)) ']']};
Y_Sc = {[num2str(muHat(2)) '- [' num2str(muCI(1,2)) ' -' num2str(muCI(2,2)) ']']};
X_St = {[num2str(muHat(3)) '- [' num2str(muCI(1,3)) ' -' num2str(muCI(2,3)) ']']};
Y_St = {[num2str(muHat(4)) '- [' num2str(muCI(1,4)) ' -' num2str(muCI(2,4)) ']']};

T_MU_CI = table(X_Sc,Y_Sc,X_St,Y_St);
T_MU_CI.Properties.VariableNames= {'X_Sc','Y_Sc','X_St','Y_St'};

%%
t_usar = t(not(Adulto),:);
Hombres = strcmp(t_usar.Sexo,'M');
Mujeres = strcmp(t_usar.Sexo,'F');
Sexo = Hombres + Mujeres*2;

[muHat_M,~,muCI_M,~] = normfit(Distancia(Sexo ==1,:));

X_Dist_M = {[num2str(muHat_M(1)) '- [' num2str(muCI_M(1,1)) ' -' num2str(muCI_M(2,1)) ']']};
Y_Dist_M = {[num2str(muHat_M(2)) '- [' num2str(muCI_M(1,2)) ' -' num2str(muCI_M(2,2)) ']']};
Dist_T_M = {[num2str(muHat_M(3)) '- [' num2str(muCI_M(1,3)) ' -' num2str(muCI_M(2,3)) ']']};

T_Dist_CI_M = table(X_Dist_M,Y_Dist_M,Dist_T_M);
T_Dist_CI_M.Properties.VariableNames= {'X_Dist_M','Y_Dist_M','Dist_T_M'};

[muHat_F,~,muCI_F,~] = normfit(Distancia(Sexo ==2,:));

X_Dist_F = {[num2str(muHat_F(1)) '- [' num2str(muCI_F(1,1)) ' -' num2str(muCI_F(2,1)) ']']};
Y_Dist_F = {[num2str(muHat_F(2)) '- [' num2str(muCI_F(1,2)) ' -' num2str(muCI_F(2,2)) ']']};
Dist_T_F = {[num2str(muHat_F(3)) '- [' num2str(muCI_F(1,3)) ' -' num2str(muCI_F(2,3)) ']']};

T_Dist_CI_F = table(X_Dist_F,Y_Dist_F,Dist_T_F);
T_Dist_CI_F.Properties.VariableNames= {'X_Dist_F','Y_Dist_F','Dist_T_F'};

%%

[muHat,~,muCI,~] = normfit(Posiciones(Sexo ==1,:));

X_Sc = {num2str(muHat(1)), ['[' num2str(muCI(1,1)) ' -' num2str(muCI(2,1)) ']']};
Y_Sc = {num2str(muHat(2)), ['[' num2str(muCI(1,2)) ' -' num2str(muCI(2,2)) ']']};
X_St = {num2str(muHat(3)), ['[' num2str(muCI(1,3)) ' -' num2str(muCI(2,3)) ']']};
Y_St = {num2str(muHat(4)), ['[' num2str(muCI(1,4)) ' -' num2str(muCI(2,4)) ']']};

T_POS_CI_M = table(X_Sc,Y_Sc,X_St,Y_St);
T_POS_CI_M.Properties.VariableNames= {'X_Sc','Y_Sc','X_St','Y_St'};

[muHat,~,muCI,~] = normfit(Posiciones(Sexo ==2,:));

X_Sc = {num2str(muHat(1)), ['[' num2str(muCI(1,1)) ' -' num2str(muCI(2,1)) ']']};
Y_Sc = {num2str(muHat(2)), ['[' num2str(muCI(1,2)) ' -' num2str(muCI(2,2)) ']']};
X_St = {num2str(muHat(3)), ['[' num2str(muCI(1,3)) ' -' num2str(muCI(2,3)) ']']};
Y_St = {num2str(muHat(4)), ['[' num2str(muCI(1,4)) ' -' num2str(muCI(2,4)) ']']};

T_POS_CI_F = table(X_Sc,Y_Sc,X_St,Y_St);
T_POS_CI_F.Properties.VariableNames= {'X_Sc','Y_Sc','X_St','Y_St'};
%% Ttest

[h_1,p_1] = ttest2(Posiciones(:,1),Posiciones(:,3))
[h_2,p_2] = ttest2(Posiciones(:,2),Posiciones(:,4))

[h_1,p_1] = ttest2(Posiciones(Hombres,1),Posiciones(Hombres,3))
[h_2,p_2] = ttest2(Posiciones(Hombres,2),Posiciones(Hombres,4))

[h_1,p_1] = ttest2(Posiciones(Mujeres,1),Posiciones(Mujeres,3))
[h_2,p_2] = ttest2(Posiciones(Mujeres,2),Posiciones(Mujeres,4))

%%

[h_1,p_1] = ttest2(Distancia(Hombres(not(Adultos)),1),Distancia(Mujeres(not(Adultos)),1))
[h_2,p_2] = ttest2(Distancia(Hombres(not(Adultos)),2),Distancia(Mujeres(not(Adultos)),2))

[h_1,p_1] = ttest2(Posiciones(Hombres,1),Posiciones(Hombres,3))
[h_2,p_2] = ttest2(Posiciones(Hombres,2),Posiciones(Hombres,4))

[h_1,p_1] = ttest2(Posiciones(Mujeres,1),Posiciones(Mujeres,3))
[h_2,p_2] = ttest2(Posiciones(Mujeres,2),Posiciones(Mujeres,4))



%% Anovas
%X
[p_X,tbl1_X,stats1_X,terms1_X] = anovan(Distancia(:,1),{Sexo});
[results_X,means_X] = multcompare(stats1_X)
%Y
[p_Y,tbl1_Y,stats_Y,terms1_Y] = anovan(Distancia(:,2),{Sexo});
[results_Y,means_Y] = multcompare(stats_Y)

%% An�lisis de Normalidad
%  Kolmogorov-Smirnov test analiza si los datos vienen de una
%  distribuci�n normal estandar (o,1), entonces hay que escalar los datos
%   [h,p] = adtest(___)
%   [H, pValue, W] = swtest(x, alpha)
%   [h,p] = kstest((Distancia(:,1)-mean(Distancia(:,1)))./sdt(Distancia(:,1)))
%   esta hay que normalizarla

Indice_IM = t.F_femur == 1;
Indice_M = not(Indice_IM);
Hombres = strcmp(t.Sexo,'M');
Mujeres = strcmp(t.Sexo,'F');
Edades = unique(t.Edad);

Indices = {Indice_IM, Indice_IM & Hombres, Indice_IM & Mujeres, ...
    Indice_M, Indice_M & Hombres, Indice_M & Mujeres};

Normalidad_X = zeros(7,3);
Normalidad_Y = zeros(7,3);

for k=1:length(Indices)+1
    
    if k == 1
    
        p_x = Tests(Distancia(:,1),0.05);
        Normalidad_X(k,:) = round(p_x,2);
        p_y = Tests(Distancia(:,2),0.05);
        Normalidad_Y(k,:) = round(p_y,2);
    
    else
        
        p_x = Tests(Distancia(Indices{k-1},1),0.05);
        Normalidad_X(k,:) = round(p_x,2);
        p_y = Tests(Distancia(Indices{k-1},2),0.05);
        Normalidad_Y(k,:) = round(p_y,2);
    end
    
end


%% Xx
Edades = unique(t.Edad(Indice_IM));
Normalidad_edades = zeros(length(Edades),4);
Eje = 2;

for k=1:length(Edades)

    Index_EM = t.Edad(Indice_IM) == Edades(k);
    fprintf('Para Inmaduro de edad %d es: \n',double(Edades(k)));
    Normalidad_edades(k,5) = sum(Index_EM);
    Normalidad_edades(k,1) = Edades(k);
    p_edad = round(Tests(Distancia(Index_EM,Eje),0.05),2);
    Normalidad_edades(k,2:4) = p_edad;

end

