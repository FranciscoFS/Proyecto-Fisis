function V_out = Rotar_3D(V_seg)


    V_out = Rotar_Z(V_seg);
    %V_out = V_seg;
    
    tam = size(V_out.femur.bones,3);
    [~,~,v1] = ind2sub(size(V_out.femur.bones),find(V_out.femur.bones > 0));
    Mid = round((max(v1)+min(v1))/2);
    
    %Esta comentado el giro en el eje largo porque ser�a redundante con
    %sthephen

    % %Giro 1: Eje largo
    % 
    % imshow(V_seg.femur.bones(:,:,Aproximar(tam/2)))
    % uiwait(msgbox('Ingrese dos puntos para el primer circulo, con el ultimo haga doble click'));
    % [Y1,X1] = getpts();
    % uiwait(msgbox('Ingrese dos puntos para el segundo circulo, con el ultimo haga doble click'));
    % [Y2,X2] = getpts();
    % %Punto medio
    % centro1 = [(X1(1)+X1(2))/2,(Y1(1)+Y1(2))/2];
    % centro2 = [(X2(1)+X2(2))/2,(Y2(1)+Y2(2))/2];
    % x = [centro1(1),centro2(1)];
    % y = [centro1(2),centro2(2)];
    % 
    % %syms p
    % m1 = (y(2)-y(1))/(x(2)-x(1));
    % 
    % %a = 0;
    % a = atand(m1)
    % 
    % metodo = 'linear';
    % eje = 'Z'; %Respecto a los condilos
    % V_seg.vol.orig = imrotate3_fast(V_seg.vol.orig,{-a eje},metodo);
    % V_seg.vol.filt = imrotate3_fast(V_seg.vol.filt,{-a eje},metodo);
    % V_seg.mascara = imrotate3_fast(V_seg.mascara,{-a eje},metodo);
    % V_seg.femur.fisis = imrotate3_fast(V_seg.femur.fisis,{-a eje},metodo);
    % V_seg.femur.bones = imrotate3_fast(V_seg.femur.bones,{-a eje},metodo);
    
    

    % Giro 2: los condilos

    fila_atras1 = 0;
    fila_atras2 = 0;
    x_atras = [];
    
    for i=1:tam
        if i< Mid
            im = V_out.femur.bones(:,:,i);
            [~, col] = find(im);
            topcol1 = max(col);
            if isempty(topcol1)
                x_atras(i) = 0;
            else
                x_atras(i) = topcol1;
            end
            if topcol1 > fila_atras1
                fila_atras1 = topcol1;
                n_im1 = i;
                coord1 = [n_im1,fila_atras1];
            end
            
        else
            im = V_out.femur.bones(:,:,i);
            [~, col] = find(im);
            topcol2 = max(col);
            if isempty(topcol2)
                x_atras(i) = 0;
            else
                x_atras(i) = topcol2;
            end
            if topcol2 > fila_atras2
                fila_atras2 = topcol2;
                n_im2 = i;
                coord2 = [n_im2,fila_atras2];
            end
        end
    end

    plot(x_atras,1:tam)

    m2 = (coord2(2)-coord1(2))/(coord2(1)-coord1(1));


    b = atand(m2);
    c= 90-b;

    %plot(x_atras,1:tam)

    dif_n = n_im2-n_im1;
    dif_fila = fila_atras2-fila_atras1;

    if dif_fila == 0
        disp('Ya alineado!')
    end


    %Rotar deje metodo libre para que usara el default
    %respecto al eje largo del femur
    
    eje = 'Y';
    
    V_out.vol.orig = imrotate3_fast(V_out.vol.orig,{b eje});
    V_out.vol.filt = imrotate3_fast(V_out.vol.filt,{b eje});
    V_out.mascara = imrotate3_fast(V_out.mascara,{b eje});
    V_out.femur.fisis = imrotate3_fast(V_out.femur.fisis,{b eje});
    V_out.femur.bones = imrotate3_fast(V_out.femur.bones,{b eje});

    V_out.info{7} = b;
    %Rotar SliceThickness  (PixelSpacing se mantiene igual)
    %V_seg.info{2,1} = nuevo_SliceThickness;

    disp('listo!')

end



