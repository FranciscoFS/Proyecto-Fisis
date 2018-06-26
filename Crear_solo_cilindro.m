function matriz_cilindro = Crear_solo_cilindro(V_seg,alpha,beta)
   %Direccion y distancia

    coordenada = V_seg.info{9};
    
    % 1 = Femur_hueso, 2 = Fisis_femur (indices de la mascara)
    
   % fisis_usar = V_seg.femur.fisis;
    fisis_usar = V_seg.mascara == 2;
    
    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};

    a1 = alpha;% azimut
    a2 = beta;% elevacion
    mm = 45;%Profundidad
    diametro = 6;

    
    [z,x,y] = sph2cart(deg2rad(a1),deg2rad(a2),mm);
    
    
    %dif_x
    pixeles_x = x/dx;

    %dif_y
    pixeles_y = y/dx;

    %dif_z
    pixeles_z = z/dz;
    
    
    P1 = coordenada;
    P2 = [P1(1)+pixeles_x, P1(2) + pixeles_y, P1(3) + pixeles_z];
    P2 = Aproximar(P2);

    [X, Y, Z] = bresenham_line3d(P1, P2);

    % Cilindro
    radio = diametro/2;
    radio_pix = Aproximar(radio/dx);
    
    [Xm,Ym] = meshgrid(1:size(fisis_usar,1),1:size(fisis_usar,1));   
    matriz_cilindro = zeros(size(fisis_usar));
    
    for i = 1:size(Z,2)
        pos_z = Z(i);
        xl = Aproximar(X(i));
        yl = Aproximar(Y(i));
        im = (Xm-xl).^2 + (Ym-yl).^2 <= radio_pix^2;
        matriz_cilindro(:,:,pos_z) = (matriz_cilindro(:,:,pos_z) + im);
    end
    
end