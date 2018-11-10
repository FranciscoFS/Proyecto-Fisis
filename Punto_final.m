function Posicion_punto = Punto_final_taladro(V_seg,alpha,beta,p)

    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};
    coordenada = V_seg.info{8};
    
    %Angulo 1 Elevación y 2 horizontal
    
    [z,x,y] = sph2cart(deg2rad(beta),deg2rad(alpha),p);
    %dif_x
    pixeles_x = x/dx;
    %dif_y
    pixeles_y = y/dx;
    %dif_z
    pixeles_z = z/dz;

    P1 = [coordenada(1),coordenada(2),coordenada(3)];
    P2 = [P1(1)+pixeles_x, P1(2) + pixeles_y, P1(3) + pixeles_z];
    P2 = Aproximar(P2);
    Posicion_punto = P2;
end