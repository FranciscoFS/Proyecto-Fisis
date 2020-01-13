%% Análisis Diferencia TAC y RM
% Dist1 = TT-TG en info{11}

N = 10; % Cantidad de Rodillas a calcular
Datos = zeros(N,12);

for k = 1:N
    
    RM = Base_datos(k).RM;
    TAC = Puntos_TAC2(Base_datos(k).TAC);
    [TAC,RM] = Pendientes(TAC,RM);
    Base_datos(k).RM = RM;
    Base_datos(k).TAC = TAC;
    
    TT_TG = [TAC.info{11}(1) RM.info{11}(1)];
    Relacion = [TAC.info{13}(1,2)/TAC.info{13}(2,2) ...
        RM.info{13}(1,2)/RM.info{13}(2,2)];
    
    Datos(k,1:2) = TT_TG;
    Datos(k,3:10) = [TAC.info{13}(:)' RM.info{13}(:)'];
    Datos(k,11:12) = Relacion;
    
    
end



%% Graficas Diferencia

k = 10; %Rodilla para ver

TAC = Base_datos(k).TAC;
RM = Base_datos(k).RM;

% Gráficar TAC
subplot(1,2,1);
Calculos_TAC(TAC,[1 0 0]);

%Graficar RM
subplot(1,2,2);
Calculos_RM(RM, [1 0 0]);
 


