function Rotado = Ajustar_angulos(Vol, ang)

    if ang > 0
        Vol= imrotate3_fast(Vol,{(90-ang) 'Z'}); 
        Vol= imrotate3_fast(Vol,{270 'X'});
        Vol= imrotate3_fast(Vol,{(270) 'Z'});
        Rotado= imrotate3_fast(Vol,{(180) 'Y'});
    else
        
        Vol= imrotate3_fast(Vol,{-(90+ang) 'Z'});
        Vol= imrotate3_fast(Vol,{270 'X'});
        Vol= imrotate3_fast(Vol,{(270) 'Z'});
        Rotado= imrotate3_fast(Vol,{(180) 'Y'});
    end

end