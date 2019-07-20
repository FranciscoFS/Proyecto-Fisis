function [mu,CI]  = Mean_CI(X)

    mu = mean(X);
    n = length(X);
    SEM = std(X)/(sqrt(n));
    t = tinv([0.025 0.975], n -1);
    CI = mu + t*SEM;
    
end