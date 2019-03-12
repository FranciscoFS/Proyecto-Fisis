function Altura = Dist_Fisis_Stephen2(V_seg)

    % Calcularemos la distancia hasta la Superficie Distal y proximal de la
    % fisis.
    % Hay que decidir un radio de elección y profundidad.
    % Radio = 
    % #pixeles = Radio/dx.
    
    Radio = 2.5 ; %en mm
    
    if length(V_seg.info) == 8
        
        dx = V_seg.info{1};

        Fisis = V_seg.mascara == 2;
        %plot_MRI(Fisis)
        Stephen_P = V_seg.info{8};
        Radio_pixeles = round(Radio/dx);
        Lim_anterior = Stephen_P(1) - Radio_pixeles;
        Lim_posterior = Stephen_P(1) + Radio_pixeles;
        
        [~,~,v1] = ind2sub(size(Fisis),find(Fisis > 0));
        %Mid = round((max(v1)+min(v1))/2);
        z_usar = min(v1);
        
        Fisis_usar = Fisis(:,Lim_anterior:Lim_posterior,z_usar);
        %imshow(Fisis_usar)
        [row,col,z] = ind2sub(size(Fisis_usar),find(Fisis_usar>0));
        
        Columnas = unique(col);
        Alturas_fisis_distal = zeros(size(Columnas));
        Alturas_fisis_proximal = zeros(size(Columnas));

        for k=1:length(Columnas)          
          
            Alturas_fisis_proximal(k) = min(row(col == Columnas(k)));
            Alturas_fisis_distal(k) = max(row(col == Columnas(k)));

        end

        Altura{1} = (mean(Alturas_fisis_distal - Stephen_P(2))*dx);
        Altura{2} = (mean(Alturas_fisis_proximal - Stephen_P(2))*dx);        
    else
        
        Altura = 0;
    end
    
%     size(Alturas_fisis_distal)
%     size(Alturas_fisis_proximal)
    
    imshow(Fisis(:,:,z_usar),[]);
    hold on;
    plot(1:length(Columnas),Alturas_fisis_distal,'-r')
    plot(1:length(Columnas),Alturas_fisis_proximal,'-b')
    scatter(Stephen_P(1),Stephen_P(2))
    
end

    