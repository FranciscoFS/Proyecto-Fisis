function Altura = Dist_Fisis_Stephen(V_seg,r)

    % 1 Distal
    % 2 Proximal

    Radio = r ;
    
    if length(V_seg.info) == 8
        
        dx = V_seg.info{1};

        Fisis = V_seg.mascara == 2;
        Stephen_P = V_seg.info{8};
        
        Radio_pixeles = round(Radio/dx);
        Lim_anterior = Stephen_P(2) - Radio_pixeles;
        Lim_posterior = Stephen_P(2) + Radio_pixeles;
        
        [~,~,v1] = ind2sub(size(Fisis),find(Fisis > 0));
        z_usar = min(v1);

        Fisis_usar = Fisis(:,Lim_anterior:Lim_posterior,z_usar);
        
        Proy_S_fisis = sum(Fisis_usar,3);
        [row,col] = ind2sub(size(Proy_S_fisis),find(Proy_S_fisis>0));

        Columnas = unique(col);
        Alturas_fisis_distal = zeros(size(Columnas));
        Alturas_fisis_proximal = zeros(size(Columnas));

        for k=1:length(Columnas)

            Alturas_fisis_distal(k) = max(row(col == Columnas(k)));
            Alturas_fisis_proximal(k) = min(row(col == Columnas(k)));

        end

        Altura{1} = (mean(Alturas_fisis_distal - Stephen_P(1))*dx);
        Altura{2} = (mean(Alturas_fisis_proximal - Stephen_P(1))*dx);

    else
        
        Altura{1} = nan;
        Altura{2} = nan;

    end
    
%     figure;
%     imshow(sum(V_seg.mascara(:,:,1:mid),3),[]);
%      imshow(sum(V_seg.mascara(:,:,:),3),[]);
%   %  imshow(Proy_S_fisis,[])
%     hold on;
%     plot(Columnas + (Lim_anterior -1) ,Alturas_fisis_distal,'-r')
%     plot(Columnas + (Lim_anterior -1) ,Alturas_fisis_proximal,'-b')
%     plot(Columnas + (Lim_anterior -1),repmat(mean(Alturas_fisis_proximal),size(Columnas)));
%     plot(Columnas + (Lim_anterior -1),repmat(mean(Alturas_fisis_distal),size(Columnas)));
%     scatter(Stephen_P(1),Stephen_P(2),'*r');
%     scatter(Stephen_P(2),Stephen_P(1),'*y');

    
end

    