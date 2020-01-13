
folder = uigetdir();
DIM = dir(folder);
%%
Base_datos = struct();
Pendientes = [];
contador = 0;
contador2 = 0;
largos_p2 = [];

    for k=1:numel(DIM)
        
        %pos = Lista(Seleccionados(k))+2;
        pos = k;
        if length(DIM(pos).name) > 5 && DIM(pos).isdir

             p = strsplit(genpath([DIM(pos).folder '/' DIM(pos).name]),';');
             
           largos_p2(end+1) = length(p);
             
             if length(p) == 6

                 try
                    contador = contador +1;
                    Base_datos(contador).RM = Dicomsave(p{3});
                    Base_datos(contador).TAC = Dicomspave(p{5});
                    fprintf('Pacientes %d guardado \n',contador);
                 catch
                     contador2 = contador2 + 1;
                     Pendientes(contador2) = k;
                     fprintf('Pacientes %d guardado \n',contador);
                 end
             end

%              if length(p) == 7 || length(p) == 8
% 
%                  try
%                     contador = contador +1;
%                     RM_dir = uigetdir(['D:\Drive\Uc\LPFM\TT-TG vs TT-PCL\Base Datos\' DIM(k).name],['Selecciona MRI de ' DIM(k).name]);
%                     Base_datos(contador).RM = Dicomsave(RM_dir);
%                     TAC_dir = uigetdir(['D:\Drive\Uc\LPFM\TT-TG vs TT-PCL\Base Datos\' DIM(k).name],['Selecciona TAC de ' DIM(k).name]);
%                     Base_datos(contador).TAC = Dicomsave(TAC_dir);
%                     fprintf('Pacientes %d guardado \n',contador);
%                  catch
%                      contador2 = contador2 + 1;
%                      Pendientes(contador2) = k;
%                      fprintf('Pacientes %d guardado \n',contador);
%                  end
%              end

        end
        
        if contador == 50
            break
        else 
            continue
        end
    end


%%
