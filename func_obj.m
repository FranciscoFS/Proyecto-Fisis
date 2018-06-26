function [Value1,Value2,Value3,Value4] = func_obj(omega,Rodillas)

    alpha = omega(1);
    beta = omega(2);

    % Cargar la base de datos primero 
    
    %load('Base_datos.m','Datos')
    
    regulador = 0.5;  %Peso para la varianza
    
    %global Rodillas
    
    
   % Recorrer la base de datos y calcular el % para alpha y beta
    
    Destruccion = zeros(1,numel(Rodillas));
    
    for k=1:numel(Rodillas)
        
        Destruccion(k) = Cilindro_fx_final(Rodillas(k).Rodilla,alpha,beta);
        
    end
    
    Value1 = mean(Destruccion) + var(Destruccion);
    Value2 = mean(Destruccion) + regulador*var(Destruccion);
    Value3 = norm(Destruccion);
    Value4 = mean(Destruccion);
end
    