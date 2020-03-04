function [porc,out] = Cilindro_fx_final_tibia(V_seg,beta,delta,d,p,ver,Tal2)

    ang = V_seg.info{10};
    coordenada = V_seg.info{11};

    % 3 = Tibia hueso, 4 = Tibia fisis (indices de la mascara)

    fisis_usar = gpuArray(single(V_seg.mascara == 4));
    hueso_usar = double(V_seg.mascara == 3);

    if ang > 0
        fisis_usar= imrotate3_fast(fisis_usar,{(90-ang) 'Z'});
        hueso_usar= imrotate3_fast(hueso_usar,{(90-ang) 'Z'});
 
    else
        fisis_usar= imrotate3_fast(fisis_usar,{-(90+ang) 'Z'});
        hueso_usar= imrotate3_fast(hueso_usar,{-(90+ang) 'Z'});
    end

    fisis_usar= imrotate3_fast(fisis_usar,{270 'X'});
    hueso_usar= imrotate3_fast(hueso_usar,{270 'X'});
    fisis_usar= imrotate3_fast(fisis_usar,{(270) 'Z'});
    hueso_usar= imrotate3_fast(hueso_usar,{(270) 'Z'});

    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};
    pace = (dx/dz);

    % fisis_nueva = [];
    % hueso_nuevo = [];
    m = size(fisis_usar,1);
    n = size(fisis_usar,3);
    k =size(fisis_usar,2);
    [Xq,Zq,Yq] = meshgrid(1:pace:k,1:m,1:n);
    %[Xq,Zq] = meshgrid(1:pace:k,1:m);

    fisis_nueva = interp3(gather(fisis_usar), Xq,Zq,Yq);
    hueso_nuevo = interp3(hueso_usar,Xq,Zq,Yq);

    % for i = 1:size(fisis_usar,3)
    % h = interp2(hueso_usar(:,:,i),Xq,Zq);
    % f = interp2(fisis_usar(:,:,i),Xq,Zq);
    % fisis_nueva(:,:,i) = f;
    % hueso_nuevo(:,:,i) = h;
    % end

    %vol = fisis_nueva + hueso_nuevo;
    %aplastado_DP = squeeze(sum(vol,3));

    a1 = -beta;% hacia medial
    a2 = -delta;% hacia anterior
    mm = p;% Profundidad
    diametro = d;

    %x aca es medial-lateral (lateral es +) (que en [] es y)
    %y aca es anterior-posterior (posterior +)
    %z aca es distal-proximal

    [z,y,x] = sph2cart(deg2rad(a2),deg2rad(a1),(mm));

    %dif_x
    pixeles_x = Aproximar(x)/(dx);
    %dif_y
    pixeles_y = Aproximar(y)/(dx);
    %dif_z
    pixeles_z = Aproximar(z)/(dx);

    % 
    P1 = [coordenada(2),coordenada(1),coordenada(3)];
    P2 = [P1(1)+pixeles_y, P1(2) + pixeles_x, P1(3) + pixeles_z];
    P2 = Aproximar(P2);

    [X, Y, Z] = bresenham_line3d(P1, P2);

    % Cilindro
    radio = diametro/2;
    radio_pix = Aproximar(radio/(dx));

    pixeles_ya_sumados = zeros(size(fisis_nueva));

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


    if ver
        
        Bb = 21;
        
        pixeles_ya_sumados= imrotate3_fast(pixeles_ya_sumados.*(hueso_nuevo + fisis_nueva),{180 'Y'});
        fisis_nueva= imrotate3_fast(fisis_nueva,{180 'Y'});
        hueso_nuevo= imrotate3_fast(hueso_nuevo,{180 'Y'});
        Tal2 = interp3(Ajustar_angulos(Tal2,ang),Xq,Zq,Yq);
        Femur_hueso = interp3(Ajustar_angulos(double(V_seg.mascara == 1),ang),Xq,Zq,Yq);
        Femur_fisis = interp3(Ajustar_angulos(double(V_seg.mascara == 2),ang), Xq,Zq,Yq);
        

        fu= smooth3(fisis_nueva, 'box', Bb);
        hu = smooth3(hueso_nuevo,'box', Bb);
        Fh = smooth3(Femur_hueso,'box', Bb);
        Ff = smooth3(Femur_fisis,'box', Bb);
        cilindro = smooth3(pixeles_ya_sumados,'box', 9);    
        %Tal2 = smooth3(Tal2,'box', 3);
        
%         p1= patch(isosurface(fu),'FaceColor','none','EdgeColor','yellow','LineWidth',0.1,'EdgeAlpha','0.4');
%         %isonormals(fu,p1)
%         reducepatch(p1,0.05)
%         p2= patch(isosurface(hu),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
%         reducepatch(p2,0.01)
%         p3= patch(isosurface(cilindro, 0.7),'FaceColor','green','EdgeColor','none');
%         isonormals(cilindro,p3)
%         p6 = patch(isosurface(Ff),'FaceColor','none','EdgeColor','yellow','LineWidth',0.1,'EdgeAlpha','0.4');
%         reducepatch(p6,0.05)
%         p4 = patch(isosurface(Fh),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
%         reducepatch(p4,0.01)
%         p5= patch(isosurface(Tal2, 0.7),'FaceColor','green','EdgeColor','none');
%         isonormals(Tal2,p5)
% 
%         axis off
%         set(gcf,'color','white')
%         daspect([1 1 1])
%         camlight('headlight');
%         lighting gouraud
%         material dull
%         view(0,0)

    %    title('Rodilla')

    %     while true
    %         camlight(l,'headlight')
    %         pause(0.05);  
    %     end


    end

    out.fu = fu;
    out.hu = hu;
    out.Fh = Fh;
    out.Ff = Ff;
    out.cilindroT = cilindro;
    out.cilindroF = Tal2;
    
    fisis_nueva = fisis_nueva>0;
    total_de_1s = sum(fisis_nueva(:));
    delta = (fisis_nueva - pixeles_ya_sumados) == 1;
    total_1s_resta = sum(delta(:));
    porc = ((total_de_1s - total_1s_resta)/total_de_1s)*100;
    
end