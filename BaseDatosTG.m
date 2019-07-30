
folder = uigetdir();
DIM = dir(folder);
Base_datos = struct();
Pendientes = [];
contador = 0;
contador2 = 0;
%largos_p = [];

    for k=1:numel(DIM)

        if length(DIM(k).name) > 5 && DIM(k).isdir

             p = strsplit(genpath([DIM(k).folder '/' DIM(k).name]),';');
             
%              largos_p(end+1) = length(p);

             if length(p) == 6

                 try
                    contador = contador +1;
                    Base_datos(contador).RM = Dicomsave(p{3});
                    Base_datos(contador).TAC = Dicomsave(p{5});
                    fprintf('Pacientes %d guardado \n',contador);
                 catch
                     contador2 = contador2 + 1;
                     Pendientes(contador2) = k;
                     fprintf('Pacientes %d guardado \n',contador);
                 end
             end
        end
        
        if contador == 50
            break
        else 
            continue
        end
    end


%%
                 

