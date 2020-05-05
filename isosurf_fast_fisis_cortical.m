function isosurf_fast_fisis_cortical(V_seg)

fisis = double(V_seg.mascara == 2);
cortical = double(V_seg.mascara == 1);

dz = V_seg.info{2,1};
dx = V_seg.info{1,1};

pace = (1/(dz/dx));
[m,n,k] = size(fisis);
[Xq,Yq,Zq] = meshgrid(1:m,1:n,1:pace:k);

X = interp3(cortical,Xq,Yq,Zq);
X = smooth3(X,'box',9);

Y = interp3(fisis,Xq,Yq,Zq);
Y = smooth3(Y,'box',9);

hold on

p1= patch(isosurface(Y),'FaceColor','none','EdgeColor','red','LineWidth',0.1,'EdgeAlpha','0.4');
reducepatch(p1,0.4)
p2= patch(isosurface(X),'FaceColor','none','EdgeColor','blue','LineWidth',0.01,'EdgeAlpha','0.1');
reducepatch(p1,0.05)

ax = gca;
ax.DataAspectRatio= [1 1 1];
axis tight

% while true
%     camlight(l,'headlight')
%     pause(0.05);
% end

end