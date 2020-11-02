%% Perforaciones para LCA
% Cargar todas las rodillas, hacer For para cada pacientes y cal
% Punto 10,11 Tibia y 12 Femur.
%   beta;% azimut (+ hacia distal)
%   alpha;% horizontal (+ hacia posterior)
%
%   alpha: 20-90
%   beta: 0-60
%   gamma: 30-90
%   delta: 30-70
%   diámetros: 8, 9, 10mm

% gamma = 0:5:70;
% Alpha = 0:5:70;

delta = 10:5:60;
beta = 10:5:60;

[Xx,Yy] = meshgrid(beta,delta);
p = 50;

Dest_7_new = zeros([size(Xx) numel(BD_T)]);
Dest_8_new = zeros([size(Xx) numel(BD_T)]);
Dest_9_new = zeros([size(Xx) numel(BD_T)]);
Dest_10_new = zeros([size(Xx) numel(BD_T)]);

%%
tic;
pendientes = [];
aux = 0;

for k=32:numel(BD_T)
    
    Rodilla = BD_T(k).Rodilla;   
    fprintf('Rodilla %d empezando \n', k);
    
    ang = Rodilla.info{10};

    % 3 = Tibia hueso, 4 = Tibia fisis (indices de la mascara)

    if ang > 0
        fisis_usar= imrotate3_fast(single(Rodilla.mascara == 4),{(90-ang) 'Z'});
        hueso_usar= imrotate3_fast(single(Rodilla.mascara == 3),{(90-ang) 'Z'});
 
    else
        fisis_usar= imrotate3_fast(single(Rodilla.mascara == 4),{-(90+ang) 'Z'});
        hueso_usar= imrotate3_fast(single(Rodilla.mascara == 3),{-(90+ang) 'Z'});
    end
    
    fisis_usar= imrotate3_fast(fisis_usar,{270 'X'});
    hueso_usar= imrotate3_fast(hueso_usar,{270 'X'});
    fisis_usar= imrotate3_fast(fisis_usar,{(270) 'Z'});
    hueso_usar= imrotate3_fast(hueso_usar,{(270) 'Z'});

    dz = Rodilla.info{2,1};
    dx = Rodilla.info{1,1};
    pace = dx/dz;
    
    [m,z,n] = size(hueso_usar);
    [Xq,Zq,Yq] = meshgrid(single(1:pace:z),single(1:m),single(1:n));
    %[Xq,Zq] = meshgrid(1:pace:k,1:m);

    Fisis = interp3(fisis_usar, Xq,Zq,Yq,'nearest');
    Hueso = interp3(hueso_usar,Xq,Zq,Yq,'nearest');
    
%     [m,n,z] = size((Rodilla.mascara == 1));
%     [Xq,Yq,Zq] = meshgrid(single(1:m),single(1:n),single(1:pace:z));
%     hueso = interp3(hueso_usar,Xq,Yq,Zq,'nearest');
%     fisis = interp3(fisis_usar,Xq,Yq,Zq,'nearest');
%     
%     Opciones{1} = Xq;
%     Opciones{2} = Yq;
%     Opciones{3} = Zq;
%     Opciones{4} = 0; %Ver
%     Opciones{5} = 0; %Medio
%     Opciones{6} = Rodilla.info; %info

