function [Vols] = Med(X)

    Vols = [];

    for k = 1 : numel(X)
        V_seg1 = X(k).V_seg;
        
        Vols(end+1) = sum(V_seg1.femur.bones(:));
        Vols(end+1) = sum(V_seg1.femur.fisis(:));
        Vols(end+1) = sum(V_seg1.tibia.bones(:));
        Vols(end+1) = sum(V_seg1.tibia.fisis(:));
        Vols(end+1) = sum(V_seg1.perone.bones(:));
        Vols(end+1) = sum(V_seg1.perone.fisis(:));
        Vols(end+1) = sum(V_seg1.rotula(:));
    end
    
  
end