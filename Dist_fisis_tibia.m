function [Dist] = Dist_fisis_tibia(V_seg)

    dx = V_seg.info{1};
    
    Tibia = V_seg.mascara == 3;
    Fisis = V_seg.mascara == 4;
    
    %Aqui necesito calcular la distancia de cada punto de la fisis a su
    %pixel más lejano del femur.
    
    [~,~,Z_fisis] = ind2sub(size(Fisis),find(Fisis>0));
    
    Dist_real = [];
    Dist_mean = [];
    
    
    for k=min(Z_fisis):max(Z_fisis)
        
        Femur_k = Tibia(:,:,k);
        Fisis_k = Fisis(:,:,k);
        
        [row_f,col_f] = ind2sub(size(Fisis_k),find(Fisis_k>0));
        [row_h,col_h] = ind2sub(size(Femur_k),find(Femur_k>0));
        
        Columnas_fisis = unique(col_f);
        Dist_aux = [];
        
        for i= 1:length(Columnas_fisis)
      
            Fisis_distal = min(row_f(col_f==Columnas_fisis(i)));
            Femur_distal = min(row_h(col_h==Columnas_fisis(i)));
            
            if isempty(Femur_distal)
            
                Dist_real(end+1) = mean(Dist_real);
                Dist_aux(i) = mean(Dist_aux);
                
            else
                Dist_real(end+1) = abs(Femur_distal-Fisis_distal)*dx;
                Dist_aux(i) = abs(Femur_distal-Fisis_distal)*dx;
                
            end
            
        end
        
        Dist_mean(end+1) = mean(Dist_aux);

    end
    
    Dist{1} = mean(Dist_real,'omitnan');
    
    Proy_S_Fisis = sum(Fisis,3);
    Proy_S_Femur = sum(Tibia,3);
    [row_f,~] = ind2sub(size(Proy_S_Fisis),find(Proy_S_Fisis>0));
    [row_h,~] = ind2sub(size(Proy_S_Femur),find(Proy_S_Femur>0));
    
    Dist{2} = abs(min(row_h) - mean(row_f))*dx;
    
    %Dist{2} = Dist_real;
    %Dist{2} = Dist_mean;
    
    
end
    
    