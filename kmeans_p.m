function [I_out] = kmeans_p(I,k,Size)
    
    % Esto hace kmeans
    % / INPUTS:
    
        % I, es el vector de características, en el caso de las imagenes
        % ponerlo como I(:)
        % k, es el nº de clusters
        % en Size poner size(V), el size del Volumen o si es imagen size(I)
    
    rng(1)
    
    Idx = kmeans(I,k,'MaxIter',100000);
    I_out = reshape(Idx,Size);
    
end