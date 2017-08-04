clear all;
close all;
imtool close all;  % Close all imtool figures.
clearvars; 
fprintf('Iniciando Segmentacion\n'); 
workspace;
format long g;
format compact;
captionFontSize = 14;
T = timer('TimerFcn',@(~,~)disp('Fired.'),'StartDelay',3);

% Revisa que este instalado Image Processing Toolbox
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		return;
	end
end

uiwait(msgbox('Seleccione la rodilla a analizar.','Informacion','modal')); 

[filename, pathname] = uigetfile({'*.mat';'*.m';'*.slx';'*.*'},'Elegir archivo');

% Mostrar Cada uno de los cortes en el Mat y preguntar por el N

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
    title(['Corte Nº ' num2str(k) foto(Selected_im ).corte])
end

% Seleccionar la clase
Selected_Class = inputdlg('Select Class to use');
close all

N = str2double(Selected_Class{1});
Indice = [foto.class] == N;
foto = foto(Indice);
V = zeros([size(foto(1).data) numel(foto)]);
V_preFilt = zeros([size(foto(1).data) numel(foto)]);

%Prefiltrado
se = strel('disk',5);
for k=1:numel(foto)
    V(:,:,k) =  im2single(foto(k).data);
    Im = imadjust((V(:,:,k))); 
    Im = Im + imtophat(Im,se) - imbothat(Im,se);
	V_preFilt(:,:,k) =  medfilt2(adapthisteq(Im),[9 9]);
end  
  
f1 = figure;
plot_MRI(V); title('Volumen RAW');

%Comienza el filtrado
uiwait(msgbox({'Ahora se filtrara la imagen.' '' 'Para seguir a la siguiente filtracion solo debe pulsar OK.'},'Informacion','modal'));

f2= figure;
plot_MRI(V_preFilt); title('Volumen Con Filtros de preprocesamiento');

uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

% Kmeans
V_kmeans1 = kmeans_p(V_preFilt(:),2,size(V));
plot_MRI(V_kmeans1)

uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

%Arreglemos la Mascara
answer = inputdlg('¿Que cluster usar (1 o 0)?');
answer = str2double(answer{1,1});
Mask1 = logical(V_kmeans1==answer);
Se1 = strel('disk',5);
Se2 = strel('disk',1);
Mask1 = imerode(Mask1,Se2);
Mask1 = imclose(Mask1,Se1);
%Mask1 = im(Mask1,Se2);
plot_MRI(Mask1)

uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

% Aplicar Filtro de Gabriel
V_filt = zeros(size(V));

for k=1:size(V,3)
	V_filt(:,:,k) = filtro_gabriel(V_preFilt(:,:,k),not(Mask1(:,:,k)),0.5,10);
end

plot_MRI(V_filt)

uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

% Random Walker
V_final = zeros(size(V_filt));
V_final_BW = zeros(size(V_filt));

for k=1:size(V_filt,3)
    
    Im_seg = 1- V_preFilt(:,:,k);

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
        
            answer_seg = inputdlg('Is it Ok, (1 = Yes or 0 = No)');
            
            if str2double(answer_seg{1,1}) == 1
                Change = 0;
                V_final_BW(:,:,k) = mask==1;
                V_final(:,:,k) = (mask==1).*V_preFilt(:,:,k);
                
            else
                continue
            end
            
        end
        
    else
        continue
    end
end













