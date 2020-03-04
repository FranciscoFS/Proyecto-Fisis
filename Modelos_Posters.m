% Graficar modelos Posters

    Taladro_femur = smooth3(Ajustar_angulos(Tal,Rodilla_testF.info{10}),'box',15);
%%
    p1= patch(isosurface(Modelos.fu),'FaceColor','none','EdgeColor','red','LineWidth',0.1,'EdgeAlpha','0.4');
    reducepatch(p1,0.01)
    p2= patch(isosurface(Modelos.hu),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
    reducepatch(p2,0.01)
    p3= patch(isosurface(Modelos.cilindroT, 0.25),'FaceColor','green','EdgeColor','none');
    isonormals(Modelos.cilindroT,p3)
    p6 = patch(isosurface(Modelos.Ff),'FaceColor','none','EdgeColor','red','LineWidth',0.1,'EdgeAlpha','0.4');
    reducepatch(p6,0.01)
    p4 = patch(isosurface(Modelos.Fh),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
    reducepatch(p4,0.01)
    p5= patch(isosurface(Taladro_femur, 0.25),'FaceColor','green','EdgeColor','none');
    isonormals(Taladro_femur,p5)

    axis off
    set(gcf,'color','white')
    daspect([1 1 1])
    l = camlight('headlight');
    lighting gouraud
    material dull
    view(90,0)

   title('Rodilla')
%%
    while true
        lighting gouraud
        camlight(l,'headlight')
        pause(0.05);  
    end