function [V_out] = Rotar(V_in,Omega,eje)
    V_out = V_in;
    V_out.vol.orig = imrotate3_fast(V_in.vol.orig,{Omega eje});
    V_out.vol.filt = imrotate3_fast(V_in.vol.filt,{Omega eje});
    V_out.mascara = imrotate3_fast(V_in.mascara,{Omega eje});
 %   V_out.femur.fisis = imrotate3_fast(V_in.femur.fisis,{Omega eje});
 %   V_out.femur.bones = imrotate3_fast(V_in.femur.bones,{Omega eje});
%     V_out.tibia.fisis = imrotate3_fast(V_in.tibia.fisis,{Omega eje});
%     V_out.tibia.bones = imrotate3_fast(V_in.tibia.bones,{Omega eje});
end