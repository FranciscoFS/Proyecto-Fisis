%% Cálculo paso a la otra cortical Para un angulo Horizontal fijo.

ang.min = 0;
ang.max = 45;
angulos = ang.min:2.5:ang.max;

Datos = zeros(numel(Base_datos),length(angulos));
Destruccion_cruzando = zeros(numel(Base_datos),length(angulos));
data.d = 7;
data.alpha =0;

S = strel('Disk',5);


for k=1:numel(Base_datos)
    fprintf('Rodilla nº %d \n',k);
    
    Rodilla = Base_datos(k).Rodilla;
    [mm_dist_cada_angulo,~] = Distancia_a_cortical_lateral_1_angulo(Rodilla,angulos);
    
        for i=1:length(mm_dist_cada_angulo)

            data.beta = angulos(i);
            data.p = mm_dist_cada_angulo(i);
            Taladro = Crear_solo_cilindro_test(Rodilla,Rodilla.mascara ==1,data.alpha,...
            data.beta,data.d,data.p);
            Datos(k,i) = Fuera_femur(Rodilla,Taladro,S);
            Destruccion_cruzando(k,i) = Cilindro_fx_final(Rodilla,...
                data.alpha,data.beta,data.d,data.p);
            
        end
         
end

%% Cálculo paso a la otra cortical Para pares de angulos
% Ahora (05/10/18) para todo el mapeo

Limit_alpha = 45;
Limit_beta = 45;

D = 7;

Alpha = -1*Limit_alpha:5:Limit_alpha;
Beta = -1*Limit_beta:5:Limit_beta;

[Xx,Yy] = meshgrid(Beta,Alpha);

% Out_Angulos_2= zeros(size(Xx,1),size(Xx,1),numel(Base_datos));
% Dest_Angulos_2 = zeros(size(Xx,1),size(Xx,1),numel(Base_datos));

Out_Cruzando_Todos= zeros(size(Xx,1),size(Xx,1),numel(Base_datos));
Dest_Cruzando_Todos = zeros(size(Xx,1),size(Xx,1),numel(Base_datos));

S = strel('Disk',5);

%%

for k=21:numel(Base_datos)
    
    Rodilla = Base_datos(k).Rodilla;
    cortical = Rodilla.mascara == 1;
    
    for i = 1:size(Alpha,2)
        
        for j = 1:size(Beta,2)
            
            [mm_dist_cada_angulo,~] = Distancia_a_cortical_lateral_dos_angulos(Rodilla,Beta(j),Alpha(i));
            Taladro = Crear_solo_cilindro_test(Rodilla,cortical,Alpha(i)...
                ,Beta(j),D,mm_dist_cada_angulo);
            
%             Out_Angulos_2(i,j,k) = Fuera_femur(Rodilla,Taladro,S);
%             Dest_Angulos_2(i,j,k) = Cilindro_fx_final(Rodilla,...
%                 Alpha(i),Beta(j),D,mm_dist_cada_angulo);
            
            Out_Cruzando_Todos(i,j,k) = Fuera_femur(Rodilla,Taladro,S);
            Dest_Cruzando_Todos(i,j,k) = Cilindro_fx_final(Rodilla,...
                Alpha(i),Beta(j),D,mm_dist_cada_angulo);
               
           fprintf('Paciente %d Angulos (%d/%d) \n',k,i,j)
            
        end
    end
    
    fprintf('Terminado Paciente nº %d \n',k)
    
end

%% Comparar Fuera_femur con Dest

D = 7;
P = 30;
Fuera_out = zeros(size(Alpha,1),size(Beta,1));
Dest = zeros(size(Alpha,1),size(Beta,1));


   for k=1:length(Alpha)
        

        for i = 1:length(Beta)
            
            Taladro = Crear_solo_cilindro_test(V_seg,V_seg.mascara == 1,Alpha(k),Beta(i),D,P);
            Fuera_out(k,i) = Fuera_femur(V_out,Taladro);
            Dest(k,i) = Cilindro_fx_final(V_out,Alpha(k),Beta(i),D,P);

        end 
        
        fprintf('Angulo actual %d \n',k)

   end

%% Calculo de %Out por todas las rodillas y angulos

Limit_alpha = 45;
pace_alpha = 1;
Limit_beta = 45;
pace_beta = 1;

D = 7;
P = 30;

Alpha = -Limit_alpha:5:Limit_alpha;
Beta = -Limit_beta:5:Limit_beta;

[Xx,Yy] = meshgrid(Alpha,Beta);

Out = zeros(size(Xx,1),size(Xx,1),numel(Base_datos));

S = strel('Disk',5);

for k=1:numel(Base_datos)
    
    Rodilla = Base_datos(k).Rodilla;
    cortical = Rodilla.mascara == 1;
    
    for i = 1:size(Alpha,2)
        
        for j = 1:size(Beta,2)
            
            Taladro = Crear_solo_cilindro_test(Rodilla,cortical,Alpha(i)...
                ,Beta(j),D,P);
            Out(i,j,k) = Fuera_femur(Rodilla,Taladro,S);
            
        end
    end
    
    fprintf('Paciente nº %d \n',k)
    
end

%% Análisis por Ángulos Segmentos.
% Yeq = Corresponde a alpha (Horizontal) e Xeq a Beta (elevacion)

Pace = 1;
[Xeq,Yeq] = meshgrid(-Limit_beta:Pace:Limit_beta,-Limit_alpha:Pace:Limit_alpha);
Dest_Cruzando_Todos_int = interp2(Xx,Yy,mean(Dest_Cruzando_Todos,3),Xeq,Yeq,'cubic');
Out_Cruzando_Todos_int = interp2(Xx,Yy,mean(Out_Cruzando_Todos,3),Xeq,Yeq,'cubic');


%%

%Indice_Seguros = (Yeq <0) & (Out_interp < 2) & (Test3_interp < 3);
Indice_Seguros_Cruzando = (Yeq <0) & (Out_Cruzando_Todos_int < 5) & (Dest_Cruzando_Todos_int < 5);
Angulos_seguros_final = [Xeq(Indice_Seguros_Cruzando),Yeq(Indice_Seguros_Cruzando)];
%Puntos = zeros(size(Angulos_seguros_final,1),3);

subplot(1,2,1);surf(Xeq,Yeq,Out_Cruzando_Todos_int);hold on; surf(Xeq,Yeq,20*Indice_Seguros_Cruzando,'EdgeColor','red');
subplot(1,2,2);surf(Xeq,Yeq,Dest_Cruzando_Todos_int);hold on; surf(Xeq,Yeq,20*Indice_Seguros_Cruzando,'EdgeColor','red');

%% X = beta

Angulos_seguros_final = [Xeq(Indice_Seguros_Cruzando),Yeq(Indice_Seguros_Cruzando)];
Puntos = zeros(size(Angulos_seguros_final,1),3);
Rodilla = V_out;

for k=1:size(Angulos_seguros_final,1)
    k
    [~ ,Puntos(k,:)] = Distancia_a_cortical_lateral_dos_angulos(Rodilla,Angulos_seguros_final(k,1),Angulos_seguros_final(k,2));
    
end

Plot_circulos_y_lineas(V_out,Puntos)

%%

    



  
    
    
    
    






    