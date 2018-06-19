function Grabar_video(tiempo)%tiempo en segundos
axis off
axis tight manual
ax = gca;
ax.NextPlot = 'replaceChildren';
v = VideoWriter('Rodilla_girando');
v.Quality = 100;
open(v);

frame_total = tiempo*30;%30 por los fps = 30
az= 0;
el = -90;
l = camlight('headlight');
lighting gouraud
material dull
for j = 1:frame_total
    camlight(l,'headlight')
    view(az,el)
    drawnow
    frame = getframe(gcf);
    writeVideo(v,frame);
%     if j<frame_total/4
%         az = az +1;
%     elseif j<(frame_total/2)
%         el = el +1;
%     else
        az = az+0.5;
        el = el+0.2;
%     end
end
close(v)
end