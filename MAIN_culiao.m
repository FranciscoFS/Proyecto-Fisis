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
rodillas = {};
seguir = 1;
contador = 1;

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
        uiwait(msgbox('Seleccione otro Sujeto, con m?s Cortes','Success','modal'));
        continue
    end
end

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
%uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

% Aplicar Filtro de Gabriel
V_filt = zeros(size(V));

for k=1:size(V,3)
	V_filt(:,:,k) = filtro_gabriel(V_preFilt(:,:,k), not(Mask1(:,:,k)),5,2);
end
figure;
plot_MRI(V_filt); title('Filtro de Gabriel');
figure;
plot_MRI(V_preFilt); title('preFiltro');
%uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

% Random Walker
%%

 V_final_fisis = zeros(size(V_filt));
 V_final_bones = zeros(size(V_filt));
 V_fisis_final_BW = zeros(size(V_filt));
 V_bones_final_BW = zeros(size(V_filt));

f3 = figure;



for k=1:size(V_filt,3)
    
    close all

    Im_seg = 1- V_filt(:,:,k);
    Im = V_filt(:,:,k);
    
    figure; 
    subplot(1,2,1);
    imshow(Im,[]); title(['Imagen ' num2str(k)  ' de ' num2str(size(V_filt,3))]);  
  
    subplot(1,2, 2);
    imshow(Im_seg,[]); 

    message = sprintf('Has it physis?');
    reply = questdlg(message, 'Physis', 'Yes', 'No','No');
       
    if strcmpi(reply, '') % Esto por si hay un error y queri "salir rapido" del programa
        
        return;
        
    elseif strcmpi(reply, 'Yes')
        
        Change = 1;
            
        while Change
            
            close all
            imshow(Im_seg, []);title(['Imagen ' num2str(k)  ' de ' num2str(size(V_filt,3))]);
            
            uiwait(msgbox('Ingrese las semillas del Hueso, con el ultimo haga doble click'));
            [X1,Y1] = getpts();
            
            uiwait(msgbox('Ingrese las semillas de las Fisis con el ultimo haga doble click'));
            [X2,Y2] = getpts();
            
            uiwait(msgbox('Ingrese las semillas del background, con el ultimo haga doble click'));
           [X3,Y3] = getpts();

            L1 = ones(1,length(X1));
            L2 = 2*ones(1,length(X2));
            L3 = 3*ones(1,length(X3));

            axis equal
            axis tight
            axis off
            hold on;
           
            close all
            
            [mask,probabilities] = random_walker(Im,[sub2ind(size(Im_seg),uint16(Y1'),uint16(X1')),...
                sub2ind(size(Im_seg),uint16(Y2'),uint16(X2')),sub2ind(size(Im_seg),uint16(Y3'),uint16(X3'))],[L1 L2 L3]);

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
            reply = questdlg(message, 'Physis', 'Yes', 'No','No');
         
            if strcmpi(reply, 'Yes')
                Change = 0;
                V_bones_final_BW(:,:,k) = mask==1;
                V_fisis_final_BW(:,:,k) = mask==2;
                V_final_bones(:,:,k) = (mask==1).*V_preFilt(:,:,k);
                V_final_fisis(:,:,k) = (mask==2).*V_preFilt(:,:,k);
            else
                continue
            end
            
        end
        
    else
        continue
    end
end


%%
%Plot 3D
uiwait(msgbox('Ahora se mostrara en 3D la fisis.'));
if exist ('info') == 1
    isosurf(V_final_BW, V_final,info)
else
    isosurf(V_final_BW, V_final)
end

% Falta la info del DICOM para poder plotearlo con las proporciones correctas


%Guardar rodilla
message = sprintf('Quiere ponerle el nombre o  que se haga automatico?');
reply = questdlg(message, 'Guardar', 'Ponerle', 'Auto','No');

if strcmpi(reply, 'Ponerle')
    nombre = inputdlg('Select Class to use');
    save([nombre '.mat'],'V_final_BW', 'V_final', 'filename','info')
    
elseif strcmpi(reply, 'Auto')
    rodillas{contador,1} = V_final_BW;
    rodillas{contador,2} = V_final;
    save(['fisis_'  filename],{'V_final_BW', 'V_final', 'filename','info'})
end

save(['Todas_las_fisis' '.mat'],'rodillas')


%Siguiente rodilla
message = sprintf('Quiere segmentar otra rodilla?');
reply = questdlg(message, 'Physis', 'Yes', 'No','No');
if strcmpi(reply, 'No')
    seguir = 0;
end
contador = contador + 1;

end

