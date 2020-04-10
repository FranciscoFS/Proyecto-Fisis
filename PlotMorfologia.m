%% I) Padd (Ya no es necesario)

for k=1:numel(Distribucion)
    LargosSG_norm(k) = length(Distribucion(k).SG_norm.Filas);
    LargosAP_norm(k) = length(Distribucion(k).AP_nom.Filas);
end

[MaxSG, MaxSG_pos] = max(LargosSG_norm);
[MaxAP, MaxAP_pos] = max(LargosAP_norm);

New_SGFilas = zeros(numel(Distribucion),MaxSG);
New_SGCol = zeros(numel(Distribucion),MaxSG);

New_APFilas = zeros(numel(Distribucion),MaxAP);
New_APCol = zeros(numel(Distribucion),MaxAP);

for k=1:numel(Distribucion)
    New_SGFilas(k,:) = padding(Distribucion(k).SG_norm.Filas, MaxSG);
    New_SGCol(k,:) = padding(Distribucion(k).SG_norm.Columnas, MaxSG);
    
    New_APFilas(k,:) = padding(Distribucion(k).AP_nom.Filas, MaxAP);
    New_APCol(k,:) = padding(Distribucion(k).AP_nom.Columnas, MaxAP);
end

NewSG.Filas = New_SGFilas;
NewSG.Col = New_SGCol;

NewAp.Filas = New_APFilas;
NewAp.Col = New_APCol;

%% Ajuste por el más largo 

LargosSG_norm = zeros(1,numel(Distribucion));
LargosAP_norm = zeros(1,numel(Distribucion));
DiffsSG = [];
DiffsAP = [];

for k=1:numel(Distribucion)
    LargosSG_norm(k) = length(Distribucion(k).SG_norm.Filas);
    LargosAP_norm(k) = length(Distribucion(k).AP_norm.Filas);
end

[MaxSG, MaxSG_pos] = max(LargosSG_norm);
[MaxAP, MaxAP_pos] = max(LargosAP_norm);

Filas_AjSG = zeros(numel(Distribucion),MaxSG);
Columna_usarSG = Distribucion(MaxSG_pos).SG_norm.Columnas;

Filas_AjAP = zeros(numel(Distribucion),MaxAP);
Columna_usarAP = Distribucion(MaxAP_pos).AP_norm.Columnas;

for k=1:numel(Distribucion)
    
    LargoSG = length(Distribucion(k).SG_norm.Filas);
    pace = LargoSG/MaxSG;
    InterpolFilasSG = interp1(Distribucion(k).SG_norm.Filas,1:pace:LargoSG);
   % InterpolColumnas = interp1(Distribucion(k).SG_norm.Columnas,1:pace:Largo1);

    LargoAP = length(Distribucion(k).AP_norm.Filas);
    paceAP = LargoAP/MaxAP;
    InterpolFilasAP = interp1(Distribucion(k).AP_norm.Filas,1:paceAP:LargoAP);
   
    if length(InterpolFilasSG) == MaxSG
        Filas_AjSG(k,:) = InterpolFilasSG;
       % Columnas_Aj(k,:) = InterpolColumnas;
        
    else
        Diff = MaxSG - length(InterpolFilasSG);
        InterpolFilasSG(end+1:end +Diff) = NaN(1,Diff);
        Filas_AjSG(k,:) = InterpolFilasSG;
       % Columnas_Aj(k,:) = InterpolColumnas;
       % InterpolColumnas(end+1:end +Diff) = NaN(1,Diff);
       DiffsSG(end +1) = Diff;

    end
    
    if length(InterpolFilasAP) == MaxAP
        Filas_AjAP(k,:) = InterpolFilasAP;
       % Columnas_Aj(k,:) = InterpolColumnas;
        
    else
        Diff = MaxAP - length(InterpolFilasAP);
        InterpolFilasAP(end+1:end +Diff) = NaN(1,Diff);
        Filas_AjAP(k,:) = InterpolFilasAP;
       % Columnas_Aj(k,:) = InterpolColumnas;
       % InterpolColumnas(end+1:end +Diff) = NaN(1,Diff);
       DiffsAP(end +1) = Diff;

    end
    
