function V_seg = Elegir_puntos_para_TAC(V_seg)

f = figure('units','normalized','outerposition',[0 0 1 1]);
maximize(f)
a = uicontrol;
a.String = 'Anterior';
a.Position = [20 10 60 20];
a.Callback = @Boton_a;

s = uicontrol;
s.String = 'Siguiente';
s.Position = [200 10 60 20];
s.Callback = @Boton_b;

slider = uicontrol('Style','slider','Min',1,'Max',size(V_seg.Vol,3),'SliderStep',[1/(size(V_seg.Vol,3) - 1)...
    5/(size(V_seg.Vol,3) - 1)]);
slider.String = 'Corte';
slider.Position = [500 10 300 20];
slider.Callback = @Slider;
slider.Value = 10;
n_slide_actual = round(get(slider,'value'));

    function Boton_a(~,~)
        n_slide_actual = n_slide_actual-1;
        if n_slide_actual <1
            n_slide_actual = 1;
        end
        imshow(V_seg.Vol(:,:,n_slide_actual),[])
    end
    function Boton_b(~,~)
        n_slide_actual = n_slide_actual+1;
        if n_slide_actual > size(V_seg.Vol,3)
            n_slide_actual = size(V_seg.Vol,3);
        end
        imshow(V_seg.Vol(:,:,n_slide_actual),[])
    end

    function Slider(~,~)
        n_slide_actual = round(get(slider,'value'));
        imshow(V_seg.Vol(:,:,n_slide_actual),[])
    end

imshow(V_seg.Vol(:,:,n_slide_actual),[])

%Asumiendo rotacion neutra
n = 0;
uiwait(msgbox('Desplazarse con los botones. Al encontrar la slice tocar una vez la pantalla y apretar alguna tecla'));
uiwait(msgbox('Orden de slice a buscar: 1° TT-TG: corte con troclea y cóndilos; 2° SIC-TAC: corte con surco intercondileo y cóndilos; 3° TT: corte con punto más anterior de la tuberosidad de la tibia')); 
while n <3 
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
uiwait(msgbox('SIC-TAC: Dos puntos para los cóndilos, un tercero en la parte más anterior del surco intercondileo'));
[x3,y3] = getpts();
slc3 = n_slide_actual;
n = 2;
k=0;
end

%Tibia
if n == 2 && k ==1
uiwait(msgbox('TT: Un punto en el punto más anterior de la tuberosidad de la tibia'));
[x2,y2] = getpts();
slc2 = n_slide_actual;
n = 3;
k=0;
end

end
V_seg.info{10,1} = {x;y;x2;y2;x3;y3;slc1;slc2;slc3};
close(f)
end