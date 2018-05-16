function porc = Cilindro_fx_final(V_seg,alpha,beta)
%Dirección y distancia

coordenada = handles.info{8,1};

fisis_usar = V_seg.femur.fisis;
hueso_usar = V_seg.femur.bones;

dz = V_seg.info{2,1};
dx = V_seg.info{1,1};

a1 = alpha;
a2 = beta;
mm = 30;%Profundidad
diametro = 2;

%profundidad
prof = cosd((a2))*mm;
pixeles_z = prof/dz;

%elevacion
elevacion = sind((a2))*mm;
pixeles_y = elevacion/dx;

%traslacion
tras = tand((a1))*prof;
pixeles_x = tras/dx;


P1 = coordenada;
P2 = [P1(1)+pixeles_x, P1(2) + pixeles_y, P1(3) + pixeles_z];
P2 = Aproximar(P2);

[X, Y, Z] = bresenham_line3d(P1, P2);

% Cilindro
radio = diametro/2;
radio_pix = Aproximar(radio/dx);

contador = 0;
total_de_1s = sum(fisis_usar(:) == 1);


% f = figure;
% hold on
% fu= smooth3(fisis_usar);
% hu = smooth3(hueso_usar);
% p1= patch(isosurface(fu),'FaceColor','red','EdgeColor','none');
% p2= patch(isosurface(hu),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
% reducepatch(p2,0.01)
pixeles_ya_sumados = zeros(size(fisis_usar));

% ax = gca;
% c = ax.DataAspectRatio;
% ax.DataAspectRatio= [dz,dz,dx];


for i = 1:size(Z,2)
    im = fisis_usar(:,:,Z(i));

    x = Aproximar(X(i));
    y = Aproximar(Y(i));
   
    p = x - radio_pix : x + radio_pix;
    q = y - radio_pix : y + radio_pix;

    for j = 1:size(p,2)
    for t = 1:size(p,2)
    if (x-p(j)).^2 + (y-q(t)).^2 <= radio_pix.^2
        if (pixeles_ya_sumados(p(j),q(t),Z(i)) == 0)
            pixeles_ya_sumados(p(j),q(t),Z(i)) = 1;
            if (im(p(j),q(t)) > 0)
                contador = contador + 1;
            end 
        end
               
    end 
    end
    end
end

porc = (contador/total_de_1s)*100;
%uiwait(msgbox({'Se ha perforado un ' num2str(porc) '% de la fisis'}));

end