end



%% Variables H y M, poner 1 para Femur, y 2 para Tibia

Masculino = zeros(1,numel(Base_datos_2));
Edad = zeros(1,numel(Base_datos_2));
for k=1:numel(Base_datos_2)
    
    Edad_aux = Base_datos_2(k).Rodilla.info{5};
    Edad(k) = str2double(Edad_aux(2:3));
    
    if strcmp(Base_datos_2(k).Rodilla.info{6},'M')
        Masculino(k) = 1;
    end
end

Mujeres = Masculino == 0;
Masculino = not(Mujeres);  

%%  Femur

Masculino = zeros(1,numel(Base_datos));
Edad = zeros(1,numel(Base_datos));
for k=1:numel(Base_datos)
    
    Edad_aux = Base_datos(k).Rodilla.info{5};
    Edad(k) = str2double(Edad_aux(2:3));
    
    if strcmp(Base_datos(k).Rodilla.info{6},'M')
        Masculino(k) = 1;
    end
end

Mujeres = Masculino == 0;
Masculino = not(Mujeres);  
%% Ploteos todas las proyeccion FEMUR

% FEMUR SG

    medFilas = median(Filas_AjSG,'omitnan');
    %medCol = median(NewAp.Col,'omitnan');
    Filas_Iqr = medFilas + iqr(Filas_AjSG);
    Filas_Iqr2 = medFilas - iqr(Filas_AjSG);
    
    figure;    
    %subplot(2,2,1);
    hold on;

    for k=1:numel(Distribucion)
        plot(Columna_usarSG,Filas_AjSG(k,:),'color', rand(1,3));
    end
    
    plot(Columna_usarSG,medFilas,'--r','LineWidth',3)
    plot(Columna_usarSG,Filas_Iqr,'--b','LineWidth',3)
    plot(Columna_usarSG,Filas_Iqr2,'--b','LineWidth',3)
    axis off
    set(gcf,'color','white')
    daspect([1 1 1])
    
% Femur AP

    medFilas = median(Filas_AjAP,'omitnan');
    %medCol = median(NewSG.Col,'omitnan');
    Filas_Iqr = medFilas + iqr(Filas_AjAP);
    Filas_Iqr2 = medFilas - iqr(Filas_AjAP);
    
    figure;      
    %subplot(2,2,2);
    hold on;

    for k=1:numel(Distribucion)
        plot(Columna_usarAP, Filas_AjAP(k,:),'color', rand(1,3));
    end
    
    plot(Columna_usarAP,medFilas,'--r','LineWidth',3)
    plot(Columna_usarAP,Filas_Iqr,'--b','LineWidth',3)
    plot(Columna_usarAP,Filas_Iqr2,'--b','LineWidth',3)
    axis off
    set(gcf,'color','white')
    daspect([1 1 1])
    
 %% Ploteo Sexo y edades AP
 
    figure; hold on;
    set(gcf,'color','white')
    axis on
    daspect([1 1 1])
    
    
    p1 = plot(Columna_usarAP, median(Filas_AjAP(Masculino,:),'omitnan'),'--r','LineWidth',3);
    %p3 = plot(Columna_usarAP, median(Filas_AjAP(Masculino,:),'omitnan') + iqr(Filas_AjAP(Masculino,:)),'--y','LineWidth',2);
    %plot(Columna_usarAP, median(Filas_AjAP(Masculino,:),'omitnan') - iqr(Filas_AjAP(Masculino,:)),'--y','LineWidth',2);
    p2 = plot(Columna_usarAP, median(Filas_AjAP(Mujeres,:),'omitnan'),'--b','LineWidth',3);
    %p4 = plot(Columna_usarAP, median(Filas_AjAP(Mujeres,:),'omitnan') + iqr(Filas_AjAP(Mujeres,:)),'--m','LineWidth',2);
    %plot(Columna_usarAP, median(Filas_AjAP(Mujeres,:),'omitnan') - iqr(Filas_AjAP(Mujeres,:)),'--m','LineWidth',2)
    
    legend([p1 p2],'Masculino','Femenino','Iqr Masculino', 'Iqr Femenino','FontSize',14)
    %%
    figure; hold on;
    set(gcf,'color','white')
    axis on
    daspect([1 1 1])
    
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 10,:),'omitnan'),'--r','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 11,:),'omitnan'),'--b','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 12,:),'omitnan'),'--g','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 13,:),'omitnan'),'--y','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 14,:),'omitnan'),'--k','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 15,:),'omitnan'),'--m','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 16,:),'omitnan'),'--c','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 17,:),'omitnan'),'--','color',[0.4940 0.1840 0.5560],'LineWidth',3)
    legend('10','11','12','13','14','15','16','17','FontSize',14)

    
