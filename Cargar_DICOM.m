%Seleccionar todos los archivos en la carpeta

[filename, pathname] = uigetfile( ...
{ %%'*.mat','MAT-files (*.mat)'; ...
   %%'*.slx;*.mdl','Models (*.slx, *.mdl)'; ...
   '*.*',  'All Files (*.*)'}, ...
  'Seleccione las slides a analizar', ...
   'MultiSelect', 'on');

addpath(pathname);

%Rodilla UC 0 es coronal,
%Rodilla UC 2 es sagital,
%Rodilla UC 4 es axial

X = [];
for i=1:size(filename,2)
    im = dicomread(filename{1,i});
    X(:,:,i) = im;
end

V_seg.vol.orig = X;
info = dicominfo(filename{1,1});
V_seg.info{1,1} = info.PixelSpacing(1);
V_seg.info{2,1} = info.SliceThickness;
V_seg.info{3,1} = info.PatientBirthDate;
V_seg.info{4,1} = info.PatientWeight;
%V_seg.info{5,1} = info.PatientAge;
%V_seg.info{6,1} = info.PatientSex;
V_seg.info{7,1} = info.SpacingBetweenSlices;

%% Si es que se cargan cortes AXIALES
figure
plot_MRI(V_seg.vol.orig)
message = sprintf('El perone esta a la IZQUIERDA DE LA IMAGEN (en otras palabras es una rodilla DERECHA)?');
reply = questdlg(message, 'Physis', 'Yes', 'No','No');
close all
if strcmpi(reply, 'No')
    V_seg = Mirror(V_seg);
end

prompt = {'Nombre a ponerle al archivo'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'Nueva Rodilla'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

uiwait(msgbox('Seleccione carpeta para guardar al paciente','Guardar','modal'));
folder_save = uigetdir();
save([folder_save '/' char(answer)],'V_seg')
