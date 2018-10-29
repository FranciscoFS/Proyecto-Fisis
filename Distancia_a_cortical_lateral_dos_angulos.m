function [mm_dist,posicion_final] = Distancia_a_cortical_lateral_dos_angulos(V_seg,ang1,ang2)

    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};
    
    %ang1 horizontal
    %ang2 vertical
    
    mm = 200; %asegurarse que atraviese (podria ser cualquier cosa)
    coordenada = V_seg.info{8};
    Femur = V_seg.mascara == 1;
    Fisis = V_seg.mascara == 2;
    Femur_total = (Femur + Fisis)>0;

    [z,x,y] = sph2cart(deg2rad(ang1),deg2rad(ang2),mm);
    %dif_x
    pixeles_x = x/dx;
    %dif_y
    pixeles_y = y/dx;
    %dif_z
    pixeles_z = z/dz;

    P1 = [coordenada(1),coordenada(2),coordenada(3)];
    P2 = [P1(1)+pixeles_x, P1(2) + pixeles_y, P1(3) + pixeles_z];
    P2 = Aproximar(P2);

    [X, Y, Z] = bresenham_line3d(P1, P2);

    for y = size(Z,2):-1:1
        if Z(y)<= size(Femur_total,3)
            if Femur_total(X(y),Y(y),Z(y))>0
                ultimo_punto = [X(y),Y(y),Z(y)];
                posicion_final(1,1) = ultimo_punto(1);
                posicion_final(1,2) = ultimo_punto(2);
                posicion_final(1,3) = ultimo_punto(3);
                mm_dist = sqrt(((ultimo_punto(3)-P1(3))*dz)^2 +((ultimo_punto(2)-P1(2))*dx)^2);
                break
            end
        end
    end
end