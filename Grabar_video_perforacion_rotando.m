function Grabar_video_perforacion_rotando(tiempo,V_seg,angulo1,angulo2,p,d)%tiempo en segundos
    hold on
    isosurf_fast(V_seg)
    %Aqui poner isosurf mejor calidad (pero yo creo que se ve bien como esta)pero que permita ver el cilindro
    
    axis off
    axis vis3d
    l = camlight('headlight');
    lighting gouraud
    material dull


    ax = gca;
    ax.NextPlot = 'replaceChildren';
    v = VideoWriter('Grabar_video_perforacion_rotando');
    v.Quality = 100;
    open(v);

    frame_total = tiempo*30;%30 por los fps = 30
    az= 8;
    el = -70;

    theta=0:(360/frame_total):360;
    view(0,-70)

for j = 1:frame_total
        pixeles_ya_sumados = Crear_solo_cilindro3(V_seg,angulo1,angulo2,p,d);
        view(theta(j),el)
        p3= patch(isosurface(pixeles_ya_sumados, 0.7),'FaceColor','green','EdgeColor','none');
        camlight(l,'headlight')
        drawnow
        frame = getframe(gcf);
        writeVideo(v,frame);
        delete(p3)
    end
    close(v)
end