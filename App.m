function varargout = App(varargin)
% APP MATLAB code for App.fig
%      APP, by itself, creates a new APP or raises the existing
%      singleton*.
%
%      H = APP returns the handle to a new APP or the handle to
%      the existing singleton*.
%
%      APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APP.M with the given input arguments.
%
%      APP('Property','Value',...) creates a new APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before App_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to App_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help App

% Last Modified by GUIDE v2.5 09-Oct-2017 22:52:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @App_OpeningFcn, ...
                   'gui_OutputFcn',  @App_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before App is made visible.
function App_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to App (see VARARGIN)

% Choose default command line output for App
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes App wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = App_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Empezar.
function Empezar_Callback(hObject, ~, handles)
% hObject    handle to Empezar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.V_preFilt = zeros(size(handles.V));

f1 = figure('units', 'normalize', 'outerposition',[0 0 1 1]);
plot_MRI(handles.V); title('Volumen Sin Filtros, ver donde esta el perone');


%Todas las rodillas a rodillas derecha (en dicominfo no encontre nada)
message = sprintf('El perone esta al principio?');
reply = questdlg(message, 'Physis', 'Yes', 'No','No');

if strcmpi(reply, 'Yes')
    handles.V = flipdim(handles.V,3);
end

close(f1)

h = waitbar(0,'Trabajando...');

% Prefiltrado
i = 50;
se = strel('disk',i,8);
Test = handles.V(:,:,round(size(handles.V,3)/2));
STD_inicial = std(Test(:));
Umbral = 25;

for m=1:.5:30
    Im = Test + m.*(imtophat(Test,se) - imbothat(Test,se));
    Im = medfilt2(adapthisteq(Im),[5 5]);
    Error = ((std(Im(:)) - STD_inicial)/STD_inicial)*100;
    
    if Error > Umbral
        waitbar(1/3)
        for ii=1:size(handles.V,3)
            Im = handles.V(:,:,ii);
            Im = Im + m.*(imtophat(Im,se) - imbothat(Im,se));
            handles.V_preFilt(:,:,ii) =  medfilt2(adapthisteq(Im),[7 7]);
        end
        
        break
    
    else
        continue
    end
end

waitbar(2/3)

% Kmeans
rng(1)
V_kmeans = kmeans_p(handles.V_preFilt(:),3,size(handles.V));

waitbar(1)
close(h)

f1 = figure('units', 'normalize', 'outerposition',[0 0 1 1]);
plot_MRI(V_kmeans); title('Kmeans');
answer = inputdlg('Que cluster usar (1, 2, 3)?');

if not(isempty(answer))
    Cluster = str2double(answer{1,1});
    Mask1 = logical(V_kmeans==Cluster);
    Se1 = strel('disk',1,8);
    Se2 = strel('disk',7,8);
    Maskf = imerode(Mask1,Se1);
    Maskf = imclose(Maskf,Se2);
    close(f1)
    
else 
    close(f1)
    return
end

% uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.','Informacion','modal'));
close(f1)

% Aplicar FiltroG
handles.V_filt = zeros(size(handles.V));

alfa = 2;
beta = 1.2;

for k=1:size(handles.V,3)
	handles.V_filt(:,:,k) = filtro_gabriel(handles.V_preFilt(:,:,k), not(Maskf(:,:,k)),alfa,beta);
end

%plot_MRI(handles.V_filt);
%uiwait(msgbox('Para seguir a la siguiente filtracion solo debe pulsar OK.','Informacion','modal'));

handles.V_seg.vol.orig = handles.V;
handles.V_seg.vol.filt = handles.V_filt;
handles.V_seg.info = handles.info;
handles.V_seg.mascara = zeros(size(handles.V_filt));
handles.V_seg.puntos = {};
handles.V_seg.filename = handles.filename;
handles.V_seg.femur.fisis = zeros(size(handles.V_filt));
handles.V_seg.femur.bones = zeros(size(handles.V_filt));
handles.V_seg.perone.fisis = zeros(size(handles.V_filt));
handles.V_seg.perone.bones = zeros(size(handles.V_filt));
handles.V_seg.tibia.fisis = zeros(size(handles.V_filt));
handles.V_seg.tibia.bones = zeros(size(handles.V_filt));
handles.V_seg.rotula = zeros(size(handles.V_filt));

