function [porc] = Cilindro_fx_final_LCA_3D(hueso_usar,fisis_usar,alpha,gamma,d,Opciones)
%Direccion y distancia

%     Opciones{1} = Xq;
%     Opciones{2} = Yq;
%     Opciones{3} = Zq;
%     Opciones{4} = 0; %Ver
%     Opciones{5} = 1; %Medio
%     Opciones{6} = Rodilla.info; %info
    
    info = Opciones{6};
    medio = Opciones{5};
    ver = Opciones{4};
    
    if medio

        coordenada = info{12}/2;
        dz =info{2,1}*2;
        dx =info{1,1}*2;
        pace = dx/dz;
        Diametro = d;
        radio = (2/dx)*(Diametro/2); 
        
    else
     
        coordenada = info{12};
        dz = info{2,1};   
        dx = info{1,1};
        pace = dx/dz;
        radio = d/2;
        radio = radio/dx;
    end
    
    
    [~,~,v1] = ind2sub(size(hueso_usar),find(hueso_usar > 0));
    Mid = round((max(v1)+min(v1))/2);
    vol = hueso_usar(1:size(hueso_usar,1),1:size(hueso_usar,1),Mid: size(hueso_usar,3));
    
    encontrado = 0;
    contador = 1;
    
    while (contador <= size(vol,3) && encontrado ==0)
   
        if vol(Aproximar(coordenada(2)),Aproximar(coordenada(1)),contador)>0
            
            coord_3D = [Aproximar(coordenada(1)),Aproximar(coordenada(2)),Mid + contador];
            encontrado =1;
            
        end
        contador = contador+1;
    end

    coordenada = coord_3D;

    
    [m,n,k] = size(hueso_usar); 
    Xx = Opciones{1};
    Yy = Opciones{2};
    
    Cilindro = single(((Xx-m/2).^2 + (Yy-n/2).^2 <= radio^2));
    %imshow(Cilindro(:,:,coordenada(3)))
    
    CilindroR = imrotate3_fast(single(Cilindro),{-1*alpha 'X'},'cubic'); 
    CilindroR = imrotate3_fast(single(CilindroR),{gamma 'Y'},'cubic'); 
    
%    imshow(CilindroR(:,:,coordenada(3)))
    %figure;
%     imshow(CilindroR(:,:,size(CilindroR,3)/2))    
%     figure;
%     imshow(CilindroR(:,:,coordenada(3)))
     
    Traslacion = [coordenada(1)-(m/2), coordenada(2)-(n/2),coordenada(3)-size(Cilindro,3)/2];
    CilindroR = imtranslate(CilindroR,Traslacion);
     
    figure;
    imshow(CilindroR(:,:,coordenada(3)))
    %fisis_usar = imtranslate(fisis_usar,-1*Traslacion);
    %hueso_usar = imtranslate(hueso_usar,-1*Traslacion);
   
    fisis_usar = fisis_usar > 0.5;
    CilindroR2 = CilindroR > 0;
        figure;
    imshow(fisis_usar(:,:,coordenada(3)+50)-(CilindroR(:,:,coordenada(3)+50))==1,[])
    figure;
    imshow(fisis_usar(:,:,coordenada(3)+50)-(CilindroR2(:,:,coordenada(3)+50))==1,[])
    total_de_1s = sum(fisis_usar(:));
    delta = (fisis_usar - CilindroR2) == 1;
    total_1s_resta = sum(delta(:));
    porc = ((total_de_1s - total_1s_resta)/total_de_1s)*100
    

    if ver
        
        figure
        p1= patch(isosurface(fisis_usar),'FaceColor','none','EdgeColor','red');
        p2= patch(isosurface(hueso_usar),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
        reducepatch(p2,0.01)
        p3= patch(isosurface(CilindroR, 0.25),'FaceColor','green','EdgeColor','none');
        %Cylinder([P1(2) P1(1) P1(3)],[P2(2) P2(1) P2(3)],radio_pix,22,'b',1,0)
        
        %scatter3(P1(2),P1(1),P1(3),'red','filled'); 
        %scatter3(P2(2),P2(1),P2(3),'yellow');
        
    
        axis on
        l = camlight('headlight');
        daspect([1 1 1])
        lighting gouraud
        material dull
        title('Fisis')
        view(0,0)
        
        title('Rodilla')

        while true
            camlight(l,'headlight')
            pause(0.05);  
        end

    end
         
end
    
