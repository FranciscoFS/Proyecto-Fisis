function V_seg = Calculos_BPD(V_seg)

info = V_seg.info{14,1};
x = info{1,1};
y = info{2,1};
slc1 = info{3,1};

syms p q
if x(2) == x(1)
    x(2) = x(2) +1;
end
if y(2) == y(1)
    y(2) = y(2) +1;
end
m1 = (y(2)-y(1))/(x(2)-x(1));

%Linea a
q = symfun(m1*(p-x(1))+y(1),[p]);

%Linea f1
m_perp = -1/m1;
syms q2
q2 = symfun(m_perp*(p-x(3))+y(3),[p]);
x2=solve(q==q2);
y2=q2(x2);

%Linea f2
m_perp = -1/m1;
syms q4
q4 = symfun(m_perp*(p-x(4))+y(4),[p]);
x4=solve(q==q4);
y4=q4(x4);

%Linea b
syms n
n = symfun(m_perp*(p-x(2))+y(2),[p]);

%Linea e
syms q3
q3 = symfun(m1*(p-x(3))+y(3),[p]);

x3=solve(n==q3);
y3=q3(x3);

%Puntos de la linea a
P1 = [x(1),y(1)]; %Punto mas anterior FISIS
P3 = [x(3),y(3)];% CARTILAGO anterior
P4 = [x(4),y(4)];% HUESO anterior
P5 = [eval(x2),eval(y2)]; %Interseccion 1
P6 = [eval(x4),eval(y4)]; %Interseccion 2


fg = figure;
maximize(fg)
imshow ((V_seg.vol.orig(:,:,slc1)),[]);
hold on

plot([x(1),x(2)],[y(1),y(2)],'LineWidth',1.5,'color', 'w')
plot([P3(1),P5(1)],[P3(2),P5(2)],'LineWidth',1.5,'color', 'w')
plot([P5(1),x(1)],[P5(2),y(1)],'LineWidth',1.5,'color', 'w')
%plot([P3(1),x3],[P3(2),y3],'LineWidth',1.5,'color', 'w')
plot([P4(1),x4],[P4(2),y4],'LineWidth',1.5,'color', 'w')
plot([P5(1),P6(1)],[P5(2),P6(2)],'LineWidth',1.5,'color', 'w')
plot([x(5),x(6)],[y(5),y(6)],'LineWidth',1.5,'color', 'w')

scatter(x(1),y(1),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(P5(1),P5(2),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(P4(1),P4(2),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(P5(1),P5(2),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(P6(1),P6(2),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(x(3),y(3),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')

%distancia f1
distf1 = pdist([P3;P5],'euclidean')*V_seg.info{1,1};
%distancia f2
distf2 = pdist([P4;P6],'euclidean')*V_seg.info{1,1};

%distancia g1
distg1 = pdist([P5;P1],'euclidean')*V_seg.info{1,1};

%distancia g2
distg2 = pdist([P6;P1],'euclidean')*V_seg.info{1,1};

%distancia tibia d
dist_tibia = pdist([[x(5),y(5)];[x(6),y(6)]],'euclidean')*V_seg.info{1,1};


V_seg.info{15,1} = {x;y;distf1;distf2;distg1;distg2;dist_tibia};
end
