function Grabar_video_rotando(tiempo,V_seg)%tiempo en segundos
    coordenada = V_seg.info{8};

    hold on
    isosurf_fast(V_seg)
        scatter3(coordenada(2),coordenada(1),coordenada(3),300,...
        'MarkerEdgeColor','k',...
            'MarkerFaceColor',[0 1 0]);
        
    hold on
    pixeles_ya_sumados=Crear_segmento_esfera(V_seg,[-20,20],[-20,20],45);     
    Box_size = 3;
    Cono = smooth3(pixeles_ya_sumados,'box',Box_size);
    p3= patch(isosurface(Cono),'FaceColor','green','EdgeColor','none');
    %p3= patch(isosurface(pixeles_ya_sumados),'FaceColor','green','EdgeColor','none');    
    
    %Aqui poner isosurf mejor calidad (pero yo creo que se ve bien como esta)pero que permita ver el cilindro
    
    axis off
    axis vis3d
    l = camlight('headlight');
    lighting gouraud
    material dull


    ax = gca;
    ax.NextPlot = 'replaceChildren';
    v = VideoWriter('Grabar_video');
    v.Quality = 100;
    open(v);

    frame_total = tiempo*30;%30 por los fps = 30
    az= 8;
    el = -70;

    theta=0:(360/frame_total):360;
    view(0,-70)

for j = 1:frame_total
        view(theta(j),el)
        camlight(l,'headlight')
        drawnow
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
    close(v)
end