%     [m,n,z] = size((Rodilla.mascara == 1));
%     [Xq,Yq,Zq] = meshgrid(single(1:m),single(1:n),single(1:pace:z));
%     hueso = interp3(single(Rodilla.mascara == 1),Xq,Yq,Zq,'cubic');
%     fisis = interp3(single(Rodilla.mascara == 2),Xq,Yq,Zq,'cubic');

    
%     try 
        for i = 1:length(delta)    
            for j = 1:2
                
                   tic;
                   [Destrucciones,~] = Crear_cilindro_3D_fx_Tibia(Hueso,Fisis,Rodilla,delta(i),beta(j),[7 8 9 10],p);
                   Dest_7_new(i,j,k) = Destrucciones(1);
                   Dest_8_new(i,j,k) = Destrucciones(2);
                   Dest_9_new(i,j,k) = Destrucciones(3);
                   Dest_10_new(i,j,k) = Destrucciones(4);
                   toc;
   

                fprintf(' Angulos(%d,%d) de Rodilla %d  \n',beta(j),delta(i),k)
            end
        end

        %save([direction '\' 'Femur_78910_medio'],'Dest_7_medio','Dest_8_medio','Dest_9_medio','Dest_10_medio','k','-v7.3')
       %save([direction '\' 'Femur_7_3D2'],'Dest_7D_2','k','-v7.3')
        fprintf('Rodilla %d lista \n', k);  
        
%     catch
%         aux = aux +1;
%         pendientes(aux) = k;
%         fprintf('Rodilla %d pendiente \n', k);  
%     end
    
end
toc;

%%
tic;
   for i = 1:length(Alpha)
        for j = 1:length(gamma)
            
            Dest(i,j,k) = Cilindro_fx_final_LCA_Femur(Rodilla,gamma(j),Alpha(i),d,p);
        end
    end
toc;
%%

[Xeq,Yeq] = meshgrid(0:70,0:90);

Dest_7_interp = interp2(Xx,Yy,mean(Dest_7_medio,3),Xeq,Yeq);
Dest_8_interp = interp2(Xx,Yy,mean(Dest_8_medio,3),Xeq,Yeq);
Dest_9_interp = interp2(Xx,Yy,mean(Dest_9_medio,3),Xeq,Yeq);sur
Dest_10_interp = interp2(Xx,Yy,mean(Dest_10_medio,3),Xeq,Yeq);

%%
[Xx3F,Yy3F,Zz3F] = meshgrid(0:70,0:70,1:size(Dest_73D,3));
[Xx3_Or,Yy3_Or,Zz3_Or] = meshgrid(0:5:70,0:5:70,1:size(Dest_73D,3));

Dest_7_interp_F3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or,Dest_7_new,Xx3F,Yy3F,Zz3F);
Dest_8_interp_F3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or,Dest_8_new,Xx3F,Yy3F,Zz3F);
Dest_9_interp_F3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or,Dest_9_new,Xx3F,Yy3F,Zz3F);
Dest_10_interp_F3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or, Dest_10_new,Xx3F,Yy3F,Zz3F);

% Dest_7_interp_F3 = interp3(Dest_73D,Xx3F,Yy3F,Zz3F);
% Dest_8_interp_F3 = interp3(Dest_83D,Xx3F,Yy3F,Zz3F);
% Dest_9_interp_F3 = interp3(Dest_93D,Xx3F,Yy3F,Zz3F);
% Dest_10_interp_F3 = interp3(Dest_103D,Xx3F,Yy3F,Zz3F);

%%

ax = figure;
ax.Color = 'white';

subplot(2,2,1);surf(Xeq_T,Yeq_T,mean(Dest_7_interp_T_3,3)); title('Diametro 7 mm'); colorbar; view(0,90); axis equal tight
subplot(2,2,2);surf(Xeq_T,Yeq_T,mean(Dest_8_interp_T_3,3)); title('Diametro 8 mm'); colorbar; view(0,90);axis equal tight
subplot(2,2,3);surf(Xeq_T,Yeq_T,mean(Dest_9_interp_T_3,3)); title('Diametro 9 mm'); colorbar; view(0,90);axis equal tight
subplot(2,2,4);surf(Xeq_T,Yeq_T,mean(Dest_10_interp_T_3,3));title('Diametro 10 mm'); colorbar; view(0,90);axis equal tight
colormap jet

%% Tibia

delta= 30:5:70;
beta=  0:5:60;

[Xx_T,Yy_T] = meshgrid(beta,delta);
p = 45;
Dest_8_T = zeros([size(Xx_T) numel(BD_F_LCA)]);
Dest_9_T = zeros([size(Xx_T) numel(BD_F_LCA)]);
Dest_10_T = zeros([size(Xx_T) numel(BD_F_LCA)]);


