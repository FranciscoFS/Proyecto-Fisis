function [Value1,Value2,Value3,Value4] = func_obj(omega,Rodillas,d,p)

    alpha = omega(1);
    beta = omega(2);

    % Cargar la base de datos primero 
    
    %load('Base_datos.m','Datos')
    
    regulador = 0.5;  %Peso para la varianza
    
    %global Rodillas
    
    
   % Recorrer la base de datos y calcular el % para alpha y beta
    
    Destruccion = zeros(1,numel(Rodillas));
    
    for k=1:numel(Rodillas)

        Destruccion(k) = Cilindro_fx_final(Rodillas(k).Rodilla,alpha,beta,d,p);

    end
    
    Value1 = mean(Destruccion,'omitnan') + var(Destruccion);
    Value2 = mean(Destruccion,'omitnan') + regulador*var(Destruccion);
    Value3 = norm(Destruccion(not(isnan(Destruccion))));
    Value4 = mean(Destruccion,'omitnan');
end
    