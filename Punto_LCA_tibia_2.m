function V_seg = Punto_LCA_tibia_2(V_seg)
%Rodillas: 0 medial y terminan en lateral


a = V_seg.mascara ==3; %hueso
b = V_seg.mascara ==4;%fisis
vol = a+b;
%LM: lateral medial
aplastado_LM = squeeze(sum(vol,3));
imshow(aplastado_LM,[])
uiwait(msgbox('Poner un punto donde comienza la tuberosidad de la tibia (de proximal a distal)'));
[X1,Y1] = getpts();
close

%Cortar

vol2 = vol(1:Aproximar(Y1),1:size(vol,1),1:size(vol,3));
aplastado_LM = squeeze(sum(vol2,3));
%imshow(aplastado_LM,[])
%uiwait(msgbox('Tibia cortada'));

vol2 = imrotate3_fast(vol2,{270 'X'});
vol2 = imrotate3_fast(vol2,{270 'Z'});

%DP: distal proximal

%ANTES
%aplastado_DP = squeeze(sum(vol2,1));

%NO es necesario, solo para mostrar
dz = V_seg.info{2,1};
dx = V_seg.info{1,1};
pace = (dx/dz);

%     im = double(aplastado_DP);
%     [m,k] = size(im);
%     [Xq,Zq] = meshgrid(1:pace:k,1:m);
%     aplastado_DP =interp2(im,Xq,Zq);

vol_nuevo = [];
m = size(vol2,1);
k = size(vol2,2);
n = size(vol2,3);
[Xq,Zq] = meshgrid(1:pace:k,1:m);

for i = 1:size(vol2,3)
    v = interp2(vol2(:,:,i),Xq,Zq);
    vol_nuevo(:,:,i) = v;
end
aplastado_DP = squeeze(sum(vol_nuevo,3));


%AP=25%±2.8% ML=50.5%±4.2% AP=46.4%±3.7% ML=52.4%±2.5%


%figure, imshow(aplastado_DP,[])
%hold on

[row, col] = find(aplastado_DP);
x_medial = min(col);
x_lateral = max(col);
dx = x_lateral-x_medial;
dx_x = dx*(0.505+0.524)/2;
x_final = x_medial+dx_x;

y_anterior = min(row);
y_posterior = max(row);
dy = y_posterior-y_anterior;
dy_x = dy*(0.25+0.464)/2;
y_final = y_anterior + dy_x;

%scatter(x_final,y_final,100,'o','filled')

%x aca es medial-lateral (que en [] es y)
%y aca es anterior-posterior
%z aca es distal-proximal

encontrado = 0;

contador = 1;

while (contador <= size(vol_nuevo,3)  && encontrado ==0)
    if vol_nuevo(Aproximar(y_final),Aproximar(x_final),contador)>0
        coord_3D = [Aproximar(x_final),Aproximar(y_final), contador];
        coord_3D = double(coord_3D);
        uiwait(msgbox('PUNTO ENCONTRADO'));
        encontrado =1;
    end
    contador = contador+1;
end

V_seg.info{11} = coord_3D;

close(gcf)
    

end