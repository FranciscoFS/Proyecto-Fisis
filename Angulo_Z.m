function [Angulo] = Angulo_Z(V_seg)

        % Hay que hacer el proceso para cada Volumen
        %Por ahora es solo para el femur
        
        Femur = V_seg.mascara == 1;

        [n,m,k] = size(Femur);
        [Xx,Yy,~] = meshgrid(1:n,1:m,1:k);
        
        [~,~,v1] = ind2sub(size(Femur),find(Femur > 0));
     %  [~,~,v2] = ind2sub(size(V_seg.femur.bones),find(V_seg.femur.bones > 0));
     %  [~,~,v3] = ind2sub(size(V_seg.tibia.bones),find(V_seg.tibia.bones > 0));

        Muestra_femur = Femur(:,:,round((max(v1)+min(v1))/2));
       % Muestra_perone = V_seg.perone.bones(:,:,round((max(v1)+min(v1))/2));
       % Muestra_tibia = V_seg.tibia.bones(:,:,round((max(v3)+min(v3))/2));

        Xx_femur = Xx(Muestra_femur >0);
        Yy_femur = Yy(Muestra_femur >0);
        
      % Xx_femur = Xx(V_seg.femur.bones(:)>0);
      % Yy_femur = Yy(V_seg.femur.bones(:)>0);
      % Zz_femur = Zz(V_seg.femur.bones(:)>0);
        [Coeff, ~] = pca([Xx_femur,Yy_femur]);
        Angulo = 90 - acosd(abs(Coeff(1,1)));
 
        
     %  Xx_perone = Xx(Muestra_perone >0);
     %  Yy_perone = Yy(Muestra_perone >0);
     %  [Coeff, ~] = pca([Xx_perone,Yy_perone]);
     %  Theta_perone = 90 - acosd(abs(Coeff(1,1)));

     %  Xx_tibia = Xx(Muestra_tibia >0);
     %  Yy_tibia = Yy(Muestra_tibia >0);
     %  [Coeff, ~] = pca([Xx_tibia,Yy_tibia]);
     %  Theta_tibia = 90 - acos(abs(Coeff(1,1))).*180/pi;

     %  V_rotado.femur.bones = imrotate3(V_seg.femur.bones,Theta_femur,[0 0 1],'crop','FillValues',0);
     %  V_rotado.femur.fisis = imrotate3(V_seg.femur.fisis,Theta_femur,[0 0 1],'crop','FillValues',0);
     %  V_rotado.perone.bones = imrotate3(V_seg.perone.bones,-1*Theta_perone,[0 0 1],'crop','FillValues',0) >0;
     %  V_rotado.perone.fisis = imrotate3(V_seg.perone.fisis,-1*Theta_perone,[0 0 1],'crop','FillValues',0) >0;
     %  V_rotado.tibia.bones = imrotate3(V_seg.tibia.bones,-1*Theta_tibia,[0 0 1],'crop','FillValues',0)>0;
     %  V_rotado.tibia.fisis = imrotate3(V_seg.tibia.fisis,-1*Theta_tibia,[0 0 1],'crop','FillValues',0)>0;

     %M�todo Fast
     
%     eje = 'Z';
%     
%     V_rotado.femur.bones = imrotate3_fast(V_seg.femur.bones,{Theta_femur eje});
%     V_rotado.femur.fisis = imrotate3_fast(V_seg.femur.fisis,{Theta_femur eje});
%     V_rotado.vol.orig =  imrotate3_fast(V_seg.vol.orig,{Theta_femur eje});
%     V_rotado.vol.filt =  imrotate3_fast(V_seg.vol.filt,{Theta_femur eje});
%     V_rotado.mascara = imrotate3_fast(V_rotado.mascara,{Theta_femur eje});
%     
    %V_rotado.mascara = imrotate3(V_seg.mascara, Theta_femur,[0 1 0],'FillValues',1);

    
end
  
        
        
        
        
        
            
        
        
        
        
        

        

        