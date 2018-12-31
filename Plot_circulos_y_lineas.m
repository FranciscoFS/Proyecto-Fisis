function Plot_circulos_y_lineas(V_seg,posicion_final,Info)

    %Antes de esta funcion tiene que haberse corrido:
    %isosurf_fast(V_seg)
    isosurf_todos(V_seg,[1 0 0 0 0 0],0);
    hold on
%     isosurf_fast(V_seg)
%         hold on
%         scatter3(coordenada(2),coordenada(1),coordenada(3),300,...
%         'MarkerEdgeColor','k',...
%             'MarkerFaceColor',[0 1 0]);

    %[row,~,z] = ind2sub(size(cortical),find(cortical>0));

   
    %coordenada = V_seg.info{8};
    coordenada = Info{8};

    
    P1 = [coordenada(2),coordenada(1),coordenada(3)];
    
    scatter3(coordenada(2),coordenada(1),coordenada(3),300,...
    'MarkerEdgeColor','none',...
    'MarkerFaceColor',[0 0 0]);

   for i = 1:size(posicion_final,1)
        %scatter3(posicion_final(i,2),posicion_final(i,1),posicion_final(i,3),100,...
        %'MarkerEdgeColor','k',...
         %   'MarkerFaceColor',[1 1 0])
        pts = [P1; [posicion_final(i,2),posicion_final(i,1),posicion_final(i,3)]];
        plot3(pts(:,1), pts(:,2), pts(:,3),'green','LineWidth', 10)
   end

end