Dest_8_Tibias = zeros([size(Xx_T) numel(BD_F_LCA)]);
Dest_9_Tibias = zeros([size(Xx_T) numel(BD_F_LCA)]);
Dest_10_Tibias = zeros([size(Xx_T) numel(BD_F_LCA)]);
%% Fecha 21/07 paciente 7 y 32 pendiente, se deja corriendo desde el 8 llegue hasta el 28. Patir del 29 (18:24 21.07).
% 22/07, pc se reinció asi que se hará denuevo, pero si harán guardando las
% variables
Dest_7_Tibias = zeros([size(Xx_T) numel(BD_T_LCA)]);
%%
tic;
pendientes = [];
p = 45;

for k=8:numel(BD_T_LCA)
    
    fprintf('Rodilla %d empezando \n', k);  
    try   
    
        for i = 1:length(delta)
            for j = 1:length(beta)

%                 Dest_8_T(i,j,k) = Cilindro_fx_final_tibia(Rodilla,beta(j),delta(i),8,p,0);
%                 Dest_9_T(i,j,k) = Cilindro_fx_final_tibia(Rodilla,beta(j),delta(i),9,p,0);
%                 Dest_10_T(i,j,k) = Cilindro_fx_final_tibia(Rodilla,beta(j),delta(i),10,p,0);
%                 
     
%                     Dest_8_Tibias(i,j,k) = Cilindro_fx_final_tibia(BD_T_LCA(k).Rodilla,beta(j),delta(i),8,p,0);
%                     Dest_9_Tibias(i,j,k) = Cilindro_fx_final_tibia(BD_T_LCA(k).Rodilla,beta(j),delta(i),9,p,0);
%                     Dest_10_Tibias(i,j,k) = Cilindro_fx_final_tibia(BD_T_LCA(k).Rodilla,beta(j),delta(i),10,p,0);
                    Dest_7_Tibias(i,j,k) = Cilindro_fx_final_tibia(BD_T_LCA(k).Rodilla,beta(j),delta(i),7,p,0,0);

                    fprintf(' Angulos(%d,%d) de Rodilla %d Destruccion %d  \n',beta(j),delta(i),k,Dest_7_Tibias(i,j,k))
                
            end
        end
        
        filename = 'Tibias_7';
        save([path '\' filename],'Dest_7_Tibias','k','-v7.3')
        fprintf('Rodilla %d lista y guardada \n', k);  
        
    catch
        pendientes(end +1 ) = k;
        fprintf('Rodilla %d pendiente \n', k);  
   end
        
    
end
toc;
%%
[Xeq_T,Yeq_T] = meshgrid(10:60,10:60);
Dest_8_interp_T = interp2(Xx_T,Yy_T,mean(Dest_8_Tibias(:,:,1:47),3),Xeq_T,Yeq_T);
Dest_9_interp_T = interp2(Xx_T,Yy_T,mean(Dest_9_Tibias(:,:,1:47),3),Xeq_T,Yeq_T);
Dest_10_interp_T = interp2(Xx_T,Yy_T,mean(Dest_10_Tibias(:,:,1:47),3),Xeq_T,Yeq_T);

%%

[Xx3_Or,Yy3_Or,Zz3_Or] = meshgrid(10:5:60,10:5:60,1:size(Dest_7_new,3));
[Xx3,Yy3,Zz3] = meshgrid(10:60,10:60,1:size(Dest_7_new,3));

Dest_7_interp_T_3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or,Dest_7_new,Xx3,Yy3,Zz3);
Dest_8_interp_T_3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or,Dest_8_new,Xx3,Yy3,Zz3);
Dest_9_interp_T_3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or,Dest_9_new,Xx3,Yy3,Zz3);
Dest_10_interp_T_3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or,Dest_10_new,Xx3,Yy3,Zz3);


%%
ax = figure;
ax.Color = 'white';
subplot(2,3,4);surf(Xeq_T,Yeq_T, Dest_8_interp_T); title('Diametro 8 mm'); colorbar; view(180,-90); axis equal tight;
subplot(2,3,5);surf(Xeq_T,Yeq_T, Dest_9_interp_T); title('Diametro 9 mm'); colorbar; view(180,-90); axis equal tight;
subplot(2,3,6);surf(Xeq_T,Yeq_T, Dest_10_interp_T);title('Diametro 10 mm'); colorbar; view(180,-90); axis equal tight;

