function rx = Crear_rx(V_seg)
orig = V_seg.vol.orig;
filt = V_seg.vol.filt;
masc = V_seg.mascara;

rx_orig = zeros(size(orig,1),size(orig,2));
rx_filt = zeros(size(orig,1),size(orig,2));
rx_masc = zeros(size(orig,1),size(orig,2));

% prompt = {'Mascara:'};
% dlg_title = 'Input';
% num_lines = 1;
% defaultans = {'3'};
% answer1 = inputdlg(prompt,dlg_title,num_lines,defaultans);
% answer1 = str2double(answer1);
answer1= 3;
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

end


