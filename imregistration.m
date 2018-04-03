%% Prueba Nº 1 de Image Registration

N = 4; %Numero de Volumenes a Registrar
Datos = struct();

for k = 1:N
    
    [FileName,PathName,FilterIndex] = uigetfile();
    
    Datos(k).Rodillas = load([PathName FileName]);
    Datos(k).Vol = Datos(k).Rodillas.V_seg.mascara.*(Datos(k).Rodillas.V_seg.mascara<3);
    
end

% Value = 1 = Femur
% Value = 2 = Fisis

%% Seleccionar uno como referencia

Ref = 2;
List = 1:size(Datos,2);
List(Ref) = [];
centerFixed = round(size(Datos(Ref).Vol)/2);
figure;

for k=1:length(List)
    
    centerMoving = round(size(Datos(List(k)).Vol)/2);
    subplot(1,3,k);
    imshowpair(Datos(List(k)).Vol(:,:,centerMoving(3)), Datos(Ref).Vol(:,:,centerFixed(3)));
    title('Unregistered')
end

%% Multi Vol Registration

Fix_ref = imref3d(size(Datos(Ref).Vol),Datos(Ref).Rodillas.V_seg.info{1,1},Datos(Ref).Rodillas.V_seg.info{1,1},Datos(Ref).Rodillas.V_seg.info{2,1});
Datos(Ref).VolM = Datos(Ref).Vol;


for k=1:length(List)
    
    Index = List(k);
    
    MovRef = imref3d(size(Datos(Index).Vol),Datos(Index).Rodillas.V_seg.info{1,1},Datos(Index).Rodillas.V_seg.info{1,1},Datos(Index).Rodillas.V_seg.info{2,1});
    
    fprintf('Empezando Vol Registration..... %d/%d \n', k ,length(List));
    Datos(Index).VolM = Vol_registration(Datos(List(k)).Vol, MovRef, Datos(Ref).Vol, Fix_ref); 
    fprintf('Terminado Vol %d/%d \n', k ,length(List));
    
end




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

figure;

for k=1:length(List)
    
    centerMoving = round(size(Datos(List(k)).Vol)/2);
    subplot(1,3,k);
    imshowpair(Datos(List(k)).VolM(:,:,centerFixed(3)), Datos(Ref).VolM(:,:,centerFixed(3)));
    title('Registered')
end

