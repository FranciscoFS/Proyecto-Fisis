function Map_Norm = Mapeo_norm(V_seg,aux)
    
    Omega = V_seg.info{25,1}(1,1);
    
    if V_seg.info{25,1}(1,2) <0
        Omega = -Omega;
    end
    
    Mask_rot = imrotate3_fast2(single(V_seg.mascara==2),{Omega,'Z'});
    
    dx = V_seg.info{1};
    dz = V_seg.info{2};
    pace = dx/dz;
    
    [m,n,z] = size(Mask_rot);
    
    if aux
        [Xq,Yq,Zq] = meshgrid(1:2:m,1:2:n,1:2*pace:z);
    else
        [Xq,Yq,Zq] = meshgrid(1:m,1:n,1:pace:z);
    end

    Fisis_Int = interp3(Mask_rot,Xq,Yq,Zq,'nearest');
    Mapeo = zeros(size(Fisis_Int,2),size(Fisis_Int,3));

    for k=1:size(Fisis_Int,3)

        Slice = Fisis_Int(:,:,k) > 0 ;
        [Row,Col] = find(Slice);
        Columnas = unique(Col);

        for i = 1:length(Columnas)
            Alturas = mean(Row(Col == Columnas(i)));
            Mapeo(Columnas(i),k) = Alturas;
        end

    end
   
    Mapeo(Mapeo<=0) = nan;
    Altura_media = (max(Mapeo(:)) + min(Mapeo(:)))/2 ;
    
    if aux
        Map_Norm = (Mapeo - nanmean(Mapeo(:))).*(2*dx);
        %Map_Norm = (Mapeo - Altura_media).*(2*dx);

    else
        Map_Norm = (Mapeo - nanmean(Mapeo(:))).*dx;
        %Map_Norm = (Mapeo - Altura_media).*(2*dx);

    end
    
end
    

