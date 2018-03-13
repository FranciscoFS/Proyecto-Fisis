%% Prueba Nº 1 de Image Registration

N = 2; %Numero de Volumenes a Registrar
Datos = struct();

for k = 1:N
    
    [FileName,PathName,FilterIndex] = uigetfile();
    
    Datos(k).Rodillas = load([PathName FileName]);
    Datos(k).Vol = Datos(k).Rodillas.V_seg.mascara.*(Datos(k).Rodillas.V_seg.mascara<3);
    
end

%%

centerFixed = size(Datos(1).Vol)/2;
centerMoving = size(Datos(2).Vol)/2;
figure
imshowpair(Datos(1).Vol(:,:,centerMoving(3)), Datos(2).Vol(:,:,centerFixed(3)));
title('Unregistered')

%% Registracion Affine moving_reg = imregister(moving,fixed,transformType,optimizer,metric) moving es la que se mueve

% imref3d(imageSize,pixelExtentInWorldX,pixelExtentInWorldY,pixelExtentInWorldZ)

FixRef = imref3d(size(Datos(1).Vol),Datos(1).Rodillas.V_seg.info{1,1},Datos(1).Rodillas.V_seg.info{1,1},Datos(1).Rodillas.V_seg.info{2,1});
MovRef = imref3d(size(Datos(2).Vol),Datos(2).Rodillas.V_seg.info{1,1},Datos(2).Rodillas.V_seg.info{1,1},Datos(2).Rodillas.V_seg.info{2,1});

%a = 1.250000e-02;
%[optimizer,metric] = imregconfig('monomodal');
[optimizer,metric] = imregconfig('monomodal');

%optimizer.MaximumStepLength = a;
Vol_New_1 = imregister(Datos(2).Vol,MovRef, Datos(1).Vol,FixRef, 'affine', optimizer, metric);

%Vol_New_1 = imregister(Datos(2).Vol, Datos(1).Vol, 'affine', optimizer, metric);


%[~,Vol_New_Dem] = imregdemons(Vol_New,Datos(1).Vol);

%% Registracion 'similarity'

a = 3.1250000e-02;
[optimizer,metric] = imregconfig('monomodal');
optimizer.MaximumStepLength = a;
Vol_New_2 = imregister(Datos(2).Vol, Datos(1).Vol, 'similarity', optimizer, metric);
%[~,Vol_New_Dem] = imregdemons(Vol_New,Datos(1).Vol);

%%

centerFixed = size(Datos(1).Vol)/2;
centerMoving = size(Vol_New_1)/2;
figure
imshowpair(Datos(1).Vol(:,:,centerMoving(3)), Vol_New_1(:,:,centerFixed(3)));
title('Registered')
