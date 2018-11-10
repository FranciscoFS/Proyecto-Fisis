function isosurf_fast(V_seg)

    fisis_usar = V_seg.mascara == 2;
    hueso_usar = V_seg.mascara == 1;
    

    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};
    
    f = figure;
    hold on
    fu= smooth3(fisis_usar, 'box', 9);
    hu = smooth3(hueso_usar,'box', 9);
    p1= patch(isosurface(fu),'FaceColor','none','EdgeColor','red','LineWidth',0.1,'EdgeAlpha','0.4');
    p2= patch(isosurface(hu),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
    reducepatch(p1,0.5)
    reducepatch(p2,0.02)

    ax = gca;
    ax.DataAspectRatio= [1 1 dx/dz];

end