function V_out = Rotar_3D(V_seg)

    %Enderezar en Z podemos obtener el angulo con regionprops3
    
%   Angulos = regionprops3(V_seg.femur.bones,'Orientation');
    Theta_Z = Angulo_Z(V_seg);
    eje_Z = 'Z';
    %eje_Z = [0 0 1];
    V_out = Rotar(V_seg,Theta_Z, eje_Z);
    V_out.info{8} = Theta_Z;
%   V_out.Angulos = Angulos;
    
    tam = size(V_out.femur.bones,3);
    dx = V_out.info{1};
    dz = V_out.info{2};
    [~,~,v1] = ind2sub(size(V_out.femur.bones),find(V_out.femur.bones > 0));
    Mid = round((max(v1)+min(v1))/2);
   
%Endezar en Y
    
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
    y2 = z_atras(z2);
    
    %subplot(1,2,1); plot(z_atras,1:tam);title('Antes') 
    
    m = ((y2 -y1))/((z2 -z1)); %angulo a girar en datos para que quede alineado
    m2 = ((y2 -y1)*dx)/((z2 -z1)*dz); %angulo en mundo real
    Theta_Y = atand(m);
    Theta_Y_2 = atand(m2);
    V_out.info{7,1} = Theta_Y;
    V_out.info{7,2} = Theta_Y_2;
    
    % Respecto al eje largo del femur
    
    eje_Y = 'Y';
    %eje_Y = [0 1 0];
    V_out = Rotar(V_out,Theta_Y,eje_Y);

%Girar en x    

        z_abajo = zeros(1,tam);

    for i=1:tam

        im = V_seg.femur.bones(:,:,i);
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
    V_out.info{9,1} = Theta_X;
    V_out.info{9,2} = Theta_X_2;
    
    % Respecto al eje largo del femur
    
    eje_X = 'X';
    %eje_Y = [0 1 0];
    V_out = Rotar(V_out,Theta_X,eje_X);






%     
%     tam_after = size(V_out.femur.bones,3);
%     z_atras_after = zeros(1,tam_after);
% 
%     for i=1:tam_after
% 
%         im = V_out.femur.bones(:,:,i);
%         [~, col] = find(im);
%         topcol1 = max(col);
% 
%         if isempty(topcol1) == 0
%             
%             z_atras_after(i) = topcol1;
%             
%         end
% 
%     end
%     
%     %[x_atras,tam] = comprobar_condilos(V_seg);
%     subplot(1,2,2); plot(z_atras_after,1:tam_after);title('Despues') 
%     
end



