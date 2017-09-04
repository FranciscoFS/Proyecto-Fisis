%1 girar en base al femur, respecto a la slice central usando orientation
%(region props)
%z que es el femur, en matlab es y
%2. Ya teniendo fisis y cortical giradas, llevar rodillas al piso
%3. Ajustar slicethickness y pixelspacing con respecto a las menores
%4. Sumar
%5. Ver
%% Girar 



%% SUMA DE FISIS
dxdy2 = 0.4688; dz2 = 3;
dxdy= 0.293; dz =3.5;

razon_dxdy = dxdy/dxdy2;
razon_dz = dz2/dz;

[m1,n1,k1] = size(Fisis1);
[Xq1,Yq1,Zq1] = meshgrid(1:m1,1:n1,1+razon_dz: razon_dz:k1);

V1 = interp3(Fisis1,Xq1,Yq1,Zq1);

[m2,n2,k2] = size(Fisis2);
[Xq2,Yq2,Zq2] = meshgrid(1 + razon_dxdy:razon_dxdy:m2,1 + razon_dxdy:razon_dxdy:n2,1:k2);

V2 = interp3(Fisis2,Xq2,Yq2,Zq2);


%% Arreglos

[a1,~,b1] = size(V1);
[a2,~,b2] = size(V2);

V1_ajust = padarray(V1,[(a2-a1)/2 (a2-a1)/2 (b2-b1)/2],0,'both');
