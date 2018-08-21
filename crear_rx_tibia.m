function [rx_tibia] = crear_rx_tibia(hueso_usar,fisis_usar)

    tibia = hueso_usar;
    Fisis = fisis_usar;
    
    rx_tibia = zeros(size(tibia,1),size(tibia,2));
    for i = 1:size(rx_tibia,3)
        rx_tibia = rx_tibia + tibia(:,:,i) + 2*Fisis(:,:,i);      
    end
end