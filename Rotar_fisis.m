function [V_out] = Rotar_fisis(V_in,Omega,eje)
    V_out = V_in;
    V_out.vol.orig = imrotate3_fast(V_in.vol.orig,{Omega eje});
    V_out.vol.filt = imrotate3_fast(V_in.vol.filt,{Omega eje});
    V_out.mascara = imrotate3_fast(V_in.mascara,{Omega eje});
end