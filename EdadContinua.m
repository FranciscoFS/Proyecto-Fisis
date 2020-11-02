function Edad = EdadContinua(FechaNacimiento,FechaEstudio)

    FechaNacimiento= num2str(FechaNacimiento);
    FechaEstudio = num2str(FechaEstudio);
    
    DiasNaciemiento =  str2double(FechaNacimiento(1:4))*365 + str2double(FechaNacimiento(5:6))*30 ...
        + str2double(FechaNacimiento(7:8));
    DiasEstudio = str2double(FechaEstudio(1:4))*365 + str2double(FechaEstudio(5:6))*30 ...
    + str2double(FechaEstudio(7:8));
    
    Edad = (DiasEstudio - DiasNaciemiento)/365;

end

    
    