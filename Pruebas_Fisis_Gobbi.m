
L = length(Map_maxD);
figure;
options.nj    = 10;             % 10 x 20 
options.ni    = 5;             % histograms
options.B     = 9;              % 9 bins
options.show  = 1;              % show results;

for k=1:L
    
    subplot(4,4,k);
   % [n,m] = Map_maxD{k};
    imshow(Map_maxD{k},[]);
    %Bfx_hog(Map_maxC{k}(1:(round(end/2)),:),options);
    colormap jet
    colorbar
    
end

%% Crear Mapas medio y análisis

Map = Maps;
Corte = 1;
Mapas_D = Map(:,:,Displasia >= Corte);
Mapas_ND = Map(:,:,Displasia ==0);

Mean_D = nanmean(Mapas_D,3);
Mean_ND = nanmean(Mapas_ND,3);

ValoresP = zeros(size(Mean_D));
ValoresPt = zeros(size(Mean_D));

for k=1:size(Mapas_D,1)
    for j=1:size(Mapas_D,2)
        %[h,p] = ttest2(Mapas_D(k,j,:),Mapas_ND(k,j,:));
        try
            p = ranksum(squeeze(Mapas_D(k,j,:)),squeeze(Mapas_ND(k,j,:)));
           % [h,p2] = ttest2(squeeze(Mapas_D(k,j,:)),squeeze(Mapas_ND(k,j,:)));
        catch
            p = nan;
           % p2 = nan;
        end
        ValoresP(k,j) = p;
        %ValoresPt(k,j) = p2;

    end
end

%%
figure;
set(gcf,'color','white')

subplot(2,2,1);
surf(Mean_D,'EdgeColor','none'); title('Alturas promedios Displasia');axis off;axis equal; colorbar;
subplot(2,2,2);
surf(Mean_ND,'EdgeColor','none'); title('Alturas promedios Control');axis off;axis equal; colorbar;
subplot(2,2,3)
surf(single((ValoresP < 0.05)*5),'EdgeColor','none'); title('Valores P < 0.05 con Mann Whitney');axis off;axis equal
subplot(2,2,4)
surf(single((ValoresPt < 0.05)*5),'EdgeColor','none'); title('Valores P < 0.05 con Tstudent');axis off;axis equal
colormap summer


%%

figure;
set(gcf,'color','white')
surf(Mean_D./-0.3,'EdgeColor','none'); title('Alturas promedios Displasia');axis off; colorbar;axis equal
colormap jet

figure;
set(gcf,'color','white')
surf(Mean_ND./-0.3,'EdgeColor','none'); title('Alturas promedios Control');axis off; colorbar;
axis equal
colormap jet





%% MannWhithney para cada uno

ValoresP = zeros(size(Mean_D));

for k=1:size(Mapas_D,1)
    for j=1:size(Mapas_D,2)
        %[h,p] = ttest2(Mapas_D(k,j,:),Mapas_ND(k,j,:));
        try
            p = ranksum(squeeze(Mapas_D(k,j,:)),squeeze(Mapas_ND(k,j,:)));
        catch
            p = nan;
        end
        ValoresP(k,j) = p;
    end
end



%%
