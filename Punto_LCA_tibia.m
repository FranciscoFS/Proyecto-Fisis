function V_seg = Punto_LCA_tibia(V_seg)
%Rodillas: 0 medial y terminan en lateral

    V_seg.mascara = (V_seg.mascara < 8).*(V_seg.mascara);
    a = V_seg.mascara ==3; %hueso
    b = V_seg.mascara ==4;  %fisis
    vol = a+b;
    %LM: lateral medial
    aplastado_LM = squeeze(sum(vol,3));
    imshow(aplastado_LM,[])
    uiwait(msgbox('Poner un punto donde comienza la tuberosidad de la tibia (de proximal a distal)'));
    [X1,Y1] = getpts();
    close
    
    %Cortar

    vol2 = vol(1:Aproximar(Y1),1:size(vol,1),1:size(vol,3));
    aplastado_LM = squeeze(sum(vol2,3));
    imshow(aplastado_LM,[])
    uiwait(msgbox('Tibia cortada'));    
    
    %DP: distal proximal
    aplastado_DP = squeeze(sum(vol2,1));
    %aplastado_DP = squeeze(sum(V_seg.mascara,1));
    
    %NO es necesario, solo para mostrar
    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};
    pace = (dx/dz);
    
    im = double(aplastado_DP);
    [m,k] = size(im);
    [Xq,Zq] = meshgrid(1:pace:k,1:m);
    aplastado_DP =interp2(im,Xq,Zq);
  
    
%AP=25%�2.8% ML=50.5%�4.2% AP=46.4%�3.7% ML=52.4%�2.5%
    
    
    figure, imshow(aplastado_DP,[])
    hold on
    
    [row, col] = find(aplastado_DP);
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
    
    scatter(x_final,y_final,100,'o','filled')
    
    figure, imshow(im,[])
    hold on
    [row2, col2] = find(im);
    x_medial2 = min(col2);
    x_lateral2 = max(col2);
    dx2 = x_lateral2-x_medial2;
    dx_x2 = dx2*(0.505+0.524)/2;
    x_final2 = x_medial2+dx_x2;
    
    y_anterior2 = min(row2);
    y_posterior2 = max(row2);
    dy2 = y_posterior2-y_anterior2;
    dy_x2 = dy2*(0.25+0.464)/2;
    y_final2 = y_anterior2 + dy_x2;
    
    scatter(x_final2,y_final2,100,'o','filled')
    %x en realidad es "z" en imagenes
    %y en realidad es "x" en imagenes (y en [])
    
encontrado = 0;
contador = 1;
while (contador <= size(a,2) && encontrado ==0)
    if a(contador, Aproximar(y_final2),Aproximar(x_final2))>0
        coord_3D = [Aproximar(y_final2),contador,Aproximar(x_final2)];
        coord_3D = double(coord_3D);
        uiwait(msgbox('PUNTO ENCONTRADO'));
        encontrado =1;
    end
    contador = contador+1;
end

    V_seg.info{11} = [coord_3D];
    

end