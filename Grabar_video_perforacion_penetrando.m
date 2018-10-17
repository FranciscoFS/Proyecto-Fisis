function Grabar_video_perforacion_penetrando(VideoName,tiempo,V_seg,angulo1,angulo2,p,d)%tiempo en segundos
    %hold on
    cortical = isosurf_todos(V_seg,[1 0 0 0 0]);
    %Aqui poner isosurf mejor calidad (pero yo creo que se ve bien como esta)pero que permita ver el cilindro
    
    axis off
    axis vis3d
    l = camlight('headlight');
    lighting gouraud
    material dull
    Box_size = 9;
    
    ax = gca;
    ax.NextPlot = 'replaceChildren';
    v = VideoWriter(VideoName);
    v.Quality = 100;
    open(v);

    frame_total = tiempo*24;%30 por los fps = 30
    az= 0;
    el = 0;
    view(280,-45)
    
    theta=1:(p/frame_total):p;

    for j = 1:frame_total
        Taladro = Crear_solo_cilindro_test(V_seg,cortical,angulo1,angulo2,d,theta(j));
        Taladro = smooth3(Taladro,'box',Box_size);
        p3= patch(isosurface(Taladro, 0.5),'FaceColor','green','EdgeColor','none');
        isonormals(Taladro,p3);
        camlight(l,'headlight')
        drawnow
        frame = getframe(gcf);
        writeVideo(v,frame);
        delete(p3)
        %az = az+1;
    end
    close(v)
end