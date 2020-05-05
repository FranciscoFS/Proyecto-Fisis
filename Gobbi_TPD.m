function Gobbi_TPD()
uiwait(msgbox('Seleccione la secuencia SAGITAL del paciente','Guardar','modal'));
[filename, pathname] = uigetfile();
V_seg = importdata([pathname filename]);

uiwait(msgbox('Seleccione la secuencia AXIAL del paciente','Guardar','modal'));
[filename, pathname] = uigetfile();
V_seg_1 = importdata([pathname filename]);

%V_seg_1 seria el volumen axial, que incluye los datos y posiciones de XYZ
info = V_seg_1.info{10,1};
x = info{1,1};
y = info{2,1};

tam_sag = size(V_seg.vol.orig,3);

info2 = V_seg_1.info{11,1};
tam_axial = info2(5,1);


slc_x = tam_sag - Aproximar((x(3)*tam_sag)/(tam_axial(1,1))); %+1
slc_y = tam_sag - Aproximar((x(4)*tam_sag)/(tam_axial(1,1))); %-1
slc_z = tam_sag - Aproximar((x(5)*tam_sag)/(tam_axial(1,1)));


uiwait(msgbox('Primero una línea para la cortical anterior (2 puntos); Luego: 1 punto en sitio de llegada de fisis a cortical anterior; 1 punto en sitio mas proximal de CARTILAGO troclear; FINALMENTE dos puntos para la distancia AP tibial (d)'));

