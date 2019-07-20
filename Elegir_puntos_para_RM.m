function V_seg = Elegir_puntos_para_RM(V_seg)

n_slide_actual = 1;

f = figure;
a = uicontrol;
a.String = 'Anterior';
a.Position = [20 10 60 20];
a.Callback = @Boton_a;

s = uicontrol;
s.String = 'Siguiente';
s.Position = [200 10 60 20];
s.Callback = @Boton_b;

    function Boton_a(~,~)
        n_slide_actual = n_slide_actual-1;
        if n_slide_actual <1
            n_slide_actual = 1;
        end
        imshow(V_seg.mascara(:,:,n_slide_actual),[])
    end
    function Boton_b(~,~)
        n_slide_actual = n_slide_actual+1;
        if n_slide_actual > size(V_seg.mascara,3)
            n_slide_actual = size(V_seg.mascara,3);
        end
        imshow(V_seg.mascara(:,:,n_slide_actual),[])
    end

imshow(V_seg.mascara(:,:,n_slide_actual),[])

%Asumiendo rotacion neutra
n = 0;
uiwait(msgbox('Desplazarse con los botones. Al encontrar la slice tocar una vez la pantalla y apretar alguna tecla'));
uiwait(msgbox('Orden de slice a buscar: 1° TT-TG: corte con troclea y cóndilos; 2° SIC-TAC: corte con surco intercondileo y cóndilos; 3° TT-PCL: corte con inserción LCP en Tibia; 4° TT: corte con punto más anterior de la tuberosidad de la tibia')); 
while n <4 
k = waitforbuttonpress;

%TT-TG
if n == 0 && k ==1
uiwait(msgbox('TT-TG: Dos puntos para los cóndilos, un tercero en la parte más baja de la troclea'));    
[x,y] = getpts();
slc1 = n_slide_actual;
n = 1;
k=0;
end

%SIC-TAC
if n == 1 && k ==1
uiwait(msgbox('SIC-TAC: Dos puntos para los condiolos, un tercero en la parte más anterior del surco intercondileo'));
[x4,y4] = getpts();
slc4 = n_slide_actual;
n = 2;
k=0;
end

%TT-PCL
if n == 2 && k ==1
uiwait(msgbox('TT-PCL: Dos puntos para las partes más posteriores de los platillos tibiales, un tercero en la parte media del LCP'));
[x3,y3] = getpts();
slc3 = n_slide_actual;
n = 3;
k=0;
end

%Tibia
if n == 3 && k ==1
uiwait(msgbox('TT: Un punto en el punto más anterior de la tuberosidad de la tibia'));
[x2,y2] = getpts();
slc2 = n_slide_actual;
n = 4;
k=0;
end

end
V_seg.info{10,1} = {x;y;x2;y2;x3;y3;x4;y4;slc1;slc2;slc3;slc4};
end