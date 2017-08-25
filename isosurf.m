function isosurf(V_final_BW,V_final,info)

message = sprintf('Que quiere cargar?');
reply = questdlg(message,'Fisis', 'V_final de workspace', 'Desde un archivo', 'No');

if strcmpi(reply, 'Desde un archivo')
        [filename, pathname] = uigetfile({'*.mat';'*.m';'*.slx';'*.*'},'Seleccione las fisis a analizar');
        load(filename)
end

% Falta la info del DICOM para poder plotearlo con las proporciones correctas
message = sprintf('Plot?');
reply = questdlg(message, 'Physis', 'V_final_BW', 'V_final','No');

fig = figure;
if strcmpi(reply, 'V_final_BW')
    isosurface(V_final_BW)
elseif strcmpi(reply, 'V_final')
    isosurface(V_final)
end

%AspectRatio

if exist('info') == 1
    dxdy = info.PixelSpacing{1};
    dz = info.SliceThickness;
else
    dxdy = inputdlg('Ingrese dxdy');
    dxdy = str2double(dxdy);
    dz = inputdlg('Ingrese dz');
    dz = str2double(dz);
%     dx 0.4688 dz 3
    
end
ax = gca;
c = ax.DataAspectRatio;
ax.DataAspectRatio= [dz,dz,dxdy];

l = camlight('headlight');
axis tight
grid on;
end