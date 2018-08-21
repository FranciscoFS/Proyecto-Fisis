function [V_out] = Rotar(V_in,Omega,eje)

      V_out = V_in;
      
%     Rdefault = imref3d(size(V)); % The default coordinate system used by imrotate
%     tX = mean(Rdefault.XWorldLimits);
%     tY = mean(Rdefault.YWorldLimits);
%     tZ = mean(Rdefault.ZWorldLimits);
%     
%     % Matrices de Traslaci�n
%     
%     tTranslationToCenterAtOrigin = [1 0 0 0; 0 1 0 0; 0 0 1 0; -tX -tY -tZ 1];
%     tTransOriginal = [1 0 0 0; 0 1 0 0; 0 0 1 0; tX tY tZ 1];
% 
%     % Matrices de Rotaci�n
%     
%     tRotationZ = [cosd(Theta_Z) sind(Theta_Z) 0 0; -sind(Theta_Z) cosd(Theta_Z) 0 0; 0 0 1 0;0 0 0 1];
%     tRotationY = [cosd(Theta_Y) 0 -sind(Theta_Y) 0; 0 1 0 0; sind(Theta_Y) 0 cosd(Theta_Y) 0; 0 0 0 1];
%     
%     tMatrix =  tTranslationToCenterAtOrigin*tRotationZ*tRotationY;
%   %  tMatrix =  tRotationZ*tRotationY;
%     tMatrix = affine3d(tMatrix);
%     %tMatrix = affine3d(tTranslationToCenterAtOrigin);
%     
%     [V_rotado,V_ref] = imwarp(V,Rdefault, tMatrix,'nearest');
    
    V_out.vol.orig = imrotate3_fast(V_in.vol.orig,{Omega eje});
    V_out.vol.filt = imrotate3_fast(V_in.vol.filt,{Omega eje});
    V_out.mascara = imrotate3_fast(V_in.mascara,{Omega eje});
    
%     V_out.femur.fisis = imrotate3_fast(V_in.femur.fisis,{Omega eje});
%     V_out.femur.bones = imrotate3_fast(V_in.femur.bones,{Omega eje});
%     V_out.tibia.fisis = imrotate3_fast(V_in.tibia.fisis,{Omega eje});
%     V_out.tibia.bones = imrotate3_fast(V_in.tibia.bones,{Omega eje});

end