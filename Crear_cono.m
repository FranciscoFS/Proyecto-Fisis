function pixeles_ya_sumados = Crear_cono(V_seg,posiciones_finales)
    %Direccion y distancia

    coordenada = V_seg.info{8};
    
    % 1 = Femur_hueso, 2 = Fisis_femur (indices de la mascara)
    
    % fisis_usar = V_seg.femur.fisis;
    fisis_usar = V_seg.mascara == 2;
    
    P1 = [coordenada(2),coordenada(1),coordenada(3)];
    pixeles_ya_sumados = zeros(size(fisis_usar));
    
    for n = 1:size(posiciones_finales,2)
        
    P2 = posiciones_finales(n,:);
    P2 = [P2(2),P2(1),P2(3)];
    
    [X, Y, Z] = bresenham_line3d(P1, P2);

    for i = 1:size(Z,2)
        x = Aproximar(X(i));
        y = Aproximar(Y(i));
        pixeles_ya_sumados(x,y,Z(i)) = 1;
        
    end
    end

    
    %p3= patch(isosurface(pixeles_ya_sumados),'FaceColor','green','EdgeColor','none');
    
    Box_size = 9;
    Cono = smooth3(pixeles_ya_sumados,'box',Box_size);
    p3= patch(isosurface(Cono),'FaceColor','green','EdgeColor','none');

end