function [AP, SG] = Proyecciones_tibia(V_seg)

    dx = V_seg.info{1}; 
    dz = V_seg.info{2};
    pace = dx/dz;

    Fisis = V_seg.mascara == 4;
    
    Proyeccion_SG = sum(Fisis > 0,3);

    Proyeccion_AP = squeeze(sum(Fisis > 0,2));
    [n,z] = size(Proyeccion_AP);
    [Xq,Zq] = meshgrid(1:pace:z,1:n);
    Proyeccion_AP = interp2(Proyeccion_AP,Xq,Zq);

    [row_AP,col_AP] = find(Proyeccion_AP > 0);
    [row_SG,col_SG] = find(Proyeccion_SG > 0);

    Columnas_AP = unique(col_AP);
    Columnas_SG = unique(col_SG);

    Fisis_AP_mean = zeros(size(Columnas_AP));
    Fisis_SG_mean = zeros(size(Columnas_SG));
    Fisis_AP = zeros(size(Columnas_AP));
    Fisis_SG = zeros(size(Columnas_SG));

    for k=1:length(Columnas_AP)

        contador = 0;
        indice = find(col_AP == Columnas_AP(k));
        aux = zeros(size(indice));

        for i=1:length(indice)

            aux(i) = row_AP(indice(i))*Proyeccion_AP(row_AP(indice(i)),col_AP(indice(i)));
            contador = contador + Proyeccion_AP(row_AP(indice(i)),col_AP(indice(i)));

        end

        Fisis_AP(k) = mean(row_AP(col_AP == Columnas_AP(k)));
        Fisis_AP_mean(k) = sum(aux)/contador;

    end


    for k=1:length(Columnas_SG)

        contador = 0;
        indice = find(col_SG == Columnas_SG(k));
        aux = zeros(size(indice));

        for i=1:length(indice)

            aux(i) = row_SG(indice(i))*Proyeccion_SG(row_SG(indice(i)),col_SG(indice(i)));
            contador = contador + Proyeccion_SG(row_SG(indice(i)),col_SG(indice(i)));

        end

        Fisis_SG(k) = mean(row_SG(col_SG == Columnas_SG(k)));
        Fisis_SG_mean(k) = sum(aux)/contador;

    end
    
    AP.Columnas = Columnas_AP;%x
    AP.Filas = Fisis_AP_mean;%y
    SG.Columnas = Columnas_SG;
    SG.Filas = Fisis_SG_mean;
    
end