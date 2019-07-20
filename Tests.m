function [p] = Tests(X,alpha)

    if size(X) < 4
        
        fprintf('Muestra muy pequeña \n')
        p_1 = nan;
        p_2 = nan;
        [h_3,p_3] = kstest((X - mean(X))./std(X));
        
    else
        
        [h_1,p_1] = adtest(X);
        fprintf('Valor p = %f con h = %d para Adtest \n',p_1,h_1);
        [h_2, p_2, W] = swtest(X,alpha);
        fprintf('Valor p = %f con h = %d para Swtest \n',p_2,h_2);
        [h_3,p_3] = kstest((X - mean(X))./std(X));
        fprintf('Valor p = %f con h = %d para Kstest \n',p_3,h_3);
        
    end
    
    p = [p_1,p_2,p_3];

end
    