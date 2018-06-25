function porc = Cilindro_fx_final_fast(V_seg,alpha,beta)
    %Direccion y distancia

    coordenada = V_seg.info{9};
    coordenada([1 2]) = coordenada([2 1]);
    % 1 = Femur_hueso, 2 = Fisis_femur (indices de la mascara)
    
    % 1 = Femur_hueso, 2 = Fisis_femur (indices de la mascara)
    
   % fisis_usar = V_seg.femur.fisis;
    fisis_usar = V_seg.mascara == 2;
    % hueso_usar = V_seg.mascara == 1;
    
    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};

    a1 = beta;% azimut (+ hacia posterior)
    a2 = alpha;% elevacion (+ hacia distal)
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
    
%     f = figure;
%     hold on
%     fu= smooth3(fisis_usar, 'box', 3);
%     hu = smooth3(hueso_usar,'box', 3);
%     p1= patch(isosurface(fu),'FaceColor','red','EdgeColor','none');
%     p2= patch(isosurface(hu),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
%     p3= patch(isosurface(matriz_cilindro, 0.7),'FaceColor','green','EdgeColor','none');
%     reducepatch(p2,0.01)
%     ax = gca;
%     c = ax.DataAspectRatio;
%     ax.DataAspectRatio= [dz,dz,dx];
%     
%     axis tight
%     l = camlight('headlight');
%     lighting gouraud
%     material dull
%     title('Fisis')
    
    total_de_1s = sum(fisis_usar(:));
    delta = (fisis_usar - matriz_cilindro) == 1;
    total_1s_resta = sum(delta(:));
    porc = ((total_de_1s - total_1s_resta)/total_de_1s)*100;

 end

    %uiwait(msgbox({'Se ha perforado un ' num2str(porc) '% de la fisis'}));

