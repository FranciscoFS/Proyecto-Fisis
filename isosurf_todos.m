function fh = isosurf_todos(V_out,check,data)

    info = V_out.info;

    %Proporciones RM
    if check(6)
        V_out.mascara = imrotate3_fast(V_out.mascara,{90 'X'});
        dxdy = info{1};
        dz = info{2};
        pace = (dxdy/dz);
        [m,n,k] = size(V_out.mascara);
        [Xq,Yq,Zq] = meshgrid(1:n,1:pace:m,1:k);
        Box_size = 9;
    else
        dxdy = info{1};
        dz = info{2};
        pace = (dxdy/dz);
        [m,n,k] = size(V_out.mascara);
        [Xq,Yq,Zq] = meshgrid(1:n,1:m,1:pace:k);
        Box_size = 9;
    end
 
    figure('units','normalized','outerposition',[0 0 1 1])

    %Patch femur fisis
    %ff =interp3(im2double(V_out.mascara==2),Xq,Yq,Zq,'cubic');
    if check(1)
        ff = smooth3(interp3(im2double(V_out.mascara==2),Xq,Yq,Zq,'cubic')...
            ,'box',Box_size);
        %Patch femur hueso
        %fh =interp3(im2double(V_out.mascara==1),Xq,Yq,Zq,'cubic');
        fh = smooth3(interp3(im2double(V_out.mascara==1),Xq,Yq,Zq,'cubic')...
            ,'box',Box_size);
        p1= patch(isosurface(ff,0.4),'FaceColor','red','EdgeColor','none');
        isonormals(ff,p1)
        p2= patch(isosurface(fh,0.2),'FaceColor','none','EdgeColor','blue','LineWidth',...
        0.1,'EdgeAlpha','0.4');
        reducepatch(p2,0.01)
    end
    
    if check(2)
    %Patch tibia fisis
        % tf =interp3(im2double(V_out.mascara==4),Xq,Yq,Zq,'cubic');
        tf = smooth3(interp3(im2double(V_out.mascara==4),Xq,Yq,Zq,'cubic')...
            ,'box',Box_size);
        %Patch tibia hueso
        %th =interp3(im2double(V_out.mascara==3),Xq,Yq,Zq,'cubic');
        th = smooth3(interp3(im2double(V_out.mascara==3),Xq,Yq,Zq,'cubic')...
            ,'box',Box_size);
         p3= patch(isosurface(tf),'FaceColor','green','EdgeColor','none');
        isonormals(tf,p3)
        p4= patch(isosurface(th),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
        isonormals(tf,p3)
        %isonormals(th,p4)
        reducepatch(p4,0.01)
    end
    
    if check(3)
    %Patch perone fisis
        pf =interp3(im2double(V_out.mascara==6),Xq,Yq,Zq,'cubic');
        pf = smooth3(pf,'box',Box_size);
        %Patch perone hueso
         % ph =interp3(im2double(V_out.mascara==5),Xq,Yq,Zq,'cubic');
         ph = smooth3(interp3(im2double(V_out.mascara==5),Xq,Yq,Zq,'cubic')...
        ,'box',Box_size);
         p5= patch(isosurface(pf),'FaceColor','red','EdgeColor','none');
        p6= patch(isosurface(ph),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
        isonormals(pf,p5)
        reducepatch(p6,0.01)
        %Patch rotula
        %r =interp3(im2double(V_out.mascara==7),Xq,Yq,Zq,'cubic');
    end
    
    if check(4) 
         r = smooth3(interp3(im2double(V_out.mascara==7),Xq,Yq,Zq,'cubic')...
        ,'box',Box_size);
        p7= patch(isosurface(r),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
         reducepatch(p7,0.01)
    end
    
    if check(5) && check(6)
        Z3 = Crear_solo_cilindro_test(V_out,fh,data.alpha,data.beta,data.d,data.p);
        Z3 = smooth3(Z3,'box',Box_size);
        Z3 = imrotate3_fast(Z3,{90 'X'});
        p3 = patch(isosurface(Z3,0.5),'FaceColor','green','EdgeColor','none');
        isonormals(Z3,p3);
        
    elseif check(5) && not(check(6))
        Z3 = Crear_solo_cilindro_test(V_out,fh,data.alpha,data.beta,data.d,data.p);
        Z3 = smooth3(Z3,'box',Box_size);
        p3 = patch(isosurface(Z3,0.5),'FaceColor','green','EdgeColor','none');
        isonormals(Z3,p3);
        
    end
    

    %Vista y Luz
    
    view(3)
    axis off
    set(gcf,'color','white')
    daspect([1 1 1])
    l = camlight('headlight');
    lighting gouraud
    material dull
    
%     title('Rodilla')

%     while true
%         camlight(l,'headlight')
%         pause(0.05);  
%     end

end

