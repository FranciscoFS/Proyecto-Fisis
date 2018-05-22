function V_out = Rotar_3D(V_seg)

    %Enderezar en Z podemos obtener el angulo con regionprops3
    
    V_seg.mascara = (V_seg.mascara < 8).*(V_seg.mascara);
%   Angulos = regionprops3(V_seg.femur.bones,'Orientation');
    Theta_Z = Angulo_Z(V_seg);
    eje_Z = 'Z';
    V_out = Rotar(V_seg,Theta_Z, eje_Z);
    V_out.info{8} = Theta_Z;
%   V_out.Angulos = Angulos;
    
    tam = size(V_out.femur.bones,3);
    dx = V_out.info{1};
    dz = V_out.info{2};
    [~,~,v1] = ind2sub(size(V_out.femur.bones),find(V_out.femur.bones > 0));
    Mid = round((max(v1)+min(v1))/2);
   
    % Mi forma para endezar en Y

    z_atras = zeros(1,tam);

    for i=1:tam

        im = V_out.femur.bones(:,:,i);
        [~, col] = find(im);
        topcol1 = max(col);

        if isempty(topcol1) == 0
            
            z_atras(i) = topcol1;
            
        end

    end

    z1 = find(z_atras(1:Mid) == max(z_atras(1:Mid)),1,'last');
    z2 = find(z_atras(Mid+1:end) == max(z_atras(Mid+1:end)),1,'first') + Mid;

    y1 = z_atras(z1);
    y2 = z_atras(z2); plot(z_atras,1:tam);
    
    m = ((y2 -y1)*dx)/((z2 -z1)*dz);
    Theta_Y = atand(m);
    V_out.info{7} = Theta_Y;
    
    % Respecto al eje largo del femur
    
    eje_Y = 'Y';
    V_out = Rotar(V_out,Theta_Y,eje_Y);
    
end