%% Ploteo Sexo y edades SG

% Sexo

%     Tibia = Base_datos_2(MaxSG_pos).Rodilla.mascara == 3;
%     Fisis = Base_datos_2(MaxSG_pos).Rodilla.mascara == 4;
%     imshow(sum(Tibia + 2*Fisis,3),[]);
%     MED_Filas = median(Distribucion(MaxSG_pos).SG.Filas);
%     dx = Base_datos_2(MaxSG_pos).Rodilla.info{1};
    

    %imshow(sum(Tibia + 2*Fisis,3),[]);
    figure; 
    hold on;
    set(gcf,'color','white')
    axis off
    daspect([1 1 1])
    
    plot(Columna_usarSG, mean(Filas_AjSG(Masculino,:),'omitnan'),'--r','LineWidth',3)
    plot(Columna_usarSG, mean(Filas_AjSG(Mujeres,:),'omitnan'),'--b','LineWidth',3)
    legend('Masculino','Femenino','FontSize',14)
    
%%    
    figure; hold on;
    set(gcf,'color','white')
    axis on
    daspect([1 1 1])
    
    plot(Columna_usarSG, median(Filas_AjSG(Edad == 10,:),'omitnan'),'--r','LineWidth',3)
    plot(Columna_usarSG, median(Filas_AjSG(Edad == 11,:),'omitnan'),'--b','LineWidth',3)
    plot(Columna_usarSG, median(Filas_AjSG(Edad == 12,:),'omitnan'),'--g','LineWidth',3)
    plot(Columna_usarSG, median(Filas_AjSG(Edad == 13,:),'omitnan'),'--y','LineWidth',3)
    plot(Columna_usarSG, median(Filas_AjSG(Edad == 14,:),'omitnan'),'--k','LineWidth',3)
    plot(Columna_usarSG, median(Filas_AjSG(Edad == 15,:),'omitnan'),'--m','LineWidth',3)
    %plot(Columna_usarSG, median(Filas_AjSG(Edad == 16,:),'omitnan'),'--c','LineWidth',3)
    %plot(Columna_usarSG, median(Filas_AjSG(Edad == 17,:),'omitnan'),'--','color',[0.4940 0.1840 0.5560],'LineWidth',3)
    %legend('10','11','12','13','14','15','16','17')
    legend('10','11','12','13','14','15','FontSize',14)

    
%% Test Análitis por tercios SG

Window = floor(MaxSG/3);

% Filas_AjSG_1_3H = Filas_AjSG(Masculino,1:Window);
% Filas_AjSG_2_3H = Filas_AjSG(Masculino,Window+1:2*Window);
% Filas_AjSG_3_3H = Filas_AjSG(Masculino,2*Window+1:3*Window);
% 
% Filas_AjSG_1_3M = Filas_AjSG(Mujeres,1:Window);
% Filas_AjSG_2_3M = Filas_AjSG(Mujeres,Window+1:2*Window);
% Filas_AjSG_3_3M = Filas_AjSG(Mujeres,2*Window+1:3*Window);


Filas_AjSG_1_3 = Filas_AjSG(Edad < 16,1:Window);
Filas_AjSG_2_3 = Filas_AjSG(Edad < 16,Window+1:2*Window);
Filas_AjSG_3_3 = Filas_AjSG(Edad < 16,2*Window+1:3*Window);

