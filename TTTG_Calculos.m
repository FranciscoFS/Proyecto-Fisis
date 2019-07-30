%% Calculo puntos 

fallos = [];
contador = 0;


for k = 12:numel(Base_datos)
    
    try
        New_RM = Para_RM(Base_datos(k).RM);
        New_TAC = Para_TAC(Base_datos(k).TAC, Base_datos(k).RM);

        Base_datos(k).RM = New_RM;
        Base_datos(k).TAC = New_TAC;
        fprintf('SUCCES %d \n',k);
        
    catch
        contador = contador + 1;
        fallos(contador) = k;
        fprintf(' FALLO %d \n',k);
        uiwait(msgbox('Fallaste en esta','Fail','error'));
    end
end

%% Crear Excel
