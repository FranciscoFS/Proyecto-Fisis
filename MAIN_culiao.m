clear all;
close all;
imtool close all;
clearvars; 
fprintf('Iniciando Segmentacion\n'); 
workspace;

% Revisa que este instalado Image Processing Toolbox

hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		return;
    end
end

%Rodillas
seguir = 1;

%%
while seguir

Var = 1;

while Var
    [filename, pathname] = uigetfile({'*.mat';'*.m';'*.slx';'*.*'},'Seleccione MRI de Paciente a analizar');
    load(filename)
    foto = MRI;
    Classes = unique([foto.class]);
    
    if length(Classes) < 10
        Var = 0;
    else
        uiwait(msgbox('Seleccione otro Sujeto, con mas Cortes','Success','modal'));
        continue
    end
end

%info 
info = {};
info{1,1} = unique([foto.PixelSpacing]);
info{2,1} = unique([foto.SliceThickness]);

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
    title(['Corte N? ' num2str(k) foto(Selected_im ).corte])
    
end


% Seleccionar la clase
Selected_Class = inputdlg('Select Class to use');
close all

N = str2double(Selected_Class{1});
Indice = [foto.class] == N;
foto = foto(Indice);

%%
V = zeros([size(foto(1).data) numel(foto)]);
V_preFilt = zeros([size(foto(1).data) numel(foto)]);

%Prefiltrado
i = 35;
se = strel('disk',i,8);
m = 1;

for k=1:numel(foto)
    Im = imadjust(im2single(foto(k).data));
    V(:,:,k) =  Im;
    %Im = imadjust((V(:,:,k))); 
    Im = Im + m.*(imtophat(Im,se) - imbothat(Im,se));
	V_preFilt(:,:,k) =  medfilt2(adapthisteq(Im),[5 5]);
    %medfilt2(adapthisteq(Im),[5 5]);
end  
 

figure;
plot_MRI(V); title('Volumen RAW');

%Comienza el filtrado
%uiwait(msgbox({'Ahora se filtrara la imagen.' '' 'Para seguir a la siguiente filtracion solo debe pulsar OK.'},'Informacion','modal'));

%xclose all

figure;
plot_MRI(V_preFilt); title('Volumen Con Filtros de preprocesamiento');

%%
%uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

close all

% Kmeans
V_kmeans = kmeans_p(V_preFilt(:),3,size(V));
plot_MRI(V_kmeans); title('Kmeans');

uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

%Arreglemos la Mascara
answer = inputdlg('?Que cluster usar (1 o 2)?');
%%
Cluster = str2double(answer{1,1});
Mask1 = logical(V_kmeans==Cluster);
Se1 = strel('disk',5,8);
Se2 = strel('disk',1,8);
Mask1 = imerode(Mask1,Se2);
Mask1 = imclose(Mask1,Se1);

%Mask1 = im(Mask1,Se2);
plot_MRI(Mask1); title('Mascara');

%%
uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

% Aplicar Filtro de Gabriel
V_filt = zeros(size(V));

alfa = 5;
beta = 2;

for k=1:size(V,3)
	V_filt(:,:,k) = filtro_gabriel(V_preFilt(:,:,k), not(Mask1(:,:,k)),alfa,beta);
end
figure;
plot_MRI(V_filt); title('Filtro de Gabriel');

% figure;
% plot_MRI(V_preFilt); title('preFiltro');
%uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

% Random Walker

%%
%Aqui y al final tenis que agregarle las weas para que se guarden las otras cosas como perone y tibia 

V_femur_fisis_BW = zeros(size(V_filt));
V_femur_bones_BW = zeros(size(V_filt));
V_perone_fisis_BW = zeros(size(V_filt));
V_perone_bones_BW = zeros(size(V_filt));
V_tibia_fisis_BW = zeros(size(V_filt));
V_tibia_bones_BW = zeros(size(V_filt));


