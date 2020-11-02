function Map_ajust = Mapas_Gobbi(BD)
% 
%     Folder = uigetdir();
%     Lista = dir(Folder);
    Mapeos = {};

    for k=1:numel(BD)

        %if not(Lista(k).isdir) && (Lista(k).bytes > 500)
            Rodilla = BD(k).Rodilla;
            if size(Rodilla.mascara,1) <= 900
                %load([Lista(k).folder '\' Lista(k).name])
                Mapeos{k} = Mapeo_norm(Rodilla,0);
            else
               Mapeos{k} = Mapeo_norm(Rodilla,1);
            end

        %end
        fprintf('Rodilla numero %d  \n',k)

    end
    
    Tam = zeros(1,length(Mapeos));
    Crop_Map = cell(size(Mapeos));

    for k=1:length(Mapeos)
        BB =  regionprops(not(isnan(Mapeos{k})),'BoundingBox');
        Box = BB.BoundingBox;
        Tam(k) = Box(3)*Box(4);
        Crop_Map{k} = imcrop(Mapeos{k},Box);
    end
        
    Pos_max = find(Tam == max(Tam),1);
    [m,n] = size(Crop_Map{Pos_max});
    Map_ajust = zeros(m,n,length(Crop_Map));

    for k=1:size(Map_ajust,3)

        [m2,n2] = size(Crop_Map{k});
        [Xq,Yq] = meshgrid(1:n2/n:n2,1:m2/m:m2);
        Fisis_ajust = interp2(Crop_Map{k},Xq,Yq,'cubic');
       
        if m2 < m
            Fisis_ajust(end+1:m,:) = nan;
        end
        
        if n2 < n
            Fisis_ajust(:,end+1:n) = nan;
        end
        
        Map_ajust(:,:,k) = Fisis_ajust;
    end
    
    
end