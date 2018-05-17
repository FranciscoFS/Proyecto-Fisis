function Value = func_obj(alpha,beta)

    % Cargar la base de datos primero 
    
    load('Base_datos.m','Datos')
    regulador = 0.5;  %Peso para la varianza
    
    %Recorrer la base de datos y calcular el % para alpha y beta
    
    Destruccion = zeros(1,numel(Datos));
    
    for k=1:numel(Base_datos)
        
        Destruccion(k) = Cilindro(Datos(k),alpha,beta);
        
    end
    
    Value = mean(Destruccion) + regulador*var(Destruccion);
        
end
    