    Rodilla = BD_T(k).Rodilla;
    dx = Rodilla.info{1}; 
    dz = Rodilla.info{2};
    pace = dx/dz;
    
    Puntos{k,1} = round(Rodilla.info{20,1}/pace);

    Fisis = single(Rodilla.mascara == 2);
    [n,m,z] = size(Fisis);
    [Xeq,Yeq,Zeq] = meshgrid(1:n,1:m,1:pace:z);
    Fisis = interp3(Fisis,Xeq,Yeq,Zeq,'nearest');
    Fisis = Fisis > 0.2;
    
    Distribucion1(k) = ProyeccionesFisis(Fisis(:,:,1:Puntos{k,1}(2)),dx);
    Distribucion2(k) = ProyeccionesFisis(Fisis(:,:,(Puntos{k,1}(2)+1):Puntos{k,1}(3)),dx);
    Distribucion3(k) = ProyeccionesFisis(Fisis(:,:,(Puntos{k,1}(3)+1):Puntos{k,1}(1)),dx);
    Distribucion4(k) = ProyeccionesFisis(Fisis(:,:,(Puntos{k,1}(1)+1):end),dx);
