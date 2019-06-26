function V_seg = TT_TG_y_TT_PCL_elegir_puntos(V_seg)

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
while n <3 
k = waitforbuttonpress;

if n == 0 && k ==1
uiwait(msgbox('Dos puntos para los condiolos, un tercero en la parte m�s baja de la troclea'));    
[x,y] = getpts();
slc1 = n_slide_actual;
n = 1;
k=0;
end

if n == 1 && k ==1
uiwait(msgbox('Dos puntos para las partes m�s posteriores de los platillos tibiales, un tercero en la parte media del LCP'));
%Tibia
[x3,y3] = getpts();
slc3 = n_slide_actual;
n = 2;
k=0;
end

if n == 2 && k ==1
uiwait(msgbox('Un punto en el punto m�s anterior de la tibia'));
%Tibia
[x2,y2] = getpts();
slc2 = n_slide_actual;
n = 3;
k=0;
end

end
V_seg.info{10,1} = {x;y;x2;y2;x3;y3;slc1;slc2;slc3};
end