function pixeles_ya_sumados = Crear_segmento_esfera(V_seg,rango_ang_1,rango_ang_2,mm)
fisis_usar = V_seg.mascara == 2;
pixeles_ya_sumados = zeros(size(fisis_usar));

coordenada = V_seg.info{8};
dz = V_seg.info{2,1};
dx = V_seg.info{1,1};

%Rango de angulos
for i= rango_ang_1(1,1):rango_ang_1(1,2)
    
for n = rango_ang_2(1,1):rango_ang_2(1,2)
    
    [z,x,y] = sph2cart(deg2rad(i),deg2rad(n),mm);
    
    %dif_x
    pixeles_x = x/dx;

    %dif_y
    pixeles_y = y/dx;

    %dif_z
    pixeles_z = z/dz;
    
    P1 = [coordenada(1),coordenada(2),coordenada(3)];
    P2 = [coordenada(1)+pixeles_x, coordenada(2) + pixeles_y, P1(3) + pixeles_z];
    
    [X, Y, Z] = bresenham_line3d(P1, P2);
    
    %Crear la linea
    for k = 1:size(Z,2)
        x = Aproximar(X(k));
        y = Aproximar(Y(k));
        pixeles_ya_sumados(x,y,Z(k)) = 1;
    end

end
end
    isosurf_fast(V_seg)
        hold on
        scatter3(coordenada(2),coordenada(1),coordenada(3),300,...
        'MarkerEdgeColor','k',...
            'MarkerFaceColor',[0 1 0]);
        
    %Box_size = 9;
    %Cono = smooth3(pixeles_ya_sumados,'box',Box_size);
    %p3= patch(isosurface(Cono),'FaceColor','green','EdgeColor','none');
    p3= patch(isosurface(pixeles_ya_sumados),'FaceColor','green','EdgeColor','none');
   camlight('headlight')
end
%%

