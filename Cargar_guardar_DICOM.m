%Cargar y guardar en .mat
[filename, pathname] = uigetfile( ...
{ %%'*.mat','MAT-files (*.mat)'; ...
   %%'*.slx;*.mdl','Models (*.slx, *.mdl)'; ...
   '*.*',  'All Files (*.*)'}, ...
  'Seleccione las slides a analizar', ...
   'MultiSelect', 'on');
addpath(pathname);

X = [];
for i=1:size(filename,2)
    im = dicomread(filename{1,i});
    X(:,:,i) = im;
end

V_seg.mascara = X;
info = dicominfo(filename{1,1});
V_seg.info{1,1} = info.PixelSpacing(1);
V_seg.info{2,1} = info.SliceThickness;
V_seg.info{3,1} = info.PatientBirthDate;
V_seg.info{4,1} = info.PatientWeight;
%V_seg.info{5,1} = info.PatientAge;
V_seg.info{6,1} = info.PatientSex;

save('V_seg.mat','V_seg')


           