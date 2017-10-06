clear all;
close all;
imtool close all;
clearvars; 
fprintf('Iniciando Segmentacion \n'); 
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

cd;
addpath(cd);

seguir = 1;

while seguir
    
uiwait(msgbox('Seleccione LA CARPETA del paciente a analizar','Success','modal'));

folder = uigetdir();
[~,filename,~] = fileparts(folder);
DIM = dir(folder);
cd;
cd(folder);
V=[];

for p = 3:size(DIM,1)
    im = imadjust(im2single(dicomread(DIM(p).name)));
    V(:,:,p-2) = im;
end

%info
infor = dicominfo(DIM(p).name);
info = {};
if infor.PixelSpacing(1)~= infor.PixelSpacing(2)
    uiwait(msgbox('ERROR! Avisar a Francisco y Tomas! anota que rodilla es esta','Success','modal'));
end
info{1,1} = infor.PixelSpacing(1);
info{2,1} = infor.SliceThickness;
info{3,1} = infor.PatientBirthDate;
info{4,1} = infor.PatientWeight;
info{5,1} = infor.PatientAge;
info{6,1} = infor.PatientSex;

V_preFilt = zeros([size(im) size(V,3)]);

figure('units', 'normalize', 'outerposition',[0 0 1 1]);
plot_MRI(V); title('Volumen Sin Filtros, ver donde esta el perone');


%Todas las rodillas a rodillas derecha (en dicominfo no encontre nada)
message = sprintf('El perone esta al principio?');
reply = questdlg(message, 'Physis', 'Yes', 'No','No');
if strcmpi(reply, 'Yes')
    V = flipdim(V,3);
end

uiwait(msgbox({'Ahora se filtrara la imagen.' '' 'Para seguir a la siguiente filtracion solo debe pulsar OK.'},'Informacion','modal'));
% Prefiltrado
i = 50;
se = strel('disk',i,8);
Test = V(:,:,round(size(V,3)/2));
STD_inicial = std(Test(:));
Umbral = 35;

for m=1:.5:10
    Im = Test + m.*(imtophat(Test,se) - imbothat(Test,se));
    Im = medfilt2(adapthisteq(Im),[5 5]);
    Error = ((std(Im(:)) - STD_inicial)/STD_inicial)*100;
    
    if Error > Umbral
        M_final = m;
        
        for ii=1:size(V,3)
            Im = V(:,:,ii);
            Im = Im + M_final.*(imtophat(Im,se) - imbothat(Im,se));
            V_preFilt(:,:,ii) =  medfilt2(adapthisteq(Im),[7 7]);
        end
        
        break
    
    else
        continue
    end
end

figure('units', 'normalize', 'outerposition',[0 0 1 1]);
plot_MRI(V_preFilt); title('Volumen Con Filtros de preprocesamiento');
uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.','Informacion','modal'));

close all

% Kmeans
rng(1)
V_kmeans = kmeans_p(V_preFilt(:),3,size(V));

figure('units', 'normalize', 'outerposition',[0 0 1 1]);
plot_MRI(V_kmeans); title('Kmeans');
uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.','Informacion','modal'));

% Arreglemos la Mascara

answer = inputdlg('Que cluster usar (1, 2, 3)?');
Cluster = str2double(answer{1,1});
Mask1 = logical(V_kmeans==Cluster);
Se1 = strel('disk',1,8);
Se2 = strel('disk',7,8);
Maskf = imerode(Mask1,Se1);
Maskf = imclose(Maskf,Se2);

% figure;
% plot_MRI(Mask1); title('Mascara');
% figure('units', 'normalize', 'outerposition',[0 0 1 1]);
% plot_MRI(Maskf); title('Mascara');
% 
% uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.','Informacion','modal'));
close all

% Aplicar FiltroG
V_filt = zeros(size(V));

alfa = 2;
beta = 1.5;

for k=1:size(V,3)
	V_filt(:,:,k) = filtro_gabriel(V_preFilt(:,:,k), not(Maskf(:,:,k)),alfa,beta);
end

% figure('units', 'normalize', 'outerposition',[0 0 1 1]);
% plot_MRI(V_filt); title('Filtro G');
% 
% figure('units', 'normalize', 'outerposition',[0 0 1 1]);
% plot_MRI(V_preFilt); title('Filtro G');

%plot_MRI(V_preFilt); title('Filtro de Gabriel');
% uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.','Informacion','modal'));

% Random Walker

%%
V_seg.vol.orig = V;
V_seg.vol.filt = V_filt;
V_seg.info = info;
V_seg.mascara = [];
V_seg.puntos = {};
V_seg.filename = filename;
V_seg.femur.fisis = zeros(size(V_filt));
V_seg.femur.bones = zeros(size(V_filt));
V_seg.perone.fisis = zeros(size(V_filt));
V_seg.perone.bones = zeros(size(V_filt));
V_seg.tibia.fisis = zeros(size(V_filt));
V_seg.tibia.bones = zeros(size(V_filt));
V_seg.rotula = zeros(size(V_filt));

%%
N = 8; % Numero de Clusters
Words = {'Femur','Fisis Femur','Tibia','Fisis Tibia', 'Perone','Fisis Perone','Rotula','Background'};
colores = {'g.','r.','b.','y.','m.','c.','k.', 'w.'};

