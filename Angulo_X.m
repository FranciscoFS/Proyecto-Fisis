function Angulos = Angulo_X(V_seg)

    Angulos = [];
    
    Femur = V_seg.mascara == 1;

    tam = size(Femur,3);
    dx = V_seg.info{1};
    dz = V_seg.info{2};
    [~,~,v1] = ind2sub(size(Femur),find(Femur > 0));
    Mid = round((max(v1)+min(v1))/2);
    z_abajo = zeros(1,tam);

    for i=1:tam

        im = Femur(:,:,i);
        [row, ~] = find(im);
        toprow1 = max(row);

        if isempty(toprow1) == 0
            
            z_abajo(i) = toprow1;
            
        end

    end

    z1 = find(z_abajo(1:Mid) == max(z_abajo(1:Mid)),1,'last');
    z2 = find(z_abajo(Mid+1:end) == max(z_abajo(Mid+1:end)),1,'first') + Mid;

    y1 = z_abajo(z1);
    y2 = z_abajo(z2);
    
    %subplot(1,2,1); plot(z_atras,1:tam);title('Antes') 

    m = ((y2 -y1))/((z2 -z1)); %angulo a girar en datos para que quede alineado
    m2 = ((y2 -y1)*dx)/((z2 -z1)*dz); %angulo en mundo real
    Theta_X = atand(m);
    Theta_X_2 = atand(m2);
    Angulos(1,1)= Theta_X;
    Angulos(1,2) = Theta_X_2;
    
end






