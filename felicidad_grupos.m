function varianza = felicidad_grupos(puntajes_grupos)
%calcular felicidad de cada grupo
suma = zeros(size(puntajes_grupos,2));
for i = 1:size(puntajes_grupos)
    grupo = puntajes_grupos(i);
    suma(i) = sum(grupo(:));
end

varianza = var(suma)
end
