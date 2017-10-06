
[filename, pathname, filterindex] = uigetfile( ...
{ %%'*.mat','MAT-files (*.mat)'; ...
   %%'*.slx;*.mdl','Models (*.slx, *.mdl)'; ...
   '*.*',  'All Files (*.*)'}, ...
  'Seleccione las slides a analizar', ...
   'MultiSelect', 'on');
% addpath(getpath(folder));
cd;
cd(pathname);
X = [];

for i=1:size(filename,2)
    im = dicomread(filename{1,i});
    X(:,:,i) = im;
end

info = dicominfo(filename{1,i});
dxdy = info.PixelSpacing;
dz = info.SliceThickness;
nRows = info.Rows;
nCols = info.Columns;
nPlanes = info.SamplesPerPixel;


%%
uiwait(msgbox('Ahora se mostraran las slide. Haga click con el mouse para la siguiente. Presione una tecla para la anterior'));
i = 1;
f = figure;

while i > 0
imshow(X(:,:,i),[]) 
k = waitforbuttonpress;
if k == 0
    i = i+1;
    if i > size(X,3)
        i =size(X,3);
    end
elseif k == 1
    i= i-1;
    if i < 1
        i = 1;
    end
end
end

