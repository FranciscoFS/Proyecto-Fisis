function [Diff] = comparar(V_seg1,V_seg2)

    %Diferencias entre los volumenes
    
    Diferencias = zeros(1,7);
    
    Diferencias(1) = (sum(abs(V_seg1.femur.bones(:) - V_seg2.femur.bones(:))))./(sum(V_seg1.femur.bones(:)));
    Diferencias(2) = (sum(abs(V_seg1.femur.fisis(:) - V_seg2.femur.fisis(:))))./(sum(V_seg1.femur.fisis(:)));
    Diferencias(3) = (sum(abs(V_seg1.tibia.bones(:) - V_seg2.tibia.bones(:))))./(sum(V_seg1.tibia.bones(:)));
    Diferencias(4) = (sum(abs(V_seg1.tibia.fisis(:) - V_seg2.tibia.fisis(:))))./(sum(V_seg1.tibia.fisis(:)));
    Diferencias(5) = (sum(abs(V_seg1.perone.bones(:) - V_seg2.perone.bones(:))))./(sum(V_seg1.perone.bones(:)));
    Diferencias(6) = (sum(abs(V_seg1.perone.fisis(:) - V_seg2.perone.fisis(:))))./(sum(V_seg1.perone.fisis(:)));
    Diferencias(7) = (sum(abs(V_seg1.rotula(:) - V_seg2.rotula(:))))./(sum(V_seg1.rotula(:)));
    
    Diff = mean(Diferencias);
    
end
    