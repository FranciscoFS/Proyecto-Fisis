function V_seg = Calculos_xyz(V_seg)

info = V_seg.info{10,1};

x = info{1,1};
y = info{2,1};
slc1 = info{3,1};

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

%x
m_perp = -1/m1;
syms q2
q2 = symfun(m_perp*(p-x(3))+y(3),[p]);
x2=solve(q==q2);
y2=q2(x2);
%Puntos de la linea 1
P3 = [x(3),y(3)];
P4 = [eval(x2),eval(y2)]; %Interseccion x

%y
syms q2
q2 = symfun(m_perp*(p-x(4))+y(4),[p]);
x2=solve(q==q2);
y2=q2(x2);
%Puntos de la linea 2
P5 = [x(4),y(4)];
P6 = [eval(x2),eval(y2)]; %Interseccion y

%z
syms q2
q2 = symfun(m_perp*(p-x(5))+y(5),[p]);
x2=solve(q==q2);
y2=q2(x2);
%Puntos de la linea 2
P7 = [x(5),y(5)];
P8 = [eval(x2),eval(y2)]; %Interseccion z

imagen_sumada1 = (V_seg.vol.orig(:,:,slc1));

fg = figure;
imshow (imagen_sumada1,[]);
maximize(fg)

hold on
plot([x(1)-100,x(2)+100],[q(x(1)-100),q(x(2)+100)],'LineWidth',1.5,'color', 'w')
plot([P3(1),P4(1)],[P3(2),P4(2)],'LineWidth',1.5,'color', 'w')
plot([P5(1),P6(1)],[P5(2),P6(2)],'LineWidth',1.5,'color', 'w')
plot([P7(1),P8(1)],[P7(2),P8(2)],'LineWidth',1.5,'color', 'w')

scatter(x(1),y(1),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(x(2),y(2),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(x(3),y(3),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(x(4),y(4),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(x(5),y(5),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')

% scatter(P4(1),P4(2),50,'o','filled','color', 'w')
% scatter(P6(1),P6(2),50,'o','filled','color', 'w')
% scatter(P8(1),P8(2),50,'o','filled','color', 'w')

distx = pdist([P3;P4],'euclidean')*V_seg.info{1,1};
disty = pdist([P5;P6],'euclidean')*V_seg.info{1,1};
distz = pdist([P7;P8],'euclidean')*V_seg.info{1,1};
profundidad_troclear = ((distx+disty)/2)-distz;

tam_axial = size(V_seg.vol.orig,1);

V_seg.info{11,1} = [distx;disty;distz;profundidad_troclear;tam_axial];

end
