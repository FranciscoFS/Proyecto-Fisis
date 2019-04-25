
Box_size = [25 25 25];

ff_smooth = smooth3(ff,'box',9);
fh_smooth = smooth3(fh,'box',Box_size);
Z3_smooth = smooth3(Z3,'box',9);
Z3_smooth = imrotate3_fast(Z3_smooth,{90 'X'});


%%
p1= patch(isosurface(ff_smooth,0.2),'FaceColor','red','EdgeColor','none');
isonormals(ff_smooth,p1)
p2= patch(isosurface(fh_smooth,0.2),'FaceColor','none','EdgeColor','blue','LineWidth',...
0.1,'EdgeAlpha','0.4');
reducepatch(p2,0.01)

%Z3_smooth = imrotate3_fast(Z3_smooth,{90 'X'});
p3 = patch(isosurface(Z3_smooth,0.1),'FaceColor','green','EdgeColor','none');
isonormals(Z3_smooth,p3);

view(3)
axis off
set(gcf,'color','white')
daspect([1 1 1])
l = camlight('headlight');
lighting gouraud
material dull

title('Rodilla')

while true
    camlight(l,'headlight')
    pause(0.05);  
end