function [Vol_out] = V_epifisis_tibia(V_seg)

    dx = V_seg.info{1};
    dz = V_seg.info{2};
    Vol_pixel = dx^2*dz;
    
    Tibia = V_seg.mascara == 3;
    Fisis = V_seg.mascara == 4;
    
    % Cálculo de los volumenes exactamente sobre la fisis (Literal)
    
    Vol_femur_total = sum(Tibia(:))*Vol_pixel;
    
    [~,~,v1] = ind2sub(size(Fisis),find(Fisis > 0));
    
    contador = 0;
    
    for k=min(v1):max(v1)
       
        [row_h,col_h] = find(Tibia(:,:,k)> 0);
        [row_f,col_f] = find(Fisis(:,:,k)> 0);
        
        lista_columnas_fisis = unique(col_f);
        
        for i=1:length(lista_columnas_fisis)
            
            ind = col_f == lista_columnas_fisis(i);
            ind2 = col_h == lista_columnas_fisis(i);
            
            altura_min_fisis = min(row_f(ind));
            cantidad_pixeles = sum(row_h(ind2) < altura_min_fisis);
            contador = contador + cantidad_pixeles;
            
        end
            
    end
    
    % Modo 2: Calcular el volumen bajo la altura promedio de la fisis 
    
    [row_h,~,~] = ind2sub(size(Tibia),find(Tibia>0));
    [row_f,~,~] = ind2sub(size(Fisis),find(Fisis>0));
    
    altura_prom = mean(row_f);
    indice_pixeles_hueso = (row_h >= altura_prom);

    Vol_out{1} = sum(indice_pixeles_hueso)*Vol_pixel;
    Vol_out{2} = ((Vol_out{1})/(Vol_femur_total))*100;

    %Vol_bajo_fisis = contador*Vol_pixel;
    %Vol_out{1} = Vol_femur_total;
    %Vol_out{3} = Vol_bajo_fisis;
end
    
    
    