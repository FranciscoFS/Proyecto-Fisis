function V_seg = Rotar_3D(V_seg)

tam = size(V_seg.femur.bones,3);

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
% 

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


%Rotar
eje = 'Y';%respecto al eje largo del femur

V_seg.vol.orig = imrotate3_fast(V_seg.vol.orig,{b eje},metodo);
V_seg.vol.filt = imrotate3_fast(V_seg.vol.filt,{b eje},metodo);
V_seg.mascara = imrotate3_fast(V_seg.mascara,{b eje},metodo);
V_seg.femur.fisis = imrotate3_fast(V_seg.femur.fisis,{b eje},metodo);
V_seg.femur.bones = imrotate3_fast(V_seg.femur.bones,{b eje},metodo);
V_seg.info{7,2} = b;
%Rotar SliceThickness  (PixelSpacing se mantiene igual)

V_seg.info{2,1} = nuevo_SliceThickness;

disp('listo!')
end



