function [alpha,beta,muHat,muCI] = Calculo_angulo(Caso,Xeq,Yeq)

    Datos = mean(Caso,3);
    [row,col] = find(Datos == max(Datos(:)));
    alpha.max = Yeq(row,1); beta.max = Xeq(1,col) ;
    [muHat.max,~,muCI.max,~] =normfit(squeeze(Caso(row,col,:)));

    [col] = find(Datos(45,:) == min(Datos(45,:)));
    beta.min = Xeq(1,col);
    alpha.min = 0 ;
    [muHat.min,~,muCI.min,~] = normfit(squeeze(Caso(45,col,:)));
    
end