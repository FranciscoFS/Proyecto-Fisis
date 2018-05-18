function [V_rotado] = Rotar_V(V_seg)

        % Hay que hacer el proceso para cada Volumen
        %Por ahora es solo para el femur
        
        V_rotado = V_seg;
        
<<<<<<< HEAD
        %dxdy = V_seg.info{1,1};
        %dz = V_seg.info{2,1};
        %pace = (1/(dz/dxdy));
        
        [n,m,k] = size(V_seg.femur.bones);
        [Xx,Yy,~] = meshgrid(1:n,1:m,1:k);
        
        %femur = interp3(V_seg.femur.bones,Xx,Yy,Zz,'cubic');
        %tibia = interp3(V_seg.femur.bones,Xx,Yy,Zz,'cubic');
        %perone = interp3(V_seg.femur.bones,Xx,Yy,Zz,'cubic');
        
       % [~,~,v1] = ind2sub(size(V_seg.perone.bones),find(V_seg.perone.bones > 0));
        [~,~,v1] = ind2sub(size(V_seg.femur.bones),find(V_seg.femur.bones > 0));
       % [~,~,v3] = ind2sub(size(V_seg.tibia.bones),find(V_seg.tibia.bones > 0));
        
        Muestra_femur = V_seg.femur.bones(:,:,round((max(v1)+min(v1))/2));
       % Muestra_perone = V_seg.perone.bones(:,:,round((max(v1)+min(v1))/2));
       % Muestra_tibia = V_seg.tibia.bones(:,:,round((max(v3)+min(v3))/2));
=======
        [n,m,k] = size(V_seg.femur.bones);
        [Xx,Yy,~] = meshgrid(1:n,1:m,1:k);
        
    %   femur = interp3(V_seg.femur.bones,Xx,Yy,Zz,'cubic');
    %   tibia = interp3(V_seg.femur.bones,Xx,Yy,Zz,'cubic');
    %   perone = interp3(V_seg.femur.bones,Xx,Yy,Zz,'cubic');
        
     %  [~,~,v1] = ind2sub(size(V_seg.perone.bones),find(V_seg.perone.bones > 0));
        [~,~,v2] = ind2sub(size(V_seg.femur.bones),find(V_seg.femur.bones > 0));
     %  [~,~,v3] = ind2sub(size(V_seg.tibia.bones),find(V_seg.tibia.bones > 0));
        
        Muestra_femur = V_seg.femur.bones(:,:,round((max(v2)+min(v2))/2));
      % Muestra_perone = V_seg.perone.bones(:,:,round((max(v1)+min(v1))/2));
      % Muestra_tibia = V_seg.tibia.bones(:,:,round((max(v3)+min(v3))/2));
>>>>>>> d321500572cd5497345981c364c498e59ee0ffd8
        
        Xx_femur = Xx(Muestra_femur >0);
        Yy_femur = Yy(Muestra_femur >0);
        [Coeff, ~] = pca([Xx_femur,Yy_femur]);
        Theta_femur = 90 - acos(abs(Coeff(1,1))).*180/pi;
        V_rotado.info{9} = Theta_femur;
        
<<<<<<< HEAD
        %Xx_perone = Xx(Muestra_perone >0);
        %Yy_perone = Yy(Muestra_perone >0);
        %[Coeff, ~] = pca([Xx_perone,Yy_perone]);
        %Theta_perone = 90 - acos(abs(Coeff(1,1))).*180/pi;
        
        %Xx_tibia = Xx(Muestra_tibia >0);
        %Yy_tibia = Yy(Muestra_tibia >0);
        %[Coeff, ~] = pca([Xx_tibia,Yy_tibia]);
        %Theta_tibia = 90 - acos(abs(Coeff(1,1))).*180/pi;
        
        eje = 'Z';
        V_rotado.femur.bones = imrotate3(V_seg.femur.bones,Theta_femur,[0 0 1],'FillValues',0) >0;
        V_rotado.femur.fisis = imrotate3(V_seg.femur.fisis,Theta_femur,[0 0 1],'FillValues',0) >0;
        
        V_rotado.femur.bones = imrotate3_fast(V_seg.femur.bones,{Theta_femur eje}) >0;
        V_rotado.femur.fisis = imrotate3_fast(V_seg.femur.fisis,{Theta_femur eje}) >0; 
        
        
        %V_rotado.perone.bones = imrotate3(V_seg.perone.bones,-1*Theta_perone,[0 0 1],'crop','FillValues',0) >0;
        %V_rotado.perone.fisis = imrotate3(V_seg.perone.fisis,-1*Theta_perone,[0 0 1],'crop','FillValues',0) >0;
        %V_rotado.tibia.bones = imrotate3(V_seg.tibia.bones,-1*Theta_tibia,[0 0 1],'crop','FillValues',0)>0;
        %V_rotado.tibia.fisis = imrotate3(V_seg.tibia.fisis,-1*Theta_tibia,[0 0 1],'crop','FillValues',0)>0;
        
        V_rotado.mascara = imrotate3(V_seg.mascara,Theta_femur,[0 0 1],'crop','FillValues',1);
=======
     %  Xx_perone = Xx(Muestra_perone >0);
     %  Yy_perone = Yy(Muestra_perone >0);
     %  [Coeff, ~] = pca([Xx_perone,Yy_perone]);
     %  Theta_perone = 90 - acos(abs(Coeff(1,1))).*180/pi;
        
     %  Xx_tibia = Xx(Muestra_tibia >0);
     %  Yy_tibia = Yy(Muestra_tibia >0);
     %  [Coeff, ~] = pca([Xx_tibia,Yy_tibia]);
     %  Theta_tibia = 90 - acos(abs(Coeff(1,1))).*180/pi;
        
     %  V_rotado.femur.bones = imrotate3(V_seg.femur.bones,Theta_femur,[0 0 1],'crop','FillValues',0);
     %  V_rotado.femur.fisis = imrotate3(V_seg.femur.fisis,Theta_femur,[0 0 1],'crop','FillValues',0);
        
        eje = 'Z';
        
        V_rotado.femur.bones = imrotate3_fast(V_seg.femur.bones,{Theta_femur eje});
        V_rotado.femur.fisis = imrotate3_fast(V_seg.femur.fisis,{Theta_femur eje});
        V_rotado.vol.orig = 
        
     %  V_rotado.perone.bones = imrotate3(V_seg.perone.bones,-1*Theta_perone,[0 0 1],'crop','FillValues',0) >0;
     %  V_rotado.perone.fisis = imrotate3(V_seg.perone.fisis,-1*Theta_perone,[0 0 1],'crop','FillValues',0) >0;
     %  V_rotado.tibia.bones = imrotate3(V_seg.tibia.bones,-1*Theta_tibia,[0 0 1],'crop','FillValues',0)>0;
     %  V_rotado.tibia.fisis = imrotate3(V_seg.tibia.fisis,-1*Theta_tibia,[0 0 1],'crop','FillValues',0)>0;
>>>>>>> d321500572cd5497345981c364c498e59ee0ffd8
        
        
        
end
  
        
        
        
        
        
            
        
        
        
        
        

        

        