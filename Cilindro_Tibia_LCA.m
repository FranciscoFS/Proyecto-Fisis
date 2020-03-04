function [Cilindro] = Cilindro_Tibia_LCA(V_seg,beta,delta,d,p)

    ang = V_seg.info{10};
    coordenada = V_seg.info{11};

    % 3 = Tibia hueso, 4 = Tibia fisis (indices de la mascara)

    fisis_usar = gpuArray(single(V_seg.mascara == 4));
%    hueso_usar = double(V_seg.mascara == 3);

    if ang > 0
        fisis_usar= imrotate3_fast(fisis_usar,{(90-ang) 'Z'});
      %  hueso_usar= imrotate3_fast(hueso_usar,{(90-ang) 'Z'});
    else
        fisis_usar= imrotate3_fast(fisis_usar,{-(90+ang) 'Z'});
     %   hueso_usar= imrotate3_fast(hueso_usar,{-(90+ang) 'Z'});
    end

    fisis_usar= imrotate3_fast(fisis_usar,{270 'X'});
    %hueso_usar= imrotate3_fast(hueso_usar,{270 'X'});
    fisis_usar= imrotate3_fast(fisis_usar,{(270) 'Z'});
    %hueso_usar= imrotate3_fast(hueso_usar,{(270) 'Z'});

    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};
    pace = (dx/dz);

    % fisis_nueva = [];
    % hueso_nuevo = [];
    m = size(fisis_usar,1);
    n = size(fisis_usar,3);
    k =size(fisis_usar,2);
    [Xq,Zq,Yq] = meshgrid(1:pace:k,1:m,1:n);
    %[Xq,Zq] = meshgrid(1:pace:k,1:m);

    fisis_nueva = interp3(gather(fisis_usar), Xq,Zq,Yq);
   % hueso_nuevo = interp3(hueso_usar,Xq,Zq,Yq);
    
    a1 = -beta;% hacia medial
    a2 = -delta;% hacia anterior
    mm = p;% Profundidad
    diametro = d;
    %x aca es medial-lateral (lateral es +) (que en [] es y)
    %y aca es anterior-posterior (posterior +)
    %z aca es distal-proximal

    [z,y,x] = sph2cart(deg2rad(a2),deg2rad(a1),(mm));

    %dif_x
    pixeles_x = Aproximar(x)/(dx);
    %dif_y
    pixeles_y = Aproximar(y)/(dx);
    %dif_z
    pixeles_z = Aproximar(z)/(dx);

    % 
    P1 = [coordenada(2),coordenada(1),coordenada(3)];
    P2 = [P1(1)+pixeles_y, P1(2) + pixeles_x, P1(3) + pixeles_z];
    P2 = Aproximar(P2);

    [X, Y, Z] = bresenham_line3d(P1, P2);

    % Cilindro
    radio = diametro/2;
    radio_pix = Aproximar(radio/(dx));

    pixeles_ya_sumados = zeros(size(fisis_nueva));

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
    
    pixeles_ya_sumados= imrotate3_fast(pixeles_ya_sumados,{-270 'Z'});
    pixeles_ya_sumados= imrotate3_fast(pixeles_ya_sumados,{-270 'X'});

    
    if ang > 0
        pixeles_ya_sumados= imrotate3_fast(pixeles_ya_sumados,{-(90-ang) 'Z'});
    else
        pixeles_ya_sumados= imrotate3_fast(pixeles_ya_sumados,{(90+ang) 'Z'});
    end
    

    Cilindro = pixeles_ya_sumados;
    
end
