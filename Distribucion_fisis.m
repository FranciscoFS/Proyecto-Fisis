function Distribucion_fisis
%Distribucion espacial de la fisis promedio

uiwait(msgbox('Seleccione las rodillas de los pacientes a analizar (los .mat)'));

[filename, pathname, filterindex] = uigetfile( ...
{  '*.mat','MAT-files (*.mat)'; ...
   '*.slx;*.mdl','Models (*.slx, *.mdl)'; ...
   '*.*',  'All Files (*.*)'}, ...
  'Seleccione las rodillas de los pacientes a analizar', ...
   'MultiSelect', 'on');

cd;
cd(pathname);

rodillas = {};

for i=1:size(filename,2)
    load(filename{1,i})
    rodillas{i,1} = V_final_fisis;
    rodillas{i,2} = V_final_bones;
    rodillas{i,3} = V_fisis_final_BW;
    rodillas{i,4} = V_bones_final_BW;
    rodillas{i,5} = info;
    rodillas{i,6} = filename;   
end


%1. Girar y rotar las rodillas respecto a su eje principal (femur) y a su
%centro de masa?

%Rotación con respecto a x
Rx = [ 1 0 0 0; 
   0  cos(a1) -sin(a1) 0; 
   0 sin(a1) cos(a1) 0; 
   0 0 0 1 ];

%Rotación con respecto a y
Ry = [ cos(a2) 0 sin(a2) 0; 
   0 1 0 0; 
   -sin(a2) 0 cos(a2) 0; 
   0 0 0 1 ];
%respecto a z                               
Rz = [ cos(a3) -sin(a3) 0 0; 
   sin(a3)  cos(a3) 0 0; 
   0 0 1 0; 
   0 0 0 1 ];

tform = affine3d(Rx*Ry*Rz);
rotado = imwarp(Aqui va la matriz a rotar,tform);



%2. Sumar todas las rodillas

info = rodillas{i,5};
dxdy = info{1,1};
dz= info{2,1};
pace = (1/(dz/dxdy));
[m,n,k] = size(fisis);
[Xq,Yq,Zq] = meshgrid(1:m,1:n,1:pace:k);
Box_size = [3 3 3];

Y =interp3(fisis,Xq,Yq,Zq,'cubic');












esp_pixel = [];
esp_slice = [];

for i=1:size(rodillas,1)
    info = rodillas{i,5};
    espaciado_pixel = info{1,1};
    esp_pixel(i) = espaciado_pixel;
    espaciado_slice= info{2,1};
    esp_slice(i) = espaciado_slice;
end

ancho_mayor=0;
alto_mayor=0;

%Sacar dimensiones maximas
for i=1:size(rodillas,1)
    info = rodillas{i,5};
    espaciado_pixel = info{1,1};
    espaciado_slice= info{2,1};
    tam1 = max(size(rodillas{i,1}))*espaciado_pixel;
    tam2 = min(size(rodillas{i,1}))*espaciado_slice;
    if tam1>ancho_mayor
        ancho_mayor = tam1
    end
    if tam2>ancho_mayor
        alto_mayor = tam2
    end
end
    %entonces las dimensiones serian = ancho_mayor x ancho_mayor x
    %alto_mayor
    
X = repmat(int16(0), [ancho_mayor, ancho_mayor, alto_mayor]);

    


% %Resize
% mayor = 0;
% for i=1:size(rodillas,1)
%     tam = max(size(rodillas{i,1}));
%     if tam>mayor
%         mayor = tam
%     end
% end

%cellsz = cellfun(@size,rodillas,'uni',false);
%cellsz = cellfun(@max,cellsz,'uni',false);

% for i=1:size(rodillas,1)
%     rodillas{i,1} = imresize(rodillas{i,1},[mayor,mayor])
%     rodillas{i,2} = imresize(rodillas{i,2},[mayor,mayor])
% end

end
