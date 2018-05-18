function [V_rotado,V_ref] = Rotar(V,Theta_Z,Theta_Y)

    Rdefault = imref3d(size(V)); % The default coordinate system used by imrotate
    tX = mean(Rdefault.XWorldLimits);
    tY = mean(Rdefault.YWorldLimits);
    tZ = mean(Rdefault.ZWorldLimits);
    
    % Matrices de Traslación
    
    tTranslationToCenterAtOrigin = [1 0 0 0; 0 1 0 0; 0 0 1 0; -tX -tY -tZ 1];
    tTransOriginal = [1 0 0 0; 0 1 0 0; 0 0 1 0; tX tY tZ 1];

    % Matrices de Rotación
    
    tRotationZ = [cosd(Theta_Z) -sind(Theta_Z) 0 0; sind(Theta_Z) cosd(Theta_Z) 0 0; 0 0 1 0;0 0 0 1];
    tRotationY = [cosd(Theta_Y) 0 sind(Theta_Y) 0; 0 1 0 0; -sind(Theta_Y) 0 cosd(Theta_Y) 0; 0 0 0 1];
    
    tMatrix =  tTranslationToCenterAtOrigin*tRotationZ*tRotationY*tTransOriginal;
    tMatrix = affine3d(tMatrix);
    %tMatrix = affine3d(tTranslationToCenterAtOrigin);
    [V_rotado,V_ref] = imwarp(V,tMatrix,'nearest');
    

end