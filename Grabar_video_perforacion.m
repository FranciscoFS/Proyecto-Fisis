function Grabar_video_perforacion(tiempo,V_seg,angulo)%tiempo en segundos
    hold on
    isosurf_fast(V_seg)
    
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
angulo = sind(angulo);    
theta = -angulo:angulo*(2/frame_total):angulo;
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