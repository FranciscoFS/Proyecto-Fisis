function V_seg = Stephen_auto(V_seg)

    V_seg.mascara = (V_seg.mascara < 8).*(V_seg.mascara);
    
    % Primero se gira
    
    %V_seg = Rotar_3D(V_seg);
    Az = Angulo_Z(V_seg);
    Eje = 'Z';
    V_seg = Rotar(V_seg,Az,Eje);
    
    % Luego se crea la rx
    
    [~,rx_femur,~] = crear_rx(V_seg);
    %V_seg.rx.rx = rx;
    %V_seg.rx.rx1 = rx_femur;
    %V_seg.rx.rx_femur = rx_femur;
    
    %1. Poner los puntos

    [row, col] = find(rx_femur);
    x_ant = min(col);
    x_post = max(col);
    y_distal = max(row);

    P1 = [x_ant,y_distal];
    P2 = [x_post,y_distal];

    xy = [P1;P2];
    d_ant = pdist(xy,'euclidean')*0.59;
    d_distal= pdist(xy,'euclidean')*0.51;

    P3 = [x_ant + d_ant,y_distal];
    P4 = [x_ant + d_ant,y_distal - d_distal];
    
%   imshow(rx_femur,[])
%     hold on
% 
%     scatter(P1(1),P1(2),100,'d','filled')
%     scatter(P2(1),P2(2),100,'d','filled')
%     scatter(P3(1),P3(2),100,'d','filled')
%     scatter(P4(1),P4(2),100,'d','filled')

    coordenada = P4;
 
    % Encontrar coordenada punto

    v_usar = (V_seg.mascara == 2) + (V_seg.mascara ==1);
    encontrado = 0;
    contador = 1;

    while (contador <= size(v_usar,3) && encontrado ==0)
        if v_usar(Aproximar(coordenada(2)),Aproximar(coordenada(1)),contador)>0
            coord_3D = [Aproximar(coordenada(2)),Aproximar(coordenada(1)),contador];
            coord_3D = double(coord_3D);
            %uiwait(msgbox('PUNTO ENCONTRADO'));
            fprintf('Punto encontrado \n');
            encontrado =1;
            contador = contador-1;
        end
        contador = contador+1;    
    end

    V_seg.info{8} = coord_3D;
    V_seg.info{7} = Az;

end
