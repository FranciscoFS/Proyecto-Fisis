function [Xx,Yy,Dest] = plot_fcn(Limit_alpha,Limit_beta,pace)

    Alpha = -Limit_alpha:pace:Limit_alpha;
    Beta = -Limit_beta:pace:Limit_beta;
    
    [Xx,Yy] = meshgrid(Alpha,Beta);
    Dest = zeros(length(Alpha),2);
    
    
    for k=1:length(Alpha)
        
        for i = 1:length(Beta)
            
            Omega = [Alpha(k) Beta(i)];
            Dest(k,i) = func_obj(Omega);
            
        end 
    end
    
end
            
            