function Distribucion_fisis
%Distribucion espacial de la fisis promedio
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


% for i=1:size(rodillas,1);
%     for e=1:size(rodillas{i,elegir},3)
%         rodillas{i,elegir}
%     fisis_prom = fisis_prom{ + rodillas{i,elegir};
%     end
% end
% 
% rodillas = rodillas./max(rodillas(:));
% Indice = (rodillas(:) > 0);
% [X,Y,Z] = meshgrid(size(rodillas,1),size(rodillas,2),size(rodillas,3));
% scatter3(X(Indice),Y(Indice),Z(Indice),5,Disk_T(Indice));
% daspect([1 1 1]);
end
