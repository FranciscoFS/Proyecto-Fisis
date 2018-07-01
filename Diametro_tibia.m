function lreal = Diametro_tibia(V_seg)

    dz = V_seg.info{2,1};
    dx = V_seg.info{1,1};
    %hueso_usar = V_seg.mascara == 3;
    %fisis_usar = V_seg.mascara == 4;

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
    cual = 0;
    
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
    angulo = regionprops(hueso_usar(:,:,cual),'Orientation');
    lz = dist_max*sind(angulo.Orientation)*dz;
    lx = dist_max*cosd(angulo.Orientation)*dx;
    lreal = sqrt(lz^2 + lx^2);

end