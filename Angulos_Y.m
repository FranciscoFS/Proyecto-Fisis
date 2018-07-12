function Angulos = Angulos_Y(V_seg)

    Angulos = [];
    
    Femur = V_seg.mascara == 1;
    
    tam = size(V_seg.mascara,3);
    dx = V_seg.info{1};
    dz = V_seg.info{2};
    [~,~,v1] = ind2sub(size(Femur),find(Femur > 0));
    Mid = round((max(v1)+min(v1))/2);
    
     z_atras = zeros(1,tam);

    for i=1:tam

        im = Femur(:,:,i);
        [~, col] = find(im);
        topcol1 = max(col);

        if isempty(topcol1) == 0
            
            z_atras(i) = topcol1;
            
        end

    end

    z1 = find(z_atras(1:Mid) == max(z_atras(1:Mid)),1,'last');
    z2 = find(z_atras(Mid+1:end) == max(z_atras(Mid+1:end)),1,'first') + Mid;

    y1 = z_atras(z1);
    y2 = z_atras(z2);
    
    %subplot(1,2,1); plot(z_atras,1:tam);title('Antes') 
    
    m = ((y2 -y1))/((z2 -z1));
    m2 = ((y2 -y1)*dx)/((z2 -z1)*dz);
    Theta_Y = atand(m);
    Theta_Y_2 = atand(m2);
    Angulos(1,1)= Theta_Y;
    Angulos(1,2) = Theta_Y_2;
    
end
    

    