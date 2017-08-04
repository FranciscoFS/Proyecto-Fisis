%% Se carga la slide, y se le hacen algunas operaciones 

clear all
load('Data.mat')
rng(1);
N = 4;
Indice = [foto.class] == N;
Fotos = foto(Indice);
V = zeros([size(Fotos(1).data) numel(Fotos)]);
se = strel('disk',5);

for k=1:numel(Fotos)
    Im = imadjust(imgaussfilt(im2single(Fotos(k).data),0.5)); 
    Im = imadjust(Im + imtophat(Im,se) - imbothat(Im,se));
    V(:,:,k) =  adapthisteq(Im);
end

figure;
plot_MRI(V)

%% Kmeans1

V_kmeans1 = kmeans_p(V(:),3,size(V));
Mask1 = logical(Mask1==1);
SE = strel('disk',20);
Mask1 = imerode((Mask1),SE);

%% Kmeans2

[Y,X,Z] = meshgrid(1:size(V,1),1:size(V,2),1:size(V,3));
% alpha*Bft_norm((X(:)-size(V,1)/2).^2 + (Y(:)-size(V,2)/2).^2 ,0)
alpha = 0.6;
beta = 1;
Vector = [beta*Bft_norm(V(:),0) alpha*Bft_norm((X(:)-size(V,1)/2),0) alpha*Bft_norm((Y(:)-size(V,2)/2),0)];
V_kmeans2 = kmeans_p(Vector,3,size(V));
plot_MRI(V_kmeans2);

%%
Mask2 = logical(V_kmeans2==1);

SE = strel('disk',5);
Mask2 = imopen(Mask2,SE);
plot_MRI((Mask2));
MaskF = not(Mask2);

%% Aplicar Filtro de Gabriel

V_filt = zeros(size(V));

for k=1:size(V,3)
    
    V_filt(:,:,k) = filtro_gabriel(V(:,:,k),MaskF(:,:,k),1.6,1.3);
    
end

plot_MRI(V_filt)

%%
%Probar snakes del Toolbox, método Hibrido

propagation_weight = 1e-3; 
GAC_weight = 0.02; 
g = ac_gradient_map(V2,1); 
delta_t = 4; 
mu = 0; 

margin = [200 100 6]; 
center = [size(V2,1)/2, size(V2,2)/2, round(size(V2,3)/2)]; 
phi = zeros(size(V2)); 
phi(center(1)-margin(1):center(1)+margin(1),...
    center(2)-margin(2):center(2)+margin(2),...
    center(3)-margin(3):center(3)+margin(3)) = 1; 

%%

for i = 1:10    
    phi = ac_hybrid_model(V2-mu, phi-.5, propagation_weight, GAC_weight, g, ...
        delta_t, 1); 
    if exist('h','var') && all(ishandle(h)), delete(h); end
    iso = isosurface(phi,0.8);
    h = patch(iso,'edgecolor','r','facecolor','w');  axis equal;  view(3);
    xlim([0 size(V2,1)]);ylim([0 size(V2,2)]);zlim([0 size(V2,3)]);
    set(gcf,'name', sprintf('#iters = %d',i));
    drawnow; 
end
%%

figure;
slice = [3,5,7,9,12,15,17,19];
for i = 1:length(slice)
    subplot(2,4,i); imshow(V2(:,:,slice(i)),[]); hold on; 
    c = contours(phi(:,:,slice(i)),[0,0]);
    zy_plot_contours(c,'linewidth',2);
end

%%

[Y,X,Z] = meshgrid(1:L,1:L,1:numel(Fotos));
alpha = 0.4;

I2 = logical(I_seg==3).*I;

Idx2 = kmeans([Bft_norm(I2(:),0) alpha*Bft_norm(X(:),0)  alpha*Bft_norm(Y(:),0) alpha*Bft_norm(Z(:),0)],4);
I_seg2 = reshape(Idx2, size(I,1),size(I,2),size(I,3));
montage(reshape(I_seg2,size(I,1),size(I,2),1,size(I,3)),'DisplayRange',[]);


%%

I_new = false(size(I_seg==2));
Area= [];
for k = 1:size(I_seg==2,3)
    
    Im = I_seg(:,:,k)==2;
    CC = bwconncomp(Im);
    S = regionprops(CC,'Area','Eccentricity');
    Areas = [S.Area];
    pos = find(max(Areas(Areas < max(Areas)))==Areas);
    Area(k) = Areas(pos);
    I_new(:,:,k) = labelmatrix(CC) == pos;
    
end
    
montage(reshape(I_new,size(I,1),size(I,2),1,size(I,3)),'DisplayRange',[]);

%%

Mask = false(size(I));
Mask(:,:,9) = BW;

Active_contours = activecontour(I,Mask,100000,'edge');
montage(reshape(Active_contours,size(I,1),size(I,2),1,size(I,3)),'DisplayRange',[]);