function [V_rotado] = Rotar_V(Volumenes)

        % Hay que hacer el proceso para cada Volumen
        
        V_rotado = Volumenes;
        
        [n,m,k] = size(Volumenes.femur.hueso);
        [Xx,Yy] = meshgrid(1:n,1:m);
        Muestra_femur = Volumenes.femur.bones(:,:,round(k/2));
        Muestra_perone = Volumenes.perone.bones(:,:,round(k/2));
        Muestra_tibia = Volumenes.tibia.bones(:,:,round(k/2));
        
        Xx_femur = Xx(Muestra_femur >0);
        Yy_femur = Yy(Muestra_femur >0);
        [Coeff, ~] = pca([Xx_femur,Yy_femur]);
        Theta_femur = 90 - acos(abs(Coeff(1,1))).*180/pi;
        
        Xx_perone = Xx(Muestra_perone >0);
        Yy_perone = Yy(Muestra_perone >0);
        [Coeff, ~] = pca([Xx_perone,Yy_perone]);
        Theta_perone = 90 - acos(abs(Coeff(1,1))).*180/pi;
        
        Xx_tibia = Xx(Muestra_tibia >0);
        Yy_tibia = Yy(Muestra_tibia >0);
        [Coeff, ~] = pca([Xx_tibia,Yy_tibia]);
        Theta_tibia = 90 - acos(abs(Coeff(1,1))).*180/pi;
        
        V_rotado.femur.bones = imrotate3(Volumenes.femur.bones,Theta_femur,[0 1 0],'crop','FillValues',0);
        V_rotado.femur.fisis = imrotate3(Volumenes.femur.bones,Theta_femur,[0 1 0],'crop','FillValues',0);
        V_rotado.perone.bones = imrotate3(Volumenes.femur.bones,Theta_perone,[0 1 0],'crop','FillValues',0);
        V_rotado.perone.bones = imrotate3(Volumenes.femur.bones,Theta_perone,[0 1 0],'crop','FillValues',0);
        V_rotado.tibia.bones = imrotate3(Volumenes.femur.bones,Theta_tibia,[0 1 0],'crop','FillValues',0);
        V_rotado.tibia.bones = imrotate3(Volumenes.femur.bones,Theta_tibia,[0 1 0],'crop','FillValues',0);
        
end
  
        
        
        
        
        
            
        
        
        
        
        

        

        