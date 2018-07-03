function [Vol_out] = V_bajo_fisis(V_seg)

    dx = V_seg.info{1};
    dz = V_seg.info{2};
    Vol_pixel = dx^2*dz;
    
    Femur = V_seg.mascara == 1;
    Fisis = V_seg.mascara == 2;
    
    % Cálculo de los volumenes
    
    Vol_femur_total = sum(Femur(:))*Vol_pixel;
    
    [~,~,v1] = ind2sub(size(Fisis),find(Fisis > 0));
    
    contador = 0;
    
    for k=min(v1):max(v1)
       
        [row_h,col_h] = find(Femur(:,:,k)> 0);
        [row_f,col_f] = find(Fisis(:,:,k)> 0);
        
        lista_columnas_fisis = unique(col_f);
        
        for i=1:length(lista_columnas_fisis)
            
            ind = col_f == lista_columnas_fisis(i);
            ind2 = col_h == lista_columnas_fisis(i);
            
            altura_min_fisis = max(row_f(ind));
            cantidad_pixeles = sum(row_h(ind2) > altura_min_fisis);
            contador = contador + cantidad_pixeles;
            
        end
            
    end
    
    Vol_bajo_fisis = contador*Vol_pixel;
    %Vol_out{1} = Vol_femur_total;
    Vol_out{1} = Vol_bajo_fisis;
    Vol_out{2} = ((Vol_bajo_fisis)/(Vol_femur_total))*100;
end
    
    
    