handles.Prefiltrado = 1;

guidata(hObject, handles);




function Segmentar_Callback(hObject, ~, handles)

if handles.Prefiltrado
    
    condicion = 1;

    if handles.check(handles.v)
         message = sprintf('Ya realizaste esta Slide, seguro que quires hacerla denuevo?');
         reply = questdlg(message,'Chequeo','Si','No (No hacerla)');

         if reply == 'No'
             condicion = 0;
         end

    end


    while condicion

    N = 8; % Numero de Clusters
    Words = {'Femur','Fisis Femur','Tibia','Fisis Tibia', 'Perone','Fisis Perone','Rotula','Background'};
    colores = {'g.','r.','b.','y.','m.','c.','k.', 'w.'};

        for k=handles.v

            falto = 0;
            m = ones(1,N);
            L_i = {};
            Vector_i = {};

            Im_seg = 1- handles.V_filt(:,:,k);
            Im =handles.V_filt(:,:,k);


            Change = 1;

            while Change

                %close(f1)
                f1 = figure('units', 'normalize', 'outerposition',[0.5 0 0.5 1]);
                imshow(handles.V(:,:,k),'InitialMagnification','fit');title('Imagen de referencia');
                f2 = figure('units', 'normalize', 'outerposition',[0 0 0.5 1]);
                imshow(Im, [],'InitialMagnification','fit');title(['Imagen ' num2str(k)  ' de ' num2str(size(handles.V_filt,3))]);
                hold on

                for ii = 1:N
                        %f1.Name = Words{ii};
                        title(['Imagen ' num2str(k)  ' de ' num2str(size(handles.V_filt,3)) ': ' Words{ii}]);  
                        if falto == 1

                            for jj = 1:N
                                if m(jj)
                                    plot(Puntos{jj,1}, Puntos{jj,2},colores{jj},'Markersize',12);
                                end
                            end
                            message = sprintf(['Te faltaron puntos en '  Words{ii} '?']);
                            reply = questdlg(message, 'Fisis', 'Yes', 'No','No');

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

                close(f1,f2)
                L = [];
                Vector = [];

                for kk=1:length(m)
                    if m(kk)
                        L = [L L_i{kk}];
                        Vector = [Vector Vector_i{kk}];
                    end
                end  

                [mask,~] = random_walker(Im,Vector,L);

                f3 = figure('units', 'normalize', 'outerposition',[0 0 1 1]);
                subplot(1,2,1);
                imshow(mask,[]);
                subplot(1,2,2);
                [~,~,imgMarkup]=segoutput(Im,mask);
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
                    condicion = 0;
                    handles.V_seg.puntos{k} = [Puntos(:,1),Puntos(:,2)];
                    handles.V_seg.mascara(:,:,k) = mask;
                    handles.check(handles.v) = 1;
                    if m(1)
                        handles.V_seg.femur.bones(:,:,k) = mask==1;
                    end
                    if m(2)
                        handles.V_seg.femur.fisis(:,:,k) = mask==2;
                    end
                    if m(3)
                        handles.V_seg.tibia.bones(:,:,k) = mask==3;
                    end
                    if m(4) 
                        handles.V_seg.tibia.fisis(:,:,k) = mask==4;
                    end
                    if m(5)             
                        handles.V_seg.perone.bones(:,:,k) = mask==5;
                    end
                    if m(6)
                        handles.V_seg.perone.fisis(:,:,k) = mask==6;
                    end    
                    if m(7)
                        handles.V_seg.rotula(:,:,k) = mask==7;
                    end
                    guidata(hObject, handles);
                    close(f3)
                    
                elseif strcmpi(reply, 'Me faltaron puntos')
                    falto = 1;
                    close(f3)
                    
                else
                    falto = 0;
                    close(f3)
                    
                end
            end
        end
    end

else
    msgbox('Porfavor use EMPEZAR primero antes de Segmentar slides')
end






