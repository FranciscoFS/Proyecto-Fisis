for i = 1: size(hueso_usar,3) 
   im = hueso_usar(:,:,i);
   if sum(im(:))>0
       dist = regionprops(im,'MajorAxisLength');
       if size(dist,1) == 1 && dist.MajorAxisLength>dist_max
           dist_max = dist.MajorAxisLength;
           cual = i;
       end
   end
end

function lreal = Diametro_tibia(V_seg)

    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};

%     Az = Angulo_Z_tibia(V_seg);
%     Eje = 'Z';
%     V_seg = Rotar(V_seg,Az,Eje);


    theta = pi/2;
    
%Rotacion en x     
    t =  [1             0              0              0
          0             cos(theta)     -sin(theta)    0
          0             sin(theta)     cos(theta)     0
          0             0              0              1];
   
%Rotacion en y     
%     t =  [cos(theta)    0      sin(theta)     0
%           0             1              0      0
%           -sin(theta)   0      cos(theta)     0
%           0             0              0      1];
 
%Rotacion en z
%      t = [cos(theta)    -sin(theta) 0     0
%           sin(theta)    cos(theta)  0     0
%           0             0           1     0
%           0             0           0     1];
 
 
    tform = affine3d(t);
    rotado = imwarp(V_seg.mascara,tform);
    hueso_usar = rotado == 3;
    dist_max = 0;
    angulo_max = 0;
    cual = 0;
    pace = (dx/dz);
    [m,k] = size(hueso_usar(:,:,1));
    [Xq,Zq] = meshgrid(1:k,1:pace:m);
    
for i = 1: size(hueso_usar,3) 
   im = double(hueso_usar(:,:,cual));
   im =interp2(im,Xq,Zq);
   if sum(im(:))>0
       dist = regionprops(im,'MajorAxisLength');
       if size(dist,1) == 1 && dist.MajorAxisLength>dist_max
           dist_max = dist.MajorAxisLength;
           angulo = regionprops(im,'Orientation');
           cual = i;
       end
   end
end

    
    lz = dist_max*sind(angulo.Orientation);
    lx = dist_max*cosd(angulo.Orientation);
    lreal = sqrt(lz^2 + lx^2);

end