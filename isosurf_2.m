function isosurf_2(fisis,cortical,info)

h = waitbar(0.5,'Modelando en 3D.....');

    if exist('info') == 1
        dxdy = info{1};
        dz = info{2};
    else
        dxdy = inputdlg('Ingrese dxdy');
        dxdy = str2double(dxdy);
        dz = inputdlg('Ingrese dz');
        dz = str2double(dz);
    end    
    pace = (1/(dz/dxdy));
    [m,n,k] = size(fisis);
    [Xq,Yq,Zq] = meshgrid(1:m,1:n,1:pace:k);
    Box_size = 3;

    fprintf('Working in Fisis ..... \n');

    Y =interp3(fisis,Xq,Yq,Zq);
    Y = smooth3(Y,'box',Box_size);

    %Patch Cortical

    fprintf('Working in Bone ..... \n');
    W =interp3(cortical,Xq,Yq,Zq);
    W = smooth3(W,'box',Box_size);


    %Vista y Luz
    
    figure()

    p1= patch(isosurface(Y),'FaceColor','green','EdgeColor','none','FaceAlpha','0.95');
    p2= patch(isosurface(W),'FaceColor','none','EdgeColor','blue','LineWidth',0.1,'EdgeAlpha','0.4','MarkerSize',0.5);
    reducepatch(p2,0.01)

    view(3)
    axis equal
    daspect([1 1 1])
    l = camlight('headlight');
    lighting gouraud
    material dull
    title('Fisis')
    
    while true
    camlight(l,'headlight')
    pause(0.05);
    end
    
  

close(h)


Para que la luz siempre apunte del frente al girarlo



end

