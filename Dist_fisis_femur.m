function [Dist] = Dist_fisis_femur(V_seg)

    dx = V_seg.info{1};
    
    Femur = V_seg.mascara == 1;
    Fisis = V_seg.mascara == 2;
    
    Proy_Femur = zeros(size(Femur(:,:,1)));
    Proy_Fisis = zeros(size(Fisis(:,:,1)));
    
    for k=1:size(Femur,3)
        
        Proy_Femur = Proy_Femur + Femur(:,:,k);
        Proy_Fisis = Proy_Fisis + Fisis(:,:,k);
        
    end
    
    [row_femur,~] = find(Proy_Femur > 0);
    [row_fisis,~] = find(Proy_Fisis > 0);
    
    altura_promedio_fisis = mean(row_fisis);
    punto_bajo_femur = max(row_femur);
    
    Dist = abs((punto_bajo_femur - altura_promedio_fisis))*dx;
    
    
end
    
    