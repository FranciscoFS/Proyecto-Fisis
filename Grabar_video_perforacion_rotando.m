function Grabar_video_perforacion_rotando(V_seg,data,tiempo,Name)%tiempo en segundos
    %hold on
    %,V_seg,angulo1,angulo2,p,d
    %isosurf_todos(V_seg,[1 0 0 0 1 1],data);
    %Aqui poner isosurf mejor calidad (pero yo creo que se ve bien como esta)pero que permita ver el cilindro
    %V_seg.mascara = imrotate3_fast(V_seg.mascara,{90 'X'});
    %Pto = V_seg.info{8};
    %V_seg.info{8} = [Pto(3) Pto(1) Pto(2)];
    
    axis off
    axis vis3d
    l = camlight('headlight');
    lighting gouraud
    material dull


    ax = gca;
    ax.NextPlot = 'replaceChildren';
    v = VideoWriter(Name);
    v.Quality = 100;
    open(v);

    frame_total = tiempo*30;%30 por los fps = 30
    az_o= 45;
    el_o = 45;
    Angulos_total =45;


    theta = az_o:(-1*(((Angulos_total)*2)/frame_total)):(az_o - Angulos_total);
    theta_2 = (az_o- Angulos_total)+1:(((90)*2)/frame_total):90;
    omega = el_o:(((Angulos_total)*2)/frame_total):(el_o + Angulos_total);
    view(az_o,el_o)
    theta = [theta theta_2];
    omega = [omega repmat(90,size(omega))];
    
    for j = 1:frame_total
        %pixeles_ya_sumados = Crear_solo_cilindro3(V_seg,angulo1,angulo2,p,d);
        view(theta(j),omega(j))
        %p3= patch(isosurface(pixeles_ya_sumados, 0.7),'FaceColor','green','EdgeColor','none');
        camlight(l,'headlight')
        drawnow
        frame = getframe(gcf);
        writeVideo(v,frame);
        %delete(p3)
    end
  close(v)
end