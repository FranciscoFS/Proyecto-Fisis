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

ax = figure;
ax.Color = 'white';
subplot(1,3,1);surf(Xeq,Yeq,Dest_8_interp); title('Diametro 8 mm'); colorbar; view(0,-90);
subplot(1,3,2);surf(Xeq,Yeq,Dest_9_interp); title('Diametro 9 mm'); colorbar; view(0,-90);
subplot(1,3,3);surf(Xeq,Yeq,Dest_10_interp);title('Diametro 10 mm'); colorbar; view(0,-90);

%% Tibia

delta= 30:5:70;
beta=  0:5:60;

[Xx_T,Yy_T] = meshgrid(beta,delta);
p = 30;
Dest_8_T = zeros([size(Xx_T) numel(BD_F_LCA)]);
Dest_9_T = zeros([size(Xx_T) numel(BD_F_LCA)]);
Dest_10_T = zeros([size(Xx_T) numel(BD_F_LCA)]);

%%
tic;
for k=1:numel(BD_F_LCA)
    
    Rodilla = BD_F_LCA(k).Rodilla;
    fprintf('Rodilla %d empezando \n', k);  

    for i = 1:length(delta)
        for j = 1:length(beta)
            
            Dest_8_T(i,j,k) = Cilindro_fx_final_tibia(Rodilla,beta(j),delta(i),8,p);
            Dest_9_T(i,j,k) = Cilindro_fx_final_tibia(Rodilla,beta(j),delta(i),9,p);
            Dest_10_T(i,j,k) = Cilindro_fx_final_tibia(Rodilla,beta(j),delta(i),10,p);
            
            fprintf(' Angulos(%d,%d) de Rodilla %d  \n',gamma(j),Alpha(i),k)
        end
    end
    
    fprintf('Rodilla %d lista \n', k);  
end
toc;
