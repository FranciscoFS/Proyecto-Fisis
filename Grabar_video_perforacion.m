function Grabar_video_perforacion(tiempo,V_seg)%tiempo en segundos
    %Direccion y distancia

    coordenada = V_seg.info{9};
    
    % 1 = Femur_hueso, 2 = Fisis_femur (indices de la mascara)
    
   % fisis_usar = V_seg.femur.fisis;
    fisis_usar = V_seg.mascara == 2;
    hueso_usar = V_seg.mascara == 1;

    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};
    
    f = figure;
    hold on
    fu= smooth3(fisis_usar, 'box', 9);
    hu = smooth3(hueso_usar,'box', 9);
    p1= patch(isosurface(fu),'FaceColor','red','EdgeColor','none');
    p2= patch(isosurface(hu),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
    reducepatch(p2,0.01)
    ax = gca;
    c = ax.DataAspectRatio;
    ax.DataAspectRatio= [dz,dz,dx];
    
    axis off
    axis tight
    l = camlight('headlight');
    lighting gouraud
    material dull
    title('Fisis')

    ax = gca;
    ax.NextPlot = 'replaceChildren';
    v = VideoWriter('Perforacion_girando_2');
    v.Quality = 100;
    open(v);

    frame_total = tiempo*30;%30 por los fps = 30
    az= -90;
    el = 0;

    view(az,el)

theta = -3/4:2/frame_total:3/4;
a = (asind(theta));

for j = 1:frame_total
        matriz_cilindro= Crear_solo_cilindro2(V_seg,a(j),0);
        %view(az,el)
        p3= patch(isosurface(matriz_cilindro, 0.7),'FaceColor','green','EdgeColor','none');
        camlight(l,'headlight')
        drawnow
        frame = getframe(gcf);
        writeVideo(v,frame);
        delete(p3)
        %az = az+1;
    end
    close(v)
end