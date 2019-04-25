%% CÃ¡lculo paso a la otra cortical Para un angulo Horizontal fijo.

ang.min = 0;
ang.max = 45;
angulos = ang.min:2.5:ang.max;

Datos = zeros(numel(Base_datos),length(angulos));
Destruccion_cruzando = zeros(numel(Base_datos),length(angulos));
data.d = 7;
data.alpha =0;

S = strel('Disk',5);


for k=1:numel(Base_datos)
    fprintf('Rodilla nÂº %d \n',k);
    
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

%% CÃ¡lculo paso a la otra cortical Para pares de angulos
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
    
    fprintf('Terminado Paciente nÂº %d \n',k)
    
end

%% Comparar Fuera_femur con Dest

D = [5,6,7];
P = 30;
Fuera_out1 = zeros(size(Alpha,1),size(Beta,1));
Fuera_out2 = zeros(size(Alpha,1),size(Beta,1));
Fuera_out3 = zeros(size(Alpha,1),size(Beta,1));

%Dest = zeros(size(Alpha,1),size(Beta,1));


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
pace_alpha = 5;
Limit_beta = 45;
pace_beta = 5;

D = [5,6,7];
P = 20;

Alpha = -Limit_alpha:5:Limit_alpha;
Beta = -Limit_beta:5:Limit_beta;

[Xx,Yy] = meshgrid(Alpha,Beta);

Fuera_out1 = zeros(size(Xx,1),size(Xx,1),numel(Base_datos));
Fuera_out2 = zeros(size(Xx,1),size(Xx,1),numel(Base_datos));
Fuera_out3 = zeros(size(Xx,1),size(Xx,1),numel(Base_datos));

Dest_1 = zeros(size(Xx,1),size(Xx,1),numel(Base_datos));
Dest_2 = zeros(size(Xx,1),size(Xx,1),numel(Base_datos));
Dest_3 = zeros(size(Xx,1),size(Xx,1),numel(Base_datos));

Dest_H_6 = zeros(size(Xx,1),size(Xx,1),numel(Base_datos));
Dest_M_6 = zeros(size(Xx,1),size(Xx,1),numel(Base_datos));

S = strel('Disk',5);

for k=1:numel(Base_datos)
    
    Rodilla = Base_datos(k).Rodilla;
    cortical = Rodilla.mascara == 1;
    
    fprintf('Paciente nº Empezando %d \n',k)

    for i = 1:size(Alpha,2)
        
        for j = 1:size(Beta,2)
            
            Taladro1 = Crear_solo_cilindro_test(Rodilla,cortical,Alpha(i)...
                ,Beta(j),D(1),P);
            Fuera_out1(i,j,k) = Fuera_femur(Rodilla,Taladro1,S);
            Dest_1(i,j,k) = Cilindro_fx_final(Rodilla,Alpha(i),Beta(j),D(1),P);
            
            Taladro2 = Crear_solo_cilindro_test(Rodilla,cortical,Alpha(i)...
                ,Beta(j),D(2),P);
            Fuera_out2(i,j,k) = Fuera_femur(Rodilla,Taladro2,S);
            Dest_2(i,j,k) = Cilindro_fx_final(Rodilla,Alpha(i),Beta(j),D(2),P);

            Taladro3 = Crear_solo_cilindro_test(Rodilla,cortical,Alpha(i)...
                ,Beta(j),D(3),P);
            Fuera_out3(i,j,k) = Fuera_femur(Rodilla,Taladro3,S);
            Dest_3(i,j,k) = Cilindro_fx_final(Rodilla,Alpha(i),Beta(j),D(3),P);

            
        end
    end
    
    fprintf('Paciente nº Terminado %d \n',k)
    
end

%% AnÃ¡lisis por Ã?ngulos Segmentos.
% Yeq = Corresponde a alpha (Horizontal) e Xeq a Beta (elevacion)

Pace = 1;

[Xx3,Yy3,Zz3] = meshgrid(Alpha,Beta,1:size(Dest_1,3));
[Xeq3,Yeq3,Zeq3] = meshgrid(-Limit_beta:Pace:Limit_beta,-Limit_alpha:Pace:Limit_alpha,1:size(Dest_1,3));
[Xeq,Yeq] = meshgrid(-Limit_beta:Pace:Limit_beta,-Limit_alpha:Pace:Limit_alpha);


Out_1 = interp2(Xx,Yy,mean(Fuera_out1,3),Xeq,Yeq,'cubic');
Out_2 = interp2(Xx,Yy,mean(Fuera_out2,3),Xeq,Yeq,'cubic');
Out_3 = interp2(Xx,Yy,mean(Fuera_out3,3),Xeq,Yeq,'cubic');

% Test1_interp = interp2(Xx,Yy,mean(Dest_1,3),Xeq,Yeq,'cubic');
% Test2_interp = interp2(Xx,Yy,mean(Dest_2,3),Xeq,Yeq,'cubic');
% Test3_interp = interp2(Xx,Yy,mean(Dest_3,3),Xeq,Yeq,'cubic');
% Test_hombres_interp = interp2(Xx,Yy,mean(Dest_H_6,3),Xeq,Yeq,'cubic');
% Test_mujeres_interp = interp2(Xx,Yy,mean(Dest_M_6,3),Xeq,Yeq,'cubic');

