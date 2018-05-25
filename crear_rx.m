function [rx,rx1] = crear_rx(V_seg)

    orig = V_seg.vol.orig;
    filt = V_seg.vol.filt;
    masc = V_seg.mascara;

    rx_orig = zeros(size(orig,1),size(orig,2));
    rx_filt = zeros(size(orig,1),size(orig,2));
    rx_masc = zeros(size(orig,1),size(orig,2));


    for i = 1:size(orig,3)
        rx_orig =  rx_orig + orig(:,:,i);
        rx_filt =  rx_filt + filt(:,:,i);
        rx_masc =  rx_masc + masc(:,:,i);
    end

    rx1 = rx_orig/max(rx_orig(:));
    rx3 = rx_masc/max(rx_masc(:));
    rx = (rx3 > 0).*rx1;
    %imshow([(rx3>0).*rx1 rx1 rx]) 

end


