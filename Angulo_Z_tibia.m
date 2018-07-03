function [Angulo] = Angulo_Z_tibia(V_seg)

        % Hay que hacer el proceso para cada Volumen
        %Por ahora es solo para el tibia

        %V_rotado = V_seg;
        %V_rotado.mascara = (V_rotado.mascara < 8).*(V_rotado.mascara);

        [n,m,k] = size(V_seg.tibia.bones);
        [Xx,Yy,Zz] = meshgrid(1:n,1:m,1:k);
        
        [~,~,v1] = ind2sub(size(V_seg.tibia.bones),find(V_seg.tibia.bones > 0));

        Muestra_tibia = V_seg.tibia.bones(:,:,round((max(v1)+min(v1))/2));

        Xx_tibia = Xx(Muestra_tibia >0);
        Yy_tibia = Yy(Muestra_tibia >0);
        
        [Coeff, ~] = pca([Xx_tibia,Yy_tibia]);
        Angulo = 90 - acosd(abs(Coeff(1,1)));
 
        
    
end