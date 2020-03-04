function X_norm = Normalizar(X,dx)
    
    X_norm = (X - median(X)).*dx ;

end