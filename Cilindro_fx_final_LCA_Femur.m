function porc = Cilindro_fx_final_LCA_Femur(V_seg,gamma,alpha,d,p,view)
%Direccion y distancia

    coordenada = V_seg.info{12};

    % 1 = Femur_hueso, 2 = Fisis_femur (indices de la mascara)
    % Restar 1 a la coordenada Z de los puntos LCA Femur

    % fisis_usar = V_seg.femur.fisis;
    fisis_usar = V_seg.mascara == 2;
    hueso_usar = V_seg.mascara == 1;

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
    pixeles_z = z/dz;


    % Dejar "(Y,X,Z)" si desde Stephen llega x,y,z CONFIRMADO NO CAMBIAR
    P1 = [coordenada(2),coordenada(1),coordenada(3)-1];
    P2 = [P1(1)+pixeles_y, P1(2) + pixeles_x, P1(3) + pixeles_z];
    P2 = Aproximar(P2);

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
    
    if view

        f = figure;
        pace = (dx/dz);
        [m,n,k] = size(fisis_usar);
        [Xq,Yq,Zq] = meshgrid(1:n,1:m,1:pace:k);
        Box_size = 9;
        hold on
        fu = smooth3(interp3(im2double(fisis_usar),Xq,Yq,Zq,'cubic')...
            ,'box',Box_size);
        %fu= smooth3(fisis_usar, 'box', 9);
        hu = smooth3(interp3(im2double(hueso_usar),Xq,Yq,Zq,'cubic')...
            ,'box',Box_size);
        %hu = smooth3(hueso_usar,'box', 3);
        p1= patch(isosurface(fu),'FaceColor','red','EdgeColor','none');
        p2= patch(isosurface(hu),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
        taladro = smooth3(interp3(im2double(pixeles_ya_sumados),Xq,Yq,Zq,'cubic')...
            ,'box',Box_size);
        p3= patch(isosurface(taladro, 0.7),'FaceColor','green','EdgeColor','none');
        reducepatch(p2,0.01)
        ax = gca;
        c = ax.DataAspectRatio;
        ax.DataAspectRatio= [1 1 1];
        %ax.DataAspectRatio= [dz,dz,dx];
        %scatter3(P1(2),P1(1),P1(3),'red','filled'); 
        %scatter3(P2(2),P2(1),P2(3),'yellow');
    
        axis tight
        l = camlight('headlight');
        lighting gouraud
        material dull
        title('Fisis')
    end
    
    total_de_1s = sum(fisis_usar(:));
    delta = (fisis_usar - pixeles_ya_sumados) == 1;
    total_1s_resta = sum(delta(:));
    porc = ((total_de_1s - total_1s_resta)/total_de_1s)*100;

end