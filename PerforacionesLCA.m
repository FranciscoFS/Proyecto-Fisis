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

gamma = 0:5:70;
Alpha = 20:5:90;

[Xx,Yy] = meshgrid(gamma,Alpha);
p = 50;
Dest_8 = zeros([size(Xx) numel(BD_F_LCA)]);
Dest_9 = zeros([size(Xx) numel(BD_F_LCA)]);
Dest_10 = zeros([size(Xx) numel(BD_F_LCA)]);

%%
tic;
for k=1:numel(BD_F_LCA)
    
    Rodilla = BD_F_LCA(k).Rodilla;
    fprintf('Rodilla %d empezando \n', k);  

    for i = 1:length(Alpha)
        for j = 1:length(gamma)
            
            Dest_8(i,j,k) = Cilindro_fx_final_LCA_Femur(Rodilla,gamma(j),Alpha(i),8,p,0);
            Dest_9(i,j,k) = Cilindro_fx_final_LCA_Femur(Rodilla,gamma(j),Alpha(i),9,p,0);
            Dest_10(i,j,k) = Cilindro_fx_final_LCA_Femur(Rodilla,gamma(j),Alpha(i),10,p,0);
            
            fprintf(' Angulos(%d,%d) de Rodilla %d  \n',gamma(j),Alpha(i),k)
        end
    end
    
    fprintf('Rodilla %d lista \n', k);  
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

[Xeq,Yeq] = meshgrid(0:70,20:90);
Dest_8_interp = interp2(Xx,Yy,mean(Dest_8,3),Xeq,Yeq);
Dest_9_interp = interp2(Xx,Yy,mean(Dest_9,3),Xeq,Yeq);
Dest_10_interp = interp2(Xx,Yy,mean(Dest_10,3),Xeq,Yeq);

%%
[Xx3F,Yy3F,Zz3F] = meshgrid(0:70,20:90,1:size(Dest_8,3));
[Xx3_Or,Yy3_Or,Zz3_Or] = meshgrid(0:5:70,20:5:90,1:size(Dest_8,3));
Dest_8_interp_F3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or,Dest_8,Xx3F,Yy3F,Zz3F);
Dest_9_interp_F3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or,Dest_9,Xx3F,Yy3F,Zz3F);
Dest_10_interp_F3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or, Dest_10,Xx3F,Yy3F,Zz3F);

%%

ax = figure;
ax.Color = 'white';
subplot(1,3,1);surf(Xeq,Yeq,Dest_8_interp); title('Diametro 8 mm'); colorbar; view(0,-90);
subplot(1,3,2);surf(Xeq,Yeq,Dest_9_interp); title('Diametro 9 mm'); colorbar; view(0,-90);
subplot(1,3,3);surf(Xeq,Yeq,Dest_10_interp);title('Diametro 10 mm'); colorbar; view(0,-90);

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

tic;
%pendientes = 7;

for k=7
    
    fprintf('Rodilla %d empezando \n', k);  
    try   
    
        for i = 1:length(delta)
            for j = 1:length(beta)

%                 Dest_8_T(i,j,k) = Cilindro_fx_final_tibia(Rodilla,beta(j),delta(i),8,p,0);
%                 Dest_9_T(i,j,k) = Cilindro_fx_final_tibia(Rodilla,beta(j),delta(i),9,p,0);
%                 Dest_10_T(i,j,k) = Cilindro_fx_final_tibia(Rodilla,beta(j),delta(i),10,p,0);
%                 
     
                    Dest_8_Tibias(i,j,k) = Cilindro_fx_final_tibia(BD_T_LCA(k).Rodilla,beta(j),delta(i),8,p,0);
                    Dest_9_Tibias(i,j,k) = Cilindro_fx_final_tibia(BD_T_LCA(k).Rodilla,beta(j),delta(i),9,p,0);
                    Dest_10_Tibias(i,j,k) = Cilindro_fx_final_tibia(BD_T_LCA(k).Rodilla,beta(j),delta(i),10,p,0);

                    fprintf(' Angulos(%d,%d) de Rodilla %d  \n',beta(j),delta(i),k)
                
            end
        end
        
        filename = ['Tibias'];
        save(filename,'-v7.3')
        fprintf('Rodilla %d lista y guardada \n', k);  
    catch
        pendientes(end +1 ) = k;
        fprintf('Rodilla %d pendiente \n', k);  
    end
        
    
end
toc;
%%
[Xeq_T,Yeq_T] = meshgrid(0:60,30:70);
Dest_8_interp_T = interp2(Xx_T,Yy_T,mean(Dest_8_Tibias(:,:,1:42),3),Xeq_T,Yeq_T);
Dest_9_interp_T = interp2(Xx_T,Yy_T,mean(Dest_9_Tibias(:,:,1:42),3),Xeq_T,Yeq_T);
Dest_10_interp_T = interp2(Xx_T,Yy_T,mean(Dest_10_Tibias(:,:,1:42),3),Xeq_T,Yeq_T);

%%

[Xx3_Or,Yy3_Or,Zz3_Or] = meshgrid(0:5:60,30:5:70,1:size(Dest_8_Tibias,3));
[Xx3,Yy3,Zz3] = meshgrid(0:60,30:70,1:size(Dest_8_Tibias,3));
Dest_8_interp_T_3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or,Dest_8_Tibias,Xx3,Yy3,Zz3);
Dest_9_interp_T_3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or,Dest_9_Tibias,Xx3,Yy3,Zz3);
Dest_10_interp_T_3 = interp3(Xx3_Or,Yy3_Or,Zz3_Or,Dest_10_Tibias,Xx3,Yy3,Zz3);


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