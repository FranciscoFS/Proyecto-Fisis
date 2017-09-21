%1 girar en base al femur, respecto a la slice central usando orientation
%2. Ya teniendo fisis y cortical giradas, llevar rodillas al piso
%3. Ajustar slicethickness y pixelspacing con respecto a las menores
%4. Sumar
%5. Ver

%% 1 CARGAR LAS RODILLAS
clear all
close all
uiwait(msgbox('Seleccione las rodillas de los pacientes a analizar'));

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
    rodillas{i,1} = V_seg.femur.fisis;
    rodillas{i,2} = V_seg.femur.bones;
    rodillas{i,3} = V_seg.perone.fisis;
    rodillas{i,4} = V_seg.perone.bones;
    rodillas{i,5} = V_seg.tibia.fisis;
    rodillas{i,6} = V_seg.tibia.bones;
    %rodillas{i,7} = V_seg.rotula;    
    rodillas{i,8} = V_seg.info;
    rodillas{i,9} = V_seg.filename;
end

%% 2 AJUSTAR slicethickness y pixelspacing 
%Mejor esto primero, sino habria que recalcualarlos despues de girar

pixel = [];
slice = [];
tamano = [];

for i=1:size(rodillas,1)
    [a,~,b] = size(rodillas{i,1});
    tamano(i,1) = a;
    tamano(i,2) = b;
    info = rodillas{i,8};
    pixel(i) = info{1,1};
    slice(i) = info{2,1};
end

xy_max = max(tamano(:,1));
z_max= max(tamano(:,2));
min_dxdy = min(pixel);
min_dz = min(slice);

a2 = xy_max;
b2 = z_max;

for i=1:size(rodillas,1)
    
    v1 = rodillas{i,1};
    v2 = rodillas{i,2};
    v3 = rodillas{i,3};
    v4 = rodillas{i,4};
    v5 = rodillas{i,5};
    v6 = rodillas{i,6};
    %v7 = rodillas{i,7};
    info = rodillas{i,8};
    
    dxdy = info{1,1};
    dz = info{2,1};
    
    razon_dxdy = min_dxdy/dxdy;
    razon_dz = min_dz/dz;
    
    [m,n,k] = size(v1);
    if dxdy > min_dxdy
        [Xq,Yq,Zq] = meshgrid(1 + razon_dxdy:razon_dxdy:m,1 + razon_dxdy:razon_dxdy:n,1:k);
        vol1 = interp3(v1,Xq,Yq,Zq);
        vol2 = interp3(v2,Xq,Yq,Zq);
        vol3 = interp3(v3,Xq,Yq,Zq);
        vol4 = interp3(v4,Xq,Yq,Zq);
        vol5 = interp3(v5,Xq,Yq,Zq);
        vol6 = interp3(v6,Xq,Yq,Zq);
        %vol7 = interp3(v7,Xq,Yq,Zq);
    end

    if dz > min_dz
        [Xq,Yq,Zq] = meshgrid(1:m,1:n,1+razon_dz: razon_dz:k);
        vol1 = interp3(v1,Xq,Yq,Zq);
        vol2 = interp3(v2,Xq,Yq,Zq);
        vol3 = interp3(v3,Xq,Yq,Zq);
        vol4 = interp3(v4,Xq,Yq,Zq);
        vol5 = interp3(v5,Xq,Yq,Zq);
        vol6 = interp3(v6,Xq,Yq,Zq);
        %vol7 = interp3(v7,Xq,Yq,Zq);
    end
    
% Padarray
    [a1,~,b1] = size(v1);
    d1=(a2-a1);
    d2=(b2-b1);
    
    if rem(d1,2)~= 0
        d1 = d1 + 1;
    end
    if rem(d2,2)~= 0
        d2 = d2 + 1;
    end
    d1 = d1/2;
    d2 = d2/2;

    v1_ajust = padarray(vol1,[d1 d1 d2],0,'both');
    v2_ajust = padarray(vol2,[d1 d1 d2],0,'both');
    v3_ajust = padarray(vol3,[d1 d1 d2],0,'both');
    v4_ajust = padarray(vol4,[d1 d1 d2],0,'both');
    v5_ajust = padarray(vol5,[d1 d1 d2],0,'both');
    v6_ajust = padarray(vol6,[d1 d1 d2],0,'both');
    %v7_ajust = padarray(vol1,[d1 d1 d2],0,'both');

    rodillas{i,1} = v1_ajust;
    rodillas{i,2} = v2_ajust;
    rodillas{i,3} = v3_ajust;
    rodillas{i,4} = v4_ajust;
    rodillas{i,5} = v5_ajust;
    rodillas{i,6} = v6_ajust;
    %rodillas{i,7} = v7_ajust;

end

%% 3 GIRAR RODILLAS (a partir de imagen central y eje mecanico)

for i=1:size(rodillas,1)
    porte_V = size(rodillas{i,4},3);
    V = rodillas{i,5};
    imshow(V(:,:,size/2,[]);
    
    %Dibujar "circulos"
    
    uiwait(msgbox('Ingrese dos puntos para el primer circulo, con el ultimo haga doble click'));
    [X1,Y1] = getpts();
    
    uiwait(msgbox('Ingrese dos puntos para el segundo circulo, con el ultimo haga doble click'));
    [X2,Y2] = getpts();
    
    %Punto medio
    centro1 = [(X1(1)+X1(2))/2,(Y1(1)+Y1(2))/2];
    centro2 = [(X2(1)+X2(2))/2,(Y2(1)+Y2(2))/2];
    
    angulo = atan(abs(centro1(1)-centro2(1))/abs(centro1(2)-centro2(2)));
   
    %Linea
    %sacar angulo a girar
    rodillas{i,1} = imrotate3(rodillas{i,1},angulo);
    rodillas{i,2} = imrotate3(rodillas{i,2},angulo);
    rodillas{i,3} = imrotate3(rodillas{i,3},angulo);
    rodillas{i,4} = imrotate3(rodillas{i,4},angulo);
end

%% 4 LLEVAR AL PISO

for i=1:size(rodillas,1)
    v1 = rodillas{i,1};
    v2 = rodillas{i,2};
    v3 = rodillas{i,3};
    v4 = rodillas{i,4};
    [m,n,k] = size(v1);
    
    %Punto mas bajo
    fila_baja = 0;
    for a=1:size(v1,3)
        im = v1(:,:,a);
        [row, ~] = find(im);
        lowestrow = max(row);
        if lowestrow >fila_baja
            fila_baja = lowestrow;
        end
    end
    
    %imcrop
	rodillas{i,1} = v1(1:fila_baja,1:n,1:k);
    rodillas{i,2} = v2(1:fila_baja,1:n,1:k);
    rodillas{i,3} = v3(1:fila_baja,1:n,1:k);
    rodillas{i,4} = V4(1:fila_baja,1:n,1:k);

end

%% SUMAR
ff_suma = [];
fh_suma = [];
tf_suma = [];
th_suma = [];
pf_suma = [];
ph_suma = [];
r_suma = [];
    
for i=1:size(rodillas,1)
    ff_suma = ff_suma + rodillas{i,1};
    fh_suma = fh_suma + rodillas{i,2};
    tf_suma = tf_suma + rodillas{i,3};
    th_suma = th_suma + rodillas{i,4};
    pf_suma = pf_suma + rodillas{i,5};
    ph_suma = ph_suma + rodillas{i,6};
    r_suma = r_suma + rodillas{i,7};
end

