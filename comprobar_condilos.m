function [x_atras,tam] = comprobar_condilos(V_seg)

%V_seg.femur.bones = a;

tam = size(V_seg.femur.bones,3);

% Giro 2: los condilos
fila_atras1 = 0;
fila_atras2 = 0;
x_atras = [];
for i=1:tam
    if i<tam/2
        im = V_seg.femur.bones(:,:,i);
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
        %end
    else
        im = V_seg.femur.bones(:,:,i);
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
end