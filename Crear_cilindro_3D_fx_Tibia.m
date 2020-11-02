function [porc,pixeles_ya_sumados] = Crear_cilindro_3D_fx_Tibia(hueso_usar,fisis_usar,V_seg,delta,beta,d,p,ver)
%Direccion y distancia

    coordenada = V_seg.info{11}; 
    coordenada = [coordenada(1) coordenada(2) coordenada(3)];
    dx = single(V_seg.info{1,1});

    a1 = -beta;% azimut (
    a2 = -delta;% Elevacion 
    mm = p;%Profundidad
    diametro = d;

    [z,x,y] = sph2cart(deg2rad(a1),deg2rad(a2),mm);

    %dif_x
    pixeles_x = single(x/dx);

    %dif_y
    pixeles_y = single(y/dx);

    %dif_z
    pixeles_z = single(z/dx);


    %Crear el círculo
    % vector_normal = [];
    % vector_normal(1) = sind(-gamma);
    % vector_normal(2) = sind(-alpha)*cosd(-gamma);
    % vector_normal(3) = cosd(-alpha)*cosd(-gamma);

    vector_normal = [single(x),single(y),single(z)];

    %X sería ant-post
    %Y sería distal-prox
    %Z sería medial-lat

    radio = diametro/2;
    radio_pix = round(radio/dx);

    %%

    pixeles_ya_sumados = single(zeros(size(hueso_usar)));
    [maxX,maxY,maxZ] = size(hueso_usar);

    fisis_usar = fisis_usar > 0.5;
    total_de_1s = sum(fisis_usar(:));
    contador = 1;
    porc = zeros(1,length(radio));
    se = strel('cube',2);



    for r = 1:radio_pix(end)
        puntos = plotCircle3D([coordenada(1),coordenada(2),coordenada(3)],vector_normal,r); % falta saber si es 3,2,1 o 3,1,2
        
        P1 = [];
        P2 = [];
        
        for i  = 1:size(puntos,2)

            P1(i,:) = [puntos(2,i),puntos(1,i),puntos(3,i)];
            P2(i,:) = [puntos(2,i)+pixeles_y, puntos(1,i) + pixeles_x, puntos(3,i) + pixeles_z];
            P2(i,:) = round(P2(i,:));

            [X, Y, Z] = bresenham_line3d(P1(i,:), P2(i,:));
            Pos = find((round(X) <=  maxX) & (round(Y) <= maxY) & (round(Z) <= maxZ) &...
                (round(X) > 0) & (round(Y) > 0) & (round(Z) > 0) == 1);

            for j  = Pos
                pixeles_ya_sumados(round(X(j)),round(Y(j)),round(Z(j))) = 1;
            end

        end

        if r ==radio_pix(contador)

            pixeles_ya_sumados = imclose(pixeles_ya_sumados,se);
            pixeles_ya_sumados = pixeles_ya_sumados > 0;

            delta = (fisis_usar - pixeles_ya_sumados) == 1;
            total_1s_resta = sum(delta(:));
            porc(contador) = ((total_de_1s - total_1s_resta)/total_de_1s)*100;
            contador = contador +1;

    %         figure
    %         imshow(pixeles_ya_sumados(:,:,coordenada(3)+20))

        end

    end

if ver
    
    figure
    
    Fisis = smooth3(flip(single(fisis_usar),3),'box',9);
    Hueso = smooth3(flip(single(hueso_usar),3),'box',9);
    Taladro = smooth3(flip(single(pixeles_ya_sumados),3),'box',9);

    p1 = patch(isosurface(Fisis),'FaceColor','red','EdgeColor','none');
    isonormals(Fisis,p1)
    p2 = patch(isosurface(Hueso),'FaceColor','none','EdgeColor','black','LineWidth',0.1,'EdgeAlpha','0.4');
    reducepatch(p2,0.01)
    
    p3 = patch(isosurface(Taladro, 0.7),'FaceColor','green','EdgeColor','none');
    isonormals(Taladro,p3)
    
    axis off
    set(gcf,'color','white')
    l = camlight('headlight');
    lighting gouraud
    material dull
    axis equal

    while true
        camlight(l,'headlight')
        pause(0.05);  
    end
    
end


end

