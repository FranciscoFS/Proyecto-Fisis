function [Distribucion] = ProyeccionesFisis(Fisis3,dx)
    
    Proyeccion_SG = sum(Fisis3, 3);
    Proyeccion_AP = squeeze(sum(Fisis3,2));

    [row_AP,col_AP] = find(Proyeccion_AP > 0);
    [row_SG,col_SG] = find(Proyeccion_SG > 0);

    Columnas_AP = unique(col_AP);
    Columnas_SG = unique(col_SG);

    Fisis_AP_mean = zeros(size(Columnas_AP));
    Fisis_SG_mean = zeros(size(Columnas_SG));
%     Fisis_AP = zeros(size(Columnas_AP));
%     Fisis_SG = zeros(size(Columnas_SG));

    for k=1:length(Columnas_AP)

        contador = 0;
        indice = find(col_AP == Columnas_AP(k));
        aux = zeros(size(indice));

        for i=1:length(indice)

            aux(i) = row_AP(indice(i))*Proyeccion_AP(row_AP(indice(i)),col_AP(indice(i)));
            contador = contador + Proyeccion_AP(row_AP(indice(i)),col_AP(indice(i)));

        end

    %    Fisis_AP(k) = mean(row_AP(col_AP == Columnas_AP(k)));
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

   %     Fisis_SG(k) = mean(row_SG(col_SG == Columnas_SG(k)));
        Fisis_SG_mean(k) = sum(aux)/contador;

    end
    
    AP.Columnas = Columnas_AP;
    AP.Filas = Fisis_AP_mean;
    SG.Columnas = Columnas_SG;
    SG.Filas = Fisis_SG_mean;

    Distribucion.AP = AP;
    Distribucion.SG = SG;
        
    AP_norm.Columnas = Normalizar(AP.Columnas,dx);
    AP_norm.Filas = -1*Normalizar(AP.Filas,dx);
    SG_norm.Columnas = Normalizar(SG.Columnas,dx);
    SG_norm.Filas = -1*Normalizar(SG.Filas,dx);
    
    Distribucion.AP_norm = AP_norm;
    Distribucion.SG_norm = SG_norm;
    
end