function Plot_circulos_y_lineas(V_seg,posicion_final)

    %Antes de esta funcion tiene que haberse corrido:
    % isosurf_fast(V_seg)
    %     hold on
    %     scatter3(coordenada(2),coordenada(1),coordenada(3),300,...
    %     'MarkerEdgeColor','k',...
    %         'MarkerFaceColor',[0 1 0]);

    coordenada = V_seg.info{8};
    P1 = [coordenada(2),coordenada(1),coordenada(3)];

    %for 1 = 1:size(posicion_final,1)
    scatter3(posicion_final(1,2),posicion_final(1,1),posicion_final(1,3),100,...
    'MarkerEdgeColor','k',...
        'MarkerFaceColor',[1 1 0])
    pts = [P1; [posicion_final(1,2),posicion_final(1,1),posicion_final(1,3)]];
    plot3(pts(:,1), pts(:,2), pts(:,3),'LineWidth', 1.5)

end