function V_out = Schottle_fix(V_in)

    V_out = V_in;
    Angulo = V_in.info{7};
    Eje = 'z';
    Matriz = zeros(size(V_in.mascara));
    pto_schottle = V_in.info{13}; % Viene x,y
    Matriz(pto_schottle(2),pto_schottle(1),end) = 1;
    Matriz_rot = imrotate3_fast(Matriz,{Angulo Eje});
    imshow(Matriz_rot(:,:,end),[])
    [row,col] = find(Matriz_rot(:,:,end) == 1);
    V_out.info{13}  = [col, row, pto_schottle(3)];
    
end
    
    
    