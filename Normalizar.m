function X_norm = Normalizar(X)
    
    X_norm = (X - mean(X))./(std(X)) ;
end