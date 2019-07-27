function V_seg = Para_TAC(V_seg,n)
%SIC-TAC, TT-TG
uiwait(msgbox(Base_datos(n).RM.info{8,1}));
V_seg = Elegir_puntos_para_TAC(V_seg);
V_seg = Calculos_TAC(V_seg);
end