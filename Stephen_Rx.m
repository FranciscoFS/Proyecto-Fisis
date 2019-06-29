function rx = Stephen_Rx(rx)
im = rx.seg;

%1. Poner los puntos
[row, col] = find(im);
x_ant = min(col);
x_post = max(col);
y_distal = max(row);

P1 = [x_ant,y_distal];
P2 = [x_post,y_distal];

xy = [P1;P2];
d_ant = pdist(xy,'euclidean')*0.59;
d_distal= pdist(xy,'euclidean')*0.51;

P3 = [x_ant + d_ant,y_distal];
P4 = [x_ant + d_ant,y_distal - d_distal];

figure;
imshow(im,[])
hold on
scatter(P1(1),P1(2),100,'o','filled')
scatter(P2(1),P2(2),100,'o','filled')
scatter(P3(1),P3(2),100,'o','filled')
scatter(P4(1),P4(2),100,'o','filled','yellow')

hold on
plot([P1(1),P1(1)],[P1(2)+1000,P1(2)-1000],'LineWidth',3)
plot([P2(1),P2(1)],[P2(2)+1000,P2(2)-1000],'LineWidth',3)
plot([P3(1)-1000,P3(1)+1000],[P3(2),P3(2)],'LineWidth',3)

coord_3D = [Aproximar(P4(1)),Aproximar(P4(2))];
rx.info{8} = coord_3D;
end
