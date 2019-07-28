function V_seg = Para_TAC(V_seg,V_seg2)
%SIC-TAC, TT-TG
uiwait(msgbox(V_seg2.info{8,1}));
V_seg = Elegir_puntos_para_TAC(V_seg);
V_seg = Calculos_TAC(V_seg);
end