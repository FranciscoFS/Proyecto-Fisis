%% Calculo puntos 

fallos = [];
contador = 0;
tiempo = zeros(1,numel(Base_datos));
ultimo = 1;

%%
answer = 'Si';

for k =  fallos         %ultimo:numel(Base_datos)
    
    if strcmp(answer,'Si')
        
        try
            tic;
            New_RM = Para_RM(Base_datos(k).RM);
            Base_datos(k).RM = New_RM;

            New_TAC = Para_TAC(Base_datos(k).TAC, Base_datos(k).RM);
            Base_datos(k).TAC = New_TAC;

            tiempo(k)= toc;
            fprintf('SUCCES %d \n',k);

        catch
            contador = contador + 1;
            fallos(contador) = k;
            fprintf(' FALLO %d \n',k);
            uiwait(msgbox('Fallaste en esta','Fail','error'));
        end
    
    else
        ultimo = k;
        break
    end
        
        
    answer = questdlg('Continuar?', ...
	'Continue', ...
	'Si','No','Si');

end

%% Crear Excel con datos
% Orden Info: RM = [TT-TG, SIC-TAC, TT-PCL] y TAC = [TT-TG, SIC TAC]

Datos = cell(numel(Base_datos),11);

for k=1:numel(Base_datos)
    
    info_RM = Base_datos(k).RM.info;
    info_TAC = Base_datos(k).TAC.info;
    Datos{k,1} = regexprep(Base_datos(k).TAC.info{6},' ','_');
    Datos{k,2} = str2double(info_RM{4}(2:3));
    Datos{k,3} = info_RM{5};
    Datos{k,4} = info_RM{8};
    Datos{k,5} = info_TAC{8};
    Datos{k,11} = tiempo(k);
    try
        Datos{k,6} = info_RM{11}(1);
        Datos{k,7} = info_RM{11}(2);
        Datos{k,8} = info_RM{11}(3);
    catch
        Datos{k,6} = nan;
        Datos{k,7} = nan;
        Datos{k,8} = nan;
        
    end
    
    try 
        Datos{k,9} = info_TAC{11}(1);
        Datos{k,10} = info_TAC{11}(2);
    catch
        Datos{k,9} = nan; 
        Datos{k,10} = nan;
    end
    
end
                 
Tabla = cell2table(Datos);
Variables = {'Name','Edad','Sex','Estudio_RM','Estudio_TAC','RM_TTTG',...
    'RM_SICTAC','RM_TTPCL','TAC_TTTG','TAC_SICTAC','Tiempos'};
Tabla.Properties.VariableNames = Variables;

%%

writetable(Tabla,'Quintos_46_5.xlsx')
