function Grabar_video_perforacion(tiempo,V_seg,angulo1,angulo2,p,d)%tiempo en segundos
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
    v = VideoWriter('Perforacion_girando');
    v.Quality = 100;
    open(v);

    frame_total = tiempo*30;%30 por los fps = 30
    az= 20;
    el = -60;

    view(az,el)
    
    angulo1 = sind(angulo1);    
    theta = -angulo1:angulo1*(2/frame_total):angulo1;
    a = (asind(theta));
    
    angulo2 = sind(angulo2);    
    theta = -angulo2:angulo2*(2/frame_total):angulo2;
    b = (asind(theta));

for j = 1:frame_total
        pixeles_ya_sumados = Crear_solo_cilindro2(V_seg,a(j),0,p,d);
        %view(az,el)
        p3= patch(isosurface(pixeles_ya_sumados, 0.7),'FaceColor','green','EdgeColor','none');
        camlight(l,'headlight')
        drawnow
        frame = getframe(gcf);
        writeVideo(v,frame);
        delete(p3)
        %az = az+1;
    end
    close(v)
end