n = 1;
while n <4
    
    if n ==1
        uiwait(msgbox('X'));
        f1 = figure;
        imshow(V_seg.vol.orig(:,:,slc_x),[])
        maximize(f1)
        [x1,y1] = getpts();
        P1 = [x1,y1];
        
        syms p a1
        if x1(2) == x1(1)
            x1(2) = x1(2) +1;
        end
        if y1(2) == y1(1)
            y1(2) = y1(2) +1;
        end
        m1 = (y1(2)-y1(1))/(x1(2)-x1(1));
        
        %Linea a
        a1 = symfun(m1*(p-x1(1))+y1(1),[p]);
        
        %Linea b
        m_perp = -1/m1;
        syms b1
        b1 = symfun(m_perp*(p-x1(3))+y1(3),[p]);
        xb=solve(a1==b1);
        yb=b1(xb);
        
        %Linea c
        syms c1
        c1 = symfun(m_perp*(p-x1(4))+y1(4),[p]);
        xc=solve(a1==c1);
        yc=c1(xc);
        
        
        %Linea d
        d_x = pdist([[x1(5),y1(5)];[x1(6),y1(6)]],'euclidean')*V_seg.info{1,1};
        
        %TPD
        TPD_x = pdist([[xb,yb];[xc,yc]],'euclidean')*V_seg.info{1,1};
        
        f2 = figure;
        imshow(V_seg.vol.orig(:,:,slc_x),[])
        maximize(f2)
        hold on
        plot([x1(1)-50,x1(2)+50],[a1(x1(1)-50),a1(x1(2)+50)],'LineWidth',1.5,'color', 'w')
        plot([xb-100,xb+100],[b1(xb-100),b1(xb+100)],'LineWidth',1.5,'color', 'w')
        plot([xc-100,xc+100],[c1(xc-100),c1(xc+100)],'LineWidth',1.5,'color', 'w')
        plot([x1(5),x1(6)],[y1(5),y1(6)],'LineWidth',1.5,'color', 'w')
        
        
        %         scatter(x1(4),y1(4),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
        %         scatter(x1(3),y1(3),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
    end
    
    if n ==2
        f3 = figure;
        uiwait(msgbox('Y'));
        imshow(V_seg.vol.orig(:,:,slc_y),[])
        maximize(f3)
        [x1,y1] = getpts();
        P2 = [x1,y1];
        
        syms p a1
        if x1(2) == x1(1)
            x1(2) = x1(2) +1;
        end
        if y1(2) == y1(1)
            y1(2) = y1(2) +1;
        end
        m1 = (y1(2)-y1(1))/(x1(2)-x1(1));
        
        %Linea a
        a1 = symfun(m1*(p-x1(1))+y1(1),[p]);
        
        %Linea b
        m_perp = -1/m1;
        syms b1
        b1 = symfun(m_perp*(p-x1(3))+y1(3),[p]);
        xb=solve(a1==b1);
        yb=b1(xb);
        
        %Linea c
        syms c1
        c1 = symfun(m_perp*(p-x1(4))+y1(4),[p]);
        xc=solve(a1==c1);
        yc=c1(xc);
        
        %Linea d
        d_y = pdist([[x1(5),y1(5)];[x1(6),y1(6)]],'euclidean')*V_seg.info{1,1};
        
        %TPD
        TPD_y = pdist([[xb,yb];[xc,yc]],'euclidean')*V_seg.info{1,1};
        
        f4 = figure;
        imshow(V_seg.vol.orig(:,:,slc_y),[])
        maximize(f4)
        hold on
        plot([x1(1)-50,x1(2)+50],[a1(x1(1)-50),a1(x1(2)+50)],'LineWidth',1.5,'color', 'w')
        plot([xb-100,xb+100],[b1(xb-100),b1(xb+100)],'LineWidth',1.5,'color', 'w')
        plot([xc-100,xc+100],[c1(xc-100),c1(xc+100)],'LineWidth',1.5,'color', 'w')
        plot([x1(5),x1(6)],[y1(5),y1(6)],'LineWidth',1.5,'color', 'w')
        
        %         scatter(x1(4),y1(4),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
        %         scatter(x1(3),y1(3),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
        
    end
    
    if n ==3
        f5= figure;
        uiwait(msgbox('Z'));
        imshow(V_seg.vol.orig(:,:,slc_z),[])
        maximize(f5)
        [x1,y1] = getpts();
        P3 = [x1,y1];
        
        syms p a1
        if x1(2) == x1(1)
            x1(2) = x1(2) +1;
        end
        if y1(2) == y1(1)
            y1(2) = y1(2) +1;
        end
        m1 = (y1(2)-y1(1))/(x1(2)-x1(1));
        
        %Linea a
        a1 = symfun(m1*(p-x1(1))+y1(1),[p]);
        
        %Linea b
        m_perp = -1/m1;
        syms b1
        b1 = symfun(m_perp*(p-x1(3))+y1(3),[p]);
        xb=solve(a1==b1);
        yb=b1(xb);
        
        %Linea c
        syms c1
        c1 = symfun(m_perp*(p-x1(4))+y1(4),[p]);
        xc=solve(a1==c1);
        yc=c1(xc);
        
        %Linea d
        d_z = pdist([[x1(5),y1(5)];[x1(6),y1(6)]],'euclidean')*V_seg.info{1,1};
        
        %TPD
        TPD_z = pdist([[xb,yb];[xc,yc]],'euclidean')*V_seg.info{1,1};
        
        f6 = figure;
        imshow(V_seg.vol.orig(:,:,slc_z),[])
        maximize(f6)
        hold on
        plot([x1(1)-50,x1(2)+50],[a1(x1(1)-50),a1(x1(2)+50)],'LineWidth',1.5,'color', 'w')
        plot([xb-100,xb+100],[b1(xb-100),b1(xb+100)],'LineWidth',1.5,'color', 'w')
        plot([xc-100,xc+100],[c1(xc-100),c1(xc+100)],'LineWidth',1.5,'color', 'w')
        plot([x1(5),x1(6)],[y1(5),y1(6)],'LineWidth',1.5,'color', 'w')
        
        %         scatter(x1(4),y1(4),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
        %         scatter(x1(3),y1(3),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
        
    end
    
    n=n+1;
end
V_seg_1.info{12,1} = {P1;P2;P3};
V_seg_1.info{13,1} = [TPD_x;TPD_y;TPD_z;d_x;d_y;d_z];

save([pathname filename],'V_seg_1')

close all
end