subplot(2,3,1);surf(Xeq,Yeq,Dest_8_interp); title('Diametro 8 mm'); colorbar; view(180,90); axis equal tight;
subplot(2,3,2);surf(Xeq,Yeq,Dest_9_interp); title('Diametro 9 mm'); colorbar; view(180,90); axis equal tight;
subplot(2,3,3);surf(Xeq,Yeq,Dest_10_interp);title('Diametro 10 mm'); colorbar; view(180,90) ;axis equal tight;

%% Puntos LCA

for k=31:38
    
    aux = Punto_LCA_tibia_2(BD_T_LCA(k).Rodilla);
    BD_T_LCA(k).Rodilla = aux;
    
end

%% Análisis Estadistico Tibia

[row_1,col_1] = find(Dest_8_interp_T == max(Dest_8_interp_T(:)));
Delta_1_max = Yeq_T(row_1,1); Beta_1_max = Xeq_T(1,col_1) ;
Caso_1_T_Max = squeeze(Dest_8_interp_T_3(row_1,col_1,:));

[row_2,col_2] = find(Dest_9_interp_T == max(Dest_9_interp_T(:)));
Delta_2_max = Yeq_T(row_2,1); Beta_2_max = Xeq_T(1,col_2) ;
Caso_2_T_Max = squeeze(Dest_9_interp_T_3(row_2,col_2,:));

[row_3,col_3] = find(Dest_10_interp_T == max(Dest_10_interp_T(:)));
Delta_3_max = Yeq_T(row_3,1); Beta_3_max = Xeq_T(1,col_3) ;
Caso_3_T_Max = squeeze(Dest_10_interp_T_3(row_3,col_3,:));

[row_1,col_1] = find(Dest_8_interp_T == min(Dest_8_interp_T(:)));
Delta_1_min = Yeq_T(row_1,1); Beta_1_min = Xeq_T(1,col_1) ;
Caso_1_T_Min = squeeze(Dest_8_interp_T_3(row_1(1),col_1(1),:));

[row_2,col_2] = find(Dest_9_interp_T == min(Dest_9_interp_T(:)));
Delta_2_min = Yeq_T(row_2,1); Beta_2_min = Xeq_T(1,col_2) ;
Caso_2_T_Min = squeeze(Dest_9_interp_T_3(row_2(1),col_2(1),:));

[row_3,col_3] = find(Dest_10_interp_T == min(Dest_10_interp_T(:)));
Delta_3_min = Yeq_T(row_3,1); Beta_3_min = Xeq_T(1,col_3) ;
Caso_3_T_Min = squeeze(Dest_10_interp_T_3(row_3(1),col_3(1),:));

%%


[muHat_1,~,muCI_1,~] = normfit(Caso_1_T_Max);
[muHat_2,~,muCI_2,~] = normfit(Caso_2_T_Max);
[muHat_3,~,muCI_3,~] = normfit(Caso_3_T_Max);

% [muHat_hombres,~,muCI_hombres,~] = normfit(squeeze(Caso_H(row_1,col_hombre,:)));
% [muHat_mujeres,~,muCI_mujeres,~] = normfit(squeeze(Caso_M(row_1,col_mujer,:)));

Caso_1_CI_T_Max = {[num2str(muHat_1) '- [' num2str(muCI_1(1)) ' -' num2str(muCI_1(2)) ']'];...
    [num2str(Delta_1_max) ',' num2str(Beta_1_max)]};
Caso_2_CI_T_Max = {[num2str(muHat_2) '- [' num2str(muCI_2(1)) ' -' num2str(muCI_2(2)) ']'];...
    [num2str(Delta_2_max) ',' num2str(Beta_2_max)]};
Caso_3_CI_T_Max = {[num2str(muHat_3) '- [' num2str(muCI_3(1)) ' -' num2str(muCI_3(2)) ']'];...
    [num2str(Delta_3_max) ',' num2str(Beta_3_max)]};

