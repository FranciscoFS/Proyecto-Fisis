function Proyeccion_coronal(V_seg)
%----------COMUN:
%V_seg = Rotar(V_seg,90,'Y');
V_seg = Rotar_fisis(V_seg,90,'Y');
%a = double(V_seg.mascara ==1); %hueso
b = double(V_seg.mascara ==2); %fisis
vol = b;

%vol = a+2.*b;

%-----------Si volumen coronal es solo:
% aplastado = squeeze(sum(vol,3));

%-----------Si volumen sagital
dz = V_seg.info{2,1};
dx = V_seg.info{1,1};
pace = (dx/dz);
vol_nuevo = [];
m = size(vol,1);
k = size(vol,2);
[Xq,Zq] = meshgrid(1:pace:k,1:m);
for i = 1:size(vol,3)
    v = interp2(vol(:,:,i),Xq,Zq);
    vol_nuevo(:,:,i) = v;
end
aplastado = squeeze(sum(vol_nuevo,3));

%----------------------------------------

f1 = figure;
imshow(aplastado,[])
maximize(f1);

f2 = figure;
imshow(aplastado,[])
colormap(jet(256));
colorbar;
maximize(f2);
colorbar

%%
%hold on
% %Linea medial-lateral
% uiwait(msgbox('Ingrese dos puntos para la linea medial-lateral'));
% [x1,y1] = getpts();
% p_medial = [x1(1),y1(1)];
% p_lateral = [x1(2),y1(2)];
% syms p q
% if x1(2) == x1(1)
%     x1(2) = x1(2) +1;
% end
% if y1(2) == y1(1)
%     y1(2) = y1(2) +1;
% end
% m1 = (y1(2)-y1(1))/(x1(2)-x1(1));
% 
% q = symfun(m1*(p-x1(1))+y1(1),[p]);
% 
% %Punto medial peak
% uiwait(msgbox('Ingrese un punto para el medial peak'));
% [x2,y2] = getpts();
% medial_peak = [x2,y2];
% m_perp = -1/m1;
% syms q2
% q2 = symfun(m_perp*(p-x2(1))+y2(1),[p]);
% x_int1=solve(q==q2);
% y_int1=q2(x_int1);
% p_int1 = [x_int1,y_int1];
% dist_medial_peak = pdist([medial_peak;p_int1],'euclidean')*V_seg.info{1,1};
% 
% % uiwait(msgbox('Ingrese un punto para el medial peak'));
% % [x2,y2] = getpts();
% % medial_peak = [x2,y2];
% 
% plot([x1(1),x1(2)],[y1(1),y1(2)],'LineWidth',0.5,'color', 'w')
% scatter(x1(1),y1(1),10,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
% scatter(x2(1),y2(1),10,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')
% scatter(x1(2),y1(2),10,'o','filled','MarkerEdgeColor', 'w','MarkerFaceColor', 'w')




end