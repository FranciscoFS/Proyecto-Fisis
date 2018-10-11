function Altura = Dist_Fisis_Stephen(V_seg)
    
    if length(V_seg.info) == 8
        
        dx = V_seg.info{1};

        Fisis = V_seg.mascara == 2;
        Stephen_P = V_seg.info{8};
        
        

        Proy_S_fisis = sum(Fisis,3);
        [row,col] = ind2sub(size(Proy_S_fisis),find(Proy_S_fisis>0));

        Columnas = unique(col);
        Alturas_fisis_distal = zeros(size(Columnas));

        for k=1:length(Columnas)

            Alturas_fisis_distal(k) = max(row(col == Columnas(k)));

        end

        Altura = (mean(Alturas_fisis_distal - Stephen_P(2))*dx);
        
    else
        
        Altura = 0;
    end
    
    %plot(1:length(Columnas),Alturas_fisis_distal)
    
end

    