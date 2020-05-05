function V_seg = Elegir_puntos_xyz(V_seg)

n_slide_actual = 1;

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

    function Boton_a(~,~)
        n_slide_actual = n_slide_actual-1;
        if n_slide_actual <1
            n_slide_actual = 1;
        end
        imshow(V_seg.vol.orig(:,:,n_slide_actual),[])
    end
    function Boton_b(~,~)
        n_slide_actual = n_slide_actual+1;
        if n_slide_actual > size(V_seg.vol.orig,3)
            n_slide_actual = size(V_seg.vol.orig,3);
        end
        imshow(V_seg.vol.orig(:,:,n_slide_actual),[])
    end

imshow(V_seg.vol.orig(:,:,n_slide_actual),[])

%Asumiendo rotacion neutra
n = 0;
uiwait(msgbox('Desplazarse con los botones. Al encontrar la slice tocar una vez la pantalla y apretar alguna tecla'));
uiwait(msgbox('Elegir slice con "most proximal section with complete cartilaginous trochlea" y en la medición considerar: "Measurements were performed from the cartilaginous surfaces"')); 
while n <1 
k = waitforbuttonpress;

%xyz
if n == 0 && k ==1
uiwait(msgbox('Primero 2 puntos para la linea de los condilos; luego los puntos: "x(lateral)" "y(medial)" "z(centro)" en troclea, INCLUYENDO cartílago'));    
[x,y] = getpts();
slc1 = n_slide_actual;
n = 1;
k=0;
end

end
V_seg.info{10,1} = {x;y;slc1};
end