function [posicion_final] = ...
    Distancia_a_cortical_lateral_dos_angulos_2(Fisis, Femur,Info,Elevacion,Hortizontal)

    dx = Info{1,1};
    dz = dx;
    
    %ang1 Vertical
    %ang2 Horizontal
    
    mm = 90; %asegurarse que atraviese (podria ser cualquier cosa)
    coordenada = Info{8};
    Femur_total = (Femur + Fisis)>0;


    [z,x,y] = sph2cart(deg2rad(Elevacion),deg2rad(Hortizontal),mm);
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
    
    [~,~,z] = ind2sub(size(Femur_total>0), find(Femur_total>0));
    pos = max(z);
    
    for y = size(Z,2):-1:1
        
         if Z(y)<= pos
            try
                if Femur_total(X(y),Y(y),Z(y))>0
                    ultimo_punto = [X(y),Y(y),Z(y)];
                    posicion_final(1,1) = ultimo_punto(1);
                    posicion_final(1,2) = ultimo_punto(2);
                    posicion_final(1,3) = ultimo_punto(3);
                    % usar pitagoras dos veces
                    %Cateto = sqrt(((ultimo_punto(3)-P1(3))*dz)^2 +((ultimo_punto(2)-P1(2))*dx)^2);
                    %mm_dist = sqrt(((ultimo_punto(1)-P1(1))*dx)^2 +(Cateto^2));
                    break
                end
            catch
                continue
            end
        end
    end
end