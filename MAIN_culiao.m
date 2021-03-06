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


while seguir

Var = 1;

uiwait(msgbox('Seleccione el paciente a analizar','Success','modal'));

while Var
    [filename, pathname] = uigetfile({'*.mat';'*.m';'*.slx';'*.*'},'Seleccione MRI de Paciente a analizar');
    load(filename)
    foto = MRI;
    Classes = unique([foto.class]);
    
    if length(Classes) < 10
        Var = 0;
    else
        uiwait(msgbox('Seleccione otro paciente, con mas Cortes','Success','modal'));
        continue
    end
end



if mod(length(Classes),2) == 0
    size_plot = [2,length(Classes)/2];
else
    size_plot = [2,round(length(Classes)/2)];
end

figure('units', 'normalize', 'outerposition',[0 0 1 1]);
for k = 1:length(Classes)
    pos = find([foto.class] == Classes(k));
    Selected_im = pos(round(length(pos)/2));
    subplot(size_plot(2),size_plot(1),k); imshow(foto(Selected_im).data,[]);
    title(['Corte N ' num2str(k) foto(Selected_im ).corte])
end


% Seleccionar la clase
Selected_Class = inputdlg('Seleccione la clase a usar');
close all

N = str2double(Selected_Class{1});
Indice = [foto.class] == N;
foto = foto(Indice);

%info 
info = {};
info{1,1} = unique([foto.PixelSpacing]);
info{2,1} = unique([foto.SliceThickness]);

V = zeros([size(foto(1).data) numel(foto)]);
V_preFilt = zeros([size(foto(1).data) numel(foto)]);

for k=1:numel(foto)
    Im = imadjust(im2single(foto(k).data));
    V(:,:,k) =  Im;
end

%Todas las rodillas a rodillas derecha (en dicominfo no encontre nada)
message = sprintf('La rodilla es izquierda?');
reply = questdlg(message, 'Physis', 'Yes', 'No','No');
if strcmpi(reply, 'Yes')
    V = flipdim(V,3);
end

% Prefiltrado
i = 50;
se = strel('disk',i,8);
Test = V(:,:,round(size(V,3)/2));
STD_inicial = std(Test(:));
Umbral = 30;

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
plot_MRI(V); title('Volumen RAW');

uiwait(msgbox({'Ahora se filtrara la imagen.' '' 'Para seguir a la siguiente filtracion solo debe pulsar OK.'},'Informacion','modal'));

figure('units', 'normalize', 'outerposition',[0 0 1 1]);
plot_MRI(V_preFilt); title('Volumen Con Filtros de preprocesamiento');

uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

close all

% Kmeans
rng(1)
V_kmeans = kmeans_p(V_preFilt(:),3,size(V));

figure('units', 'normalize', 'outerposition',[0 0 1 1]);
plot_MRI(V_kmeans); title('Kmeans');

figure('units', 'normalize', 'outerposition',[0 0 1 1]);
plot_MRI(V_preFilt); title('Volumen Con Filtros de preprocesamiento');
uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

%
% Arreglemos la Mascara

answer = inputdlg('Que cluster usar (1 o 2)?');
Cluster = str2double(answer{1,1});
Mask1 = logical(V_kmeans==Cluster);
Se1 = strel('disk',1,8);
Se2 = strel('disk',7,8);
Maskf = imerode(Mask1,Se1);
Maskf = imclose(Maskf,Se2);

figure;
plot_MRI(Mask1); title('Mascara');
figure('units', 'normalize', 'outerposition',[0 0 1 1]);
plot_MRI(Maskf); title('Mascara');

uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

% Aplicar FiltroG
V_filt = zeros(size(V));

alfa = 2;
beta = 1.5;

for k=1:size(V,3)
	V_filt(:,:,k) = filtro_gabriel(V_preFilt(:,:,k), not(Maskf(:,:,k)),alfa,beta);
end

figure('units', 'normalize', 'outerposition',[0 0 1 1]);
plot_MRI(V_filt); title('Filtro G');

figure('units', 'normalize', 'outerposition',[0 0 1 1]);
plot_MRI(V_preFilt); title('Filtro G');

%plot_MRI(V_preFilt); title('Filtro de Gabriel');
uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.'));

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


%%

%Guardar rodilla
message = sprintf('Quiere ponerle el nombre o  que se haga automatico?');
reply = questdlg(message, 'Guardar', 'Ponerle', 'Auto','No');

if strcmpi(reply, 'Ponerle')
    nombre = inputdlg('Select Class to use');
    save([nombre '.mat'],'V_seg')
elseif strcmpi(reply, 'Auto')
    save(['Rodilla_'  filename],'V_seg')
end

%Siguiente rodilla
message = sprintf('Quiere segmentar otra rodilla?');
reply = questdlg(message, 'Physis', 'Yes', 'No','No');
if strcmpi(reply, 'No')
    seguir = 0;
    fprintf('Eres libre... era broma te tocan 20 mas \n');
end

end

