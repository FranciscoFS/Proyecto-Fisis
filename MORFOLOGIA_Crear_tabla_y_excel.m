% Crear Tabla y Excel
%Crear Tabla
T = table(Nombre,Distancia_LM,Distancia_AP,Distancia_PD,Volumen_fisis,...
    Promedio_Altura_LM1,Promedio_Altura_LM2,Promedio_Altura_LM3,Min_Altura_LM1,Min_Altura_LM2,Min_Altura_LM3,Max_Altura_LM1,Max_Altura_LM2,Max_Altura_LM3,...
    Promedio_Altura_AP1,Promedio_Altura_AP2,Promedio_Altura_AP3,Min_Altura_AP1,Min_Altura_AP2,Min_Altura_AP3,Max_Altura_AP1,Max_Altura_AP2,Max_Altura_AP3);

%Write
prompt = {'Nombre a ponerle al archivo'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'Nueva Rodilla'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

writetable(T,[char(answer) '.xls'])