[muHat_1,~,muCI_1,~] = normfit(Caso_1_T_Min);
[muHat_2,~,muCI_2,~] = normfit(Caso_2_T_Min);
[muHat_3,~,muCI_3,~] = normfit(Caso_3_T_Min);

% [muHat_hombres,~,muCI_hombres,~] = normfit(squeeze(Caso_H(row_1,col_hombre,:)));
% [muHat_mujeres,~,muCI_mujeres,~] = normfit(squeeze(Caso_M(row_1,col_mujer,:)));

Caso_1_CI_T_Min = {[num2str(muHat_1) '- [' num2str(muCI_1(1)) ' -' num2str(muCI_1(2)) ']'];...
    [num2str(Delta_1_min) ',' num2str(Beta_1_min)]};
Caso_2_CI_T_Min = {[num2str(muHat_2) '- [' num2str(muCI_2(1)) ' -' num2str(muCI_2(2)) ']'];...
   [num2str(Delta_2_min) ',' num2str(Beta_2_min)]};
Caso_3_CI_T_Min = {[num2str(muHat_3) '- [' num2str(muCI_3(1)) ' -' num2str(muCI_3(2)) ']'];...
    [num2str(Delta_3_min) ',' num2str(Beta_3_min)]};


tabla_T = table(Caso_1_CI_T_Min,Caso_2_CI_T_Min,Caso_3_CI_T_Min,...
    Caso_1_CI_T_Max,Caso_2_CI_T_Max,Caso_3_CI_T_Max);
%%
[p,tbl,stats_max] = anova1([Caso_1_T_Max,Caso_2_T_Max,Caso_3_T_Max])
c_max = multcompare(stats_max);

[p,tbl,stats_min] = anova1([Caso_1_T_Min,Caso_2_T_Min,Caso_3_T_Min])
c_min = multcompare(stats_min);
%% Anàlisis Femur

[row_1,col_1] = find(Dest_8_interp == max(Dest_8_interp(:)));
Gamma_1_max = Yeq(row_1,1); Alpha_1_max = Xeq(1,col_1) ;

[row_2,col_2] = find(Dest_9_interp == max(Dest_9_interp(:)));
Gamma_2_max = Yeq(row_2,1); Alpha_2_max = Xeq(1,col_2) ;

[row_3,col_3] = find(Dest_10_interp == max(Dest_10_interp(:)));
Gamma_3_max = Yeq(row_3,1); Alpha_3_max = Xeq(1,col_3) ;

Caso_1_F_max = squeeze(Dest_8_interp_F3(row_1,col_1,:));
Caso_2_F_max = squeeze(Dest_9_interp_F3(row_2,col_2,:));
Caso_3_F_max = squeeze(Dest_10_interp_F3(row_3,col_3,:));


[row_1,col_1] = find(Dest_8_interp == min(Dest_8_interp(:)));
Gamma_1_min = Yeq(row_1,1); Alpha_1_min = Xeq(1,col_1) ;

[row_2,col_2] = find(Dest_9_interp == min(Dest_9_interp(:)));
Gamma_2_min = Yeq(row_2,1); Alpha_2_min = Xeq(1,col_2) ;

[row_3,col_3] = find(Dest_10_interp == min(Dest_10_interp(:)));
Gamma_3_min = Yeq(row_3,1); Alpha_3_min = Xeq(1,col_3) ;

Caso_1_F_min = squeeze(Dest_8_interp_F3(row_1,col_1,:));
Caso_2_F_min = squeeze(Dest_9_interp_F3(row_2,col_2,:));
Caso_3_F_min = squeeze(Dest_10_interp_F3(row_3,col_3,:));

%%
[muHat_1,~,muCI_1,~] = normfit(Caso_1_F_max);
[muHat_2,~,muCI_2,~] = normfit(Caso_2_F_max);
[muHat_3,~,muCI_3,~] = normfit(Caso_3_F_max);

% [muHat_hombres,~,muCI_hombres,~] = normfit(squeeze(Caso_H(row_1,col_hombre,:)));
% [muHat_mujeres,~,muCI_mujeres,~] = normfit(squeeze(Caso_M(row_1,col_mujer,:)));

