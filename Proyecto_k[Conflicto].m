%% Se carga la slide, y se le hacen algunas operaciones 

[filename, pathname] = uigetfile({'*.mat';'*.m';'*.slx';'*.*'},'Elegir archivo');

load(filename)
foto = MRI;
Classes = unique([foto.class]);

if mod(length(Classes),2) == 0
    
    size_plot = [2,length(Classes)/2];
else
    
    size_plot = [2,round(length(Classes)/2)];
    
end


figure;

for k = 1:length(Classes)
    
    pos = find([foto.class] == Classes(k));
    Selected_im = pos(round(length(pos)/2));
    subplot(size_plot(2),size_plot(1),k); imshow(foto(Selected_im).data,[]);
    title(['Corte Nº ' ' ' num2str(k)' foto(Selected_im ).corte])
end

Selected_Class = inputdlg('Select Class to use');
close all

N = str2double(Selected_Class{1});
Indice = [foto.class] == N;
foto = foto(Indice);
V = zeros([size(foto(1).data) numel(foto)]);
V_preFilt = zeros([size(foto(1).data) numel(foto)]);

%% pre procesamiento

se = strel('disk',5);
for k=1:numel(foto)
    V(:,:,k) = im2single(foto(k).data);
    Im = imadjust(im2single(foto(k).data)); 
    Im = Im + imtophat(Im,se) - imbothat(Im,se);
    V_preFilt(:,:,k) = medfilt2(adapthisteq(Im),[9 9]);
end

figure;
plot_MRI(V); title('Volumen RAW');
figure;
plot_MRI(V_preFilt); title('Volumen Con Filtros de preprocesamiento')


%% Kmeans1

V_kmeans1 = kmeans_p(V_preFilt(:),3,size(V));
figure;
plot_MRI(V_kmeans1)

%% Arreglemos la Mascar

Mask1 = logical(V_kmeans1==2);
Se1 = strel('disk',5);
Se2 = strel('disk',1);
Mask1 = imerode(Mask1,Se2);
Mask1 = imclose(Mask1,Se1);
%Mask1 = im(Mask1,Se2);

plot_MRI(Mask1)

%% Aplicar Filtro de Gabriel

V_filt = zeros(size(V));

for k=1:size(V,3)
    
    V_filt(:,:,k) = filtro_gabriel(V_preFilt(:,:,k),not(Mask1(:,:,k)),1.6,1.3);
    
end

plot_MRI(V_filt)

%% Random Walker


V_final = zeros(size(V_filt));
for k=1:size(V_filt,3)

    Im_seg = 1- V_filt(:,:,k);

    figure;
    imshow([Im_seg V_filt(:,:,k)],[]);
    answer = inputdlg('Has it physis? (1= Yes , 0 = no)');
    close all
    
    if str2double(answer{1,1}) == 1
        
        Change = 1;
            
        while Change
        
            figure;
            imshow(Im_seg);
            [X1,Y1] = getpts();
            [X2,Y2] = getpts();

            L1 = ones(1,length(X1));
            L2 = 2*ones(1,length(X2));

            axis equal
            axis tight
            axis off
            hold on;
           
            close all
            
            [mask,probabilities] = random_walker(Im_seg,[sub2ind(size(Im_seg),uint16(Y1'),uint16(X1')), sub2ind(size(Im_seg),uint16(Y2'),uint16(X2'))],[L1 L2]);

            subplot(1,2,1);
            imshow(mask,[]);

            subplot(1,2,2);
            [imgMasks,segOutline,imgMarkup]=segoutput(Im_seg,mask);
            imagesc(imgMarkup);
            colormap('gray')
            axis equal
            axis tight
            axis off
            hold on
            plot(X1,Y1,'g.','Markersize',24);
            plot(X2,Y2,'r.','Markersize',24);
            title('Outlined mask')

%             figure
%             imagesc(probabilities(:,:,1))
%             colormap('gray')
%             axis equal
%             axis tight
%             axis off
%             hold on
%             plot(X1,Y1,'g.','Markersize',24);
%             plot(X2,Y2,'r.','Markersize',24);
%             title(strcat('Probability at each pixel that a random walker released ', ...
%                 'from that pixel reaches the foreground seed'));
        
            answer_seg = inputdlg('Is it Ok, (1, yes or 0, no)');
            
            if str2double(answer_seg{1,1}) == 1
                Change = 0;
                V_final(:,:,k) = not(mask).*V_filt(:,:,k);
            else
                continue
            end
            
        end
        
    else
        continue
    end
      
end




%% Kmeans2

[Y,X,Z] = meshgrid(1:size(V,1),1:size(V,2),1:size(V,3));
% alpha*Bft_norm((X(:)-size(V,1)/2).^2 + (Y(:)-size(V,2)/2).^2 ,0)
alpha = 0.5;
beta = 0.8;

Vector = [beta*Bft_norm(V_preFilt(:),0) alpha*Bft_norm((X(:)-size(V,1)/2),0) alpha*Bft_norm((Y(:)-size(V,2)/2),0)];
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