
    isosurf_fast(V_seg)
    pixeles_ya_sumados = Crear_solo_cilindro2(V_seg,0,0,30,3);
    p3= patch(isosurface(pixeles_ya_sumados),'FaceColor','green','EdgeColor','black');