Caso_1_CI_F_Max = {[num2str(muHat_1) '- [' num2str(muCI_1(1)) ' -' num2str(muCI_1(2)) ']'];...
    [num2str(Gamma_1_max) ',' num2str(Alpha_1_max)]};
Caso_2_CI_F_Max = {[num2str(muHat_2) '- [' num2str(muCI_2(1)) ' -' num2str(muCI_2(2)) ']'];...
    [num2str(Gamma_2_max) ',' num2str(Alpha_2_max)]};
Caso_3_CI_F_Max = {[num2str(muHat_3) '- [' num2str(muCI_3(1)) ' -' num2str(muCI_3(2)) ']'];...
    [num2str(Gamma_3_max) ',' num2str(Alpha_3_max)]};

[muHat_1,~,muCI_1,~] = normfit(Caso_1_F_min);
[muHat_2,~,muCI_2,~] = normfit(Caso_2_F_min);
[muHat_3,~,muCI_3,~] = normfit(Caso_3_F_min);

% [muHat_hombres,~,muCI_hombres,~] = normfit(squeeze(Caso_H(row_1,col_hombre,:)));
% [muHat_mujeres,~,muCI_mujeres,~] = normfit(squeeze(Caso_M(row_1,col_mujer,:)));

Caso_1_CI_F_Min = {[num2str(muHat_1) '- [' num2str(muCI_1(1)) ' -' num2str(muCI_1(2)) ']'];...
    [num2str(Gamma_1_min) ',' num2str(Alpha_1_min)]};
Caso_2_CI_F_Min = {[num2str(muHat_2) '- [' num2str(muCI_2(1)) ' -' num2str(muCI_2(2)) ']'];...
   [num2str(Gamma_2_min) ',' num2str(Alpha_2_min)]};
Caso_3_CI_F_Min = {[num2str(muHat_3) '- [' num2str(muCI_3(1)) ' -' num2str(muCI_3(2)) ']'];...
    [num2str(Gamma_3_min) ',' num2str(Alpha_3_min)]};


tabla_F = table(Caso_1_CI_F_Min,Caso_2_CI_F_Min,Caso_3_CI_F_Min,...
    Caso_1_CI_F_Max,Caso_2_CI_F_Max,Caso_3_CI_F_Max);
%%
[p,tbl,stats_max] = anova1([Caso_1_F_max,Caso_2_F_max,Caso_3_F_max])
c_max = multcompare(stats_max);

[p,tbl,stats_min] = anova1([Caso_1_F_min,Caso_2_F_min,Caso_3_F_min])
c_min = multcompare(stats_min);

%%
%¿cuánto es el daño que se produce con brocas 8, 9 y 10, con ángulos alfa 20, beta 45, gama 45 y delta 70?
% En los casos de máximo daño, ...
%¿tienes la información de cuál es el grupo etario con mayor daño y el con menor daño relativo?

% Femur
[dummy, Pos_gamma45] = find(Xx == 45,1);
[Pos_alfa20, dummy] = find(Yy == 20,1);

[mu_8,CI_8] = Mean_CI(Dest_8(Pos_alfa20,Pos_gamma45,:))
[mu_9,CI_9] = Mean_CI(Dest_9(Pos_alfa20,Pos_gamma45,:))
[mu_10,CI_10] = Mean_CI(Dest_10(Pos_alfa20,Pos_gamma45,:))


%Tibia
[dummy, Pos_beta45] = find(Xx_T == 45,1);
[Pos_delta70, dummy] = find(Yy_T == 30,1);

[mu_8,CI_8] = Mean_CI(Dest_8_Tibias(Pos_delta70,Pos_beta45,:))
[mu_8,CI_8] = Mean_CI(Dest_9_Tibias(Pos_delta70,Pos_beta45,:))
[mu_8,CI_8] = Mean_CI(Dest_10_Tibias(Pos_delta70,Pos_beta45,:))

Gamma_1_max = Yeq(row_1,1); Alpha_1_max = Xeq(1,col_1) ;
Delta_1_max = Yeq_T(row_1,1); Beta_1_max = Xeq_T(1,col_1) ;

