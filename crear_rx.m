function rx = crear_rx(V_seg)
orig = V_seg.vol.orig;
filt = V_seg.vol.filt;
masc = V_seg.mascara;

fisis_usar = V_seg.femur.fisis;
hueso_usar = V_seg.femur.bones;
info = V_seg.info;

rx_orig = zeros(size(orig,1),size(orig,2));
rx_filt = zeros(size(orig,1),size(orig,2));
rx_masc = zeros(size(orig,1),size(orig,2));

prompt = {'Mascara:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'3'};
answer1 = inputdlg(prompt,dlg_title,num_lines,defaultans);
answer1 = str2double(answer1);
masc = masc<answer1;

for i = 1:size(orig,3)
    rx_orig =  rx_orig + orig(:,:,i);
    rx_filt =  rx_filt + filt(:,:,i);
    rx_masc =  rx_masc + masc(:,:,i);
end

rx1 = rx_orig/max(rx_orig(:));
rx2 = rx_filt/max(rx_filt(:));
rx3 = rx_masc/max(rx_masc(:));
rx = rx3.*rx1;
%V_seg.rx = final;


imshow(rx)
end
% subplot(2,2,1)
% imshow(rx1)
% subplot(2,2,2)
% imshow(rx2)
% subplot(2,2,3)
% imshow(rx3)
% subplot(2,2,4)
% imshow(final)
