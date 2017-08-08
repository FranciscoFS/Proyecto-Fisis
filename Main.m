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
        uiwait(msgbox('Seleccione otro Sujeto, con m�s Cortes','Success','modal'));
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
    title(['Corte N� ' num2str(k) foto(Selected_im ).corte])
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
se = strel('disk',3);

for k=1:numel(foto)
    V(:,:,k) =  im2single(foto(k).data);
    Im = imadjust((V(:,:,k))); 
    Im = Im + imtophat(Im,se) - imbothat(Im,se);
	V_preFilt(:,:,k) =  medfilt2(adapthisteq(Im),[3 3]);
end  
 
%info = dicominfo(V(:,:,1));

%%

f1 = figure;
plot_MRI(V); title('Volumen RAW');

%Comienza el filtrado
uiwait(msgbox({'Ahora se filtrara la imagen.' '' 'Para seguir a la siguiente filtracion solo debe pulsar OK.'},'Informacion','modal'));

f2= figure;
plot_MRI(V_preFilt); title('Volumen Con Filtros de preprocesamiento');

uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

% Kmeans
V_kmeans1 = kmeans_p(V_preFilt(:),2,size(V));
plot_MRI(V_kmeans1); title('Kmeans');

uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

%Arreglemos la Mascara
answer = inputdlg('�Que cluster usar (1 o 2)?');
answer = str2double(answer{1,1});
Mask1 = logical(V_kmeans1==answer);
Se1 = strel('disk',5);
Se2 = strel('disk',1);
Mask1 = imerode(Mask1,Se2);
Mask1 = imclose(Mask1,Se1);

%Mask1 = im(Mask1,Se2);
plot_MRI(Mask1); title('Mascara');

uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

% Aplicar Filtro de Gabriel
V_filt = zeros(size(V));

for k=1:size(V,3)
	V_filt(:,:,k) = filtro_gabriel(V_preFilt(:,:,k),not(Mask1(:,:,k)),0.5,10);
end

plot_MRI(V_filt); title('Filtro de Gabriel');

uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

% Random Walker
%%
V_final = zeros(size(V_filt));
V_final_BW = zeros(size(V_filt));

f3 = figure;

for k=1:size(V_filt,3)
    
    close all

    Im_seg = 1- V_preFilt(:,:,k);
    Im = V(:,:,k);
    
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
            imshow(Im, []);title(['Imagen ' num2str(k)  ' de ' num2str(size(V_filt,3))]);
            
            uiwait(msgbox('Ingrese las semillas del foreground, con el ultimo haga doble click'));
            [X1,Y1] = getpts();
            
            uiwait(msgbox('Ingrese las semillas del background, con el ultimo haga doble click'));
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

            message = sprintf('Is it Ok?');
            reply = questdlg(message, 'Physis', 'Yes', 'No','No');
         
            if strcmpi(reply, 'Yes')
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
<<<<<<< HEAD
    rodillas(:,:,contador) = V_final_BW;% como se pone que tambi�n se guarde en esa posicion V_final;
    save(['fisis_'  filename],'V_final_BW', 'V_final', 'filename')
=======
    rodillas{contador,1} = V_final_BW;
    rodillas{contador,2} = V_final;
    save(['fisis_'  filename],{'V_final_BW', 'V_final', 'filename','info'})
>>>>>>> fcc704b0ac088e6a50e28b134966151184ac9d24
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

<<<<<<< HEAD
message = sprintf('Quiere ver la distribucion de las fisis');
reply = questdlg(message, 'Physis', 'Yes', 'No','No');
if strcmpi(reply, 'Yes')
    Distribucion_fisis(rodillas);
=======

%%
%Distribucion espacial de la fisis promedio

<<<<<<< HEAD
fisis_prom = [];
for i=1:size(rodillas)
    fisis_prom = fisis_prom + rodillas(:,:,i);
    %Vamos a tener que rellenar con 0 en algunos casos porque no todas las RM son del
    %mismo tama�o
=======
%Elegir 
message = sprintf('Que quiere cargar?');
reply = questdlg(message,'Fisis', 'Rodillas de workspace', 'Desde un/varios archivo(s)', 'No');

if strcmpi(reply, 'Desde un/varios archivo(s)')
[filename, pathname, filterindex] = uigetfile( ...
{  '*.mat','MAT-files (*.mat)'; ...
   '*.slx;*.mdl','Models (*.slx, *.mdl)'; ...
   '*.*',  'All Files (*.*)'}, ...
  'Seleccione las fisis a analizar', ...
   'MultiSelect', 'on');

rodillas = {};

for i=1:size(filename,2)
    i
    load(filename{1,i})
    rodillas{i,1} = V_final_BW;
    rodillas{i,2} = V_final;
end
end



%Resize
mayor = 0;
for i=1:size(rodillas,1)
    tam = max(size(rodillas{i,1}));
    if tam>mayor
        mayor = tam
    end
end

%cellsz = cellfun(@size,rodillas,'uni',false);
%cellsz = cellfun(@max,cellsz,'uni',false);

for i=1:size(rodillas,1)
    rodillas{i,1} = imresize(rodillas{i,1},[mayor,mayor])
    rodillas{i,2} = imresize(rodillas{i,2},[mayor,mayor])
end

message = sprintf('A que fisis le quiere ver la distribucion?');
reply = questdlg(message, 'Fisis','V_final_BW', 'V_final','No');

if strcmpi(reply, 'V_final_BW')
    elegir = 1;
elseif strcmpi(reply, 'V_final')
    elegir = 2;    
end

fisis_prom = {mayor,mayor,1};

%SUMAR LAS FISIS
% Despues sigo con esto, o sigue tu
for i=1:size(rodillas,1);
    for e=1:size(rodillas{i,elegir},3)
        rodillas{i,elegir}
    fisis_prom = fisis_prom{ + rodillas{i,elegir};
    end
>>>>>>> fcc704b0ac088e6a50e28b134966151184ac9d24
>>>>>>> 2db1e807ce8919f7e1283566c1612e0593f70a55
end


