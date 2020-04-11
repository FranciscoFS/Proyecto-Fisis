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

% Last Modified by GUIDE v2.5 10-Mar-2020 22:13:53

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
handles.inicio = 0;
handles.Indice = [0 0 0 0 0 0 0 1];
set(handles.Empezar, 'Visible', 'off');
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
i = 100;
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
            handles.V_preFilt(:,:,ii) =  medfilt2(adapthisteq(Im),[5 5]);
        end
        
        break
    
    else
        continue
    end
end

waitbar(2/3)

%f1 = figure('units', 'normalize', 'outerposition',[0 0 1 1]);
%plot_MRI(handles.V_preFilt); title('Kmeans');
%uiwait(msgbox({'caca'},'Informacion','modal'));
%close(f1)

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
    Se1 = strel('disk',50,8);
    Se2 = strel('disk',7,8);
    Maskf = imerode(Mask1,Se1);
    Maskf = imclose(Maskf,Se2);
    close(f1)
    
else 
    close(f1)
    return
end

% Aplicar FiltroG
handles.V_filt = zeros(size(handles.V));

alfa = 0.8;
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

set(handles.Empezar, 'Visible', 'off');

guidata(hObject, handles);





function Segmentar_Callback(hObject, ~, handles)

if handles.Prefiltrado
    
    condicion = 1;
    if handles.V_seg.check(handles.v)
         message = sprintf('�Ya realizaste esta Slide, seguro que quires hacerla denuevo?');
         reply = questdlg(message,'Chequeo','Si','No','No');
       
         if reply == 'No'
             condicion = 0;
         end

    end
 
    handles = segmentar(handles,condicion);
    set(handles.edit1,'String','Realizado');
    handles.V_seg.check(handles.v) = 1;
    guidata(hObject, handles);
    
else
    msgbox('Porfavor use EMPEZAR primero antes de Segmentar slides')
end


