function V_seg = Calculos_RM(V_seg,graficar)

info = V_seg.info{10,1};
x = info{1,1};
y = info{2,1};
x_2 = info{3,1};
y_2 = info{4,1};
x_3 = info{5,1};
y_3 = info{6,1};
x_4 = info{7,1};
y_4 = info{8,1};
slc1 = info{9,1};
slc2 = info{10,1};
slc3 = info{11,1};
slc4 = info{12,1};

%Primero TT_TG
%Intercondilos
syms p q
if x(2) == x(1)
    x(2) = x(2) +1;
end
if y(2) == y(1)
    y(2) = y(2) +1;
end
m1 = (y(2)-y(1))/(x(2)-x(1));
q = symfun(m1*(p-x(1))+y(1),[p]);

%Troclea
m_perp = -1/m1;
syms q2
q2 = symfun(m_perp*(p-x(3))+y(3),[p]);
x2=solve(q==q2);
y2=q2(x2);
%Puntos de la linea 1
P3 = [x(3),y(3)];
P4 = [eval(x2),eval(y2)]; %Interseccion 1

%Tibia
syms q2
q2 = symfun(m_perp*(p-x_2(1))+y_2(1),[p]);
x2=solve(q==q2);
y2=q2(x2);
%Puntos de la linea 2
P5 = [x_2(1),y_2(1)];
P6 = [eval(x2),eval(y2)]; %Interseccion 2

% 
if graficar(1)
    
    imagen_sumada1 = ((V_seg.Vol(:,:,slc1)) +  (V_seg.Vol(:,:,slc2)));
    imshow (imagen_sumada1,[]);
    hold on
    plot([x(1),x(2)],[y(1),y(2)],'LineWidth',2)
    plot([x_3(1),x_3(2)],[y_3(1),y_3(2)],'LineWidth',2)
    plot([P3(1),P4(1)],[P3(2),P4(2)],'LineWidth',2)
    plot([P5(1),P6(1)],[P5(2),P6(2)],'LineWidth',2)
    scatter(P4(1),P4(2),100,'o','filled')
    scatter(P6(1),P6(2),100,'o','filled')
    
end

dist1 = pdist([P4;P6],'euclidean')*V_seg.info{1,1};

%Ahora TT_PCL
%Interplatillos
syms p q
if x_3(2) == x_3(1)
    x_3(2) = x_3(1) +1;
end
if y_3(2) == y_3(1)
    y_3(2) = y_3(2) +1;
end
m1 = (y_3(2)-y_3(1))/(x_3(2)-x_3(1));
q = symfun(m1*(p-x_3(1))+y_3(1),[p]);

%LCP
m_perp = -1/m1;
syms q2
q2 = symfun(m_perp*(p-x_3(3))+y_3(3),[p]);
x2=solve(q==q2);
y2=q2(x2);
%Puntos de la linea 1
P3 = [x_3(3),y_3(3)];
P4 = [eval(x2),eval(y2)]; %Interseccion 1

%Tibia
syms q2
q2 = symfun(m_perp*(p-x_2(1))+y_2(1),[p]);
x2=solve(q==q2);
y2=q2(x2);
%Puntos de la linea 2
P5 = [x_2(1),y_2(1)];
P6 = [eval(x2),eval(y2)]; %Interseccion 2


if graficar(2)
    
    imagen_sumada1 = ((V_seg.Vol(:,:,slc3)) + (V_seg.Vol(:,:,slc2)));
    imshow ((imagen_sumada1),[]);
    hold on
    plot([x_3(1),x_3(2)],[y_3(1),y_3(2)],'LineWidth',2)
    plot([P3(1),P4(1)],[P3(2),P4(2)],'LineWidth',2)
    plot([P5(1),P6(1)],[P5(2),P6(2)],'LineWidth',2)
    scatter(P4(1),P4(2),100,'o','filled')
    scatter(P6(1),P6(2),100,'o','filled')
end

dist2 = pdist([P4;P6],'euclidean')*V_seg.info{1,1};


%Ahora SIC_TAC
%Intercondilos
syms p q
if x_4(2) == x_4(1)
    x_4(2) = x_4(1) +1;
end
if y_4(2) == y_4(1)
    y_4(2) = y_4(2) +1;
end
m1 = (y_4(2)-y_4(1))/(x_4(2)-x_4(1));
q = symfun(m1*(p-x_4(1))+y_4(1),[p]);

%Surco
m_perp = -1/m1;
syms q2
q2 = symfun(m_perp*(p-x_4(3))+y_4(3),[p]);
x2=solve(q==q2);
y2=q2(x2);
%Puntos de la linea 1
P3 = [x_4(3),y_4(3)];
P4 = [eval(x2),eval(y2)]; %Interseccion 1

%Tibia
syms q2
q2 = symfun(m_perp*(p-x_2(1))+y_2(1),[p]);
x2=solve(q==q2);
y2=q2(x2);
%Puntos de la linea 2
P5 = [x_2(1),y_2(1)];
P6 = [eval(x2),eval(y2)]; %Interseccion 2

if graficar(3)
    
    imagen_sumada1 = ((V_seg.Vol(:,:,slc4)) + (V_seg.Vol(:,:,slc2)));
    fg2 = figure;
    imshow ((imagen_sumada1),[]);
    hold on
    plot([x_4(1),x_4(2)],[y_4(1),y_4(2)],'LineWidth',2)
    plot([P3(1),P4(1)],[P3(2),P4(2)],'LineWidth',2)
    plot([P5(1),P6(1)],[P5(2),P6(2)],'LineWidth',2)
    scatter(P4(1),P4(2),100,'o','filled')
    scatter(P6(1),P6(2),100,'o','filled')
end

dist3 = pdist([P4;P6],'euclidean')*V_seg.info{1,1};

V_seg.info{11,1} = [dist1;dist3;dist2];

end
