function [V_seg] = Elegir_puntos_BPD(V_seg)
%V_seg_1 seria el volumen axial, que incluye los datos y posiciones de XYZ
% info = V_seg_1.info{10,1};
% x = info{1,1};
% y = info{2,1};

tam_sag = size(V_seg.vol.orig,3);

% info2 = V_seg_1.info{11,1};
% tam_axial = info2(5,1);

%slc_z = Aproximar((x(5)*tam_sag)/tam_axial(1,1));
slice_midsagittal = Aproximar(tam_sag/2);

n_slide_actual = slice_midsagittal;

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

n = 0;
uiwait(msgbox('Desplazarse con los botones. Al encontrar la slice tocar una vez la pantalla y apretar alguna tecla'));
uiwait(msgbox('Elegir slice que se vea el LCA y que el BUMP de la troclea es más prominente (secuencia parte al tiro desde la mitad, suele calzar)')); 
while n <1 
k = waitforbuttonpress;

%BPD
if n == 0 && k ==1
uiwait(msgbox('Dos puntos para linea de cortical anterior (poner PRIMER punto donde llegue fisis a cortical); luego 1 punto en el punto más anterior con CARTILAGO, luego 1 punto en el punto más anterior con HUESO; DOS puntos para la tibia'));    
[x,y] = getpts();
slc_con_LCA = n_slide_actual;
n = 1;
k=0;
end

end


%V_seg_1.info{14,1} = {x;y;slc_con_LCA};
V_seg.info{14,1} = {x;y;slc_con_LCA};
end