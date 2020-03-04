function [mu,CI]  = Mean_CI(X)

    mu = mean(X,'omitnan');
    n = length(X);
    SEM = std(X,'omitnan')/(sqrt(n));
    t = tinv([0.025 0.9725], n -1);
    CI.Up = mu + t(1).*SEM;
    CI.Down = mu + t(2).*SEM;
    
end