f3 = figure;
N = 7; % Numero de Clusters
Words = {'Femur','Fisis Femur','Tibia','Fisis Tibia', 'Perone','Fisis Perone','Background'};
Vector = [];
L = [];

for k=1:size(V_filt,3)
    m = [0,0,0,0,0,0,0];
    
    close all

    Im_seg = 1- V_filt(:,:,k);
    Im = V_filt(:,:,k);
    
    figure; 
    subplot(1,2,1);
    imshow(Im,[]); title(['Imagen ' num2str(k)  ' de ' num2str(size(V_filt,3))]);  
  
    subplot(1,2, 2);
    imshow(Im_seg,[]); 

    message = sprintf('Poner puntos?');
    reply = questdlg(message, 'Physis', 'Yes', 'No','No');
       
    if strcmpi(reply, '') % Esto por si hay un error y queri "salir rapido" del programa
        
        return;
        
    elseif strcmpi(reply, 'Yes')
        
        Change = 1;
            
        while Change
            
            close all
            imshow(V(:,:,k), []);title(['Imagen ' num2str(k)  ' de ' num2str(size(V_filt,3))]);
            
            for ii = 1:N
                
                uiwait(msgbox(['Ingrese las semillas del ' Words{ii} ', con el ultimo haga doble click o click derecho.Si NO hay, SOLO ponga 1 punto en algun lugar que no sea de las partes anteriores']));
                [Puntos{ii,1}, Puntos{ii,2}] = getpts();
                
                if size(Puntos{ii,1},1) == 1
                    m(1,ii) = 1;
                end
                
                L  = [L ii*ones(1,length(Puntos{ii,1}))];
                Vector = [Vector sub2ind(size(Im_seg),uint16(Puntos{ii,2}'),uint16(Puntos{ii,1}'))];         
            end
            axis equal
            axis tight
            axis off
            hold on;
           
            close all
            
            [mask,probabilities] = random_walker(Im,Vector,L);

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
            plot(X3,Y3,'b.','Markersize',24);
            title('Outlined mask')

            message = sprintf('Is it Ok?');
            reply = questdlg(message, 'Physis', 'Yes', 'No','Me faltaron puntos','No');
         
            if strcmpi(reply, 'Yes')
                Change = 0;
                
                if m(1,1) ==0
                V_femur_bones_BW(:,:,k) = mask==1;
                end
                if m(1,2) ==0
                V_femur_fisis_BW(:,:,k) = mask==2;
                end
                if m(1,3) ==0
                V_tibia_bones_BW(:,:,k) = mask==3;
                end
                if m(1,4) ==0
                V_tibia_fisis_BW(:,:,k) = mask==4;
                end
                if m(1,5) ==0                
                V_perone_bones_BW(:,:,k) = mask==5;
                end
                if m(1,6) ==0
                V_perone_fisis_BW(:,:,k) = mask==6;
                end

            %elseif strcmpi(reply, 'Me faltaron puntos')
            %
            else
                continue
            end
            
        end
        
    else
        continue
    end
end


%%

%Guardar rodilla
message = sprintf('Quiere ponerle el nombre o  que se haga automatico?');
reply = questdlg(message, 'Guardar', 'Ponerle', 'Auto','No');

if strcmpi(reply, 'Ponerle')
    nombre = inputdlg('Select Class to use');
    save([nombre '.mat'],'V_femur_fisis_BW','V_femur_bones_BW','V_perone_fisis_BW', 'V_perone_bones_BW','V_tibia_fisis_BW','V_tibia_bones_BW', 'filename','info')
    
elseif strcmpi(reply, 'Auto')
    save(['fisis_'  filename],'V_femur_fisis_BW','V_femur_bones_BW','V_perone_fisis_BW', 'V_perone_bones_BW','V_tibia_fisis_BW','V_tibia_bones_BW', 'filename','info')
end

%Siguiente rodilla
message = sprintf('Quiere segmentar otra rodilla?');
reply = questdlg(message, 'Physis', 'Yes', 'No','No');
if strcmpi(reply, 'No')
    seguir = 0;
end

end

