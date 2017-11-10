function [ output_args ] = createModel(R,info )


dxdy = info{1,1};
dz = info{2,1};
pace = (1/(dz/dxdy));
% [m,n,k] = size(R);
% [Xq,Yq,Zq] = meshgrid(1:m,1:n,1:pace:k);
% R =interp3(R,Xq,Yq,Zq,'cubic') >0;


    BSM = R;
    [node_bin_aorta,elem_bin_aorta] = binsurface(BSM,4);
    patch('faces',elem_bin_aorta,'vertices',node_bin_aorta,'FaceColor','b','EdgeColor','k')
    %alpha(0.6);
    MM=zeros(size(BSM,1)+2,size(BSM,2)+2,size(BSM,3)+2);
    MM(2:end-1,2:end-1,2:end-1)=BSM;
    %MM=BSM;
    
    [node_bin_aorta,elem_bin_aorta] = binsurface(MM,4);
    opt_aorta.radbound = 0.9; % arista/1.3
    opt_aorta.distbound = 1;
    [p_aorta,t_aorta,regions_aorta,holes_aorta] = v2s(MM,0.4,opt_aorta,'cgalmesh') ;
    figure,patch('faces',t_aorta,'vertices',p_aorta*0.7,'FaceColor','red','EdgeColor','k'); daspect([1 1 pace]); axis off; view(3);cameramenu;drawnow
    conn=meshconn(t_aorta(:,1:3),size(p_aorta,1));
    node=p_aorta;
    node=smoothsurf(node,[],conn,7,1,'laplacian');
    figure,
    patch('faces',t_aorta,'vertices',node*0.7,'FaceColor','red','EdgeColor','k'); daspect([1 1 pace]); axis off; view(3);cameramenu;drawnow
    %savestl(node,t_aorta,'acl_first.stl','ACL'); 

    l = camlight('headlight');
    lighting gou
    material
    title('Fisis')

end