%% Analisis por edad Femur y Tibia

[p,tbl,stats] = anova1(Caso_1_T_Max,t_usar.Edad(t_usar.F_tibia ==1))
[p,tbl,stats] = anova1(Caso_2_T_Max,t_usar.Edad(t_usar.F_tibia ==1))
[p,tbl,stats] = anova1(Caso_3_T_Max,t_usar.Edad(t_usar.F_tibia ==1))

[p,tbl,stats] = anova1(Caso_1_F_max,t_usar.Edad)
[p,tbl,stats] = anova1(Caso_2_F_max,t_usar.Edad)
[p,tbl,stats] = anova1(Caso_3_F_max,t_usar.Edad)

%% Creaciones excels Tomas Angulos Femur

Pares_F = cell(size(Xeq(:)));
Xeq_lineal = Xeq(:);
Yeq_lineal = Yeq(:);

for k=1:length(Pares)
    
    Pares{k} = ['Gamma' num2str(Xeq_lineal(k)) 'y' 'Alpha' num2str(Yeq_lineal(k))];
end

Dest_10_L = array2table(reshape(Dest_10_interp_F3,5041,56)');
Dest_10_L.Id = t_usar.Nombre;
Dest_10_L.Edad = t_usar.Edad;
Dest_10_L.Sexo = t_usar.Sexo;
Dest_10_L.Properties.VariableNames = [Pares' 'Id' 'Edad' 'Sex'];

Dest_9_L = array2table(reshape(Dest_9_interp_F3,5041,56)');
Dest_9_L.Id = t_usar.Nombre;
Dest_9_L.Edad = t_usar.Edad;
Dest_9_L.Sexo = t_usar.Sexo;
Dest_9_L.Properties.VariableNames = [Pares' 'Id' 'Edad' 'Sex'];

Dest_8_L = array2table(reshape(Dest_8_interp_F3,5041,56)');
Dest_8_L.Id = t_usar.Nombre;
Dest_8_L.Edad = t_usar.Edad;
Dest_8_L.Sexo = t_usar.Sexo;
Dest_8_L.Properties.VariableNames = [Pares' 'Id' 'Edad' 'Sex'];

writetable(Dest_10_L,'Dest_10_F.xlsx')
writetable(Dest_9_L,'Dest_9_F.xlsx')
writetable(Dest_8_L,'Dest_8_F.xlsx')

%% Creaciones excels Tomas Angulos Tibia

Pares_F = cell(size(Xeq_T(:)));
Xeq_lineal = Xeq_T(:);
Yeq_lineal = Yeq_T(:);
aux = length(Pares_F);


for k=1:length(Pares_F)
    
    Pares_F{k} = ['Beta' num2str(Xeq_lineal(k)) 'y' 'Delta' num2str(Yeq_lineal(k))];
end

Dest_10_L = array2table(reshape(Dest_10_interp_T_3,aux,47)');
Dest_10_L.Id = t_T.Nombre;
Dest_10_L.Edad = t_T.Edad;
Dest_10_L.Sexo = t_T.Sexo;
Dest_10_L.Properties.VariableNames = [Pares_F' 'Id' 'Edad' 'Sex'];

Dest_9_L = array2table(reshape(Dest_9_interp_T_3,aux,47)');
Dest_9_L.Id = t_T.Nombre;
Dest_9_L.Edad = t_T.Edad;
Dest_9_L.Sexo = t_T.Sexo;
Dest_9_L.Properties.VariableNames = [Pares_F' 'Id' 'Edad' 'Sex'];

Dest_8_L = array2table(reshape(Dest_8_interp_T_3,aux,47)');
Dest_8_L.Id = t_T.Nombre;
Dest_8_L.Edad = t_T.Edad;
Dest_8_L.Sexo = t_T.Sexo;
Dest_8_L.Properties.VariableNames = [Pares_F' 'Id' 'Edad' 'Sex'];

writetable(Dest_10_L,'Dest_10_T.xlsx')
writetable(Dest_9_L,'Dest_9_T.xlsx')
writetable(Dest_8_L,'Dest_8_T.xlsx')


