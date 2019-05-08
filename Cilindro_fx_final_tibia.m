function porc = Cilindro_fx_final_tibia(V_seg,alpha,beta,d,p)
%Direccion y distancia

coordenada = V_seg.info{8};

% 3 = Tibia hueso, 4 = Tibia fisis (indices de la mascara)

fisis_usar = V_seg.mascara == 4;
hueso_usar = V_seg.mascara == 3;

%Girados
hueso_usar2 = imrotate3_fast(hueso_usar,{90 'X'});
fisis_usar = imrotate3_fast(fisis_usar,{Omega eje});

dz = V_seg.info{2,1};
dx = V_seg.info{1,1};
pace = (dx/dz);
hueso_usar = double(hueso_usar);
%Interpolar antes de girar
%im = double(aplastado_DP);
    [m,n,k] = size(hueso_usar);
    [Xq,Yq,Zq] = meshgrid(1:m,1:n,1:pace:k);
    Y =interp3(hueso_usar,Xq,Yq,Zq);
    
%Interpolar despues
[Xq,Zq] = meshgrid(1:pace:k,1:m);
aplastado_DP =interp2(im,Xq,Zq);

a1 = beta;% azimut (+ hacia distal)
a2 = alpha;% horizontal (+ hacia posterior)
mm = p;%Profundidad
diametro = d;

[z,y,x] = sph2cart(deg2rad(a1),deg2rad(a2),mm);

%dif_x
pixeles_x = x/dx;

%dif_y
pixeles_y = y/dx;

%dif_z
pixeles_z = z/dz;


% Dejar "(Y,X,Z)" si desde Stephen llega x,y,z CONFIRMADO NO CAMBIAR
P1 = [coordenada(2),coordenada(1),coordenada(3)];
P2 = [P1(1)+pixeles_y, P1(2) + pixeles_x, P1(3) + pixeles_z];
P2 = Aproximar(P2);

[X, Y, Z] = bresenham_line3d(P1, P2);

% Cilindro
radio = diametro/2;
radio_pix = Aproximar(radio/dz);

pixeles_ya_sumados = zeros(size(fisis_usar));

for i = 1:size(Z,2)
    x = Aproximar(X(i));
    y = Aproximar(Y(i));
    
    p = x - radio_pix : x + radio_pix;
    q = y - radio_pix : y + radio_pix;
    
    for j = 1:size(p,2)
        
        for t = 1:size(q,2)
            
            if (x-p(j))^2 + (y-q(t))^2 <= radio_pix^2
                
                try
                    if (pixeles_ya_sumados(p(j),q(t),Z(i)) == 0)
                        pixeles_ya_sumados(p(j),q(t),Z(i)) = 1;
                    end
                catch
                    continue
                end
            end
        end
    end
end

f = figure;
hold on
fu= smooth3(fisis_usar, 'box', 3);
hu = smooth3(hueso_usar,'box', 3);
p1= patch(isosurface(fu),'FaceColor','red','EdgeColor','none');
p2= patch(isosurface(hu),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
p3= patch(isosurface(pixeles_ya_sumados, 0.7),'FaceColor','green','EdgeColor','none');
reducepatch(p2,0.01)
ax = gca;
c = ax.DataAspectRatio;
ax.DataAspectRatio= [dz,dz,dx];

axis tight
l = camlight('headlight');
lighting gouraud
material dull
title('Fisis')

total_de_1s = sum(fisis_usar(:));
delta = (fisis_usar - pixeles_ya_sumados) == 1;
total_1s_resta = sum(delta(:));
porc = ((total_de_1s - total_1s_resta)/total_de_1s)*100;

end