% --- Executes on slider movement.
function slider1_Callback(hObject, ~, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.v = get(hObject,'Value');
imshow(handles.V(:,:,handles.v));

if handles.check(handles.v)
    set(handles.edit1,'String','Realizado')
else
    set(handles.edit1, 'String','No Realizado')
end

guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, ~, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Guardar.
function Guardar_Callback(hObject, ~, handles)
% hObject    handle to Guardar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.Prefiltrado
    uiwait(msgbox('Seleccione carpeta para guardar al paciente','Guardar','modal'));
    folder_save = uigetdir();
    V_seg = handles.V_seg;
    save([folder_save '/' 'Rodilla_'  handles.filename],'V_seg')
    guidata(hObject, handles);
else
    msgbox('No hay nada para guardar aún')
end


% --- Executes on button press in cargar.
function cargar_Callback(hObject, eventdata, handles)

uiwait(msgbox('Seleccione LA CARPETA del paciente a analizar','Success','modal'));

folder = uigetdir();

if folder == 0
    return
else
    [~,handles.filename,~] = fileparts(folder);
    DIM = dir(folder);

    handles.V=[];

    for p = 1:size(DIM,1)

        if not(DIM(p).isdir)
            if strcmp(DIM(p).name(end-2:end),'dcm')
                im = imadjust(im2single(dicomread([DIM(p).folder '/' DIM(p).name])));
                handles.V(:,:,end+1) = im;
            end
        end
    end

    %info
    n = round(p/2);
    infor = dicominfo([DIM(n).folder '/' DIM(n).name]);
    handles.info = {};

    if infor.PixelSpacing(1)~= infor.PixelSpacing(2)
        uiwait(msgbox('ERROR! Avisar a Francisco y Tomas! anota que rodilla es esta','Success','modal'));
    end

    handles.info{1,1} = infor.PixelSpacing(1);
    handles.info{2,1} = infor.SliceThickness;
    handles.info{3,1} = infor.PatientBirthDate;
    handles.info{4,1} = infor.PatientWeight;
    handles.info{5,1} = infor.PatientAge;
    handles.info{6,1} = infor.PatientSex;

    handles.check = zeros(1,size(handles.V,3));

    set(handles.slider1, 'Min', 1);
    set(handles.slider1, 'Max', size(handles.V,3));
    set(handles.slider1, 'SliderStep', [1/(size(handles.V,3)-1) , 1/(size(handles.V,3)-1) ]);
    set(handles.slider1, 'Value', 10);
    imshow(handles.V(:,:,10))
    handles.Prefiltrado = 0;
    handles.v = 10;

    guidata(hObject, handles);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'String','No Realizado')
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject,handles)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
clear all
close all


% --- Executes on button press in Femur_bone.
function Femur_bone_Callback(hObject, eventdata, handles)
% hObject    handle to Femur_bone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Femur_bone


% --- Executes on button press in Tibia_bone.
function Tibia_bone_Callback(hObject, eventdata, handles)
% hObject    handle to Tibia_bone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Tibia_bone


% --- Executes on button press in Tibia_fisis.
function Tibia_fisis_Callback(hObject, eventdata, handles)
% hObject    handle to Tibia_fisis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Tibia_fisis


% --- Executes on button press in Femur_fisis.
function Femur_fisis_Callback(hObject, eventdata, handles)
% hObject    handle to Femur_fisis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Femur_fisis


% --- Executes on button press in Perone_bone.
function Perone_bone_Callback(hObject, eventdata, handles)
% hObject    handle to Perone_bone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Perone_bone


% --- Executes on button press in Perone_fisis.
function Perone_fisis_Callback(hObject, eventdata, handles)
% hObject    handle to Perone_fisis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Perone_fisis


% --- Executes on button press in Rotula.
function Rotula_Callback(hObject, eventdata, handles)
% hObject    handle to Rotula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Rotula


% --- Executes on button press in Ver_3D.
function Ver_3D_Callback(hObject, eventdata, handles)
% hObject    handle to Ver_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.Prefiltrado
    isosurf_todos(handles.V_seg)
else
    msgbox('Aun no hay nada que modelar, usar EMPEZAR y luego segmentar algo')
end
