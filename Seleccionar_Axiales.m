%% Seleccionar Axiales

folder = uigetdir;
%%
Pacientes = dir(folder);
Direcciones = {};
aux = 0;
for k=1:length(Pacientes(:,1))
    
    if length(Pacientes(k).name) >= 3 
        aux = aux +1;
        Dir_aux= dir([Pacientes(k).folder '\' Pacientes(k).name]);
        
        for j=1:length(Dir_aux(:,1))
            if length(Dir_aux(j).name) >= 3 && Dir_aux(j).isdir
                Direcciones{aux,1} = [Dir_aux(j).folder '\' Dir_aux(j).name];
            end
        end
    end
end

%%
Datos = struct();

for j = 1:length(Direcciones)
    
    Lista = dir(Direcciones{j});
    Secuencias = {};
    aux = 0;
    aux2 = 0;
    Corte_axial = {};

    for k=1:length(Lista(:,1))

        if length(Lista(k).name) >= 3
            aux = aux +1;
            DicomList = dir([Lista(k).folder '\' Lista(k).name]);
            info = dicominfo([DicomList(3).folder '\' DicomList(3).name]);
            Sec = info.SeriesDescription;

            Palabras = split(Sec,' ');
            Palabras2 = split(Sec,'_');

            if length(Palabras2) > length(Palabras)
               Palabras = Palabras2;
            end

            Comp = strcmp(Palabras,'TR');
            Comp2 = strcmp(Palabras,'Axial');
            Comp3 = strcmp(Palabras, 'AXI');
            Comp4 = strcmp(Palabras, 'AXIAL');
            Comp5 = strcmp(Palabras, 'Axi');
           % Comp6 = strcmp(Palabras, 'TSE');            
            
            if sum(Comp == 1) || sum(Comp2 == 1) || sum(Comp3 == 1) || sum(Comp4 == 1)...
                    || sum(Comp5 == 1)
                
                aux2 = aux2 +1;
                Corte_axial{aux2} = Lista(k).name;
                aux2 = aux2 +1;
                Corte_axial{aux2} = info.SeriesDescription;
                
            end

            Secuencias{aux} = Sec;

        end
    end
    
    Datos(j).Secuencias = Secuencias;
    Datos(j).Axiales = Corte_axial;
    Datos(j).Rut = Pacientes(j+2).name;
    
    
end
   
%% Tabla

Rut = {Datos.Rut};
Axiales = {Datos.Axiales};
Tabla = table(Rut',Axiales');