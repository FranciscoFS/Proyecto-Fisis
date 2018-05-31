function [Volumenes,Check] = Volumenes_fisis(V_seg)

    dx = V_seg.info{1};
    dz = V_seg.info{2};
    
    Check = zeros(1,3);
    
    Voxel_size = dx*dx*dz ; %(en mm3)
    
    femur = V_seg.mascara == 2;
    tibia = V_seg.mascara == 4;
    perone = V_seg.mascara == 6;
    
    Volumenes.femur = sum(femur(:))*Voxel_size;
    Volumenes.tibia = sum(tibia(:))*Voxel_size;
    Volumenes.perone = sum(perone(:))*Voxel_size;
    
    if Volumenes.femur > 0
        Check(1,1) = 1;
    end
    
    if Volumenes.tibia > 0
        Check(1,2) = 1;
    end
    
    if Volumenes.perone > 0
        Check(1,3) = 1;
    end
        
    
end