Edad_ex = repmat(Edad(Edad < 16),1,Window);
Sexos_ex = repmat(2*Masculino + Mujeres,1,Window);
%% Test Análitis por tercios AP

Window = floor(MaxAP/3);

% Filas_AjAP_1_3H = Filas_AjSG(Masculino,1:Window);
% Filas_AjAP_2_3H = Filas_AjSG(Masculino,Window+1:2*Window);
% Filas_AjAP_3_3H = Filas_AjSG(Masculino,2*Window+1:3*Window);
% 
% Filas_AjAP_1_3M = Filas_AjSG(Mujeres,1:Window);
% Filas_AjAP_2_3M = Filas_AjSG(Mujeres,Window+1:2*Window);
% Filas_AjAP_3_3M = Filas_AjSG(Mujeres,2*Window+1:3*Window);


Filas_AjAP_1_3 = Filas_AjAP(Edad < 16,1:Window);
Filas_AjAP_2_3 = Filas_AjAP(Edad < 16,Window+1:2*Window);
Filas_AjAP_3_3 = Filas_AjAP(Edad < 16,2*Window+1:3*Window);

Edad_ex = repmat(Edad(Edad < 16),1,Window);
Sexos_ex = repmat(2*Masculino + Mujeres,1,Window);
%% Análisis Post HOC

[p,tbl,stats] = anovan(Filas_AjAP_1_3(:),Edad_ex'); multcompare(stats);set(gcf,'color','white')
[p,tbl,stats] = anovan(Filas_AjAP_2_3(:),Edad_ex'); multcompare(stats);set(gcf,'color','white')
[p,tbl,stats] = anovan(Filas_AjAP_3_3(:),Edad_ex'); multcompare(stats);set(gcf,'color','white')

%%
[p,tbl,stats] = anova1(Filas_AjAP_1_3(:),Sexos_ex'); p
[p,tbl,stats] = anova1(Filas_AjAP_2_3(:),Sexos_ex'); p
[p,tbl,stats] = anova1(Filas_AjAP_3_3(:),Sexos_ex'); p
%%

[h,p] = ttest2(Filas_AjSG_3_3(Edad_tibia < 13,:),Filas_AjSG_3_3(Edad_tibia >= 13,:));
plot(h)
[mu,CI] = Mean_CI(p)


%% Ploteo Sexo y edades AP


    figure; hold on;
    set(gcf,'color','white')
    axis off
    daspect([1 1 1])
    
    plot(Columna_usarAP, median(Filas_AjAP(Masculino,:),'omitnan'),'--r','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Mujeres,:),'omitnan'),'--b','LineWidth',3)
    legend('Masculino','Femenino','FontSize',14)
    
 %%   
    figure; hold on;
    set(gcf,'color','white')
    axis on
    daspect([1 1 1])
    
  
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 10,:),'omitnan'),'--r','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 11,:),'omitnan'),'--b','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 12,:),'omitnan'),'--g','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 13,:),'omitnan'),'--y','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 14,:),'omitnan'),'--k','LineWidth',3)
    plot(Columna_usarAP, median(Filas_AjAP(Edad == 15,:),'omitnan'),'--m','LineWidth',3)
  %  plot(Columna_usarAP, median(Filas_AjAP(Edad == 16,:),'omitnan'),'--c','LineWidth',3)
  %  plot(Columna_usarAP, median(Filas_AjAP(Edad == 17,:),'omitnan'),'--','color',[0.4940 0.1840 0.5560],'LineWidth',3)
 %   legend('10','11','12','13','14','15','16','17')
    legend('10','11','12','13','14','15','FontSize',14)


%%

figure;
hold on;
set(gcf,'color','white')
axis on
daspect([1 1 1])

p1 = plot(Columna_usarSG,mean(Filas_AjSG(Edad < 13,:)),'--r','LineWidth',3);
p2 = plot(Columna_usarSG,mean(Filas_AjSG((Edad >= 13) & (Edad < 16),:)),'--b','LineWidth',3);
[h,p] = ttest2(Filas_AjSG(Edad < 13,:),Filas_AjSG((Edad >= 13) & (Edad < 16),:));
scatter(Columna_usarSG,3*h,'MarkerFaceColor','yellow') 
legend([p1 p2],{'Edad [10 -12]','Edad [13-15]'},'FontSize',14);
[mu,CI] = Mean_CI(p(p>0.05))
%%

