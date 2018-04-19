%function V_nuevo = Rotar_3D(V_seg)

tam = size(V_seg.femur.fisis,3);

fila_atras1 = 0;
fila_atras2 = 0;

for i=1:tam
    i
    if i<tam/2
        %for a=1:size(V_seg.femur.fisis,1)
        im = V_seg.femur.bones(:,:,i);
        [~, col] = find(im);
        topcol1 = max(col)
        if topcol1 > fila_atras1
            fila_atras1 = topcol1;
            n_im1 = i;
        end
        %end
    else
        im = V_seg.femur.bones(:,:,i);
        [~, col] = find(im);
        topcol2 = max(col)
        if topcol2 > fila_atras2
            fila_atras2 = topcol2;
            n_im2 = i;
        end
    end
end
subplot(2,1,1)
imshow(V_seg.femur.bones(:,:,n_im1))
subplot(2,1,2)
imshow(V_seg.femur.bones(:,:,n_im2))
