function [porc] = Cilindro_fx_final_LCA_Femur(hueso_usar,fisis_usar,V_seg,alpha,gamma,d,p,ver,medio)
%Direccion y distancia

    if medio

        coordenada = V_seg.info{12}/2;

        dz = V_seg.info{2,1};
        dx = V_seg.info{1,1}*2;
        pace = dx/dz;
        
    else
        
        coordenada = V_seg.info{12};

        dz = V_seg.info{2,1};   
        dx = V_seg.info{1,1};
        pace = dx/dz;
        
    end
    
    %[m,n,k] = size((V_seg.mascara == 1));
    %[Xq,Yq,Zq] = meshgrid(single(1:m),single(1:n),single(1:pace:k));
    %hueso_usar = interp3(single(V_seg.mascara == 1),Xq,Yq,Zq,'nearest');
    %fisis_usar = interp3(single(V_seg.mascara == 2),Xq,Yq,Zq,'nearest');
    
    [~,~,v1] = ind2sub(size(hueso_usar),find(hueso_usar > 0));
    Mid = round((max(v1)+min(v1))/2);
    vol = hueso_usar(1:size(hueso_usar,1),1:size(hueso_usar,1),Mid: size(hueso_usar,3));
    
    encontrado = 0;
    contador = 1;
    while (contador <= size(vol,3) && encontrado ==0)
        if vol(Aproximar(coordenada(2)),Aproximar(coordenada(1)),contador)>0
            coord_3D = [Aproximar(coordenada(1)),Aproximar(coordenada(2)),Mid + contador-pace];
            encontrado =1;
            
        end
        contador = contador+1;
    end

    coordenada = coord_3D;
    
    % 1 = Femur_hueso, 2 = Fisis_femur (indices de la mascara)
    % Restar 1 a la coordenada Z de los puntos LCA Femur

    % fisis_usar = V_seg.femur.fisis;

    a1 = -gamma;% azimut (+ hacia proximal) 
    a2 = -alpha;% Elevacion (+ hacia anterior)
    mm = p;%Profundidad
    diametro = d;

    [z,x,y] = sph2cart(deg2rad(a1),deg2rad(a2),mm);

    %dif_x
    pixeles_x = x/dx;

    %dif_y
    pixeles_y = y/dx;

    %dif_z
    pixeles_z = z/dx;


    % Dejar "(Y,X,Z)" si desde Stephen llega x,y,z CONFIRMADO NO CAMBIAR
    P1 = [coordenada(2),coordenada(1),coordenada(3)];
    P2 = [P1(1)+pixeles_y, P1(2) + pixeles_x, P1(3) + pixeles_z];
    P2 = Aproximar(P2);

    [X, Y, Z] = bresenham_line3d(P1, P2);

    % Cilindro
    radio = diametro/2;
    radio_pix = Aproximar(radio/dx);

    pixeles_ya_sumados = zeros(size(hueso_usar));

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
    
    if ver

        %pace = (dx/dz);
        %[m,n,k] = size((V_seg.mascara == 1));
        %[Xq,Yq,Zq] = meshgrid(1:n,1:m,1:pace:k);
        Box_size = 15;
        
        
%         hold on
%         fu = imrotate3_fast(smooth3(interp3(single(V_seg.mascara == 2),Xq,Yq,Zq,'cubic')...
%             ,'box',Box_size),{90,'X'});
%         hu = imrotate3_fast(smooth3(interp3(single(V_seg.mascara == 1),Xq,Yq,Zq,'cubic')...
%             ,'box',Box_size),{90,'X'});
        %taladro = imrotate3_fast(smooth3(single(pixeles_ya_sumados.*(hueso_usar + fisis_usar)),...
         %   'box',9),{90,'X'});
         
        hold on
        fu = smooth3(fisis_usar...
            ,'box',Box_size);
        hu = smooth3(hueso_usar...
            ,'box',Box_size);
        %taladro = smooth3(single(pixeles_ya_sumados,...
         %   'box',9);
        
        p1= patch(isosurface(fu),'FaceColor','none','EdgeColor','red');
        p2= patch(isosurface(hu),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
        reducepatch(p2,0.01)
        p3= patch(isosurface(pixeles_ya_sumados, 0.25),'FaceColor','green','EdgeColor','none');
        %Cylinder([P1(2) P1(1) P1(3)],[P2(2) P2(1) P2(3)],radio_pix,22,'b',1,0)
        
        %scatter3(P1(2),P1(1),P1(3),'red','filled'); 
        %scatter3(P2(2),P2(1),P2(3),'yellow');
        
    
        axis off
        l = camlight('headlight');
        daspect([1 1 1])
        lighting gouraud
        material dull
        title('Fisis')
        view(0,0)
        
        title('Rodilla')

        while true
            camlight(l,'headlight')
            pause(0.05);  
        end

    end
     
    fisis_usar = fisis_usar > 0.5;
    total_de_1s = sum(fisis_usar(:));
    delta = (fisis_usar - pixeles_ya_sumados) == 1;
    total_1s_resta = sum(delta(:));
    porc = ((total_de_1s - total_1s_resta)/total_de_1s)*100;
    %Tal = single(pixeles_ya_sumados.*(hueso_usar + fisis_usar));
    
end
    
