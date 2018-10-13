function pixeles_ya_sumados = Crear_solo_cilindro2(V_seg,alpha,beta,p,d)
    %Direccion y distancia

    coordenada = V_seg.info{8};
    
    % 1 = Femur_hueso, 2 = Fisis_femur (indices de la mascara)
    
   % fisis_usar = V_seg.femur.fisis;
    fisis_usar = V_seg.mascara == 2;
    
    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};

    a1 = beta;% + hacia distal
    a2 = alpha;% + hacia posterior
    mm = p;%Profundidad de perforacion
    diametro = d;

    [z,x,y] = sph2cart(deg2rad(a1),deg2rad(a2),mm);

    %dif_x
    pixeles_x = x/dx;
    %dif_y
    pixeles_y = y/dx;
    %dif_z
    pixeles_z = z/dz;
    
    P1 = [coordenada(2),coordenada(1),coordenada(3)]
    P2 = [coordenada(2)+pixeles_x, coordenada(1) + pixeles_y, P1(3) + pixeles_z];
    P2 = Aproximar(P2)

    [X, Y, Z] = bresenham_line3d(P1, P2);

    % Cilindro
    radio = diametro/2;
    radio_pix = Aproximar(radio/dx);

    pixeles_ya_sumados = zeros(size(fisis_usar));

    for i = 1:size(Z,2)

        x = Aproximar(X(i));
        y = Aproximar(Y(i));

        p = x - radio_pix : x + radio_pix;
        q = y - radio_pix : y + radio_pix;

        for j = 1:size(p,2)
        for t = 1:size(q,2)
        if (x-p(j))^2 + (y-q(t))^2 <= radio_pix^2
            if (pixeles_ya_sumados(p(j),q(t),Z(i)) == 0)
                pixeles_ya_sumados(p(j),q(t),Z(i)) = 1;
            end
        end 
        end
        end
    end
    


end