%% Gráfico Edad vs Distancia a Superficie Fisis

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

%% Calculo distancias

Distacia_Fisis_Stephen_distal = zeros(numel(Base_datos),1);

for k=1:numel(Base_datos)
    
    Alturas =  Dist_Fisis_Stephen(Base_datos(k).Rodilla,5);
    Distacia_Fisis_Stephen_distal(k) = Alturas{1};
end

%% Calculo de media y CI para cada grupo

Indice_edad = unique(Edad_sexo.Edad);
D_FS_promedio = zeros(length(Indice_edad),2);

for k=1:length(Indice_edad)
    
    Grupo = Edad_sexo.Edad == Indice_edad(k);
    Contenido = Distacia_Fisis_Stephen_distal(Grupo);
    
    [muHat_1,~,muCI_1,~] = normfit(Contenido','omitnan');
    D_FS_promedio(k,1) = median(Contenido(not(isnan(Contenido))));
    D_FS_promedio(k,2) = iqr(Contenido(not(isnan(Contenido))));
    D_FS_promedio(k,3) = length(Contenido);
    
end

%% Plo

ax2 = figure;
ax2.Color = 'white';
gca.FontWeight = 'bold';
gca.FontSize= 14;
hold on; 
plot(9:18,zeros(length(9:18),1),'red');
errorbar(Indice_edad,D_FS_promedio(:,1),D_FS_promedio(:,2)./2,'o','CapSize',20)