Caso_1 = interp3(Xx3,Yy3,Zz3,Dest_1,Xeq3,Yeq3,Zeq3,'cubic');
Caso_2 = interp3(Xx3,Yy3,Zz3,Dest_2,Xeq3,Yeq3,Zeq3,'cubic');
Caso_3 = interp3(Xx3,Yy3,Zz3,Dest_3,Xeq3,Yeq3,Zeq3,'cubic');
Caso_H = Caso_2(:,:,Hombres);
Caso_M = Caso_2(:,:,Mujeres);


%%

%Indice_Seguros = (Yeq <0) & (Out_interp < 2) & (Test3_interp < 3);
Margen_dest = 1;
Margen_out = 2;
Indice_Seguros_Cruzando1 =  (Out_1 < Margen_out) & (Test1_interp < Margen_dest) & (Xeq > 0);...%;
    %& (Xeq < 25) & (Yeq > -30);
Angulos_seguros_final1 = [Xeq(Indice_Seguros_Cruzando1),Yeq(Indice_Seguros_Cruzando1)];
%Puntos = zeros(size(Angulos_seguros_final,1),3);

Indice_Seguros_Cruzando2 =  (Out_2 < Margen_out) & (Test2_interp < Margen_dest) & (Xeq > 0);...%;
    %& (Xeq < 25) & (Yeq > -30);
Angulos_seguros_final2 = [Xeq(Indice_Seguros_Cruzando1),Yeq(Indice_Seguros_Cruzando1)];

Indice_Seguros_Cruzando3 =  (Out_3 < Margen_out) & (Test3_interp < Margen_dest) & (Xeq > 0);...%;
    %& (Xeq < 25) & (Yeq > -30);
Angulos_seguros_final3 = [Xeq(Indice_Seguros_Cruzando1),Yeq(Indice_Seguros_Cruzando1)];
f1 = figure;
%subplot(1,2,1);surf(Xeq,Yeq,Out_1);hold on; surf(Xeq,Yeq,20*Indice_Seguros_Cruzando,'EdgeColor','red');view(90,90)
%subplot(1,2,2);
surf(Xeq,Yeq,Test1_interp,'LineStyle','-');hold on; surf(Xeq,Yeq,2*Indice_Seguros_Cruzando1,'FaceColor','red','LineStyle','none'); 
axis tight; axis equal; title('D = 5 mm');
view(90,90)
set(gcf,'color','w');

f2 = figure;
%subplot(1,2,1);surf(Xeq,Yeq,Out_2);hold on; surf(Xeq,Yeq,20*Indice_Seguros_Cruzando,'EdgeColor','red');view(90,90)
%subplot(1,2,2);
surf(Xeq,Yeq,Test2_interp,'LineStyle','-');hold on; surf(Xeq,Yeq,2*Indice_Seguros_Cruzando2,'FaceColor','red','LineStyle','none');
axis tight; axis equal;title('D = 6 mm');
view(90,90)
set(gcf,'color','w');

f3 = figure;
%subplot(1,2,1);surf(Xeq,Yeq,Out_3);hold on; surf(Xeq,Yeq,20*Indice_Seguros_Cruzando,'EdgeColor','red');view(90,90)
%subplot(1,2,2);
surf(Xeq,Yeq,Test3_interp,'LineStyle','-');hold on; surf(Xeq,Yeq,2*Indice_Seguros_Cruzando3,'FaceColor','red','LineStyle','none');
axis tight; axis equal;title('D = 7 mm');
view(90,90)

%% X = beta

Angulos_seguros_final = [Xeq(Indice_Seguros_Cruzando3),Yeq(Indice_Seguros_Cruzando3)];
Puntos = zeros(size(Angulos_seguros_final,1),3);
Rodilla = V_out;


for k=1:size(Angulos_seguros_final,1)
    
    [~ ,Puntos(k,:)] = Distancia_a_cortical_lateral_dos_angulos...
        (Rodilla,Angulos_seguros_final(k,1),Angulos_seguros_final(k,2));
    
end

%%

Indice_Seguros_Cruzando1 = (Yeq <0) & (Out_Cruzando_Todos_int < 5) & (Dest_Cruzando_Todos_int < 3)...
    & (Xeq < 25) & (Yeq > -30);
Angulos_seguros_final = [Xeq(Indice_Seguros_Cruzando1),Yeq(Indice_Seguros_Cruzando1)];
Puntos_interp = zeros(size(Angulos_seguros_final,1),3);

Femur = Rodilla.mascara ==1;
Fisis = Rodilla.mascara ==2;
dxdy = V_out.info{1};
dz = V_out.info{2};
pace = (dxdy/dz);
[m,n,k] = size(V_out.mascara);
[Xq,Yq,Zq] = meshgrid(1:n,1:m,1:pace:k);
Femur = interp3(im2double(Femur),Xq,Yq,Zq,'cubic');
Fisis = interp3(im2double(Fisis),Xq,Yq,Zq,'cubic');
Info = V_out.info;
[~,~,z] = ind2sub(size(Femur>0), find(Femur>0));
pos = min(z);
Pto = Info{8};
New_Pto = [Pto(1) Pto(2) pos];
Info{8} = New_Pto;

%%
for k=1:size(Angulos_seguros_final,1)
    k
    [Puntos(k,:)] = Distancia_a_cortical_lateral_dos_angulos_2...
        (Fisis, Femur,Info,Angulos_seguros_final(k,1),Angulos_seguros_final(k,2));
    
end


%Plot_circulos_y_lineas(V_out,Puntos)

%%

    



  
    
    
    
    






    