function V_seg = Punto_LCA_tibia(V_seg)

    V_seg.mascara = (V_seg.mascara < 8).*(V_seg.mascara);
    a = V_seg.mascara ==3;
    b = V_seg.mascara ==4;
    vol = a+b;
    nuevo = squeeze(sum(vol,1));
    
    %NO es necesario, solo para mostrar
    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};
    pace = (dx/dz);
    
    im = double(nuevo);
    [m,k] = size(im);
    [Xq,Zq] = meshgrid(1:pace:k,1:m);
    nuevo =interp2(im,Xq,Zq);


    
%AP=25%±2.8% ML=50.5%±4.2% AP=46.4%±3.7% ML=52.4%±2.5%
    imshow(nuevo,[])
    hold on
    [row, col] = find(nuevo);
    x_medial = min(col);
    x_lateral = max(col);
    dx = x_lateral-x_medial;
    dx_x = dx*(0.505+0.524)/2;
    x_final = x_medial+dx_x;
    
    y_anterior = min(row);
    y_posterior = max(row);
    dy = y_posterior-y_anterior;
    dy_x = dy*(0.25+0.464)/2;
    y_final = y_anterior+ dy_x;
    
    scatter(x_final,y_final,100,'d','filled')

end