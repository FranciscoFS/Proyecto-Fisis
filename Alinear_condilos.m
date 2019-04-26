function V_seg = Alinear_condilos(V_seg)

tam = size(V_seg.femur.bones,3);
dx = V_seg.info{1};
dz = V_seg.info{2};

% Giro 2: los condilos
fila_atras1 = 0;
fila_atras2 = 0;
x_atras = zeros(1,tam);
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

subplot(1,2,1); plot(x_atras,1:tam);title('Antes')

m = (coord2(2)-coord1(2))/(coord2(1)-coord1(1));%angulo a girar en datos para que quede alineado
m2= ((coord2(2)-coord1(2))*dx)/((coord2(1)-coord1(1))*dz);%angulo en mundo real

Theta_Y = atand(m);
Theta_Y_2 = atand(m2);

%plot(x_atras,1:tam)
dif_n = n_im2-n_im1;
dif_fila = fila_atras2-fila_atras1;

if abs(dif_fila) <= 1
    disp('Ya alineado!')
end

b = Theta_Y;

%Rotar
eje = 'Y';%respecto al eje largo del femur
V_seg.vol.orig = imrotate3_fast(V_seg.vol.orig,{b eje});
V_seg.vol.filt = imrotate3_fast(V_seg.vol.filt,{b eje});
V_seg.mascara = imrotate3_fast(V_seg.mascara,{b eje});
V_seg.femur.fisis = imrotate3_fast(V_seg.femur.fisis,{b eje});
V_seg.femur.bones = imrotate3_fast(V_seg.femur.bones,{b eje});
V_seg.info{7,2} = b;
%Rotar SliceThickness  (PixelSpacing se mantiene igual)

[x_atras,tam] = comprobar_condilos(V_seg);
subplot(1,2,2); plot(x_atras,1:tam);title('Despues')
disp('listo!')
end



