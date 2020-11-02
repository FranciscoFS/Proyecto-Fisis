function X_norm = Normalizar(X,dx)
    
    %pos = round(length(X)/2);
    X_norm = (X - median(X)).*dx ;

end