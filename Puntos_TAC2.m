function V_seg = Puntos_TAC2(V_seg)

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
uiwait(msgbox('Script para encontrar recta entre platillos Tibiales Posteriores')); 

while n <1
k = waitforbuttonpress;

% Puntos Platillos Tibial Posterior
    if n == 0 && k ==1
        uiwait(msgbox('Dos puntos para linea posterior tibia'));    
        [x,y] = getpts();
        slc1 = n_slide_actual;
        n = 1;
        k=0;
    end

end
V_seg.info{12,1} = {x;y};
close(f)
end