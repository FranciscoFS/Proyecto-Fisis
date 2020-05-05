function isosurf_fast_fisis(V_seg)

    fisis = double(V_seg.mascara == 2);

    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};
    
    pace = (1/(dz/dx));
    [m,n,k] = size(fisis);
    [Xq,Yq,Zq] = meshgrid(1:m,1:n,1:pace:k);

    Y = interp3(fisis,Xq,Yq,Zq);
    Y = smooth3(Y,'box',9);
    
    

    hold on

    p1= patch(isosurface(Y),'FaceColor','none','EdgeColor','red','LineWidth',0.1,'EdgeAlpha','0.4');
    reducepatch(p1,0.4)

    ax = gca;
    ax.DataAspectRatio= [1 1 1];
    axis tight

end