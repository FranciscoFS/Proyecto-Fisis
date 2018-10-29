function [Xx,Yy,Dest] = plot_fcn(Limit_alpha,Limit_beta,pace_alpha,pace_beta,Rodilla,d,p)

    %Alpha = Horizontal, Beta = Elevacion
    
    Alpha = -Limit_alpha:pace_alpha:Limit_alpha;
    Beta = -Limit_beta:pace_beta:Limit_beta;
    
    [Xx,Yy] = meshgrid(Alpha,Beta);
    Dest_var = zeros(size(Xx));
    Dest_reg = zeros(size(Xx));
    Dest_norm = zeros(size(Xx));
    Dest_mean = zeros(size(Xx));
    
    %global Rodillas
    
    %Rodilla = Rodillas;

    for k=1:length(Alpha)
        

        for i = 1:length(Beta)
            
            Omega = [Alpha(k) Beta(i)];
%           Temp(i) = func_obj(Omega,Rodilla); 
            [Value_var, Value_reg,Value_norm,Value_mean] = func_obj(Omega,Rodilla,d,p); 
            Dest_var(k,i) = Value_var;
            Dest_reg(k,i) = Value_reg;
            Dest_norm(k,i) = Value_norm;
            Dest_mean(k,i) = Value_mean;
        end 
        
        fprintf('Angulo actual %d \n',k)

    end
    
    Dest{1} = Dest_var;
    Dest{2} = Dest_reg;
    Dest{3} = Dest_norm;
    Dest{4} = Dest_mean;
end
            
            