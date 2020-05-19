function V_seg = Inclinacion_troclear_lateral(V_seg)

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

syms q2
m2 = (y(5)-y(3))/(x(5)-x(3));
q2 = symfun(m2*(p-x(5))+y(5),[p]);

angulo = atand(abs((m1-m2)/(1+m1*m2)));

imagen_sumada1 = (V_seg.vol.orig(:,:,slc1));

fg = figure;
imshow (imagen_sumada1,[]);
maximize(fg)

hold on
plot([x(1)-50,x(2)+50],[q(x(1)-50),q(x(2)+50)],'LineWidth',1.5,'color', 'w')
plot([x(3)-50,x(5)+50],[q2(x(3)-50),q2(x(5)+50)],'LineWidth',1.5,'color', 'w')
scatter(x(1),y(1),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(x(2),y(2),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(x(3),y(3),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
scatter(x(5),y(5),50,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')

V_seg.info{25,1} = [angulo];

end