figure;
hold on;
set(gcf,'color','white')
axis on
daspect([dx 1 1])

p1 = plot(mean(Filas_AjAP_3_3(Masculino,:)),'--r','LineWidth',3);
p2 = plot(mean(Filas_AjAP_3_3(Mujeres,:)),'--b','LineWidth',3);
[h,p] = ttest2(Filas_AjAP_3_3(Masculino,:),Filas_AjAP_3_3(Mujeres,:));
scatter(1:length(h),5*h,'MarkerFaceColor','yellow')
legend([p1 p2],{'Edad [10 -14]','Edad [15-17]'},'FontSize',14);
[mu,CI] = Mean_CI(p(p<0.05))

%% Ploteo Femur SG Hombres vs Mujeres

    figure;
    hold on;
    set(gcf,'color','white')
    axis off
    daspect([1 1 1])
    
   for k=1:numel(Distribucion)
       
        if Masculino(k)
            plot(Distribucion(k).SG_norm.Columnas, Distribucion(k).SG_norm.Filas,'color', 'red');
        else
            plot(Distribucion(k).SG_norm.Columnas, Distribucion(k).SG_norm.Filas,'color', 'blue');
        end
   end

    figure;
    hold on;
    set(gcf,'color','white')
    
    plot(median(NewSG.Col(Masculino==1,:),'omitnan'),median(NewSG.Filas(Masculino==1,:),'omitnan'),'--r');
    plot(median(NewSG.Col(Masculino==1,:),'omitnan'),...
        median(NewSG.Filas(Masculino==1,:),'omitnan') + iqr(NewSG.Filas(Masculino==1,:)),'--g');   
    plot(median(NewSG.Col(Masculino==1,:),'omitnan'),...
        median(NewSG.Filas(Masculino==1,:),'omitnan') - iqr(NewSG.Filas(Masculino==1,:)),'--g');  
    
    plot(median(NewSG.Col(Mujeres,:),'omitnan'),median(NewSG.Filas(Mujeres,:),'omitnan'),'--b');
    plot(median(NewSG.Col(Mujeres,:),'omitnan'),...
        median(NewSG.Filas(Mujeres,:),'omitnan') + iqr(NewSG.Filas(Mujeres,:)),'--y');   
    plot(median(NewSG.Col(Mujeres,:),'omitnan'),...
        median(NewSG.Filas(Mujeres,:),'omitnan') - iqr(NewSG.Filas(Mujeres,:)),'--y');   
    axis off
    axis equal
    
%% Ploteo Femur Ap Hombres vs Mujeres
    figure;
    hold on;
    set(gcf,'color','white')
    axis off
    axis equal
    
   for k=1:numel(Distribucion)
       
        if Masculino(k)
            plot(Distribucion(k).AP_nom.Columnas, Distribucion(k).AP_norm.Filas,'color', 'red');
        else
            plot(Distribucion(k).AP_nom.Columnas, Distribucion(k).AP_norm.Filas,'color', 'blue');
        end
   end

    figure;
    hold on;
    set(gcf,'color','white')
    
    plot(median(NewAp.Col(Masculino==1,:),'omitnan'),median(NewAp.Filas(Masculino==1,:),'omitnan'),'--r');
    plot(median(NewAp.Col(Masculino==1,:),'omitnan'),...
        median(NewAp.Filas(Masculino==1,:),'omitnan') + iqr(NewAp.Filas(Masculino==1,:)),'--g');   
    plot(median(NewAp.Col(Masculino==1,:),'omitnan'),...
        median(NewAp.Filas(Masculino==1,:),'omitnan') - iqr(NewAp.Filas(Masculino==1,:)),'--g');  
    
    plot(median(NewAp.Col(Mujeres,:),'omitnan'),median(NewAp.Filas(Mujeres,:),'omitnan'),'--b');
    plot(median(NewAp.Col(Mujeres,:),'omitnan'),...
        median(NewAp.Filas(Mujeres,:),'omitnan') + iqr(NewAp.Filas(Mujeres,:)),'--y');   
    plot(median(NewAp.Col(Mujeres,:),'omitnan'),...
        median(NewAp.Filas(Mujeres,:),'omitnan') - iqr(NewAp.Filas(Mujeres,:)),'--y');   
    axis off
    axis equal
    
