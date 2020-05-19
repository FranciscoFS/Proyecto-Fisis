function V_seg = Trochlear_facet_asymmetry(V_seg)

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

%Linea troclea lateral
if x(3) == x(5)
    x(3) = x(5) +1;
end
if y(3) == y(5)
    y(3) = y(5) +1;
end
P3 = [x(3),y(3)];
P4 = [x(4),y(4)];
P5 = [x(5),y(5)];

syms q2
m2 = (y(5)-y(3))/(x(5)-x(3));
q2 = symfun(m2*(p-x(5))+y(5),[p]);

%Linea troclea medial
if x(4) == x(5)
    x(4) = x(5) +1;
end
if y(4) == y(5)
    y(4) = y(5) +1;
end

syms q3
m3 = (y(5)-y(4))/(x(5)-x(4));
q3 = symfun(m3*(p-x(5))+y(5),[p]);


%Distancias
faceta_lateral = pdist([P3;P5],'euclidean')*V_seg.info{1,1};
faceta_medial = pdist([P4;P5],'euclidean')*V_seg.info{1,1};
trochlear_facet_ratio = (faceta_medial/faceta_lateral)*100

%Plot
imagen_sumada1 = (V_seg.vol.orig(:,:,slc1));

fg = figure;
imshow (imagen_sumada1,[]);
maximize(fg)

hold on
plot([x(1)-50,x(2)+50],[q(x(1)-50),q(x(2)+50)],'LineWidth',1.5,'color', 'w')
plot([x(3)-50,x(5)+50],[q2(x(3)-50),q2(x(5)+50)],'LineWidth',1.5,'color', 'w')
plot([x(4)-50,x(5)+50],[q3(x(4)-50),q3(x(5)+50)],'LineWidth',1.5,'color', 'w')
scatter(x(1),y(1),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(x(2),y(2),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(x(3),y(3),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(x(4),y(4),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(x(5),y(5),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')

%Guardar
V_seg.info{26,1} = [faceta_lateral;faceta_medial;trochlear_facet_ratio];

end
