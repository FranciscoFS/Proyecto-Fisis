function Cilindro = Cilindro_Femur_LCA(V_seg,cortical,gamma,alpha,d,p)

    vol = cortical;
    coordenada = V_seg.info{12};

    [~,~,v1] = ind2sub(size(vol),find(vol > 0));
    Mid = round((max(v1)+min(v1))/2);

    vol = vol(1:size(vol,1),1:size(vol,1),Mid: size(vol,3));
    encontrado = 0;
    contador = 1;
    
    while (contador <= size(vol,3) && encontrado ==0)
        if vol(Aproximar(coordenada(2)),Aproximar(coordenada(1)),contador)>0
            coordz = contador; 
            encontrado =1;
        end
        contador = contador+1;
    end
    
    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};

    a1 = (alpha-90);% azimut (+ hacia proximal) 
    a2 = -gamma;% horizontal (+ hacia anterior)
    mm = p;%Profundidad
    diametro = d;

    [z,y,x] = sph2cart(deg2rad(a1),deg2rad(a2),mm);

    %dif_x
    pixeles_x = x/dx;

    %dif_y
    pixeles_y = y/dx;

    %dif_z
    pixeles_z = z/dx;


    % Dejar "(Y,X,Z)" si desde Stephen llega x,y,z CONFIRMADO NO CAMBIAR
    P1 = [coordenada(2),coordenada(1),coordz-dz/dx];
    P2 = [P1(1)+pixeles_y, P1(2) + pixeles_x, P1(3) + pixeles_z];
    P2 = Aproximar(P2);

    [X, Y, Z] = bresenham_line3d(P1, P2);

    % Cilindro
    radio = diametro/2;
    radio_pix = Aproximar(radio/dx);
    pixeles_ya_sumados = zeros(size(cortical));

    for i = 1:size(Z,2)
        x = Aproximar(X(i));
        y = Aproximar(Y(i));

        p = x - radio_pix : x + radio_pix;
        q = y - radio_pix : y + radio_pix;

        for j = 1:size(p,2)

            for t = 1:size(q,2)

                if (x-p(j))^2 + (y-q(t))^2 <= radio_pix^2

                    try
                        if (pixeles_ya_sumados(p(j),q(t),Z(i)) == 0)
                            pixeles_ya_sumados(p(j),q(t),Z(i)) = 1;
                        end
                    catch
                        continue
                    end
                end
            end
        end
    end
    
   Cilindro = pixeles_ya_sumados;
    
end