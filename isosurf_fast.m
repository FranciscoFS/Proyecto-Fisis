function isosurf_fast(V_seg)
    fisis_usar = V_seg.mascara == 2;
    hueso_usar = V_seg.mascara == 1;

    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};
    
    f = figure;
    hold on
    fu= smooth3(fisis_usar, 'box', 9);
    hu = smooth3(hueso_usar,'box', 9);
    p1= patch(isosurface(fu),'FaceColor','red','EdgeColor','none');
    p2= patch(isosurface(hu),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4');
    reducepatch(p2,0.01)
 
    view(3)    

    ax = gca;
    c = ax.DataAspectRatio;
    ax.DataAspectRatio= [dz,dz,dx];
    

end