% --- Executes on slider movement.
function slider1_Callback(hObject, ~, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.v = get(hObject,'Value');
set(handles.edit2, 'String',handles.v)

if handles.inicio
    handles.v = get(hObject,'Value');
    
    if get(handles.cambiar,'Value')
        imshow(handles.V_seg.mascara(:,:,handles.v),[]);
    else
        imshow(handles.V(:,:,handles.v));
    end

    if handles.V_seg.check(handles.v)
        set(handles.edit1,'String','Realizado')
    else
        set(handles.edit1, 'String','No Realizado')
    end
    guidata(hObject, handles);
end

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, ~, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.v = get(hObject,'Value');
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
guidata(hObject,handles)

% --- Executes on button press in Guardar.
function Guardar_Callback(hObject, ~, handles)
% hObject    handle to Guardar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.Prefiltrado
    uiwait(msgbox('Seleccione carpeta para guardar al paciente','Guardar','modal'));
    folder_save = uigetdir();
   % V_seg = handles.V_seg;
    V_seg.vol.orig = handles.V_seg.vol.orig;
    V_seg.mascara = handles.V_seg.mascara;
    V_seg.info = handles.V_seg.info;
    V_seg.puntos = handles.V_seg.puntos;
    V_seg.check = handles.V_seg.check;
    V_seg.vol.filt = handles.V_seg.vol.filt;

    save([folder_save '/' 'Rodilla_'  handles.V_seg.filename],'V_seg')
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
    
    sigma = 0.5;
    handles.V = imgaussfilt3(handles.V,sigma);
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
    
    try
        handles.info{5,1} = infor.PatientAge;
    catch
        handles.info{5,1} = nan;
    end
        
    try
        handles.info{6,1} = infor.PatientSex;
    catch
        handles.info{6,1} = nan;
    end
    
    handles.V_seg.check = zeros(1,size(handles.V,3));
    handles.V_seg.mascara = zeros(size(handles.V));

    set(handles.slider1, 'Min', 1);
    set(handles.slider1, 'Max', size(handles.V,3));
    set(handles.slider1, 'SliderStep', [1/(size(handles.V,3)-1) , 1/(size(handles.V,3)-1) ]);
    set(handles.slider1, 'Value', 10);
    imshow(handles.V(:,:,10))
    handles.Prefiltrado = 0;
    handles.v = 10;
    handles.inicio = 1;
    
    
    set(handles.Empezar, 'Visible', 'on');
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
close all


% --- Executes on button press in Femur_bone.
function Femur_bone_Callback(hObject, eventdata, handles)
% hObject    handle to Femur_bone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    handles.Indice(1) = 1;
else
    handles.Indice(1) = 0;
end
guidata(hObject,handles)

% Hint: get(hObject,'Value') returns toggle state of Femur_bone


% --- Executes on button press in Tibia_bone.
function Tibia_bone_Callback(hObject, eventdata, handles)
% hObject    handle to Tibia_bone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    handles.Indice(3) = 1;
else
    handles.Indice(3) = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of Tibia_bone


% --- Executes on button press in Tibia_fisis.
function Tibia_fisis_Callback(hObject, eventdata, handles)
% hObject    handle to Tibia_fisis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value')
    handles.Indice(4) = 1;
else
    handles.Indice(4) = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of Tibia_fisis


% --- Executes on button press in Femur_fisis.
function Femur_fisis_Callback(hObject, eventdata, handles)
% hObject    handle to Femur_fisis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    handles.Indice(2) = 1;
else
    handles.Indice(2) = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of Femur_fisis


% --- Executes on button press in Perone_bone.
function Perone_bone_Callback(hObject, eventdata, handles)
% hObject    handle to Perone_bone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    handles.Indice(5) = 1;
else
    handles.Indice(5) = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of Perone_bone


% --- Executes on button press in Perone_fisis.
function Perone_fisis_Callback(hObject, eventdata, handles)
% hObject    handle to Perone_fisis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value')
    handles.Indice(6) = 1;
else
    handles.Indice(6) = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of Perone_fisis


% --- Executes on button press in Rotula.
function Rotula_Callback(hObject, eventdata, handles)
% hObject    handle to Rotula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value')
    handles.Indice(7) = 1;
else
    handles.Indice(7) = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of Rotula

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in Guardar.

uiwait(msgbox('Seleccione EL ARCHIVO del paciente a TERMINAR','Success','modal'));
[filename, pathname,~] = uigetfile();

if filename == 0
    return
else
    Load = open([pathname filename]); %todo dentro
    handles.V_seg = Load.V_seg;
    handles.V = handles.V_seg.vol.orig;
    
    %handles.V_seg = Load.V_seg;
    %handles.V = handles.V_seg.vol.orig;

    set(handles.slider1, 'Min', 1);
    set(handles.slider1, 'Max', size(handles.V,3));
    set(handles.slider1, 'SliderStep', [1/(size(handles.V,3)-1) , 1/(size(handles.V,3)-1) ]);
    set(handles.slider1, 'Value', 10);
    imshow(handles.V(:,:,10))
    handles.Prefiltrado = 1;
    handles.v = 10;
    handles.inicio = 1;

    guidata(hObject, handles);
end


    
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cambiar.
function cambiar_Callback(hObject, eventdata, handles)
% hObject    handle to cambiar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.inicio
    
    if get(hObject, 'Value')
       imshow(handles.V_seg.mascara(:,:,handles.v),[]);
    else
        imshow(handles.V(:,:,handles.v));
    end
    
end

% Hint: get(hObject,'Value') returns toggle state of cambiar


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
isosurf_2(handles.V_seg)


% --- Executes on button press in Stephen.
function Stephen_Callback(hObject, eventdata, handles)
% hObject    handle to Stephen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.V_seg = Stephen_final(handles.V_seg);

guidata(hObject, handles);