for k=1:size(V_filt,3)
    
    falto = 0;
    m = ones(1,N);
    L_i = {};
    Vector_i = {};

    close all

    Im_seg = 1- V_filt(:,:,k);
    Im = V_filt(:,:,k);
    
    figure('units', 'normalize', 'outerposition',[0 0 1 1]); 
    subplot(1,2,1);
    imshow(Im,[]); title(['Imagen ' num2str(k)  ' de ' num2str(size(V_filt,3))]);  
    subplot(1,2,2);
    imshow(V(:,:,k)); 

    message = sprintf('Poner puntos?');
    reply = questdlg(message, 'Physis', 'Yes', 'No','No');
       
    if strcmpi(reply, '') 
        return;
    elseif strcmpi(reply, '') 
        continue;
    elseif strcmpi(reply, 'Yes')
        
        Change = 1;
            
        while Change
            
            close all
            f1 = figure('units', 'normalize', 'outerposition',[0.5 0 0.5 1]);
            imshow(V(:,:,k),'InitialMagnification','fit');title('Imagen de referencia');
            f2 = figure('units', 'normalize', 'outerposition',[0 0 0.5 1]);
            imshow(Im, [],'InitialMagnification','fit');title(['Imagen ' num2str(k)  ' de ' num2str(size(V_filt,3))]);
            hold on
            
            for ii = 1:N
                    %f1.Name = Words{ii};
                    title(['Imagen ' num2str(k)  ' de ' num2str(size(V_filt,3)) ': ' Words{ii}]);  
                    if falto == 1
                        
                        for jj = 1:N
                            if m(jj)
                                plot(Puntos{jj,1}, Puntos{jj,2},colores{jj},'Markersize',12);
                            end
                        end
                        message = sprintf(['Te faltaron puntos en '  Words{ii} '?']);
                        reply = questdlg(message, 'Physis', 'Yes', 'No','No');
                        
                        if strcmpi(reply, 'No')
                            continue;
                        elseif strcmpi(reply, 'Yes')
                        [Puntos_nuevos{ii,1}, Puntos_nuevos{ii,2}] = getpts();
                        Puntos{ii,1} = [Puntos{ii,1};Puntos_nuevos{ii,1}];
                        Puntos{ii,2} = [Puntos{ii,2};Puntos_nuevos{ii,2}];
                        end
                    else
                        uiwait(msgbox(['Ingrese las semillas del ' Words{ii} ', con el ultimo haga doble click o click derecho. Si NO hay, SOLO ponga 1 punto en algun lugar que no sea de las partes anteriores']));
                        [Puntos{ii,1}, Puntos{ii,2}] = getpts();
                    end
                    
                    if size(Puntos{ii,1},1) == 1
                        m(ii) = 0;
                    end
                    
                L_i{ii}  = [ii*ones(1,length(Puntos{ii,1}))];
                Vector_i{ii} = [sub2ind(size(Im_seg),uint16(Puntos{ii,2}'),uint16(Puntos{ii,1}'))];         
            end
            
            axis equal
            axis tight
            axis off
            hold on;
           
            close all
            L = [];
            Vector = [];
            
            for kk=1:length(m)
                if m(kk)
                    L = [L L_i{kk}];
                    Vector = [Vector Vector_i{kk}];
                end
            end  
            
            [mask,probabilities] = random_walker(Im,Vector,L);
            
            figure('units', 'normalize', 'outerposition',[0 0 1 1]);
            subplot(1,2,1);
            imshow(mask,[]);
            subplot(1,2,2);
            [imgMasks,segOutline,imgMarkup]=segoutput(Im,mask);
            imagesc(imgMarkup);
            colormap('gray')
            axis equal
            axis tight
            axis off
            hold on
            
            for jj = 1:N
                if m(jj)
                    plot(Puntos{jj,1}, Puntos{jj,2},colores{jj},'Markersize',12);
                end
            end
            title('Outlined mask')
            
            message = sprintf('Is it Ok?');
            reply = questdlg(message,'Physis','Yes','No (Hacer esta slice de nuevo)','Me faltaron puntos','No');
         
            if strcmpi(reply, 'Yes')
                Change = 0;
                falto = 0;
                V_seg.puntos(:,:,k) = [Puntos(:,1),Puntos(:,2)];
                V_seg.mascara(:,:,k) = Im;
                if m(1)
                    V_seg.femur.bones(:,:,k) = mask==1;
                end
                if m(2)
                    V_seg.femur.fisis(:,:,k) = mask==2;
                end
                if m(3)
                    V_seg.tibia.bones(:,:,k) = mask==3;
                end
                if m(4) 
                    V_seg.tibia.fisis(:,:,k) = mask==4;
                end
                if m(5)             
                    V_seg.perone.bones(:,:,k) = mask==5;
                end
                if m(6)
                    V_seg.perone.fisis(:,:,k) = mask==6;
                end    
                if m(7)
                    V_seg.rotula(:,:,k) = mask==7;
                end

            elseif strcmpi(reply, 'Me faltaron puntos')
                falto = 1;
            else
                falto = 0;
            end
            
        end
        
    else
        continue
    end
end

%Guardar rodilla
uiwait(msgbox('Ahora se guardara la rodilla que acaba de completar, felicitaciones','Informacion','modal'));
save(['Rodilla_'  filename],'V_seg')

%Siguiente rodilla
message = sprintf('Quiere segmentar otra rodilla?');
reply = questdlg(message, 'Physis', 'Yes', 'No (estoy chato)','No');
if strcmpi(reply, 'No')
    seguir = 0;
end

end