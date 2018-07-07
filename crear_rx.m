function [rx,rx_femur,rx1] = crear_rx(V_seg)

    orig = V_seg.vol.orig;
  % filt = V_seg.vol.filt;
    masc = V_seg.mascara;
    Femur = V_seg.mascara == 1;
    Fisis = V_seg.mascara == 2;

    rx_orig = zeros(size(orig,1),size(orig,2));
    rx_femur = zeros(size(orig,1),size(orig,2));
    rx_masc = zeros(size(orig,1),size(orig,2));


    for i = 1:size(orig,3)
        rx_orig =  rx_orig + orig(:,:,i);
        rx_femur = rx_femur + Femur(:,:,i) + 2*Fisis(:,:,i);
        rx_masc =  rx_masc + masc(:,:,i);
        
    end

    rx1 = rx_orig/max(rx_orig(:));
    rx3 = rx_masc;
    rx = (rx3 > 0).*rx1;
    %imshow([rx_femur rx1 rx]) 

end


