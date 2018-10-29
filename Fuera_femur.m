%pixeles_ya_sumados=Crear_solo_cilindro2(V_seg,alpha,beta,p,d)

function [porc_fuera] = Fuera_femur(V_seg,taladro,S)

    a = V_seg.mascara ==1; %hueso
    b = V_seg.mascara ==2; %fisis
    vol = (a + b) >0; %todo el femur
    vol = imclose(vol,S);
    
    [~,~,k] = ind2sub(size(taladro),find(taladro>0));
    pos = min(k(:));
    taladro(:,:,pos) = zeros(size(taladro(:,:,pos)));
    vol_con_taladro = (vol + taladro) >0;
    %vol_con_taladro2 = ((vol)+2*(taladro)); %variable que hice para
    %comprobar que el punto de stephen y el cilindro calzaran
    queda_afuera = (vol_con_taladro-vol)>0;

    %Me falta sacarle las primeras slides para considerar solo lo que se
    %sale
    total_de_1s_fuera = sum(queda_afuera(:));
    total_de_1s_taladro = sum(taladro(:));
    porc_fuera = 100-((total_de_1s_taladro-total_de_1s_fuera)/total_de_1s_taladro)*100;

end