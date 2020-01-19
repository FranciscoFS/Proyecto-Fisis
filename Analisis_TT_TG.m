%% Análisis Diferencia TAC y RM
% Dist1 = TT-TG en info{11}

N = 23; % Cantidad de Rodillas a calcular Aqui serían 25, la 1 y 2 no las pude hacer.
Datos = zeros(N,14);
Puntos = cell(N,4);
Pacientes = 3:25; % Aqui poner desde que paciente hasta cual (tu serias 26:50)


for k = 1:length(Pacientes)
    
    Indice = Pacientes(k);
    RM = Base_datos(Indice).RM;
    TAC = Base_datos(Indice).TAC;
    
    TT_TG = [TAC.info{11}(1) RM.info{11}(1)];
    RM = Calculos_RM(Puntos_RM_TAT(RM),[0 0 0]);
    TT_TG(3) = RM.info{11}(1);
    TAC = Puntos_TAC2(TAC);
    [TAC,RM] = Pendientes(TAC,RM);
    
    Datos(k,1:3) = TT_TG;
    Datos(k,4:11) = [TAC.info{13}(:)' RM.info{13}(:)']; 
    
    Puntos{k,1} = RM.info{10}{3};
    Puntos{k,2} = RM.info{10}{4};
    Puntos{k,3} = TAC.info{12}{1};
    Puntos{k,4} = TAC.info{12}{2};
    
end

Datos(:,12) = atand((Datos(:,4) - Datos(:,5))./( 1 + Datos(:,4).*Datos(:,5)));
Datos(:,13) = atand((Datos(:,8) - Datos(:,9))./( 1 + Datos(:,8).*Datos(:,9)));
Datos(:,14) = abs(Datos(:,1) -Datos(:,3));
%% Convertir a tabla y exportar
Tabla = array2table(Datos);
Variables = {'TTTG_TAC','TTTG_RM','TTTG_RM2','M_F_TAC','M_T_TAC','Ang_F_TAC',...
    'Ang_T_TAC','M_F_RM','M_T_RM','Ang_F_RM','Ang_T_RN','Ang_TF_TAC','Ang_TF_RM','Diff_TTTG'};
Tabla.Properties.VariableNames = Variables;

Dirout = 'D:\Drive\Uc\LPFM\TT-TG vs TT-PCL\Analisis TTTG';
writetable(Tabla,[Dirout '\' 'Analisis_TTTG_primeros25.xlsx'])
save([Dirout '\' 'Puntos_primeros25.mat'],'Puntos','Pacientes') 
%Guardar los puntos nuevos por si queremos graficar
%% Graficas Diferencia CAca

k = 10; %Rodilla para ver

TAC = Base_datos(k).TAC;
RM = Base_datos(k).RM;

% Gráficar TAC
subplot(1,2,1);
Calculos_TAC(TAC,[1 0 0]);

%Graficar RM
subplot(1,2,2);
Calculos_RM(RM, [1 0 0]);