%% Edades a comparar 10,11, 15 y 16

Coefs_10 = mean(Coeficientes.Var3(Edad==10,:));
Coefs_11 = mean(Coeficientes.Var3(Edad==11,:));
Coefs_15 = mean(Coeficientes.Var3(Edad==15,:));
Coefs_16 = mean(Coeficientes.Var3(Edad==16,:));


X = min(mean(New_SGCol,'omitnan')):0.5:max(mean(New_SGCol,'omitnan'));
Y10 = Coefs_10(1).*X.^2 + Coefs_10(2).*X + repmat(Coefs_10(3),1,length(X));
Y11 = Coefs_11(1).*X.^2 + Coefs_11(2).*X + repmat(Coefs_11(3),1,length(X));
Y15 = Coefs_15(1).*X.^2 + Coefs_15(2).*X + repmat(Coefs_15(3),1,length(X));
Y16 = Coefs_16(1).*X.^2 + Coefs_16(2).*X + repmat(Coefs_16(3),1,length(X));

figure; hold on;
plot(X,Y10,'--r'); 
plot(X,Y11,'--b'); 
plot(X,Y15,'--black'); 
plot(X,Y16,'--m');
set(gcf,'color','white');
legend('10','11','15','16');


figure; hold on;
set(gcf,'color','white')

for k=1:numel(Distribucion)

    if Edad(k) == 10
        plot(Distribucion(k).SG_norm.Columnas, Distribucion(k).SG_norm.Filas,'color', 'red');
    elseif Edad(k) == 11
        plot(Distribucion(k).SG_norm.Columnas, Distribucion(k).SG_norm.Filas,'color', 'blue');
    elseif Edad(k) == 15
        plot(Distribucion(k).SG_norm.Columnas, Distribucion(k).SG_norm.Filas,'color', 'black');
    elseif Edad(k) == 16
        plot(Distribucion(k).SG_norm.Columnas, Distribucion(k).SG_norm.Filas,'color', 'magenta');
    end
    
end

plot(median(NewSG.Col(Edad == 10,:),'omitnan'),median(NewSG.Filas(Edad == 10,:),'omitnan'),'--r',...
    'LineWidth',3);
plot(median(NewSG.Col(Edad == 11,:),'omitnan'),median(NewSG.Filas(Edad == 11,:),'omitnan'),'--b',...
   'LineWidth',3);
plot(median(NewSG.Col(Edad == 15,:),'omitnan'),median(NewSG.Filas(Edad == 15,:),'omitnan'),'--k',...
    'LineWidth',3);
plot(median(NewSG.Col(Edad == 16,:),'omitnan'),median(NewSG.Filas(Edad == 16,:),'omitnan'),'--m',...
    'LineWidth',3);

%%

figure; hold on;
set(gcf,'color','white')

for k=1:numel(Distribucion)

    if Edad(k) == 10
        plot(Filas_AjSG(k,:),'color', 'red');
    elseif Edad(k) == 11
        plot(Filas_AjSG(k,:),'color', 'blue');
    elseif Edad(k) == 15
        plot(Filas_AjSG(k,:),'color', 'black');
    elseif Edad(k) == 16
        plot(Filas_AjSG(k,:),'color', 'magenta');
    end
    
end

daspect([1/dx 1 1])

plot(median(Filas_AjSG(Edad == 10,:),'omitnan'),'--r','LineWidth',3);
plot(median(Filas_AjSG(Edad == 11,:),'omitnan'),'--b','LineWidth',3);
plot(median(Filas_AjSG(Edad == 15,:),'omitnan'),'--k','LineWidth',3);
plot(median(Filas_AjSG(Edad == 16,:),'omitnan'),'--m','LineWidth',3);
legend('10','11','15','16');
