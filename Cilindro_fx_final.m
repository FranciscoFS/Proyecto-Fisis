function porc = Cilindro_fx_final(V_seg,alpha,beta,d,p)
%Direccion y distancia

    coordenada = V_seg.info{8};
    
    % 1 = Femur_hueso, 2 = Fisis_femur (indices de la mascara)
    
   % fisis_usar = V_seg.femur.fisis;
    fisis_usar = V_seg.mascara == 2;
   % hueso_usar = V_seg.mascara == 1;
    
    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};

    a1 = beta;% azimut (+ hacia posterior)
    a2 = alpha;% elevacion (+ hacia distal)
    mm = p;%Profundidad
    diametro = d;
    
    [z,x,y] = sph2cart(deg2rad(a1),deg2rad(a2),mm);
    
    %dif_x
    pixeles_x = x/dx;

    %dif_y
    pixeles_y = y/dx;

    %dif_z
    pixeles_z = z/dz;
    
    
    P1 = [coordenada(2),coordenada(1),coordenada(3)];
    P2 = [P1(1)+pixeles_x, P1(2) + pixeles_y, P1(3) + pixeles_z];
    P2 = Aproximar(P2);

    [X, Y, Z] = bresenham_line3d(P1, P2);

    % Cilindro
    radio = diametro/2;
    radio_pix = Aproximar(radio/dx);

    pixeles_ya_sumados = zeros(size(fisis_usar));

    for i = 1:size(Z,2)
        x = Aproximar(X(i));
        y = Aproximar(Y(i));

        p = x - radio_pix : x + radio_pix;
        q = y - radio_pix : y + radio_pix;

            for j = 1:size(p,2)
                
                for t = 1:size(q,2)
                    
                    if (x-p(j))^2 + (y-q(t))^2 <= radio_pix^2
                        
                        if (pixeles_ya_sumados(p(j),q(t),Z(i)) == 0)
                            
                        pixeles_ya_sumados(p(j),q(t),Z(i)) = 1;
                        
                        end
                    end 
                end
            end
    end
    
%     f = figure;
%     hold on
%     fu= smooth3(fisis_usar, 'box', 3);
%     hu = smooth3(hueso_usar,'box', 3);
%     p1= patch(isosurface(fu),'FaceColor','red','EdgeColor','none');
%     p2= patch(isosurface(hu),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
%     p3= patch(isosurface(pixeles_ya_sumados, 0.7),'FaceColor','green','EdgeColor','none');
%     reducepatch(p2,0.01)
%     ax = gca;
%     c = ax.DataAspectRatio;
%     ax.DataAspectRatio= [dz,dz,dx];
%     
%     axis tight
%     l = camlight('headlight');
%     lighting gouraud
%     material dull
%     title('Fisis')
    
    total_de_1s = sum(fisis_usar(:));
    delta = (fisis_usar - pixeles_ya_sumados) == 1;
    total_1s_resta = sum(delta(:));
    porc = ((total_de_1s - total_1s_resta)/total_de_1s)*100;
    
end
